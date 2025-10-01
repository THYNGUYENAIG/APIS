query 51045 "ACC Agreement Entry Qry"
{
    Caption = 'ACC Agreement Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = filter("Sales Document Type"::"BLACC Agreement");
            column(AgreementNo; "No.") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(Tolerance; "BLACC Tolerance %") { }
            column(CustomerNo; "Sell-to Customer No.") { }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document Type" = SalesHeader."Document Type",
                               "Document No." = SalesHeader."No.";
                column(ItemNo; "No.") { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                //column(LocationCode; "Location Code") { }
                column(BusinessUnitId; "Shortcut Dimension 2 Code") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
