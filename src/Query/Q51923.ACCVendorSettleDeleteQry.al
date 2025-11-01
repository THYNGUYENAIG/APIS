query 51923 "ACC Vendor Settle Delete Qry"
{
    Caption = 'APIS Vendor Settle Delete Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(VendorSettlement; "ACC Vendor Ledger Settlement")
        {
            column(DetailedEntryNo; "Detailed Entry No.")
            {
            }
            column(ModifiedAt; "Modified At")
            {
            }
            dataitem(VendorLedgerEntry; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Entry No." = VendorSettlement."Detailed Entry No.";
                SqlJoinType = LeftOuterJoin;
                column(EntryNo; "Entry No.")
                { }
            }
        }
    }
    trigger OnBeforeOpen()
    begin

    end;
}
