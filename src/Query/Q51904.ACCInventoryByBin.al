query 51904 "ACC Inventory By Bin"
{
    Caption = 'ACC Inventory By Bin - Q51904';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(BinContent; "Bin Content")
        {
            column(LocationCode; "Location Code") { }
            column(ItemNo; "Item No.") { }
            column(BinCode; "Bin Code") { }
            column(BinTypeCode; "Bin Type Code") { }
            column(BlockMovement; "Block Movement") { }
            column(ItemConditions; "BLACC Item Conditions") { }
            column(LocationConditions; "BLACC Location Conditions") { }
            column(Remark; "BLACC Remark") { }
            dataitem(WarehouseEntry; "Warehouse Entry")
            {
                //DataItemTableFilter = "Qty. (Base)" = filter(<> 0);
                DataItemLink = "Bin Code" = BinContent."Bin Code",
                               "Item No." = BinContent."Item No.",
                               "Location Code" = BinContent."Location Code",
                               "Variant Code" = BinContent."Variant Code";
                //column(ItemName; Description) { }
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
                    DataItemLink = "Item No." = WarehouseEntry."Item No.",
                                   "Variant Code" = WarehouseEntry."Variant Code",
                                   "Lot No." = WarehouseEntry."Lot No.";
                    column(LotNo; "Lot No.") { }
                    column(ExpirationDate; "BLACC Expiration Date") { }
                    column(ReceiptDate; "ACC Receipt Date") { }
                    column(ManufacturingDate; "BLACC Manufacturing Date") { }
                    column(RemarkLot; "BLACC Remark") { }
                    column(Blocked; Blocked) { }
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = LotNoInformation."Item No.";
                        column(ItemName; Description)
                        {
                            Caption = 'Item Name';
                        }
                        column(PackingGroup; "BLACC Packing Group") { }
                        column(NetWeight; "Net Weight") { }
                        column(GrossWeight; "Gross Weight") { }
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
