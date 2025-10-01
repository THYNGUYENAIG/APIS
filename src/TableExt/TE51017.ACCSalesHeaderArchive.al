tableextension 51017 "ACC Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(50001; "Sales Type"; Enum "ACC Sales Type")
        {
            Caption = 'Sales Type';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50002; "Unset Packing"; Boolean)
        {
            Caption = 'Unset Packing';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50003; "Agreement Start Date"; Date)
        {
            Caption = 'Agreement Start Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50004; "Agreement End Date"; Date)
        {
            Caption = 'Agreement End Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50005; "ACC Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = "ACC Sales Reason".Code;
        }
        field(50006; "ACC Reason Comment"; Text[512])
        {
            Caption = 'Reason Comment';
            DataClassification = ToBeClassified;
        }
    }
}
