query 51057 "ACC MP Inventory Lotlocked"
{
    Caption = 'APIS MP Inventory Lotlocked';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(BinContent; "Bin Content")
        {
            column(LocationCode; "Location Code") { }
            column(ItemNo; "Item No.") { }
            dataitem(WarehouseEntry; "Warehouse Entry")
            {
                DataItemLink = "Bin Code" = BinContent."Bin Code",
                               "Item No." = BinContent."Item No.",
                               "Location Code" = BinContent."Location Code",
                               "Variant Code" = BinContent."Variant Code";
                //SqlJoinType = InnerJoin;
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                dataitem(LotNoInformation; "Lot No. Information")
                {
                    DataItemTableFilter = Blocked = filter(true);
                    DataItemLink = "Item No." = WarehouseEntry."Item No.",
                                   "Variant Code" = WarehouseEntry."Variant Code",
                                   "Lot No." = WarehouseEntry."Lot No.";
                    //SqlJoinType = InnerJoin;
                    column(ItemLotNo; "Item No.") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Quantity, '<>%1', 0);
    end;
}
