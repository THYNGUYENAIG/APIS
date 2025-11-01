query 51990 "ACC BU Transaction Entry"
{
    Caption = 'APIS BU Transaction Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = ascending(ItemNo, Quantity);

    elements
    {
        dataitem(AIGTransactionEntry; "AIG Transaction Entry")
        {
            column(ItemNo; "Item No.") { }
            column(BusinessUnit; "Business Unit") { }
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
