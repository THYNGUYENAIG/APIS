query 51912 "ACC Forecast Cust Group Entry"
{
    Caption = 'ACC Forecast Cust Group Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(SalesInvoiceLine; "Sales Invoice Line")
        {
            DataItemTableFilter = Type = filter("Sales Line Type"::Item);
            column(ItemNo; "No.") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(AgreementNo; "BLACC Agreement No.") { }
            column(BusinessUnitId; "Shortcut Dimension 2 Code") { }
            column(LocationCode; "Location Code") { }
            //column(PostingDate;"Posting Date"){}
            column(PostingYear; "Posting Date")
            {
                Method = Year;
            }
            column(PostingMonth; "Posting Date")
            {
                Method = Month;
            }
            dataitem(SalesInvoiceHeader; "Sales Invoice Header")
            {
                DataItemLink = "No." = SalesInvoiceLine."Document No.";
                SqlJoinType = InnerJoin;
                column(SalespersonCode; "Salesperson Code") { }
                dataitem(Customer; Customer)
                {
                    DataItemTableFilter = "BLACC Customer Group" = filter(<> '');
                    DataItemLink = "No." = SalesInvoiceHeader."Sell-to Customer No.";
                    SqlJoinType = InnerJoin;
                    column(CustomerGroup; "BLACC Customer Group") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
