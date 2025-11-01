report 51024 "ACC TO Receipt Merge Report"
{
    ApplicationArea = All;
    Caption = 'APIS TO Receipt Merge Report - R51024';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51024.ACCTOReceiptMergeReport.rdl';
    dataset
    {
        dataitem(TransferReceiptHeader; "Transfer Receipt Header")
        {
            RequestFilterFields = "Transfer Order No.", "Transfer Order Date";
            column(No; "No.") { }
            column(TransferOrderNo; "Transfer Order No.") { }
            column(DocBarCode; EncodeTextBarCode) { }
            column(TransferOrderDate; "Transfer Order Date") { }
            column(PostingDate; "Posting Date") { }
            column(ShipmentDate; "Shipment Date") { }
            column(ReceiptDate; "Receipt Date") { }
            column(TransferfromCode; "Transfer-from Code") { }
            column(TransferfromName; "Transfer-from Name") { }
            column(TransfertoCode; "Transfer-to Code") { }
            column(TransfertoName; "Transfer-to Name") { }
            dataitem(TransferReceiptLine; "Transfer Receipt Line")
            {
                DataItemTableView = where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = field("No.");
                column(ItemNo; "Item No.") { }
                column(ItemName; InventTable."BLTEC Item Name") { }
                column(UnitCode; "Unit of Measure Code") { }
                dataitem(ItemEntryRelation; "Item Entry Relation")
                {
                    DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                    DataItemTableView = where("Source Type" = const(5747));
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Item Entry No.");
                        column(LotNo; "Lot No.") { }
                        column(Quantity; Quantity) { }
                        column(ExpirationDate; "Expiration Date") { }
                        column(ManufactureDate; LotTable."BLACC Manufacturing Date") { }
                        trigger OnAfterGetRecord()
                        begin
                            GenerateInterBarCode();
                            GetDataTable();
                        end;
                    }
                }
            }
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
    local procedure GenerateInterBarCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeString: Text;
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        BarcodeString := TransferReceiptHeader."Transfer Order No.";
        EncodeTextBarCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
    end;

    local procedure GetDataTable()
    var
    begin
        //LotTable.SetAutoCalcFields("BLACC Expiration Date");
        if LotTable.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            //LotTable.CalcShelfLife();
            //LotTable.CalcManufacturingDate();
        end;
        if InventTable.Get(ItemLedgerEntry."Item No.") then begin
        end;

    end;

    var
        InventTable: Record Item;
        LotTable: Record "Lot No. Information";
        EncodeTextBarCode: Text;
}
