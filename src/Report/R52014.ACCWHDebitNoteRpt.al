report 52014 "ACC WH Debit Note Report"
{
    Caption = 'APIS Warehouse Debit Note Report - R52014';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52014_ACCWHDebitNoteRpt.rdl';

    dataset
    {
        //Init Data
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
            begin
                if qACCILE2.Read() then begin
                    decfRcpt := 0;
                    decfIss := 0;
                end else begin
                    qACCILE2.Close();
                    CurrReport.Break();
                end;

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

                iEntryNo += 1;

                ACCWHBTmp.Init();
                ACCWHBTmp."Entry No" := iEntryNo;
                ACCWHBTmp.Insert();

                decfTotal += decfRcpt + decfIss;
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
                            ACCWHBTmp.Name := 'Phí dịch vụ lưu trữ hàng hóa tháng 02/2025 theo Hợp đồng số 2025/KVAC/HĐDV/ACC-VICTA';
                            ACCWHBTmp.Qty := 1584;
                            ACCWHBTmp.UOM := 'Pallets';
                            ACCWHBTmp.Price := 130000;
                            ACCWHBTmp.Amount := ACCWHBTmp.Qty * ACCWHBTmp.Price;
                            ACCWHBTmp.Notes := 'Cố định 1584 Pallets - 130.000 Vnđ Pallets/ tháng';
                        end;
                    2:
                        begin
                            ACCWHBTmp.Name := 'Phí dịch vụ kiểm đếm, giao nhận hàng hóa tháng 02/2025 theo Hợp đồng số 2025/KVAC/HĐDV/ACC-VICTA';
                            ACCWHBTmp.Qty := decfTotal / 1000;
                            ACCWHBTmp.UOM := 'Tấn';
                            ACCWHBTmp.Price := 23000;
                            ACCWHBTmp.Amount := ACCWHBTmp.Qty * ACCWHBTmp.Price;
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
        decfRcpt: Decimal;
        decfIss: Decimal;
        iEntryNo: Integer;
        decfTotal: Decimal;
}