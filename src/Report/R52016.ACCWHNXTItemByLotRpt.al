report 52016 "ACC WH NXT Item By Lot Report"
{
    Caption = 'APIS Warehouse NXT Item By Lot Report - R52016';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52016_ACCWHNXTItemByLotRpt.rdl';

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
            column(Lot_No; tfLot) { }
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
                if qACCILE5.Read() then begin
                    tfItem := qACCILE5.Item_No;
                    recI.Reset();
                    recI.Get(tfItem);
                    tfItemName := recI.Description;
                    tfUOM := recI."Base Unit of Measure";
                    decConvert := recI."Net Weight";
                    tfLoc := qACCILE5.Location_Code;
                    tfLot := qACCILE5.Lot_No;
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
                    qACCILE5.Close();
                    CurrReport.Break();
                end;

                qACCILE5_Open.SetFilter("Posting_Date_Filter", '< %1', dsF);
                qACCILE5_Open.SetRange(Item_No_Filter, qACCILE5.Item_No);
                qACCILE5_Open.SetRange("Location_Code_Filter", qACCILE5.Location_Code);
                qACCILE5_Open.SetRange("Lot_No_Filter", qACCILE5.Lot_No);
                qACCILE5_Open.Open();
                if qACCILE5_Open.Read() then begin
                    decfO := qACCILE5_Open.QtySum;
                    decfOCS := cuACCGP.Divider(decfO, decConvert);
                end else
                    qACCILE5_Open.Close();

                qACCILE5_Rcpt.SetRange("Posting_Date_Filter", dsF, dsT);
                qACCILE5_Rcpt.SetRange(Item_No_Filter, qACCILE5.Item_No);
                qACCILE5_Rcpt.SetRange("Location_Code_Filter", qACCILE5.Location_Code);
                qACCILE5_Rcpt.SetRange("Lot_No_Filter", qACCILE5.Lot_No);
                qACCILE5_Rcpt.SetFilter(Quantity_Filter, '> 0');
                qACCILE5_Rcpt.Open();
                if qACCILE5_Rcpt.Read() then begin
                    decfRcpt := qACCILE5_Rcpt.QtySum;
                    decfRcptCS := cuACCGP.Divider(decfRcpt, decConvert);
                end else
                    qACCILE5_Rcpt.Close();

                qACCILE5_Iss.SetRange("Posting_Date_Filter", dsF, dsT);
                qACCILE5_Iss.SetRange(Item_No_Filter, qACCILE5.Item_No);
                qACCILE5_Iss.SetRange("Location_Code_Filter", qACCILE5.Location_Code);
                qACCILE5_Iss.SetRange("Lot_No_Filter", qACCILE5.Lot_No);
                qACCILE5_Iss.SetFilter(Quantity_Filter, '< 0');
                qACCILE5_Iss.Open();
                if qACCILE5_Iss.Read() then begin
                    decfIss := -qACCILE5_Iss.QtySum;
                    decfIssCS := cuACCGP.Divider(decfIss, decConvert);
                end else
                    qACCILE5_Iss.Close();

                if (decfO = 0) and (decfRcpt = 0) and (decfIss = 0) then
                    CurrReport.Skip()
                else begin
                    decfC := decfO + decfRcpt - decfIss;
                    decfCCS := decfOCS + decfRcptCS - decfIssCS;

                    recILE.Reset();
                    recILE.SetCurrentKey("Posting Date");
                    recILE.SetRange("Item No.", qACCILE5.Item_No);
                    recILE.SetRange("Lot No.", qACCILE5.Lot_No);
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
                    qACCILE5.SetFilter(Posting_Date_Filter, '< %1', dsT + 1);
                    if tsLoc <> '' then qACCILE5.SetFilter("Location_Code_Filter", tsLoc);
                    qACCILE5.Open();
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
        qACCILE5: Query "ACC Item Ledger Entry 5 Query";
        qACCILE5_Rcpt: Query "ACC Item Ledger Entry 5 Query";
        qACCILE5_Iss: Query "ACC Item Ledger Entry 5 Query";
        qACCILE5_Open: Query "ACC Item Ledger Entry 5 Query";
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
        tfLot: Text;
        dfReceipDate: Date;
        decfInvAge: Decimal;
        recILE: Record "Item Ledger Entry";
}