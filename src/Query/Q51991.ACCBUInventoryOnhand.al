query 51991 "ACC BU Inventory Onhand"
{
    Caption = 'ACC BU Inventory Onhand';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(ACCBUInventoryEntry; "ACC BU Inventory Entry")
        {
            column(Site; Site) { }
            column(BusinessUnit; "Business Unit") { }
            column(ItemNo; "Item No.") { }
            column(Quantity; Quantity) { Method = Sum; }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
