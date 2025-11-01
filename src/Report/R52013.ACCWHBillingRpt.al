report 52013 "ACC WH Billing Report"
{
    Caption = 'APIS Warehouse Billing Report - R52013';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52013_ACCWHBillingRpt.rdl';

    dataset
    {
        //Init Data
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
            begin
                bFirst := true;

                if qACCILE2.Read() then begin
                    dfPostingDate := qACCILE2.Posting_Date;
                    decfO := 0;
                    decfRcpt := 0;
                    decfIss := 0;
                end else begin
                    qACCILE2.Close();
                    CurrReport.Break();
                end;

                if bFirst then begin
                    bFirst := false;

                    qACCILE3_Open.SetFilter("Posting_Date_Filter", '< %1', qACCILE2.Posting_Date);
                    if tsLoc <> '' then qACCILE3_Open.SetRange("Location_Code_Filter", tsLoc);
                    qACCILE3_Open.Open();
                    if qACCILE3_Open.Read() then begin
                        decfO := qACCILE3_Open.QtySum;
                    end else
                        qACCILE3_Open.Close();
                end else
                    decfO := decfC;

                qACCILE2_Rcpt.SetRange(Posting_Date_Filter, qACCILE2.Posting_Date);
                if tsLoc <> '' then qACCILE2_Rcpt.SetRange("Location_Code_Filter", tsLoc);
                qACCILE2_Rcpt.SetFilter(Quantity_Filter, '> 0');
                qACCILE2_Rcpt.Open();
                if qACCILE2_Rcpt.Read() then begin
                    decfRcpt := qACCILE2_Rcpt.QtySum;
                end else
                    qACCILE2_Rcpt.Close();

                qACCILE2_Iss.SetRange(Posting_Date_Filter, qACCILE2.Posting_Date);
                if tsLoc <> '' then qACCILE2_Iss.SetRange("Location_Code_Filter", tsLoc);
                qACCILE2_Iss.SetFilter(Quantity_Filter, '< 0');
                qACCILE2_Iss.Open();
                if qACCILE2_Iss.Read() then begin
                    decfIss := -qACCILE2_Iss.QtySum;
                end else
                    qACCILE2_Iss.Close();

                if (decfO = 0) and (decfRcpt = 0) and (decfIss = 0) then
                    CurrReport.Skip()
                else begin
                    decfC := decfO + decfRcpt - decfIss;
                    iEntryNo += 1;

                    ACCWHBTmp.Init();
                    ACCWHBTmp."Entry No" := iEntryNo;
                    ACCWHBTmp."Posting Date" := dfPostingDate;
                    ACCWHBTmp."Opening Qty" := decfO;
                    ACCWHBTmp."Receipt Qty" := decfRcpt;
                    ACCWHBTmp."Issue Qty" := decfIss;
                    ACCWHBTmp."Closing Qty" := decfC;
                    ACCWHBTmp.Insert();

                    decfTotal += decfRcpt + decfIss;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (dsF <> 0D) and (dsT <> 0D) then begin
                    qACCILE2.SetRange(Posting_Date_Filter, dsF, dsT);
                    if tsLoc <> '' then qACCILE2.SetRange("Location_Code_Filter", tsLoc);
                    qACCILE2.Open();
                end else
                    CurrReport.Break();
            end;
        }

        dataitem(int1; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
                tName: Text;
                tUOM: Text;
                tNote: Text;
            begin
                iEntryNo += 1;

                ACCWHBTmp.Init();
                ACCWHBTmp."Entry No" := iEntryNo;
                ACCWHBTmp.Group := 1;

                case Number of
                    1:
                        begin
                            ACCWHBTmp.Name := 'Phí dịch vụ lưu kho cố định 1584 pallets';
                            ACCWHBTmp.Qty := 1;
                            ACCWHBTmp.UOM := 'Tháng';
                            ACCWHBTmp.Notes := 'Áp dụng từ T03/2025';
                        end;
                    2:
                        begin
                            ACCWHBTmp.Name := 'Phí dịch vụ kiểm đếm, giao nhận hàng hóa';
                            ACCWHBTmp.Qty := decfTotal / 1000;
                            ACCWHBTmp.UOM := 'Tấn';
                            ACCWHBTmp.Notes := 'Bao gồm nhập & xuất';
                        end;

                end;

                ACCWHBTmp.Insert();
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 2);
            end;
        }

        //Main
        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");

            column(CompanyName; Name) { }
            column(CompanyAddress; Address + ' ' + "Address 2") { }
            column(CompanyPhone; "Phone No.") { }
            column(CompanyTeleFax; "Telex No.") { }
            column(VAT_Registration_No; "VAT Registration No.") { }

            column(CompanyPic; Picture) { }

            dataitem(ACCWHBTmp; "ACC WH Billing Tmp")
            {
                DataItemTableView = sorting("Entry No");

                column(Amount; Amount) { }
                column(Closing; "Closing Qty") { }
                column(Issue; "Issue Qty") { }
                column(Name; Name) { }
                column(Notes; Notes) { }
                column(Opening; "Opening Qty") { }
                column(Posting_Date; "Posting Date") { }
                column(Price; Price) { }
                column(Qty; Qty) { }
                column(Receipt; "Receipt Qty") { }
                column(UOM; UOM) { }
                column(Group; Group) { }

                column(DF_Parm; dsF) { }
                column(DT_Parm; dsT) { }
                column(Loc_Parm; tsLoc) { }
            }
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

                    field(tsLoc; tsLoc)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        TableRelation = Location.Code;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsF := DMY2Date(1, 4, 2025);
            // tsCustNo := '10-00001-00';
        end;
    }

    #region ACC Func
    #endregion

    //GLobal
    var
        dsF: Date;
        dsT: Date;
        tsLoc: Text;
        qACCILE2: Query "ACC Item Ledger Entry 2 Query";
        qACCILE2_Rcpt: Query "ACC Item Ledger Entry 2 Query";
        qACCILE2_Iss: Query "ACC Item Ledger Entry 2 Query";
        qACCILE3_Open: Query "ACC Item Ledger Entry 3 Query";
        dfPostingDate: Date;
        decfC: Decimal;
        decfO: Decimal;
        decfRcpt: Decimal;
        decfIss: Decimal;
        iEntryNo: Integer;
        decfTotal: Decimal;
        bFirst: Boolean;
}