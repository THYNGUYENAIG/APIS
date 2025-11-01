query 51042 "ACC Transfer Combine Qry"
{
    Caption = 'APIS Transfer Combine Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(TransferLine; "Transfer Line")
        {
            DataItemTableFilter = "Quantity Received" = filter(0);
            //column(SiteId; "Shortcut Dimension 1 Code") { }
            column(BusinessUnitId; "Shortcut Dimension 2 Code") { }
            column(LocationCode; "Transfer-to Code") { }
            column(ItemNo; "Item No.") { }
            //column(DeliveryDate; "Shipment Date") { }
            column(Quantity; "Quantity Shipped")
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
