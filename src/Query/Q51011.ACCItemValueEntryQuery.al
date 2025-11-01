query 51011 "ACC Item Value Entry Query"
{
    Caption = 'APIS Item Value Entry Query - Q51011';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ValueEntry; "Value Entry")
        {
            column(EntryNo; "Entry No.") { }
            column(EntryType; "Entry Type") { }
            column(DocumentType; "Document Type") { }
            column(DocumentNo; "Document No.") { }
            column(DocumentLineNo; "Document Line No.") { }
            column(DocumentDate; "Document Date") { }
            column(PostingDate; "Posting Date") { }
            column(SalespersPurchCode; "Salespers./Purch. Code") { }
            column(SourceCode; "Source Code") { }
            column(SourceNo; "Source No.") { }
            column(SourceType; "Source Type") { }
            column(No; "No.") { }
            column(OrderNo; "Order No.") { }
            column(OrderLineNo; "Order Line No.") { }
            column(OrderType; "Order Type") { }
            column(LocationCode; "Location Code") { }
            column(ItemNo; "Item No.") { }
            column(ItemLedgerEntryNo; "Item Ledger Entry No.") { }
            dataitem(ValueEntryRelation; "Value Entry Relation")
            {
                DataItemLink = "Value Entry No." = ValueEntry."Entry No.";
                column(SourceRowId; "Source RowId")
                { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
