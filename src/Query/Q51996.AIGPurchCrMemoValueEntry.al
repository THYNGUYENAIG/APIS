query 51996 "AIG Purch CrMemo Value Entry"
{
    Caption = 'AIG Purch CrMemo Value Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(PurchCrMemoLine; "Purch. Cr. Memo Line")
        {
            DataItemTableFilter = Type = filter(<> "Purchase Line Type"::" ");
            column(DocumentNo; "Document No.") { }
            column(LineNo; "Line No.") { }
            dataitem(ValueEntryRelation; "AIG Value Entry Relation")
            {
                DataItemLink = "Invoice No." = PurchCrMemoLine."Document No.",
                               "Invoice Line No." = PurchCrMemoLine."Line No.";
                SqlJoinType = LeftOuterJoin;
                column(TableNo; "Table No.") { }
                column(SourceRowID; "Source Row ID") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
