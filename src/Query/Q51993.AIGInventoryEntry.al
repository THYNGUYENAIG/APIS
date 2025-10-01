query 51993 "AIG Inventory Entry"
{
    Caption = 'AIG Inventory Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(AIGInventoryEntry; "AIG Inventory Entry")
        {
            column(ItemNo; "Item No.") { }
            column(LotNo; "Lot No.") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
