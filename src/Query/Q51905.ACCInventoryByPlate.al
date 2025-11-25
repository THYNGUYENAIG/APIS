query 51905 "ACC Inventory By Plate"
{
    Caption = 'APIS Inventory By Plate - Q51905';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(BinContent; "Bin Content")
        {
            column(LocationCode; "Location Code") { }
            column(BinCode; "Bin Code") { }
            column(BlockMovement; "Block Movement") { }
            column(ItemConditions; "BLACC Item Conditions") { }
            column(LocationConditions; "BLACC Location Conditions") { }
            column(Remark; "BLACC Remark") { }

            dataitem(LicensePlateContent; "MOB License Plate Content")
            {
                DataItemLink = "Location Code" = BinContent."Location Code",
                               "Bin Code" = BinContent."Bin Code",
                               "No." = BinContent."Item No.";
                column(LicensePlateNo; "License Plate No.")
                {
                    Caption = 'Pallet No.';
                }
                column(ItemNo; "No.")
                {
                    Caption = 'Item No.';
                }
                column(Quantity; "Quantity (Base)")
                {
                    Method = Sum;
                }

                dataitem(LotNoInformation; "Lot No. Information")
                {
                    DataItemLink = "Item No." = LicensePlateContent."No.",
                                   "Variant Code" = LicensePlateContent."Variant Code",
                                   "Lot No." = LicensePlateContent."Lot No.";
                    column(LotNo; "Lot No.") { }
                    column(ManufacturingDate; "BLACC Manufacturing Date") { }
                    column(ExpirationDate; "BLACC Expiration Date") { }
                    column(Blocked; Blocked) { }
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = LotNoInformation."Item No.";
                        column(ItemName; Description)
                        {
                            Caption = 'Item Name';
                        }
                        column(UnitCode; "Base Unit of Measure")
                        {
                            Caption = 'Unit';
                        }
                    }
                }
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
