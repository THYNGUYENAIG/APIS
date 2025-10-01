query 51998 "AIG Sales CrMemo Value Entry"
{
    Caption = 'AIG Sales CrMemo Value Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
        {
            DataItemTableFilter = Type = filter(<> "Sales Line Type"::" ");
            column(DocumentNo; "Document No.") { }
            column(LineNo; "Line No.") { }
            dataitem(ValueEntryRelation; "AIG Value Entry Relation")
            {
                DataItemLink = "Invoice No." = SalesCrMemoLine."Document No.",
                               "Invoice Line No." = SalesCrMemoLine."Line No.";
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
