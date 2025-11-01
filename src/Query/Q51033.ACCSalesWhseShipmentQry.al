query 51033 "ACC Sales Whse Shipment Qry"
{
    Caption = 'APIS Sales Whse Shipment Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(WarehouseShipmentHeader; "Warehouse Shipment Header")
        {            
            column(Count)
            {
                Method = Count;
            }
            column(No; "No.") { }
            column(RequestedDeliveryDate; "ACC Requested Delivery Date") { }
            dataitem(WarehouseShipmentLine; "Warehouse Shipment Line")
            {
                DataItemTableFilter = "Source Document" = filter("Warehouse Activity Source Document"::"Sales Order");
                DataItemLink = "No." = WarehouseShipmentHeader."No.";
                column(SourceNo; "Source No.") { }
                dataitem(SalesHeader; "Sales Header")
                {
                    DataItemLink = "No." = WarehouseShipmentLine."Source No.";
                    column(DeliveryDate; "Requested Delivery Date") { }
                    column(SellToCustomerNo; "Sell-to Customer No.") { }
                    column(SellToCustomerName; "Sell-to Customer Name") { }
                    column(ShipToAddress; "Ship-to Address") { }
                    column(ShipToAddress2; "Ship-to Address 2") { }
                    column(ShipToCity; "Ship-to City") { }
                    column(DeliveryNote; "BLACC Delivery Note") { }
                }
            }
        }
    }
    trigger OnBeforeOpen()
    begin

    end;
}
