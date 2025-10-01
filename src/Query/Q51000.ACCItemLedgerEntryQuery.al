query 51000 "ACC Item Ledger Entry Query"
{
    Caption = 'ACC Item Ledger Entry Query - Q51000';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ItemEntryRelation; "Item Entry Relation")
        {
            column(SourceType; "Source Type") { }
            column(SourceSubtype; "Source Subtype") { }
            column(SourceID; "Source ID") { }
            column(SourceBatchName; "Source Batch Name") { }
            column(SourceProdOrderLine; "Source Prod. Order Line") { }
            column(SourceRefNo; "Source Ref. No.") { }
            column(ItemEntryNo; "Item Entry No.") { }
            column(LotNo; "Lot No.") { }
            column(SerialNo; "Serial No.") { }
            column(OrderNo; "Order No.") { }
            column(OrderLineNo; "Order Line No.") { }
            column(PackageNo; "Package No.") { }
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemLink = "Entry No." = ItemEntryRelation."Item Entry No.";
                column(CostAmountActual; "Cost Amount (Actual)") { }
                column(CostAmountActualACY; "Cost Amount (Actual) (ACY)") { }
                column(Description; Description) { }
                column(DocumentDate; "Document Date") { }
                column(DocumentNo; "Document No.") { }
                column(DocumentType; "Document Type") { }
                column(EntryNo; "Entry No.") { }
                column(EntryType; "Entry Type") { }
                column(ExpirationDate; "Expiration Date") { }
                column(GlobalDimension1Code; "Global Dimension 1 Code") { }
                column(GlobalDimension2Code; "Global Dimension 2 Code") { }
                column(InvoicedQuantity; "Invoiced Quantity") { }
                column(ItemNo; "Item No.") { }
                column(EntryLotNo; "Lot No.") { }
                column(LocationCode; "Location Code") { }
                column(EntryOrderNo; "Order No.") { }
                column(OrderType; "Order Type") { }
                column(EntryOrderLineNo; "Order Line No.") { }
                column(PostingDate; "Posting Date") { }
                column(Quantity; Quantity) { }
                column(RemainingQuantity; "Remaining Quantity") { }
                column(SalesAmountActual; "Sales Amount (Actual)") { }
                column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
                column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
                column(ShortcutDimension5Code; "Shortcut Dimension 5 Code") { }
                column(ShortcutDimension6Code; "Shortcut Dimension 6 Code") { }
                column(ShortcutDimension7Code; "Shortcut Dimension 7 Code") { }
                column(ShortcutDimension8Code; "Shortcut Dimension 8 Code") { }
                column(EntrySerialNo; "Serial No.") { }
                column(SourceNo; "Source No.") { }
                column(EntrySourceType; "Source Type") { }
                column(UnitofMeasureCode; "Unit of Measure Code") { }
                column(WarrantyDate; "Warranty Date") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
