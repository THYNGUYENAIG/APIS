report 51022 "ACC Transfer Receipt Report"
{
    ApplicationArea = All;
    Caption = 'APIS Transfer Receipt Report - R51022';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51022.ACCTransferReceiptReport.rdl';
    dataset
    {
        dataitem(TransferReceiptHeader; "Transfer Receipt Header")
        {
            RequestFilterFields = "No.";
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
                column(ItemName; ItemTable."BLTEC Item Name") { }
                column(UnitCode; UnitCode) { }
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
        UnitTmp: Record "BLACC eInvoiceItemUoM";
    begin
        //LotTable.SetAutoCalcFields("BLACC Expiration Date");
        if LotTable.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            //LotTable.CalcManufacturingDate();
        end;
        if ItemTable.Get(TransferReceiptLine."Item No.") then begin
        end;
        UnitTmp.Reset();
        UnitTmp.SetRange("Item No.", TransferReceiptLine."Item No.");
        if UnitTmp.FindFirst() then begin
            UnitCode := UnitTmp."Unit of Measure Code";
        end else begin
            UnitCode := TransferReceiptLine."Unit of Measure Code";
        end;
    end;

    var
        LotTable: Record "Lot No. Information";
        EncodeTextBarCode: Text;
        ItemTable: Record Item;
        UnitCode: Text;
}
