table 52002 "ACC PO Line Tmp"
{
    Caption = 'APIS Purchase Order Line Tmp';
    TableType = Temporary;

    fields
    {
        field(5; No; Code[20]) { Caption = 'No'; }
        field(10; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(15; "Line No"; Integer) { Caption = 'Line No'; }
        field(20; Description; Text[100]) { Caption = 'Description'; }
        field(25; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(30; "Buy-from Vendor No"; Code[20]) { Caption = 'Buy-from Vendor No'; }
        field(35; "Buy-from Vendor Name"; Text[100]) { Caption = 'Buy-from Vendor Name'; }
        field(40; Quantity; Decimal) { Caption = 'Quantity'; }
        field(45; "UOM"; Code[10]) { Caption = 'Unit of Measure Code'; }
        field(50; "Unit Price"; Decimal) { Caption = 'Unit Price'; }
        field(55; "Order No"; Code[20]) { Caption = 'Order No'; }
        field(56; "Order Line No"; Integer) { Caption = 'Order Line No'; }
        field(60; "Shipment Method Code"; Code[10]) { Caption = 'Shipment Method Code'; }
        field(65; "Payment Terms Code"; Code[10]) { Caption = 'Payment Terms Code'; }
        field(70; "Declaration No"; Text[150]) { Caption = 'Declaration No'; }
        field(75; "Currency Code"; Code[10]) { Caption = 'Currency Code'; }
        field(80; "Document Date"; Date) { Caption = 'Document Date'; }
        field(85; "Due Date"; Date) { Caption = 'Due Date'; }
        field(90; "Exch Rate"; Decimal) { Caption = 'Exch Rate'; }
        field(95; "Line Amount"; Decimal) { Caption = 'Line Amount'; }
        field(100; "Line Amount (LCY)"; Decimal) { Caption = 'Line Amount (LCY)'; }
        field(105; "Line Amount Include VAT"; Decimal) { Caption = 'Line Amount Include VAT'; }
        field(110; "Line VAT Amount"; Decimal) { Caption = 'Line VAT Amount'; }
        field(115; "Line VAT Amount (LCY)"; Decimal) { Caption = 'Line VAT Amount (LCY)'; }
        field(120; "Item Category Code"; Code[20]) { Caption = 'Item Category Code'; }
        field(125; "Vendor Posting Group"; Code[20]) { Caption = 'Vendor Posting Group'; }
        field(130; "Pay-to Vendor No"; Code[20]) { Caption = 'Pay-to Vendor No'; }
        field(135; "Vendor Group"; Code[20]) { Caption = 'Vendor Group'; }
        field(140; "Purchase Code"; Code[20]) { Caption = 'Purchase Code'; }
        field(145; "Branch"; Code[20]) { Caption = 'Branch'; }
        field(150; "Branch Name"; Text[50]) { Caption = 'Branch Name'; }
        field(155; "Location Code"; Code[10]) { Caption = 'Location Code'; }
        field(160; "Add Charge Currency"; Code[10]) { Caption = 'Add Charge Currency'; }
        field(165; "Add Charge"; Decimal) { Caption = 'Add Charge'; }
        field(170; "Add Charge (LCY)"; Decimal) { Caption = 'Add Charge (LCY)'; }
        field(175; "Fee Currency"; Code[10]) { Caption = 'Fee Currency'; }
        field(180; Fee; Decimal) { Caption = 'Fee'; }
        field(185; "Fee (LCY)"; Decimal) { Caption = 'Fee (LCY)'; }
        field(190; "Freight Currency"; Code[10]) { Caption = 'Freight Currency'; }
        field(195; Freight; Decimal) { Caption = 'Freight'; }
        field(200; "Freight (LCY)"; Decimal) { Caption = 'Freight (LCY)'; }
        field(205; "Import Tax Currency"; Code[10]) { Caption = 'Import Tax Currency'; }
        field(210; "Import Tax"; Decimal) { Caption = 'Import Tax'; }
        field(215; "Import Tax (LCY)"; Decimal) { Caption = 'Import Tax (LCY)'; }
        field(220; "SerCharge Currency"; Code[10]) { Caption = 'SerCharge Currency'; }
        field(225; SerCharge; Decimal) { Caption = 'SerCharge'; }
        field(230; "SerCharge (LCY)"; Decimal) { Caption = 'SerCharge (LCY)'; }
        field(235; "Transport Currency"; Code[10]) { Caption = 'Transport Currency'; }
        field(240; Transport; Decimal) { Caption = 'Transport'; }
        field(245; "Transport (LCY)"; Decimal) { Caption = 'Transport (LCY)'; }
        field(250; "Dumping Tax Currency"; Code[10]) { Caption = 'Dumping Tax Currency'; }
        field(255; "Dumping Tax"; Decimal) { Caption = 'Dumping Tax'; }
        field(260; "Dumping Tax (LCY)"; Decimal) { Caption = 'Dumping Tax (LCY)'; }
        field(265; "InsCharge Currency"; Code[10]) { Caption = 'InsCharge Currency'; }
        field(270; InsCharge; Decimal) { Caption = 'InsCharge'; }
        field(275; "InsCharge (LCY)"; Decimal) { Caption = 'InsCharge (LCY)'; }
        field(280; "Isc SurCharge Currency"; Code[10]) { Caption = 'Isc SurCharge Currency'; }
        field(285; "Isc SurCharge"; Decimal) { Caption = 'Isc SurCharge'; }
        field(290; "Isc SurCharge (LCY)"; Decimal) { Caption = 'Isc SurCharge (LCY)'; }
        field(295; "Lss Currency"; Code[10]) { Caption = 'Lss Currency'; }
        field(300; Lss; Decimal) { Caption = 'Lss'; }
        field(305; "Lss (LCY)"; Decimal) { Caption = 'Lss (LCY)'; }
        field(310; "Vat Currency"; Code[10]) { Caption = 'Vat Currency'; }
        field(315; Vat; Decimal) { Caption = 'Vat'; }
        field(320; "Vat (LCY)"; Decimal) { Caption = 'Vat (LCY)'; }
        field(325; "Security Tax Currency"; Code[10]) { Caption = 'Security Tax Currency'; }
        field(330; "Security Tax"; Decimal) { Caption = 'Security Tax'; }
        field(335; "Security Tax (LCY)"; Decimal) { Caption = 'Security Tax (LCY)'; }
        field(340; Total; Decimal) { Caption = 'Total'; }
        field(345; "Vendor Invoice No"; Code[35]) { Caption = 'Vendor Invoice No'; }
        field(350; "Receive No"; Code[20]) { Caption = 'Receive No'; }
    }
    keys
    {
        key(PK; No, "Item No", "Line No")
        {
            Clustered = true;
        }
    }
}
