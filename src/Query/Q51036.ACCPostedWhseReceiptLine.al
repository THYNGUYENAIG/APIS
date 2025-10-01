query 51036 "ACC Posted Whse. Receipt Line"
{
    Caption = 'ACC Posted Whse. Receipt Line';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(PostedWhseReceiptLine; "Posted Whse. Receipt Line")
        {
            column(SourceNo; "Source No.") { }
            column(SourceLineNo; "Source Line No.") { }
            column(LocationCode; "Location Code") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
