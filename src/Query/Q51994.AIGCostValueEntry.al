query 51994 "AIG Cost Value Entry"
{
    Caption = 'AIG Cost Value Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ValueEntry; "Value Entry")
        {
            DataItemTableFilter = "Gen. Prod. Posting Group" = filter('<>Freight'),
                                  "Document Type" = filter("Item Ledger Document Type"::"Sales Invoice" | "Item Ledger Document Type"::"Sales Credit Memo" | "Item Ledger Document Type"::"Purchase Invoice" | "Item Ledger Document Type"::"Purchase Credit Memo");

            column(DocumentNo; "Document No.") { }
            column(DocumentType; "Document Type") { }
            column(DocumentLineNo; "Document Line No.") { }
            column(ItemLedgerEntryNo; "Item Ledger Entry No.") { }
            column(Adjustment; Adjustment) { }
            column(PostingDate; "Posting Date") { }
            column(CostAmountActual; "Cost Amount (Actual)") { Method = Sum; }
            column(SalesAmountActual; "Sales Amount (Actual)") { Method = Sum; }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
