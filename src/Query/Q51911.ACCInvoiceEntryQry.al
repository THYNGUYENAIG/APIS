query 51911 "ACC Invoice Entry Qry"
{
    Caption = 'APIS Invoice Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(SalespersonCode; "Salesperson Code") { }
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemTableFilter = Type = filter("Sales Line Type"::Item),
                                      "No." = filter(<> 'SERVICE-511');
                DataItemLink = "Document No." = SalesInvoiceHeader."No.";
                column(AgreementNo; "BLACC Agreement No.") { }
                column(CustomerNo; "Sell-to Customer No.") { }
                column(ItemNo; "No.") { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                column(LocationCode; "Location Code") { }
                column(BusinessUnitID; "Shortcut Dimension 2 Code") { }
                column(PostingDate; "Posting Date") { }
                column(PostingYear; "Posting Date")
                {
                    Method = Year;
                }
                column(PostingMonth; "Posting Date")
                {
                    Method = Month;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
