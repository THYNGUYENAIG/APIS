query 51001 "ACC Imp. Gds Opg. Decl. Query"
{
    Caption = 'APIS Imp. Gds Opg. Decl. Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            column(No; "No.") { }
            column(BuyfromVendorNo; "Buy-from Vendor No.") { }
            column(BuyfromVendorName; "Buy-from Vendor Name") { }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document Type" = PurchaseHeader."Document Type", "Document No." = PurchaseHeader."No.";
                DataItemTableFilter = Type = filter("Purchase Line Type"::Item), "Quantity Invoiced" = filter(0), "Quantity Received" = filter(0), Quantity = filter('>0');
                column(ItemNo; "No.") { }
                column(Description; Description) { }
                column(LocationCode; "Location Code") { }
                column(Site; "Shortcut Dimension 1 Code") { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                dataitem(ImportEntry; "BLTEC Import Entry")
                {
                    DataItemLink = "Purchase Order No." = PurchaseLine."Document No.", "Line No." = PurchaseLine."Line No.";
                    column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
                    column(CustomsDeclarationDate; "Customs Declaration Date") { }
                    column(BillNo; "BL No.") { }
                    //column(COForm; COForm) { }
                    column(ETADate; "Actual ETA Date") { }
                    column(ActualAvailableDate; "Actual Available Date") { }
                    column(Country; "Origin Country") { }
                    dataitem(CustomsDeclaration; "BLTEC Customs Declaration")
                    {
                        DataItemLink = "BLTEC Customs Declaration No." = ImportEntry."BLTEC Customs Declaration No.";
                        column(DeclarationNo; "BLTEC Customs Declaration No.") { }
                        column(DeclarationDate; "Declaration Date") { }
                        column(DeclarationKindCode; "BLTEC Declaration Kind Code") { }
                        column(CustomsOffice; "BLTEC Customs Office") { }
                        column(ContainerType; "BLTEC Container Type") { }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
