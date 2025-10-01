report 51018 "ACC Order Receipt Report"
{
    Caption = 'ACC Order Receipt Report - R51018';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51018.ACCPurchOrderReceiptReport.rdl';

    dataset
    {
        dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("Posting Date");
            RequestFilterFields = "Order No.", "Posting Date";
            column(OrderNo; "Order No.") { }
            column(PRINos; PRINos) { }
            column(BuyerName; "Buy-from Vendor Name") { }
            column(PostingDate; "Posting Date") { }
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemTableView = WHERE("Document Type" = FILTER('Purchase Receipt'));
                DataItemLink = "Document No." = field("No.");
                column(SourceNo_ItemLedgerEntry; "Source No.") { }
                column(SourceType_ItemLedgerEntry; "Source Type") { }
                column(DocumentNo; "Document No.") { }
                column(DocBarCode; EncodeTextBarCode) { }
                column(LocationCode; Location.Name) { }
                column(LocationManager; Location.Contact) { }
                column(ItemNo; "Item No.") { }
                column(Description; ItemTable."BLACC Purchase Name") { }
                column(UnitofMeasureCode; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(LotNo; "Lot No.") { }
                column(ManufactureDate; ManufactureDate) { }
                column(ExpirationDate; "Expiration Date") { }
                trigger OnAfterGetRecord()
                begin
                    GenerateInterBarCode();
                    GetDataTable();
                end;
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
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := PurchRcptHeader."Order No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodeTextBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    local procedure GetDataTable()
    var
        LotTable: Record "Lot No. Information";
        PurchReceipt: Record "Purch. Rcpt. Header";

    begin
        LotTable.SetAutoCalcFields("BLACC Expiration Date");
        if LotTable.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            LotTable.CalcManufacturingDate();
            ManufactureDate := LotTable."BLACC Manufacturing Date";
        end;

        PurchReceipt.Reset();
        PurchReceipt.SetRange("Order No.", PurchRcptHeader."Order No.");
        PurchReceipt.SetRange("Posting Date", PurchRcptHeader."Posting Date");
        if PurchReceipt.FindLast() then begin
            repeat
                if PRINos = '' then begin
                    PRINos := PurchReceipt."No.";
                end else begin
                    PRINos := PRINos + '|' + PurchReceipt."No.";
                end;
            until PurchReceipt.Next() = 0;
        end;

        if ItemTable.Get(ItemLedgerEntry."Item No.") then begin
        end;
        if Location.Get(ItemLedgerEntry."Location Code") then begin
        end;
    end;

    var
        EncodeTextBarCode: Text;
        ItemTable: Record Item;
        Location: Record Location;
        ManufactureDate: Date;
        PRINos: Text;
}
