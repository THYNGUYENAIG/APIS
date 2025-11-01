table 51989 "AIG eInvoice Setup"
{
    Caption = 'APIS eInvoice Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Company No."; Code[10])
        {
            Caption = 'Company No.';
        }
        field(20; "eInvoice Type"; Enum "AIG eInvoice Type")
        {
            Caption = 'eInvoice Type';
        }
        field(30; "eInvoice Template No."; Text[50])
        {
            Caption = 'eInvoice Template No.';
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Company No.", "eInvoice Type")
        {
            Clustered = true;
        }
    }
}
