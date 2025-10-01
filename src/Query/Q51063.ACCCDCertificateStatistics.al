query 51063 "ACC CD Certificate Statistics"
{
    Caption = 'ACC CD Certificate Statistics - Q51063';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    UsageCategory = "ReportsAndAnalysis";
    elements
    {
        dataitem(Item; Item)
        {
            column(HSCode; "BLTEC HS Code") { }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemTableFilter = "BLTEC Customs Declaration No." = filter(<> '');
                DataItemLink = "No." = Item."No.";
                SqlJoinType = InnerJoin;
                column(No; "No.") { }
                column(Description; Description) { }
                column(DeclarationNo; "BLTEC Customs Declaration No.") { }
                column(DocumentNo; "Document No.") { }
                column(BuyfromVendorNo; "Buy-from Vendor No.") { }
                dataitem(CDCertificateFiles; "BLACC CD Certificate Files")
                {
                    DataItemTableFilter = "BLACC Certificate No." = filter(<> '');
                    DataItemLink = "BLACC Customs Declaration No." = PurchaseLine."BLTEC Customs Declaration No.";
                    SqlJoinType = InnerJoin;
                    column(CertificateNo; "BLACC Certificate No.") { }
                    column(ValidFrom; "BLACC Valid From") { }
                    dataitem(CustomsDeclaration; "BLTEC Customs Declaration")
                    {
                        DataItemLink = "BLTEC Customs Declaration No." = CDCertificateFiles."BLACC Customs Declaration No.";
                        column(BLNo; "BL No.") { }
                        column(DeclarationDate; "Declaration Date") { }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
