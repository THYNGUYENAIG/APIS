table 51900 "AIG Sharepoint Connector"
{
    Caption = 'AIG Sharepoint Connector';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Application ID"; Text[100])
        {
            Caption = 'Application ID';
        }
        field(20; "Tenant ID"; Text[100])
        {
            Caption = 'Tenant ID';
        }
        field(30; "Client ID"; Text[100])
        {
            Caption = 'Client ID';
        }
        field(40; "Client Secret"; Text[100])
        {
            Caption = 'Client Secret';
        }
        field(50; Scope; Text[100])
        {
            Caption = 'Scope';
        }
        field(60; "Access Token URL"; Text[100])
        {
            Caption = 'Access Token URL';
        }
        field(70; "Access Token URL 2"; Text[100])
        {
            Caption = 'Access Token URL 2';
        }
        field(80; "Copy Packing Slip"; Integer)
        {
            Caption = 'Copy Packing Slip';
        }
        field(90; "Copy eInvoice"; Integer)
        {
            Caption = 'Copy eInvoice';
        }

    }
    keys
    {
        key(PK; "Application ID")
        {
            Clustered = true;
        }
    }
}
