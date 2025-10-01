query 51997 "AIG Purch Invoice Value Entry"
{
    Caption = 'AIG Purch Invoice Value Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(PurchInvLine; "Purch. Inv. Line")
        {
            DataItemTableFilter = Type = filter(<>"Purchase Line Type"::" ");
            column(DocumentNo; "Document No.") { }
            column(LineNo; "Line No.") { }
            dataitem(ValueEntryRelation; "AIG Value Entry Relation")
            {
                DataItemLink = "Invoice No." = PurchInvLine."Document No.",
                               "Invoice Line No." = PurchInvLine."Line No.";
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
