query 51024 "ACC INV - Bin Blocked Qry"
{
    Caption = 'ACC Inventory - Bin Blocked Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(BinContent; "Bin Content")
        {
            DataItemTableFilter = "Block Movement" = filter(<> '');
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
                    DataItemLink = "Item No." = WarehouseEntry."Item No.",
                                   "Variant Code" = WarehouseEntry."Variant Code",
                                   "Lot No." = WarehouseEntry."Lot No.";
                    column(LotNo; "Lot No.") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
