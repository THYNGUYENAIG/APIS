query 51929 "ACC MP Forecast Entry"
{
    Caption = 'ACC MP Forecast Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = ascending(ParentEntry, ForecastDate);
    UsageCategory = ReportsAndAnalysis;
    elements
    {
        dataitem(ProductionForecastEntry; "Production Forecast Entry")
        {
            DataItemTableFilter = "BLACC Active" = filter(true), "Forecast Quantity" = filter(> 0);
            column(ParentEntry; "BLACC Parent Entry") { }
            column(ForecastDate; "Forecast Date") { }
            column(ForecastQuantity; "Forecast Quantity")
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
