query 51917 "ACC Data MP Entry Qry"
{
    Caption = 'APIS Data MP Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;    

    elements
    {
        dataitem(DemandForecast; "ACC MP Demand Forecast")
        {
            DataItemTableFilter = Type = filter('Demand' | 'Requisition' | 'Purchase');
            column(Count) { Method = Count; }
            column(SiteNo; "Site No.") { }
            column(ItemNo; "Item No.") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
