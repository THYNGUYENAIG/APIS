query 51017 "ACC Purch. VAT Tax Decl. Query"
{
    Caption = 'APIS Purch. VAT Tax Decl. Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(CustomsDeclaration; "BLTEC Customs Declaration")
        {
            column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
            column(DeclarationDate; "Declaration Date") { }
            dataitem(CustomsDeclLine; "BLTEC Customs Decl. Line")
            {
                DataItemLink = "Document No." = CustomsDeclaration."Document No.";
                column(VATAmount; "BLTEC VAT Amount (VND)") { Method = Sum; }
                column(ImportTaxAmount; "BLTEC Import Tax Amount") { Method = Sum; }
                column(AntiDumpingDutyAmount; "BLTEC Anti-Dumping Duty Amount") { Method = Sum; }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
