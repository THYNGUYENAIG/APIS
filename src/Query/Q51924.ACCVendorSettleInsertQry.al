query 51924 "ACC Vendor Settle Insert Qry"
{
    Caption = 'ACC Vendor Settle Insert Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = ascending(PurchInvNo, VendorEntryNo);
    
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
                column(VendorEntryNo; "Entry No.") { }
                dataitem(DetailedVendorLedgerEntry; "Detailed Vendor Ledg. Entry")
                {
                    DataItemTableFilter = "Entry Type" = filter("Detailed CV Ledger Entry Type"::"Initial Entry" | "Detailed CV Ledger Entry Type"::Application);
                    DataItemLink = "Vendor Ledger Entry No." = VendorLedgerEntry."Entry No.";
                    SqlJoinType = InnerJoin;
                    column(DetailedVendorEntryNo; "Entry No.")
                    { }
                    column(ModifiedAt; SystemModifiedAt) { }
                    dataitem(VendorSettlement; "ACC Vendor Ledger Settlement")
                    {
                        DataItemLink = "Detailed Entry No." = DetailedVendorLedgerEntry."Entry No.";
                        SqlJoinType = LeftOuterJoin;
                        column(DetailedEntryNo; "Detailed Entry No.")
                        {
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
