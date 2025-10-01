table 52009 "ACC Inventory By Month"
{
    Caption = 'ACC Inventory By Month';
    DataClassification = ToBeClassified;

    fields
    {
        field(5; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(10; "Location Code"; Code[10]) { Caption = 'Location Code'; }
        field(15; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(20; "Lot No"; Code[50]) { Caption = 'Lot No'; }
        field(25; "Quantity"; Decimal) { Caption = 'Quantity'; DecimalPlaces = 0 : 5; }
        field(30; "Cost Amount (Actual)"; Decimal) { Caption = 'Cost Amount (Actual)'; DecimalPlaces = 0 : 5; }
    }
    keys
    {
        key(PK; "Posting Date", "Location Code", "Item No", "Lot No")
        {
            Clustered = true;
        }
    }
}
