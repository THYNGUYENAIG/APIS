report 51019 "ACC Return Receipt Report"
{
    Caption = 'APIS Return Receipt Report - R51019';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51019.ACCReturnReceiptReport.rdl';

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Document No.";
            DataItemTableView = WHERE("Document Type" = FILTER('Sales Return Receipt'));
            column(SourceNo_ItemLedgerEntry; "Source No.") { }
            column(SourceType_ItemLedgerEntry; "Source Type") { }
            column(DocumentNo; "Document No.") { }
            column(DocBarCode; EncodeTextBarCode) { }
            column(OrderNo; PurchReceipt."Return Order No.") { }
            column(BuyerName; PurchReceipt."Sell-to Customer Name") { }
            column(LocationCode; Location.Name) { }
            column(LocationManager; Location.Contact) { }
            column(PostingDate; "Posting Date") { }
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
        BarcodeString := ItemLedgerEntry."Document No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodeTextBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    local procedure GetDataTable()
    var
        LotTable: Record "Lot No. Information";
        MaxDate: Date;
    begin
        MaxDate := DMY2DATE(31, 12, 2020);
        if PurchReceipt.Get(ItemLedgerEntry."Document No.") then begin
        end;
        //LotTable.SetAutoCalcFields("BLACC Expiration Date");
        if LotTable.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            //LotTable.CalcManufacturingDate();
            ManufactureDate := LotTable."BLACC Manufacturing Date";
        end;

        if ItemTable.Get(ItemLedgerEntry."Item No.") then begin
        end;
        if Location.Get(ItemLedgerEntry."Location Code") then begin
        end;
    end;

    var
        EncodeTextBarCode: Text;
        PurchReceipt: Record "Return Receipt Header";
        ItemTable: Record Item;
        Location: Record Location;
        ManufactureDate: Date;
}
