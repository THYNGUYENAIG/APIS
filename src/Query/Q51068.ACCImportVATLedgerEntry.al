query 51068 "ACC Import VAT Ledger Entry"
{
    Caption = 'ACC Import VAT Ledger Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableFilter = "G/L Account No." = filter('133122');
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(GLAccountNo; "G/L Account No.")
            {
            }
            column(Amount; Amount)
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
