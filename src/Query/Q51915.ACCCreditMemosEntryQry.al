query 51915 "ACC Credit Memos Entry Qry"
{
    Caption = 'ACC Credit Memos Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            column(SalespersonCode; "Salesperson Code") { }
            dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
            {
                DataItemTableFilter = Type = filter("Sales Line Type"::Item),
                                      "No." = filter(<> 'SERVICE-511');
                DataItemLink = "Document No." = SalesCrMemoHeader."No.";
                column(AgreementNo; "BLACC Agreement No.") { }
                column(CustomerNo; "Sell-to Customer No.") { }
                column(ItemNo; "No.") { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                column(LocationCode; "Location Code") { }
                column(BusinessUnitID; "Shortcut Dimension 2 Code") { }
                column(PostingDate; "Posting Date") { }
                column(PostingYear; "Posting Date")
                {
                    Method = Year;
                }
                column(PostingMonth; "Posting Date")
                {
                    Method = Month;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
