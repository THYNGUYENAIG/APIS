query 51926 "ACC Cust Settle Insert Qry"
{
    Caption = 'APIS Cust Settle Insert Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        //dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        //{
        //column(SalesInvNo; "No.") { }
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableFilter = "Document Type" = filter("Gen. Journal Document Type"::Invoice | "Gen. Journal Document Type"::"Credit Memo"),
                                  "Customer Posting Group" = filter('1|2|3|4|5|6');
            SqlJoinType = InnerJoin;
            column(CustEntryNo; "Entry No.") { }
            column(ModifiedAt; SystemModifiedAt) { }

            dataitem(CustSettlement; "ACC Cust. Ledger Settlement")
            {
                DataItemLink = "Ledger Entry No." = CustLedgerEntry."Entry No.";
                SqlJoinType = LeftOuterJoin;
                column(LedgerEntryNo; "Ledger Entry No.")
                {
                }
            }
        }
        //}
    }
    trigger OnBeforeOpen()
    begin

    end;
}
