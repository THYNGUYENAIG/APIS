query 51064 "ACC Purch. Invoice & Cr. Memos"
{
    Caption = 'ACC Purch. Invoice & Cr. Memos - Q51064';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    UsageCategory = ReportsAndAnalysis;
    elements
    {
        dataitem(AIGValueEntryRelation; "AIG Value Entry Relation")
        {
            DataItemTableFilter = "Table No." = filter(123 | 125);
            column(InvoiceNo; "Invoice No.") { }
            column(InvoiceLineNo; "Invoice Line No.") { }
            column(InvoiceAccount; "Invoice Account") { }
            column(InvoiceName; "Invoice Name") { }
            column(ItemNo; "Item No.") { }
            column(ItemName; "Item Name") { }
            column(SearchName; "Search Name") { }
            column(UnitCode; "Unit Code") { }
            column(Quantity; Quantity) { }
            column(UnitPrice; "Unit Price") { }
            column(LineAmount; "Line Amount") { }
            column(ExchangeRate; "Exchange Rate") { }
            column(LineAmountLCY; "Line Amount (LCY)") { }
            column(eInvoiceNo; "eInvoice No.") { }
            column(ExternalDocumentNo; "External Document No.") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
