query 51922 "ACC Cust Ledger Settlement Qry"
{
    Caption = 'ACC Cust Ledger Settlement Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(SalesInvNo; "No.") { }
            dataitem(CustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = SalesInvoiceHeader."No.",
                               "Posting Date" = SalesInvoiceHeader."Posting Date";
                SqlJoinType = InnerJoin;
                column(EntryNo; "Entry No.") { }
                column(ExternalDocumentNo; "External Document No.") { }
                column(DocumentNo; "Document No.") { }
                column(CustomerNo; "Customer No.") { }
                column(CustomerName; "Customer Name") { }
                column(Description; Description) { }
                column(DocumentDate; "Document Date") { }
                column(PostingDate; "Posting Date") { }
                column(DueDate; "Due Date") { }
                column(BranchCode; "Global Dimension 1 Code") { }
                column(BusinessUnit; "Global Dimension 2 Code") { }
                column(eInvoiceNo; "BLTI eInvoice No.") { }
                column(Amount; Amount) { }
                column(AmountSettled; "Amount (LCY)") { }
                column(RemainingAmount; "Remaining Amount") { }
                column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
                column(CurrencyCode; "Currency Code") { }
                column(SystemModifiedAt; SystemModifiedAt) { }
                dataitem(Customer; Customer)
                {
                    DataItemLink = "No." = CustLedgerEntry."Customer No.";
                    column(StatisticsGroup; "Statistics Group") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
