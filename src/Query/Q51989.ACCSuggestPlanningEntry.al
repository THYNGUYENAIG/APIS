query 51989 "ACC Suggest Planning Entry"
{
    Caption = 'ACC Suggest Planning Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ACCBUInventoryEntry; "ACC BU Inventory Entry")
        {
            DataItemTableFilter = "Business Unit" = filter(<> '');
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
