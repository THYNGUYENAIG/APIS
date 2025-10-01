table 51922 "ACC MP Item Ledger Available"
{
    Caption = 'ACC MP Item Ledger Available';
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
        field(14; Period; Integer)
        {
            Caption = 'Period';
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
        key(FKItemPeriod; "Item No.", Period)
        {
            SumIndexFields = Quantity;
        }
        key(FKSitePeriod; "Item No.", "Site No.", Period)
        {
            SumIndexFields = Quantity;
        }
    }
}
