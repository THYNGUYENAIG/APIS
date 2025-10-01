query 52004 "ACC Item Ledger Entry 2 Query"
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
            filter(Quantity_Filter; Quantity) { }

            //Field
            column(Posting_Date; "Posting Date") { }

            //Calc
            column(QtySum; Quantity)
            {
                Method = Sum;
            }

            column(InvQtySum; "Invoiced Quantity")
            {
                Method = Sum;
            }
        }
    }
}