query 51992 "AIG Transaction Entry"
{
    Caption = 'AIG Transaction Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(AIGTransactionEntry; "AIG Transaction Entry")
        {
            column(EntryType; "Entry Type") { }
            column(DocumentType; "Document Type") { }
            column(OrderNo; "Order No.") { }
            column(ItemNo; "Item No.") { }
            column(Site; Site) { }
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
