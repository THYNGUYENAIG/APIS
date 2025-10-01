table 52005 "ACC WH Receipt Tmp"
{
    Caption = 'ACC  WH Receipt Tmp';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No"; Integer) { Caption = 'Entry No'; }
        field(5; "Document No"; Code[20]) { Caption = 'Document No'; }
        field(10; "Source No"; Code[20]) { Caption = 'Source No'; }
        field(15; Status; Text[30]) { Caption = 'Status'; }
        field(20; "Source Document"; Enum "Warehouse Activity Source Document") { Caption = 'Source Document'; }
        field(25; Name; Text[150]) { Caption = 'Name'; }
        field(30; "Quantity Expected"; Decimal) { Caption = 'Quantity Expected'; }
        field(35; "Quantity Received"; Decimal) { Caption = 'Quantity Received'; }
        field(40; "Declaration No"; Text[2000]) { Caption = 'Declaration No'; }
        field(45; "Created Date"; Date) { Caption = 'Created Date'; }
        field(50; "Received Date"; DateTime) { Caption = 'Received Date'; }
        field(55; "Invoice Date"; Date) { Caption = 'Invoice Date'; }
        field(60; "Quantity Invoiced"; Decimal) { Caption = 'Quantity Invoiced'; }
        field(65; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(70; "Location Code"; Code[10]) { Caption = 'Location Code'; }
        field(75; "Location Name"; Text[100]) { Caption = 'Location Name'; }
        field(80; "Vendor Invoice"; Text[2000]) { Caption = 'Vendor Invoice'; }
        field(85; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(90; "Item Name"; Text[100]) { Caption = 'Item Name'; }
        field(95; "Line No"; Integer) { Caption = 'Line No'; }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
