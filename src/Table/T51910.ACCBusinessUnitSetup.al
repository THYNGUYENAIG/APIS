table 51910 "ACC Business Unit Setup"
{
    Caption = 'APIS Business Unit Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Email; Text[255])
        {
            Caption = 'Email';
        }
        field(4; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(5; "CC Email"; Text[255])
        {
            Caption = 'CC Email';
        }
        field(6; "Forecast"; Boolean)
        {
            Caption = 'Forecast';
        }
        field(7; "Parent Code"; Code[20])
        {
            Caption = 'Merge Code';
        }
        field(8; "Create File"; Boolean)
        {
            Caption = 'Create File';
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
