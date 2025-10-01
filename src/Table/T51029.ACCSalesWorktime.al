table 51029 "ACC Sales Worktime"
{
    Caption = 'AIG Sales Worktime';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Site No."; Code[20])
        {
            Caption = 'Site No.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(11; "Time"; Integer)
        {
            Caption = 'Time';
        }
        field(12; "Type"; Enum "ACC Sales Reason Type")
        {
            Caption = 'Type';
        }
    }
    keys
    {
        key(PK; "Site No.")
        {
            Clustered = true;
        }
    }
}
