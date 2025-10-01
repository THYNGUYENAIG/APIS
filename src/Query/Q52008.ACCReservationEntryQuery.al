query 52008 "ACC Reservation Entry Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(RE; "Reservation Entry")
        {
            //Filter
            filter(Source_Type_Filter; "Source Type") { }
            filter(Location_Code_Filter; "Location Code") { }
            filter(Reservation_Status_Filter; "Reservation Status") { }
            filter(Item_No_Filter; "Item No.") { }
            filter(Lot_No_Filter; "Lot No.") { }
            filter(Source_ID_Filter; "Source ID") { }

            //Field
            column(Item_No; "Item No.") { }
            column(Lot_No; "Lot No.") { }

            //Calc
            column(Qty_To_Handle_Sum; "Qty. to Handle (Base)")
            {
                Method = Sum;
            }
        }
    }
}