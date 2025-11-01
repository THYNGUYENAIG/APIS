table 51909 "ACC Contract Document"
{
    Caption = 'APIS Contract Document';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Doc No."; Code[20])
        {
            Caption = 'Doc No.';
        }
        field(20; "Doc Name"; Text[250])
        {
            Caption = 'Doc Name';
        }
        field(30; "Doc Address"; Text[1000])
        {
            Caption = 'Doc Address';
        }
    }
    keys
    {
        key(PK; "Doc No.")
        {
            Clustered = true;
        }
    }
}
