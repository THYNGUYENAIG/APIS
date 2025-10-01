report 52008 "ACC Account Rcv Detail Report"
{
    Caption = 'ACC Account Receivable Detail Report - R52008';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52008_ACCAccountRcvDetailRpt.rdl';

    dataset
    {
        //Init Data
        dataitem(int1; Integer)
        {
            DataItemTableView = sorting(Number);

            dataitem(C; Customer)
            {
                // DataItemTableView = sorting("No.") where("Gen. Bus. Posting Group" = const('TN'));
                DataItemTableView = sorting("No.");

                trigger OnAfterGetRecord()
                var
                    qACCCLE: Query "ACC Cust Ledger Entry Query";
                    decDebAmt: Decimal;
                    decCreAmt: Decimal;
                    recCLE: Record "Cust. Ledger Entry";
                    decOpening: Decimal;
                    tDocNo: Text;
                    recSCMH: Record "Sales Cr.Memo Header";
                begin
                    //Openning
                    decOpening := 0;
                    decDebAmt := 0;
                    decCreAmt := 0;
                    qACCCLE.SetRange(Posting_Date_Filter, 0D, dsF - 1);
                    qACCCLE.SetRange(Customer_No_Filter, C."No.");
                    // qACCCLE.SetFilter(Document_Type_Filter, '%1 | %2 | %3 | %4'
                    //                     , "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo"
                    //                     , "Gen. Journal Document Type"::Payment, "Gen. Journal Document Type"::Refund);
                    qACCCLE.Open();
                    if qACCCLE.Read() then begin
                        decOpening := qACCCLE.AmtLCYSum;
                        if qACCCLE.AmtLCYSum >= 0 then decDebAmt := qACCCLE.AmtLCYSum else decCreAmt := qACCCLE.AmtLCYSum;
                        InitData(0, 0D, '', 'Số dư đầu kỳ', decDebAmt, -decCreAmt);
                    end;
                    qACCCLE.Close();

                    //In Periord
                    decDebAmt := 0;
                    decCreAmt := 0;
                    recCLE.Reset();
                    recCLE.SetRange("Posting Date", dsF, dsT);
                    recCLE.SetRange("Customer No.", C."No.");
                    // recCLE.SetFilter("Document Type", '%1 | %2 | %3 | %4'
                    //                     , "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo"
                    //                     , "Gen. Journal Document Type"::Payment, "Gen. Journal Document Type"::Refund);
                    if recCLE.FindSet() then begin
                        repeat
                            recCLE.CalcFields("Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");

                            // if recCLE."Document Type" in ["Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo"] then begin
                            if recCLE."Debit Amount (LCY)" <> 0 then begin
                                decDebAmt += recCLE."Amount (LCY)";
                                tDocNo := recCLE."Document No.";
                                case recCLE."Document Type" of
                                    "Gen. Journal Document Type"::Invoice:
                                        begin
                                            recSIH.Reset();
                                            recSIH.SetRange("No.", tDocNo);
                                            if recSIH.FindFirst() then tDocNo := recSIH."BLTI eInvoice No.";
                                        end;
                                    "Gen. Journal Document Type"::"Credit Memo":
                                        begin
                                            recSCMH.Reset();
                                            recSCMH.SetRange("No.", tDocNo);
                                            if recSCMH.FindFirst() then tDocNo := recSCMH."BLTI eInvoice No.";
                                        end;
                                end;
                                InitData(1, recCLE."Posting Date", tDocNo, recCLE.Description, recCLE."Amount (LCY)", 0)
                            end
                            else begin
                                decCreAmt += recCLE."Amount (LCY)";
                                InitData(1, recCLE."Posting Date", recCLE."Document No.", recCLE.Description, 0, -recCLE."Amount (LCY)");
                            end;
                        until recCLE.Next() < 1;
                    end;

                    if (decOpening = 0) and (decDebAmt = 0) and (decCreAmt = 0) then begin
                        ACCDCTmp.Reset();
                        ACCDCTmp.SetRange("Customer No", C."No.");
                        if ACCDCTmp.FindFirst() then ACCDCTmp.Delete();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if (dsF <> 0D) and (dsT <> 0D) then begin
                        if tsCustNo <> '' then SetRange("No.", tsCustNo);
                        // SetRange("Gen. Bus. Posting Group", 'TN');
                    end else
                        CurrReport.Break();
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 1);
            end;
        }

        //Main
        dataitem(ACCDCTmp; "ACC Debt Confirmation Tmp")
        {
            UseTemporary = true;
            DataItemTableView = sorting("Entry No");

            column(Cust_No; "Customer No") { }
            column(Cust_Name; "Customer Name") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_No; "Document No") { }
            column(Description; Description) { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Group_Sort_Int_1; "Group Sort Int 1") { }

            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }
            column(Cust_No_Parm; tsCustNo) { }
            column(Cust_Name_Parm; tsCustName) { }
        }
    }

    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(dsF; dsF)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date From';

                        trigger OnValidate()
                        begin
                            dsT := CalcDate('<CM>', dsF);
                        end;
                    }

                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date To';
                    }

                    field(tsCustNo; tsCustNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
                        Caption = 'Customer No.';
                        // Enabled = bEdit;
                        // ShowMandatory = true;

                        trigger OnValidate()
                        var
                            recC: Record Customer;
                        begin
                            recC.Get(tsCustNo);
                            tsCustName := recC.Name;
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsT := DMY2Date(27, 11, 2024);
            // tsCustNo := '131TN00235';
            // dsT := DMY2Date(31, 12, 2024);
            // dsF := CalcDate('<-CM>', dsT);
        end;
    }

    #region ACC Func
    local procedure InitData(iviType: Integer; ivdPosting: Date; ivtDocNo: Text; ivtDesc: Text; ivdecDebAmt: Decimal; ivdecCreAmt: Decimal)
    begin
        iEntryNo += 1;
        ACCDCTmp.Init();
        ACCDCTmp."Entry No" := iEntryNo;
        ACCDCTmp."Customer No" := C."No.";
        ACCDCTmp."Customer Name" := C.Name;
        if iviType = 1 then ACCDCTmp."Posting Date" := ivdPosting;
        ACCDCTmp."Document No" := ivtDocNo;
        ACCDCTmp.Description := ivtDesc;
        ACCDCTmp."Debit Amount" := ivdecDebAmt;
        ACCDCTmp."Credit Amount" := ivdecCreAmt;
        ACCDCTmp."Group Sort Int 1" := iviType;
        ACCDCTmp.Insert();
    end;
    #endregion

    //GLobal
    var
        dsF: Date;
        dsT: Date;
        tsCustNo: Text;
        iEntryNo: Integer;
        tsCustName: Text;
        recSIH: Record "Sales Invoice Header";
}