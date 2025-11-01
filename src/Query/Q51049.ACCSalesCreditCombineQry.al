query 51049 "ACC Sales Credit Combine Qry"
{
    Caption = 'APIS Sales Credit Combine Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
        {
            DataItemTableFilter = Type = filter("Sales Line Type"::Item), Quantity = filter(> 0), "Location Code" = filter(<> 'SR*');
            column(LocationCode; "Location Code") { }
            //column(SiteId; "Shortcut Dimension 1 Code") { }
            column(BusinessUnitId; "Shortcut Dimension 2 Code") { }
            column(ItemNo; "No.") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(DeliveryDate; "Posting Date") { }
            dataitem(Item; Item)
            {
                DataItemTableFilter = Type = filter("Item Type"::Inventory);
                DataItemLink = "No." = SalesCrMemoLine."No.";
                SqlJoinType = InnerJoin;
                column(ItemName; "BLTEC Item Name") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
