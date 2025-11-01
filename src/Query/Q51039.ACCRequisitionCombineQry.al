query 51039 "ACC Requisition Combine Qry"
{
    Caption = 'APIS Requisition Combine Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(RequisitionLine; "Requisition Line")
        {
            DataItemTableFilter = Type = filter("Requisition Line Type"::Item),
                                  "BLACC Requested Date" = filter(<> 0D);
            column(LocationCode; "Location Code") { }
            //column(SiteId; "Shortcut Dimension 1 Code") { }
            column(BusinessUnitId; "Shortcut Dimension 2 Code") { }
            column(ItemNo; "No.") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(DeliveryDate; "BLACC Requested Date") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
