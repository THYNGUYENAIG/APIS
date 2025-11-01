query 51931 "ACC MP Purchase Order"
{
    Caption = 'APIS MP Purchase Order';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            DataItemTableFilter = "Outstanding Quantity" = filter(> 0),
                                  "BLACC Process Status" = filter(2 | 5 | 7);
            column(ItemNo; "No.") { }
            column(LocationCode; "Location Code") { }
            column(Quantity; "Outstanding Quantity")
            {
                Method = Sum;
            }
            column(MonthDate; "BLTEC Delivery Date")
            {
                Method = Month;
            }
            column(YearDate; "BLTEC Delivery Date")
            {
                Method = Year;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
