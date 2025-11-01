query 51920 "ACC Vend Ledger Settlement Qry"
{
    Caption = 'APIS Vendor Ledger Settlement Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            column(PurchInvNo; "No.") { }
            dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
            {
                DataItemTableFilter = "Vendor Posting Group" = filter('A02' | 'B01' | 'B02');
                DataItemLink = "Document No." = PurchInvHeader."No.",
                               "Posting Date" = PurchInvHeader."Posting Date";
                SqlJoinType = InnerJoin;
                column(EntryNo; "Entry No.") { }
                column(ExternalDocumentNo; "External Document No.") { }
                column(VendorPostingGroup; "Vendor Posting Group") { }
                column(VendorNo; "Vendor No.") { }
                column(VendorName; "Vendor Name") { }
                column(Description; Description) { }
                column(PostingDate; "Posting Date") { }
                column(DueDate; "Due Date") { }
                dataitem(DetailedVendorLedgEntry; "Detailed Vendor Ledg. Entry")
                {
                    DataItemTableFilter = "Entry Type" = filter("Detailed CV Ledger Entry Type"::"Initial Entry" | "Detailed CV Ledger Entry Type"::Application);
                    DataItemLink = "Vendor Ledger Entry No." = VendorLedgerEntry."Entry No.";
                    column(AppliedVendLedgerEntryNo; "Applied Vend. Ledger Entry No.") { }
                    column(EntryType; "Entry Type") { }
                    column(DocumentType; "Document Type") { }
                    column(DetailedEntryNo; "Entry No.") { }
                    column(DocumentNo; "Document No.") { }
                    column(DateOfSettlement; "Posting Date") { }
                    column(SettledCurrency; Amount) { }
                    column(AmountSettled; "Amount (LCY)") { }
                    column(CurrencyCode; "Currency Code") { }
                    column(SystemModifiedAt; SystemModifiedAt) { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
