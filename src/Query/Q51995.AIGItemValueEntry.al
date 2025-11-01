query 51995 "AIG Item Value Entry"
{
    Caption = 'AIG Item Value Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    UsageCategory = Administration;
    
    elements
    {
        dataitem(AIGValueEntryRelation; "AIG Value Entry Relation")
        {
            column(InvoiceNo; "Invoice No.") { }
            column(InvoiceLineNo; "Invoice Line No.") { }
            column(OrderNo; "Order No.") { }
            column(OrderLineNo; "Order Line No.") { }
            column(SourceNo; "Source No.") { }
            column(SourceName; "Source Name") { }
            column(ItemNo; "Item No.") { }
            column(ItemName; "Item Name") { }
            column(UnitCode; "Unit Code") { }
            column(UnitPrice; "Unit Price") { }
            column(UnitCost; "Unit Cost") { }
            column(PostingDate; "Posting Date") { }
            dataitem(ValueEntryRelation; "Value Entry Relation")
            {
                DataItemLink = "Source RowId" = AIGValueEntryRelation."Source Row ID";
                dataitem(ValueEntry; "Value Entry")
                {
                    DataItemLink = "Entry No." = ValueEntryRelation."Value Entry No.";
                    column(ValueEntryNo; "Entry No.") { }
                    column(ItemLedgerEntryNo; "Item Ledger Entry No.") { }
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = ValueEntry."Item Ledger Entry No.";
                        SqlJoinType = InnerJoin;
                        column(DocumentType; "Document Type") { }
                        column(DocumentNo; "Document No.") { }
                        column(DocumentLineNo; "Document Line No.") { }
                        column(PhysicalDate; "Posting Date") { }
                        column(LocationCode; "Location Code") { }
                        column(Quantity; Quantity) { }
                        column(LotNo; "Lot No.") { }
                        dataitem(LotNoInformation; "Lot No. Information")
                        {
                            DataItemLink = "Item No." = ItemLedgerEntry."Item No.",
                                           "Variant Code" = ItemLedgerEntry."Variant Code",
                                           "Lot No." = ItemLedgerEntry."Lot No.";
                            column(ManufacturingDate; "BLACC Manufacturing Date") { }
                            column(ExpirationDate; "BLACC Expiration Date") { }
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
