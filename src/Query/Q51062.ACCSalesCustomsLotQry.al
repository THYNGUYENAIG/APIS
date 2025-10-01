query 51062 "ACC Sales Customs Lot Qry"
{
    Caption = 'ACC Sales Customs Lot Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(AIGValueEntryRelation; "AIG Value Entry Relation")
        {
            DataItemTableFilter = "Table No." = filter(113);
            column(Count) { Method = Count; }
            column(OrderNo; "Order No.") { }
            column(SourceName; "Source Name") { }
            column(ItemNo; "Item No.") { }
            column(PostingDate; "Posting Date") { }
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
                        dataitem(Item; Item)
                        {
                            DataItemTableFilter = "Inventory Posting Group" = filter('A-01');
                            DataItemLink = "No." = ItemLedgerEntry."Item No.";
                            column(Description; Description) { }
                        }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
