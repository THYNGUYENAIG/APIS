query 51901 "ACC Sales Shipment SPO Qry"
{
    Caption = 'ACC Sales Shipment SPO Qry';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(ShipmentDate), Ascending(LocationCode);

    elements
    {
        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            DataItemTableFilter = Quantity = filter('>0');
            column(DocumentNo; "Document No.") { }
            column(LocationCode; "Location Code") { }
            column(ShipmentDate; "Shipment Date") { }
            column(Count)
            {
                Method = Count;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
