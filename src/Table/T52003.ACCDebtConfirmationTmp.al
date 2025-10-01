table 52003 "ACC Debt Confirmation Tmp"
{
    Caption = 'ACC Debt Confirmation Tmp';
    TableType = Temporary;

    fields
    {
        field(5; "Entry No"; Integer) { Caption = 'Entry No'; }
        field(10; "Document No"; Code[20]) { Caption = 'Document No'; }
        field(15; "Customer No"; Code[20]) { Caption = 'Customer No'; }
        field(20; "Customer Name"; Text[100]) { Caption = 'Customer Name'; }
        field(25; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(30; "Expire Date"; Date) { Caption = 'Expire Date'; }
        field(35; "Over Date"; Integer) { Caption = 'Over Date'; }
        field(40; "Remaining Amount"; Decimal) { Caption = 'Remaining Amount'; }
        field(45; "Over Amount"; Decimal) { Caption = 'Over Amount'; }
        field(50; "Over Amount Less_30"; Decimal) { Caption = 'Over Amount Less_30'; }
        field(55; "Over Amount In_30_60"; Decimal) { Caption = 'Over Amount In_30_60'; }
        field(60; "Over Amount Greater_60"; Decimal) { Caption = 'Over Amount Greater_60'; }
        field(65; "Amount In Word"; Text[1024]) { Caption = 'Amount In Word'; }
        field(70; "Customer Address"; Text[150]) { Caption = 'Customer Adress'; }
        field(75; "Contact"; Text[100]) { Caption = 'Contact'; }
        field(80; "Customer Group"; Code[20]) { Caption = 'Customer Group'; }
        field(85; "Customer Group Name"; Text[100]) { Caption = 'Customer Group Name'; }
        field(90; "Debit Amount"; Decimal) { Caption = 'Debit Amount'; }
        field(95; "Credit Amount"; Decimal) { Caption = 'Credit Amount'; }
        field(100; "Year No"; Integer) { Caption = 'Year No'; }
        field(105; "Month No"; Integer) { Caption = 'Month No'; }
        field(110; Description; Text[100]) { Caption = 'Description'; }
        field(115; "Group Sort Int 1"; Integer) { Caption = 'Group Sort Int 1'; }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
