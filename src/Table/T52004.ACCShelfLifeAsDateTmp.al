table 52004 "ACC Shelf Life As Date Tmp"
{
    Caption = 'ACC Shelf Life As Date Tmp';
    TableType = Temporary;

    fields
    {
        field(5; "Location Code"; Code[10]) { Caption = 'Location Code'; }
        field(10; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(15; "Lot No"; Code[50]) { Caption = 'Lot No'; }
        field(20; Description; Text[100]) { Caption = 'Description'; }
        field(25; "Manufaturing Date"; Date) { Caption = 'Manufaturing Date'; }
        field(30; "Expiration Date"; Date) { Caption = 'Expiration Date'; }
        field(35; "Physical Inventory"; Decimal) { Caption = 'Physical Inventory'; DecimalPlaces = 0 : 5; }
        field(40; "Physical Reserved"; Decimal) { Caption = 'Physical Reserved'; DecimalPlaces = 0 : 5; }
        field(45; "Available Physical"; Decimal) { Caption = 'Available Physical'; DecimalPlaces = 0 : 5; }
        field(50; "Ordered"; Decimal) { Caption = 'Ordered'; DecimalPlaces = 0 : 5; }
        field(55; "Ordered Reserved"; Decimal) { Caption = 'Ordered Reserved'; DecimalPlaces = 0 : 5; }
        field(60; "Total Available"; Decimal) { Caption = 'Total Available'; DecimalPlaces = 0 : 5; }
        field(65; "Location Name"; Text[100]) { Caption = 'Location Name'; }
        field(70; "Remain_2_3"; Date) { Caption = 'Remain 2/3 Shelf Life'; }
        field(75; "Remain_1_3"; Date) { Caption = 'Remain 1/3 Shelf Life'; }
        field(80; "Remain_Near"; Date) { Caption = 'Remain Near Shelf Life'; }
        field(85; "Storage Condition"; Code[20]) { Caption = 'Storage Condition'; }
        field(90; "On Order"; Decimal) { Caption = 'On Order'; DecimalPlaces = 0 : 5; }
        field(95; "Posted Quantity"; Decimal) { Caption = 'Posted Quantity'; DecimalPlaces = 0 : 5; }
        field(100; "Received Date"; Date) { Caption = 'Received Date'; }
        field(105; "Quality Quantity"; Decimal) { Caption = 'Tồn Q'; DecimalPlaces = 0 : 5; }
        field(110; "ECUS - Item Name"; Text[2048]) { Caption = 'ECUS - Item Name'; }
        field(115; "Receipt Date"; Date) { Caption = 'Receipt Date'; }
        field(120; "Invoiced Date"; Date) { Caption = 'Invoiced Date'; }
    }
    keys
    {
        key(PK; "Location Code", "Item No", "Lot No")
        {
            Clustered = true;
        }
    }
}
