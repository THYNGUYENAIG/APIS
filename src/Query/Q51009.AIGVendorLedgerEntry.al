query 51009 "AIG Vendor Ledger Entry"
{
    Caption = 'AIG Vendor Ledger Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            column(EntryNo; "Entry No.") { }
            column(DocumentNo; "Document No.") { }
            column(DocumentType; "Document Type") { }
            column(DocumentDate; "Document Date") { }
            column(DueDate; "Due Date") { }
            column(PostingDate; "Posting Date") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount (LCY)") { }
            column(RemainingAmount; "Remaining Amount") { }
            column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
            dataitem(DetailedVendorLedgEntry; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor Ledger Entry No." = VendorLedgerEntry."Entry No.";
                column(DetailedEntryNo; "Entry No.") { }
                column(EntryType; "Entry Type") { }
                column(DetailedDocumentType; "Document Type") { }
                column(DetailedDocumentNo; "Document No.") { }
                column(DetailedAmount; Amount) { }
                column(DetailedAmountLCY; "Amount (LCY)") { }
                column(AppliedVendLedgerEntryNo; "Applied Vend. Ledger Entry No.") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
