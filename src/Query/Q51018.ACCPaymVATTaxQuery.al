query 51018 "ACC Paym. VAT Tax Decl. Query"
{
    Caption = 'APIS Paym. VAT Tax Decl. Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            DataItemTableFilter = "Vendor Posting Group" = filter('IMPORT' | 'GTGT' | 'TCPG'),
                                      "Bal. Account Type" = filter("Gen. Journal Account Type"::"Bank Account"),
                                      Reversed = filter(false);
            column(CustomsDeclarationNo; "External Document No.") { }
            column(VendorPostingGroup; "Vendor Posting Group") { }
            column(Amount; Amount) { Method = Sum; }
            column(AmountLCY; "Amount (LCY)") { Method = Sum; }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
