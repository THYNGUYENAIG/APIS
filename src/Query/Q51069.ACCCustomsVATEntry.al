query 51069 "ACC Customs VAT Entry"
{
    Caption = 'APIS Customs VAT Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(CustomsDeclaration; "BLTEC Customs Declaration")
        {
            column(CustomsDeclarationNo; "BLTEC Customs Declaration No.")
            {
            }
            dataitem(CustomsDeclLine; "BLTEC Customs Decl. Line")
            {
                DataItemLink = "Document No." = CustomsDeclaration."Document No.";
                column(VATAmountVND; "BLTEC VAT Amount (VND)")
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
