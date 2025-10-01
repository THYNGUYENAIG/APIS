report 52003 "ACC Sales And Paym Report"
{
    Caption = 'ACC Sales And Payment Report - R52003';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52003_ACCSalesAndPaymRpt.rdl';

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
                    dRunF: Date;
                    dRunT: Date;
                    iY: Integer;
                    iM: Integer;
                begin
                    if optsViewBy = optsViewBy::Month then begin
                        dRunF := dsF;
                        while dRunF <= dsT do begin
                            dRunT := CalcDate('<CM>', dRunF);

                            iY := Date2DMY(dRunF, 3);
                            iM := Date2DMY(dRunF, 2);

                            Clear(qACCCLE);
                            qACCCLE.SetRange(Posting_Date_Filter, dRunF, dRunT);
                            qACCCLE.SetRange(Customer_No_Filter, C."No.");
                            // qACCCLE.SetFilter(Document_Type_Filter, '%1 | %2'
                            //                     , "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo");
                            qACCCLE.SetFilter(Debit_Amount_LCY_Filter, '<> 0');
                            qACCCLE.Open();
                            if qACCCLE.Read() then begin
                                InitData(0, qACCCLE.AmtLCYSum, iY, iM, 0D);
                                GetCustGroupName();
                            end;
                            qACCCLE.Close();

                            Clear(qACCCLE);
                            qACCCLE.SetRange(Posting_Date_Filter, dRunF, dRunT);
                            qACCCLE.SetRange(Customer_No_Filter, C."No.");
                            // qACCCLE.SetFilter(Document_Type_Filter, '%1 | %2'
                            //                     , "Gen. Journal Document Type"::Payment, "Gen. Journal Document Type"::Refund);
                            qACCCLE.SetFilter(Credit_Amount_LCY_Filter, '<> 0');
                            qACCCLE.Open();
                            if qACCCLE.Read() then begin
                                InitData(1, qACCCLE.AmtLCYSum, iY, iM, 0D);
                                GetCustGroupName();
                            end;
                            qACCCLE.Close();

                            dRunF := dRunT + 1;
                            dRunT := CalcDate('<CM>', dRunF);
                            if (dRunF < dsT) and (dRunT > dsT) then dRunT := dsT;
                        end;
                    end else begin
                        dRunF := dsF;
                        while dRunF <= dsT do begin
                            iY := Date2DMY(dRunF, 3);
                            iM := Date2DMY(dRunF, 2);

                            Clear(qACCCLE);
                            qACCCLE.SetRange(Posting_Date_Filter, dRunF);
                            qACCCLE.SetRange(Customer_No_Filter, C."No.");
                            // qACCCLE.SetFilter(Document_Type_Filter, '%1 | %2'
                            //                     , "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo");
                            qACCCLE.SetFilter(Debit_Amount_LCY_Filter, '<> 0');
                            qACCCLE.Open();
                            if qACCCLE.Read() then begin
                                InitData(0, qACCCLE.AmtLCYSum, iY, iM, dRunF);
                                GetCustGroupName();
                            end;
                            qACCCLE.Close();

                            Clear(qACCCLE);
                            qACCCLE.SetRange(Posting_Date_Filter, dRunF);
                            qACCCLE.SetRange(Customer_No_Filter, C."No.");
                            // qACCCLE.SetFilter(Document_Type_Filter, '%1 | %2'
                            //                     , "Gen. Journal Document Type"::Payment, "Gen. Journal Document Type"::Refund);
                            qACCCLE.SetFilter(Credit_Amount_LCY_Filter, '<> 0');
                            qACCCLE.Open();
                            if qACCCLE.Read() then begin
                                InitData(1, qACCCLE.AmtLCYSum, iY, iM, dRunF);
                                GetCustGroupName();
                            end;
                            qACCCLE.Close();

                            dRunF := dRunF + 1;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if (dsF <> 0D) and (dsT <> 0D) and ((tsCustGroup <> '') or (tsCustNo <> '')) then begin
                        // if (tsCustGroup <> '') and (tsCustNo <> '') then begin
                        //     SetRange("BLACC Customer Group", tsCustGroup);
                        // end else begin
                        //     if tsCustGroup <> '' then SetRange("BLACC Customer Group", tsCustGroup);
                        //     if tsCustNo <> '' then SetRange("No.", tsCustNo);
                        // end;

                        if tsCustGroup <> '' then SetRange("BLACC Customer Group", tsCustGroup);
                        if tsCustNo <> '' then SetRange("No.", tsCustNo);
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
            column(Cust_Group; "Customer Group") { }
            column(Year_No; "Year No") { }
            column(Month_No; "Month No") { }
            column(Posting_Date; "Posting Date") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Remaining_Amount; "Remaining Amount") { }
            column(CustGroupName; CustGroupName) { }
            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }
            column(Cust_Group_Parm; tsCustGroup) { }
            column(Cust_No_Parm; tsCustNo) { }
            column(Cust_Name_Parm; tsCustName) { }
            column(View_By_Parm; optsViewBy) { }
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
                    }

                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date To';
                    }

                    field(tsCustGroup; tsCustGroup)
                    {
                        ApplicationArea = All;
                        TableRelation = "BLACC Customer Group".Code;
                        Caption = 'Customer Group';
                        // Enabled = bEdit;
                        // ShowMandatory = true;
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

                    field(optsViewBy; optsViewBy)
                    {
                        ApplicationArea = All;
                        Caption = 'View By';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsT := DMY2Date(27, 11, 2024);
            // tsCustNo := '10-00001-00';
        end;
    }

    #region ACC Func
    local procedure InitData(iType: Integer; ivdecAmt: Decimal; iviYear: Integer; iviMonth: Integer; ivd: Date)
    begin
        if iType = 0 then begin
            ACCDCTmp.Reset();
            ACCDCTmp.SetRange("Customer Group", C."BLACC Customer Group");
            if optsViewBy = optsViewBy::Day then
                ACCDCTmp.SetRange("Posting Date", ivd)
            else begin
                ACCDCTmp.SetRange("Year No", iviYear);
                ACCDCTmp.SetRange("Month No", iviMonth);
            end;
            if ACCDCTmp.FindFirst() then begin
                ACCDCTmp."Debit Amount" += ivdecAmt;
                ACCDCTmp."Remaining Amount" := ACCDCTmp."Debit Amount" + ACCDCTmp."Credit Amount";
                ACCDCTmp.Modify();
            end else begin
                iEntryNo += 1;

                ACCDCTmp.Init();
                ACCDCTmp."Entry No" := iEntryNo;
                ACCDCTmp."Customer Group" := C."BLACC Customer Group";
                ACCDCTmp."Customer No" := C."No.";
                ACCDCTmp."Customer Name" := C.Name;
                ACCDCTmp."Debit Amount" := ivdecAmt;
                ACCDCTmp."Remaining Amount" := ivdecAmt;
                ACCDCTmp."Year No" := iviYear;
                ACCDCTmp."Month No" := iviMonth;
                if optsViewBy = optsViewBy::Day then ACCDCTmp."Posting Date" := ivd;
                ACCDCTmp.Insert();
            end;
        end else begin
            ACCDCTmp.Reset();
            ACCDCTmp.SetRange("Customer Group", C."BLACC Customer Group");
            if optsViewBy = optsViewBy::Day then
                ACCDCTmp.SetRange("Posting Date", ivd)
            else begin
                ACCDCTmp.SetRange("Year No", iviYear);
                ACCDCTmp.SetRange("Month No", iviMonth);
            end;
            if ACCDCTmp.FindFirst() then begin
                ACCDCTmp."Credit Amount" += ivdecAmt;
                ACCDCTmp."Remaining Amount" := ACCDCTmp."Debit Amount" + ACCDCTmp."Credit Amount";
                ACCDCTmp.Modify();
            end else begin
                iEntryNo += 1;

                ACCDCTmp.Init();
                ACCDCTmp."Entry No" := iEntryNo;
                ACCDCTmp."Customer Group" := C."BLACC Customer Group";
                ACCDCTmp."Customer No" := C."No.";
                ACCDCTmp."Customer Name" := C.Name;
                ACCDCTmp."Credit Amount" := ivdecAmt;
                ACCDCTmp."Remaining Amount" := ivdecAmt;
                ACCDCTmp."Year No" := iviYear;
                ACCDCTmp."Month No" := iviMonth;
                if optsViewBy = optsViewBy::Day then ACCDCTmp."Posting Date" := ivd;
                ACCDCTmp.Insert();
            end;
        end;
    end;
    #endregion
    local procedure GetCustGroupName()
    var
        CustGroup: Record "BLACC Customer Group";
    begin
        if tsCustGroup <> '' then begin
            if CustGroup.Get(tsCustGroup) then CustGroupName := CustGroup.Description;
        end;
    end;
    //GLobal
    var
        dsF: Date;
        dsT: Date;
        tsCustGroup: Text;
        CustGroupName: Text;
        tsCustNo: Text;
        optsViewBy: Option Month,Day;
        iEntryNo: Integer;
        tsCustName: Text;
}