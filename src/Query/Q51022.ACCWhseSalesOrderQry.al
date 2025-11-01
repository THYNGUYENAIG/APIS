query 51022 "ACC Whse. Sales Order Qry"
{
    Caption = 'APIS Whse. Sales Order Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = filter("Sales Document Type"::Order);
            column(No; "No.") { }
            column(CustomerName; "Sell-to Customer Name") { }
            column(OrderDate; "Order Date") { }
            column(DocumentDate; "Document Date") { }
            column(PostingDate; "Posting Date") { }
            column(RequestedDeliveryDate; "Requested Delivery Date") { }
            column(DeliveryNote; "BLACC Delivery Note") { }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemTableFilter = Type = filter("Sales Line Type"::Item), Quantity = filter(<> 0);
                DataItemLink = "Document No." = SalesHeader."No.";
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
