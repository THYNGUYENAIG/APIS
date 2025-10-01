query 51021 "ACC Posted Sales Order Qry"
{
    Caption = 'ACC Posted Sales Order Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = ascending(LocationCode, No);
    elements
    {
        dataitem(SalesHeader; "Sales Header Archive")
        {
            DataItemTableFilter = "Version No." = filter(1);
            column(No; "No.") { }
            column(CustomerName; "Sell-to Customer Name") { }
            column(OrderDate; "Order Date") { }
            column(DocumentDate; "Document Date") { }
            column(PostingDate; "Posting Date") { }
            column(RequestedDeliveryDate; "Requested Delivery Date") { }
            dataitem(SalesLine; "Sales Line Archive")
            {
                DataItemTableFilter = Type = filter("Sales Line Type"::Item), Quantity = filter(<> 0);
                DataItemLink = "Document No." = SalesHeader."No.",
                               "Doc. No. Occurrence" = SalesHeader."Doc. No. Occurrence",
                               "Version No." = SalesHeader."Version No.";
                column(LocationCode; "Location Code") { }
                column(Quantity; Quantity)
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
