query 51061 "ACC Purchase Customs Lot Qry"
{
    Caption = 'ACC Purchase Customs Lot Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(AIGValueEntryRelation; "AIG Value Entry Relation")
        {
            DataItemTableFilter = "Declaration No." = filter(<> ''), "Table No." = filter(123);
            column(Count) { Method = Count; }
            column(DeclarationNo; "Declaration No.") { }
            column(OrderNo; "Order No.") { }
            column(ItemNo; "Item No.") { }
            column(ItemName; "Item Name") { }
            dataitem(ValueEntryRelation; "Value Entry Relation")
            {
                DataItemLink = "Source RowId" = AIGValueEntryRelation."Source Row ID";
                dataitem(ValueEntry; "Value Entry")
                {
                    DataItemLink = "Entry No." = ValueEntryRelation."Value Entry No.";
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = ValueEntry."Item Ledger Entry No.";
                        column(LotNo; "Lot No.") { }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
