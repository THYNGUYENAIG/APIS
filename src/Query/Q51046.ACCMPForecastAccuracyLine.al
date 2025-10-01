query 51046 "ACC MP Forecast Accuracy Line"
{
    Caption = 'ACC MP Forecast Accuracy Line';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ACCForecastAccuracyLine; "ACC Forecast Accuracy Line")
        {
            column(PeriodDate; "Period Date") { }
            column(ItemNo; "Item No.") { }
            column(BranchCode; "Branch Code") { }
            column(BUCode; "BU Code") { }
            column(Salesperson; Salesperson) { }
            column(SalesQuantity; "Sales Quantity")
            {
                Method = Sum;
            }
            column(FCT0; "FC T0")
            {
                Method = Sum;
            }
            column(FCT1; "FC T-1")
            {
                Method = Sum;
            }
            column(FCT2; "FC T-2")
            {
                Method = Sum;
            }
            column(FCT3; "FC T-3")
            {
                Method = Sum;
            }
            column(Budget; Budget)
            {
                Method = Sum;
            }
            column(YMNo; "YM No.") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
