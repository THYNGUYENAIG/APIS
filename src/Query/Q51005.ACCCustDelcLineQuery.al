query 51005 "ACC Cust. Delc. Line Query"
{
    Caption = 'ACC Cust. Delc. Line Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(CustomsDeclaration; "BLTEC Customs Declaration")
        {
            column(DocumentNo; "Document No.") { }
            column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
            column(DeclarationDate; "Declaration Date") { }
            column(DueDate; "Due Date") { }
            column(CustomsTaxAmount; "Customs Tax Amount") { }
            column(LedgerTaxAmount; "Ledger Tax Amount") { }
            column(TotalTaxAmount; "Total Tax Amount") { }
            column(PaymentState; "Payment State") { }
            dataitem(CustomsDeclLine; "BLTEC Customs Decl. Line")
            {
                DataItemLink = "Document No." = CustomsDeclaration."Document No.";
                column(BLTECImportTaxAmount; "BLTEC Import Tax Amount")
                {
                    Method = Sum;
                }
                column(BLTECVATAmountVND; "BLTEC VAT Amount (VND)")
                {
                    Method = Sum;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
