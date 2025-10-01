query 51058 "ACC MP Inventory Binlocked"
{
    Caption = 'ACC MP Inventory Binlocked';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(BinContent; "Bin Content")
        {
            DataItemTableFilter = "Block Movement" = filter(<> 0);
            column(LocationCode; "Location Code") { }
            column(ItemNo; "Item No.") { }
            dataitem(WarehouseEntry; "Warehouse Entry")
            {
                DataItemLink = "Bin Code" = BinContent."Bin Code",
                               "Item No." = BinContent."Item No.",
                               "Location Code" = BinContent."Location Code",
                               "Variant Code" = BinContent."Variant Code";
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                dataitem(LotNoInformation; "Lot No. Information")
                {
                    DataItemTableFilter = Blocked = filter(false);
                    DataItemLink = "Item No." = WarehouseEntry."Item No.",
                                   "Variant Code" = WarehouseEntry."Variant Code",
                                   "Lot No." = WarehouseEntry."Lot No.";
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Quantity, '<>%1', 0);
    end;
}
