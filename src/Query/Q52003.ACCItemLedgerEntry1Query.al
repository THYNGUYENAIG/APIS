query 52003 "ACC Item Ledger Entry 1 Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;
    // UsageCategory = Administration;
    // Caption = 'ACC Item Ledger Entry 1 Query';

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
            filter(Expiration_Date_Filter; "Expiration Date") { }

            //Field
            column(Location_Code; "Location Code") { }
            column(Item_No; "Item No.") { }
            column(Lot_No; "Lot No.") { }
            column(Expiration_Date; "Expiration Date") { }

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

            dataitem(I; Item)
            {
                DataItemLink = "No." = ItemLedgerEntry."Item No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Type = filter(<> "Item Type"::Service);
            }
        }
    }
}