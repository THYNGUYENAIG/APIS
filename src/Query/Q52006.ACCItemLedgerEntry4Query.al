query 52006 "ACC Item Ledger Entry 4 Query"
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
            // column(Lot_No; "Lot No.") { }

            //Calc
            column(QtySum; Quantity)
            {
                Method = Sum;
            }

            column(InvQtySum; "Invoiced Quantity")
            {
                Method = Sum;
            }

            column(ReservedQtySum; "Reserved Quantity")
            {
                Method = Sum;
            }
        }
    }
}