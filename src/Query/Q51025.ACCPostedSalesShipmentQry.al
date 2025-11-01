query 51025 "ACC Posted Sales Shipment Qry"
{
    Caption = 'APIS Posted Sales Shipment Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            column(DeliveryNote; "BLACC Delivery Note") { }
            dataitem(SalesShipmentLine; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = SalesShipmentHeader."No.";
                column(OrderNo; "Order No.") { }
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
