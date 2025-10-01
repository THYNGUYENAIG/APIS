report 51021 "ACC Transfer Order Report"
{
    ApplicationArea = All;
    Caption = 'ACC Transfer Shipment Report - R51021';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51021.ACCTransferOrderReport.rdl';
    dataset
    {
        dataitem(TransferShipmentHeader; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No; "No.") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress02; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(DocBarCode; EncodeTextBarCode) { }
            column(TransferOrderNo; "Transfer Order No.") { }
            column(TransferOrderDate; "Transfer Order Date") { }
            column(PostingDate; "Posting Date") { }
            column(ShipmentDate; "Shipment Date") { }
            column(ReceiptDate; "Receipt Date") { }
            column(TransferfromCode; "Transfer-from Code") { }
            column(TransferfromName; "Transfer-from Name") { }
            column(TransferfromAddress; "Transfer-from Address") { }
            column(TransferfromAddress2; "Transfer-from Address 2") { }
            column(TransferfromCity; "Transfer-from City") { }
            column(TransfertoCode; "Transfer-to Code") { }
            column(TransfertoName; "Transfer-to Name") { }
            column(TransfertoAddress; "Transfer-to Address") { }
            column(TransfertoAddress2; "Transfer-to Address 2") { }
            column(TransfertoCity; "Transfer-to City") { }
            dataitem(TransferShipmentLine; "Transfer Shipment Line")
            {
                DataItemTableView = where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = field("No.");
                column(ItemNo; "Item No.") { }
                column(ItemName; ItemTable."BLTEC Item Name") { }
                column(UnitCode; UnitCode) { }
                dataitem(ItemEntryRelation; "Item Entry Relation")
                {
                    DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                    DataItemTableView = where("Source Type" = const(5745));
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Item Entry No.");
                        column(LotNo; "Lot No.") { }
                        column(Quantity; Quantity) { }
                        column(ExpirationDate; "Expiration Date") { }
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
        BarcodeString := TransferShipmentHeader."Transfer Order No.";
        EncodeTextBarCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
    end;

    local procedure GetDataTable()
    var
        UnitTmp: Record "BLACC eInvoiceItemUoM";
    begin
        if CompanyInfo.Get() then begin
        end;
        if ItemTable.Get(TransferShipmentLine."Item No.") then begin
        end;

        UnitTmp.Reset();
        UnitTmp.SetRange("Item No.", TransferShipmentLine."Item No.");
        if UnitTmp.FindFirst() then begin
            UnitCode := UnitTmp."Unit of Measure Code";
        end else begin
            UnitCode := TransferShipmentLine."Unit of Measure Code";
        end;
    end;

    var
        EncodeTextBarCode: Text;
        CompanyInfo: Record "Company Information";
        ItemTable: Record Item;
        UnitCode: Text;
}
