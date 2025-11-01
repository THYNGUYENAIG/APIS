table 52006 "ACC WH Billing Tmp"
{
    Caption = 'APIS WH Billing Tmp';
    TableType = Temporary;

    fields
    {
        field(5; "Entry No"; Integer) { Caption = 'Entry No'; }
        field(10; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(15; Name; Text[250]) { Caption = 'Name'; }
        field(20; "Opening Qty"; Decimal) { Caption = 'Opening Qty'; }
        field(25; "Receipt Qty"; Decimal) { Caption = 'Receipt Qty'; }
        field(30; "Issue Qty"; Decimal) { Caption = 'Issue Qty'; }
        field(35; "Closing Qty"; Decimal) { Caption = 'Closing Qty'; }
        field(40; "Qty"; Decimal) { Caption = 'Qty'; }
        field(45; "UOM"; Text[50]) { Caption = 'UOM'; }
        field(50; "Price"; Decimal) { Caption = 'Price'; }
        field(55; "Amount"; Decimal) { Caption = 'Amount'; }
        field(60; Notes; Text[250]) { Caption = 'Notes'; }
        field(65; Group; Integer) { Caption = 'Group'; }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
