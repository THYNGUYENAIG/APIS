query 51014 "ACC Sales Lot Number Query "
{
    Caption = 'APIS Sales Lot Number Query ';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = Ascending(PostingDate);

    elements
    {
        dataitem(PurchItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Document Type" = filter("Item Ledger Document Type"::"Purchase Receipt"),
                                  "BLTEC Customs Declaration No." = filter(<> '');
            column(Count) { Method = Count; }
            column(ItemNo; "Item No.") { }
            column(LotNo; "Lot No.") { }
            column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
            dataitem(SalesItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemTableFilter = "Document Type" = filter("Item Ledger Document Type"::"Sales Shipment");
                DataItemLink = "Item No." = PurchItemLedgerEntry."Item No.",
                               "Lot No." = PurchItemLedgerEntry."Lot No.";
                column(PostingDate; "Posting Date") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
