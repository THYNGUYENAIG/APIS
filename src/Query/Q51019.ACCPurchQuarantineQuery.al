query 51019 "ACC Purch. Quarantine Query"
{
    Caption = 'ACC Purch. Quarantine Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = Ascending(CreatedAt);

    elements
    {
        dataitem(PurchItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Document Type" = filter("Item Ledger Document Type"::"Purchase Receipt"),
                                  Open = filter(true);
            column(Count) { Method = Count; }
            column(OrderNo; "ACC Order No.") { }
            column(ItemNo; "Item No.") { }
            column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
            dataitem(LotNoInformation; "Lot No. Information")
            {
                DataItemTableFilter = "ACC UnBlock Created At" = filter(> 0D);
                DataItemLink = "Item No." = PurchItemLedgerEntry."Item No.",
                               "Variant Code" = PurchItemLedgerEntry."Variant Code",
                               "Lot No." = PurchItemLedgerEntry."Lot No.";
                column(CreatedAt; "ACC UnBlock Created At") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
