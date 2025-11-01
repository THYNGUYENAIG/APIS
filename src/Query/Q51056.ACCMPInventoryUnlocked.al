query 51056 "ACC MP Inventory Unlocked"
{
    Caption = 'APIS MP Inventory Unlocked';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(BinContent; "Bin Content")
        {
            DataItemTableFilter = "Block Movement" = filter(0);
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
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Quantity, '<>%1', 0);
    end;
}
