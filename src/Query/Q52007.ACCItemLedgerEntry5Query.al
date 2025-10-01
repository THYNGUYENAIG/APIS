query 52007 "ACC Item Ledger Entry 5 Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            //Filter
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Location_Code_Filter; "Location Code") { }
            // filter(Entry_Type_Filter; "Entry Type") { }
            filter(Item_No_Filter; "Item No.") { }
            filter(Lot_No_Filter; "Lot No.") { }
            filter(Quantity_Filter; Quantity) { }

            //Field
            column(Location_Code; "Location Code") { }
            column(Item_No; "Item No.") { }
            column(Lot_No; "Lot No.") { }

            //Calc
            column(QtySum; Quantity) { Method = Sum; }
            column(Cost_Amount_Actual; "Cost Amount (Actual)") { Method = Sum; }
        }
    }
}