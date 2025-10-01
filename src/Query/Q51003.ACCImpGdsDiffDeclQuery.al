query 51003 "ACC Imp. Gds Diff. Decl. Query"
{
    Caption = 'ACC Imp. Gds Diff. Decl. Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(CustomsDeclaration; "BLTEC Customs Declaration")
        {
            column(DeclarationNo; "BLTEC Customs Declaration No.") { }
            column(DeclarationDate; "Declaration Date") { }
            column(DeclarationKindCode; "BLTEC Declaration Kind Code") { }
            column(CustomsOffice; "BLTEC Customs Office") { }
            column(ContainerType; "BLTEC Container Type") { }
            dataitem(ImportEntry; "BLTEC Import Entry")
            {
                DataItemLink = "BLTEC Customs Declaration No." = CustomsDeclaration."BLTEC Customs Declaration No.";
                SqlJoinType = InnerJoin;
                column(PONo; "Purchase Order No.") { }
                column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
                column(CustomsDeclarationDate; "Customs Declaration Date") { }
                column(ItemNo; "Item No.") { }
                column(Site; "Shortcut Dimension 1 Code") { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                dataitem(PurchaseLine; "Purchase Line")
                {
                    DataItemTableFilter = "Quantity Received" = filter(<> 0);
                    DataItemLink = "Document No." = ImportEntry."Purchase Order No.",
                                   "Line No." = ImportEntry."Line No.";
                    SqlJoinType = InnerJoin;
                    column(ItemName; "BLACC Purchase Name") { }
                    column(ReceiptQuantity; "Quantity Received")
                    {
                        Method = Sum;
                    }
                    column(InvoicedQuantity; "Quantity Invoiced")
                    {
                        Method = Sum;
                    }
                }
            }
        }
    }


    trigger OnBeforeOpen()
    begin

    end;
}
