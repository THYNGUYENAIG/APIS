table 52001 "ACC SO Line Tmp"
{
    Caption = 'APIS Sales Order Line Tmp';
    TableType = Temporary;

    fields
    {
        field(5; No; Code[20]) { Caption = 'No'; }
        field(10; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(15; "Line No"; Integer) { Caption = 'Line No'; }
        field(20; Description; Text[2048]) { Caption = 'Description'; }
        field(25; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(30; "Sell-to Customer No"; Code[20]) { Caption = 'Sell-to Customer No'; }
        field(35; "Sell-to Customer Name"; Text[100]) { Caption = 'Sell-to Customer Name'; }
        field(40; Quantity; Decimal) { Caption = 'Quantity'; }
        field(45; "UOM"; Code[10]) { Caption = 'Unit of Measure Code'; }
        field(50; "Unit Price"; Decimal) { Caption = 'Unit Price'; }
        field(55; "SalesPerson Code"; Code[20]) { Caption = 'SalesPerson Code'; }
        field(60; "SalesPerson Name"; Text[50]) { Caption = 'SalesPerson Name'; }
        field(65; "Sales District"; Text[30]) { Caption = 'Sales District'; }
        field(70; "Item Category Code"; Code[20]) { Caption = 'Item Category Code'; }
        field(75; "Item Category Name"; Text[100]) { Caption = 'Item Category Name'; }
        field(80; "Cost Center Code"; Code[20]) { Caption = 'Cost Center Code'; }
        field(85; "Cost Center Name"; Text[50]) { Caption = 'Cost Center Name'; }
        field(90; "Vendor No"; Code[20]) { Caption = 'Vendor No'; }
        field(95; "EI Invoice No"; Code[20]) { Caption = 'EI Invoice No'; }
        field(100; "VAT Perc"; Decimal) { Caption = 'VAT Perc'; }
        field(105; "Line Amount"; Decimal) { Caption = 'Line Amount'; }
        field(110; "Line Amount Include VAT"; Decimal) { Caption = 'Line Amount Include VAT'; }
        field(115; "Line VAT Amount"; Decimal) { Caption = 'Line VAT Amount'; }
        field(120; "Line Cost Amount"; Decimal) { Caption = 'Line Cost Amount'; }
        field(125; "Line GM1 Amount"; Decimal) { Caption = 'Line GM1 Amount'; }
        field(130; "Line GM2 Amount"; Decimal) { Caption = 'Line GM2 Amount'; }
        field(135; "PS No"; Code[20]) { Caption = 'Posted Shipment No'; }
        field(140; "Exch Rate"; Decimal) { Caption = 'Exch Rate'; }
        field(145; "Shipment Date"; Date) { Caption = 'Shipment Date'; }
        field(150; "Sales Order"; Code[20]) { Caption = 'Sales Order'; }
        field(155; "Location Code"; Code[10]) { Caption = 'Location Code'; }
        field(160; "Branch"; Code[20]) { Caption = 'Branch'; }
        field(165; "Branch Name"; Text[50]) { Caption = 'Branch Name'; }
        field(170; "Credit Note"; Boolean) { Caption = 'Credit Note'; }
        field(175; "Customer Group Name"; Text[100]) { Caption = 'Customer Group Name'; }
        field(180; "Bill-to Customer No"; Code[20]) { Caption = 'Bill-to Customer No'; }
        field(185; "Bill-to Customer Name"; Text[100]) { Caption = 'Bill-to Customer Name'; }
        field(190; "Search Name"; Text[100]) { Caption = 'Search Name'; }
        field(195; "Item Sales Tax Group"; Code[20]) { Caption = 'Item Sales Tax Group'; }
        field(200; "Orig Posting Date"; Date) { Caption = 'Orig Posting Date'; }
        field(205; "Orig No"; Code[20]) { Caption = 'Orig No'; }
        field(210; "Orig EI Invoice No"; Code[20]) { Caption = 'EI Invoice No'; }
        field(215; "Commission Expense Amount"; Decimal) { Caption = 'Commission Expense Amount'; }
        field(220; "Line Cost Amount Adjust"; Decimal) { Caption = 'Line Cost Amount Adjust'; }
    }
    keys
    {
        key(PK; No, "Item No", "Line No")
        {
            Clustered = true;
        }
    }
}
