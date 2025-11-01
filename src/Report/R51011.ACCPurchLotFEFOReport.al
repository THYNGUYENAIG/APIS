report 51011 "ACC Purch Lot FEFO Report"
{
    Caption = 'APIS Purchase Lot FEFO Report - R51011';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51011.ACCPurchLotFEFOReport.rdl';

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Location Code";
            DataItemTableView = WHERE("Document Type" = filter("Purchase Receipt"));
            column(SourceNo_ItemLedgerEntry; "Source No.") { }
            column(SourceType_ItemLedgerEntry; "Source Type") { }
            column(DocumentNo; "Document No.") { }
            column(LocationCode; "Location Code") { }
            column(PostingDate; "Posting Date") { }
            column(ItemNo; "Item No.") { }
            column(Description; Description) { }
            column(UnitofMeasureCode; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(InvoicedQuantity; "Invoiced Quantity") { }
            column(RemainingQuantity; "Remaining Quantity") { }
            column(LotNo; "Lot No.") { }
            column(ManufactureDate; LotInfor."BLACC Manufacturing Date") { }
            column(ExpirationDate; "Expiration Date") { }
            column(Remain2Per3ShelfLife; Remain2Per3ShelfLife) { }
            column(Remain1Per3ShelfLife; Remain1Per3ShelfLife) { }

            trigger OnAfterGetRecord()
            begin
                LotInfor.SetAutoCalcFields("BLACC Expiration Date");
                if LotInfor.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
                    LotInfor.CalcManufacturingDate();
                    if LotInfor."BLACC Manufacturing Date" = 0D then begin
                        Remain2Per3ShelfLife := ItemLedgerEntry."Posting Date" + ROUND((ItemLedgerEntry."Expiration Date" - ItemLedgerEntry."Posting Date") * 1 / 3, 1);
                        Remain1Per3ShelfLife := ItemLedgerEntry."Posting Date" + ROUND((ItemLedgerEntry."Expiration Date" - ItemLedgerEntry."Posting Date") * 2 / 3, 1);
                    end else begin
                        Remain2Per3ShelfLife := LotInfor."BLACC Manufacturing Date" + ROUND((ItemLedgerEntry."Expiration Date" - LotInfor."BLACC Manufacturing Date") * 1 / 3, 1);
                        Remain1Per3ShelfLife := LotInfor."BLACC Manufacturing Date" + ROUND((ItemLedgerEntry."Expiration Date" - LotInfor."BLACC Manufacturing Date") * 2 / 3, 1);
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        Remain2Per3ShelfLife: Date;
        Remain1Per3ShelfLife: Date;
        LotInfor: Record "Lot No. Information";
        ManufactureDate: Date;
}
