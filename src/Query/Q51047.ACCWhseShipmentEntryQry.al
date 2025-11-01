query 51047 "ACC Whse. Shipment Entry Qry"
{
    Caption = 'APIS Whse. Shipment Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(SalesNo; "No.") { }
            column(CustomerNo; "Sell-to Customer No.") { }
            column(CustomerName; "Sell-to Customer Name") { }
            column(ShiptoAddress; "Ship-to Address") { }
            column(ShiptoAddress2; "Ship-to Address 2") { }
            column(DeliveryNote; "BLACC Delivery Note") { }
            column(DeliveryDate; "Requested Delivery Date") { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(BUCode; "Responsibility Center") { }
            column(SalespersonCode; "Salesperson Code") { }
            column(SOCreatedBy; SystemCreatedBy) { }
            dataitem(WarehouseShipmentLine; "Warehouse Shipment Line")
            {
                DataItemLink = "Source No." = SalesHeader."No.",
                           "Source Document" = SalesHeader."Document Type";
                SqlJoinType = InnerJoin;
                column(Status; Status) { }
                column(SourceDocument; "Source Document") { }
                column(SourceNo; "Source No.") { }
                column(SourceLineNo; "Source Line No.") { }
                column(No; "No.") { }
                column(ItemNo; "Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(LocationCode; "Location Code") { }
                column(WSCreatedBy; SystemCreatedBy) { }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = WarehouseShipmentLine."Item No.";
                    column(PackingGroup; "BLACC Packing Group") { }
                    column(GrossWeight; "Gross Weight") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
