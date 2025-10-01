query 52010 "ACC Inventory By Month Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(ACCIBM; "ACC Inventory By Month")
        {
            //Filter
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Location_Code_Filter; "Location Code") { }
            filter(Item_No_Filter; "Item No") { }
            filter(Lot_No_Filter; "Lot No") { }

            //Field
            column(Location_Code; "Location Code") { }
            column(Item_No; "Item No") { }
            column(Lot_No; "Lot No") { }

            //Calculate
            column(Quantity; Quantity) { Method = Sum; }
            column(Cost_Amount__Actual; "Cost Amount (Actual)") { Method = Sum; }
        }
    }
}