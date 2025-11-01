query 51023 "ACC INV - Lot Blocked Qry"
{
    Caption = 'APIS Inventory - Lot Blocked Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(WarehouseEntry; "Warehouse Entry")
        {
            column(LocationCode; "Location Code") { }
            column(ItemNo; "Item No.") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            dataitem(LotNoInformation; "Lot No. Information")
            {
                DataItemTableFilter = Blocked = filter(1);
                DataItemLink = "Item No." = WarehouseEntry."Item No.",
                                   "Variant Code" = WarehouseEntry."Variant Code",
                                   "Lot No." = WarehouseEntry."Lot No.";
                column(LotNo; "Lot No.") { }
                column(Blocked; Blocked) { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
