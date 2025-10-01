table 51901 "AIG Sharepoint Connector Line"
{
    Caption = 'AIG Sharepoint Connector Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Application ID"; Text[100])
        {
            Caption = 'Application ID';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Site ID"; Text[100])
        {
            Caption = 'Site ID';
        }
        field(40; "Drive ID"; Text[250])
        {
            Caption = 'Drive ID';
        }
        field(50; "Folder Path"; Text[2048])
        {
            Caption = 'Folder Path';
        }
        field(60; "Site Url"; Text[2048])
        {
            Caption = 'Site Url';
        }
        field(70; "Create Folder Url"; Text[2048])
        {
            Caption = 'Create Folder Url';
        }
        field(80; "Create File URL"; Text[2048])
        {
            Caption = 'Create File URL';
        }
        field(90; "Sharepoint Type"; Enum "AIG Sharepoint Type")
        {
            Caption = 'Sharepoint Type';
        }
    }
    keys
    {
        key(PK; "Application ID", "Line No.")
        {
            Clustered = true;
        }
    }
}
