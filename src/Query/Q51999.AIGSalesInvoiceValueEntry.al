query 51999 "AIG Sales Invoice Value Entry"
{
    Caption = 'AIG Sales Invoice Value Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesInvoiceLine; "Sales Invoice Line")
        {
            DataItemTableFilter = Type = filter(<> "Sales Line Type"::" ");
            column(DocumentNo; "Document No.") { }
            column(LineNo; "Line No.") { }
            dataitem(ValueEntryRelation; "AIG Value Entry Relation")
            {
                DataItemLink = "Invoice No." = SalesInvoiceLine."Document No.",
                               "Invoice Line No." = SalesInvoiceLine."Line No.";
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
