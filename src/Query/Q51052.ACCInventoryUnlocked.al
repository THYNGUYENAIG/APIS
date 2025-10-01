query 51052 "ACC Inventory Unlocked"
{
    Caption = 'ACC Inventory Unlocked';
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
                column(Unit; "Unit of Measure Code")
                {
                    Caption = 'Unit';
                }
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
                    column(LotNo; "Lot No.") { }
                    column(ExpirationDate; "BLACC Expiration Date") { }
                    column(ManufacturingDate; "BLACC Manufacturing Date") { }
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = LotNoInformation."Item No.";
                        column(TransportMethod; "BLACC Transport Method") { }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Quantity, '<>%1', 0);
    end;
}
