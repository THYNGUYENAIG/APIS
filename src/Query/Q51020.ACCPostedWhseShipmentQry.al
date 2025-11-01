query 51020 "ACC Posted Whse. Shipment Qry"
{
    Caption = 'APIS Posted Whse. Shipment Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(WhseShipmentLine; "Posted Whse. Shipment Line")
        {
            DataItemTableFilter = Quantity = filter(<> 0);
            column(SourceDocument; "Source Document") { }
            column(SourceNo; "Source No.") { }
            column(ShipmentDate; "Shipment Date") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(LocationCode; "Location Code") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
