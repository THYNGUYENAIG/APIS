query 51071 "AIG Sales Invoice Qry"
{
    Caption = 'AIG Sales Invoice Qry';
    QueryType = Normal;
    QueryCategory = 'Item List';
    elements
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(No; "No.") { }
            column(SalespersonCode; "Salesperson Code") { }
            column(SelltoCustomerNo; "Sell-to Customer No.") { }
            column(SelltoCustomerName; "Sell-to Customer Name") { }
            column(BilltoCustomerNo; "Bill-to Customer No.") { }
            column(BilltoName; "Bill-to Name") { }
            column(PostingDate; "Posting Date") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(BLTIeInvoiceNo; "BLTI eInvoice No.") { }
            column(BLTIOriginaleInvoiceNo; "BLTI Original eInvoice No.") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(SelltoCity; "Sell-to City") { }
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemTableFilter = Type = filter("Sales Line Type"::"G/L Account");
                DataItemLink = "Document No." = SalesInvoiceHeader."No.";
                SqlJoinType = InnerJoin;
                column(SalesNo; "Order No.") { }
                column(LineNo; "Line No.") { }
                column(ItemNo; "No.") { }
                column(ItemName; "BLTEC Item Name") { }
                column(SearchName; Description) { }
                column(UnitCode; "Unit of Measure Code") { }
                column(DimensionSetID; "Dimension Set ID") { }
                column(Quantity; Quantity) { }
                column(UnitPrice; "Unit Price") { }
                column(LineAmount; "Line Amount") { }
                column(AmountIncludingVAT; "Amount Including VAT") { }
                column(VATBaseAmount; "VAT Base Amount") { }
                column(ItemSalesTaxGroup; "Tax Group Code") { }
                column(VATPercent; "VAT %") { }
                column(VATProdPostingGroup; "VAT Prod. Posting Group") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
