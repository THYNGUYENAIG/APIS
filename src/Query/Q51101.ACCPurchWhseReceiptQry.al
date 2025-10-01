query 51101 "ACC Purch. Whse. Receipt Qry"
{
    Caption = 'ACC Purch. Whse. Receipt Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(PostedWhseReceiptLine; "Posted Whse. Receipt Line")
        {
            column(Count) { Method = Count; }
            column(No; "No.") { }
            column(PostedSourceNo; "Posted Source No.") { }
            column(PostingDate; "Posting Date") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
