table 51911 "ACC DMS Statement"
{
    Caption = 'APIS DMS Statement';
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
