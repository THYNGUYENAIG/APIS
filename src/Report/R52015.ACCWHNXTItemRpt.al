report 52015 "ACC WH NXT Item Report"
{
    Caption = 'APIS Warehouse NXT Item Report - R52015';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52015_ACCWHNXTItemRpt.rdl';

    dataset
    {
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            dataitem(CompanyInfo; "Company Information")
            {
                DataItemTableView = sorting("Primary Key");

                column(CompanyName; Name) { }
                column(CompanyAddress; Address + ' ' + "Address 2") { }
                column(CompanyPhone; "Phone No.") { }
                column(CompanyTeleFax; "Telex No.") { }
                column(VAT_Registration_No; "VAT Registration No.") { }
                column(CompanyPic; Picture) { }
            }

            column(Item; tfItem) { }
            column(Item_Name; tfItemName) { }
            column(Location; tfLoc) { }
            column(UOM; tfUOM) { }
            column(Opening; decfO) { }
            column(Receipt; decfRcpt) { }
            column(Issue; decfIss) { }
            column(Closing; decfC) { }
            column(Opening_CS; decfOCS) { }
            column(Receipt_CS; decfRcptCS) { }
            column(Issue_CS; decfIssCS) { }
            column(Closing_CS; decfCCS) { }
            column(ReceipDate; dfReceipDate) { }
            column(InvAge; decfInvAge) { }

            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }
            column(Loc_Parm; tsLoc) { }

            trigger OnAfterGetRecord()
            var
                recI: Record Item;
                recBLACCPG: Record "BLACC Packing Group";
                decConvert: Decimal;
            begin
                if qACCILE4.Read() then begin
                    tfItem := qACCILE4.Item_No;
                    recI.Reset();
                    recI.Get(tfItem);
                    tfItemName := recI.Description;
                    tfUOM := recI."Base Unit of Measure";
                    decConvert := recI."Net Weight";
                    tfLoc := qACCILE4.Location_Code;
                    decfO := 0;
                    decfRcpt := 0;
                    decfIss := 0;
                    decfC := 0;
                    decfOCS := 0;
                    decfRcptCS := 0;
                    decfIssCS := 0;
                    decfCCS := 0;
                    Clear(dfReceipDate);
                    decfInvAge := 0;
                end else begin
                    qACCILE4.Close();
                    CurrReport.Break();
                end;

                qACCILE4_Open.SetFilter("Posting_Date_Filter", '< %1', dsF);
                qACCILE4_Open.SetRange(Item_No_Filter, qACCILE4.Item_No);
                qACCILE4_Open.SetRange("Location_Code_Filter", qACCILE4.Location_Code);
                qACCILE4_Open.Open();
                if qACCILE4_Open.Read() then begin
                    decfO := qACCILE4_Open.QtySum;
                    decfOCS := cuACCGP.Divider(decfO, decConvert);
                end else
                    qACCILE4_Open.Close();

                qACCILE4_Rcpt.SetRange("Posting_Date_Filter", dsF, dsT);
                qACCILE4_Rcpt.SetRange(Item_No_Filter, qACCILE4.Item_No);
                qACCILE4_Rcpt.SetRange("Location_Code_Filter", qACCILE4.Location_Code);
                qACCILE4_Rcpt.SetFilter(Quantity_Filter, '> 0');
                qACCILE4_Rcpt.Open();
                if qACCILE4_Rcpt.Read() then begin
                    decfRcpt := qACCILE4_Rcpt.QtySum;
                    decfRcptCS := cuACCGP.Divider(decfRcpt, decConvert);
                end else
                    qACCILE4_Rcpt.Close();

                qACCILE4_Iss.SetRange("Posting_Date_Filter", dsF, dsT);
                qACCILE4_Iss.SetRange(Item_No_Filter, qACCILE4.Item_No);
                qACCILE4_Iss.SetRange("Location_Code_Filter", qACCILE4.Location_Code);
                qACCILE4_Iss.SetFilter(Quantity_Filter, '< 0');
                qACCILE4_Iss.Open();
                if qACCILE4_Iss.Read() then begin
                    decfIss := -qACCILE4_Iss.QtySum;
                    decfIssCS := cuACCGP.Divider(decfIss, decConvert);
                end else
                    qACCILE4_Iss.Close();

                if (decfO = 0) and (decfRcpt = 0) and (decfIss = 0) then
                    CurrReport.Skip()
                else begin
                    decfC := decfO + decfRcpt - decfIss;
                    decfCCS := decfOCS + decfRcptCS - decfIssCS;

                    recILE.Reset();
                    recILE.SetCurrentKey("Posting Date");
                    recILE.SetRange("Item No.", qACCILE4.Item_No);
                    recILE.SetFilter("Entry Type", '%1 | %2', "Item Ledger Entry Type"::"Positive Adjmt.", "Item Ledger Entry Type"::Purchase);
                    if recILE.FindFirst() then begin
                        dfReceipDate := recILE."Posting Date";
                        decfInvAge := dsT - dfReceipDate;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (dsF <> 0D) and (dsT <> 0D) then begin
                    qACCILE4.SetFilter(Posting_Date_Filter, '< %1', dsT + 1);
                    if tsLoc <> '' then qACCILE4.SetFilter("Location_Code_Filter", tsLoc);
                    qACCILE4.Open();
                end else
                    CurrReport.Break();
            end;
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
                        // TableRelation = Location.Code;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            pageLL: Page "Location List";
                        begin
                            pageLL.LookupMode(true);

                            if pageLL.RunModal() = Action::LookupOK then begin
                                Text := pageLL.GetValueFromFilter('|');
                                exit(true);
                            end;
                        end;
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
        qACCILE4: Query "ACC Item Ledger Entry 4 Query";
        qACCILE4_Rcpt: Query "ACC Item Ledger Entry 4 Query";
        qACCILE4_Iss: Query "ACC Item Ledger Entry 4 Query";
        qACCILE4_Open: Query "ACC Item Ledger Entry 4 Query";
        tfItem: Text;
        decfC: Decimal;
        decfO: Decimal;
        decfRcpt: Decimal;
        decfIss: Decimal;
        tfItemName: Text;
        tfUOM: Text;
        decfOCS: Decimal;
        decfRcptCS: Decimal;
        decfIssCS: Decimal;
        decfCCS: Decimal;
        cuACCGP: Codeunit "ACC General Process";
        tfLoc: Text;
        dfReceipDate: Date;
        decfInvAge: Decimal;
        recILE: Record "Item Ledger Entry";
}