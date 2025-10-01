query 52009 "ACC WH Entry Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(WHE; "Warehouse Entry")
        {
            //Filter
            filter(WH_Document_No_Filter; "Whse. Document No.") { }
            filter(Source_No_Filter; "Source No.") { }
            filter(Item_No_Filter; "Item No.") { }
            filter(WH_Document_Line_No_Filter; "Whse. Document Line No.") { }
            filter(Bin_Code_Filter; "Bin Code") { }
            filter(Zone_Code_Filter; "Zone Code") { }
            filter(Location_Code_Filter; "Location Code") { }

            //Field
            column(Source_No; "Source No.") { }
            column(Item_No; "Item No.") { }
            column(Location_Code; "Location Code") { }
            column(Bin_Code; "Bin Code") { }
            column(Lot_No; "Lot No.") { }

            //Calculate
            column(QtySum; Quantity) { Method = Sum; }
        }
    }
}