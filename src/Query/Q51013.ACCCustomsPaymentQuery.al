query 51013 "ACC Customs Payment Query"
{
    Caption = 'ACC Customs Payment Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(DocumentNo; "Document No.")
            {
            }
            column(GLAccountNo; "G/L Account No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(CreditAmount; "Credit Amount")
            {
            }
            column(DebitAmount; "Debit Amount")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
