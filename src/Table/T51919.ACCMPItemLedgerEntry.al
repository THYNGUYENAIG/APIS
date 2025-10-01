table 51919 "ACC MP Item Ledger Entry"
{
    Caption = 'ACC MP Item Ledger Entry';
    TableType = Temporary;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(11; "Site No."; Code[20])
        {
            Caption = 'Site No.';
        }
        field(12; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(FKItem; "Item No.")
        {
            SumIndexFields = Quantity;
        }
        key(FKSite; "Item No.", "Site No.")
        {
            SumIndexFields = Quantity;
        }
    }
}
