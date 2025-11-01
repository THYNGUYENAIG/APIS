table 51913 "ACC DMS Report Type"
{
    Caption = 'APIS DMS Report Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
