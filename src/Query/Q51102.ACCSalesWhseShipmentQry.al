query 51102 "ACC Sales Whse. Shipment Qry"
{
    Caption = 'ACC Sales Whse. Shipment Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(PostedWhseShipmentLine; "Posted Whse. Shipment Line")
        {
            column(Count) { Method = Count; }
            column(No; "No.") { }
            column(PostedSourceNo; "Posted Source No.") { }
            column(PostingDate; "Posting Date") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
