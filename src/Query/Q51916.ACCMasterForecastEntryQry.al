query 51916 "ACC Master Forecast Entry Qry"
{
    Caption = 'ACC Master Forecast Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = ascending(SiteNo, ItemNo, ForecastDate);

    elements
    {
        dataitem(DemandForecast; "ACC MP Demand Forecast")
        {
            column(SiteNo; "Site No.") { }
            column(ItemNo; "Item No.") { }
            column(ForecastDate; "Forecast Date") { }
            column(ForecastQuantity; "Forecast Quantity")
            {
                Method = Sum;
            }
            column(Type; Type) { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
