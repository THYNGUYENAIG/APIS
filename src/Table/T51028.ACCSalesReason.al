table 51028 "ACC Sales Reason"
{
    Caption = 'AIG Sales Reason';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(11; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(12; "Type"; Enum "ACC Sales Reason Type")
        {
            Caption = 'Type';
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
