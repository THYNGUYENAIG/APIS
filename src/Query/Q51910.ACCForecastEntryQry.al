query 51910 "ACC Forecast Entry Qry"
{
    Caption = 'APIS Forecast Entry Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = ascending(BusinessUnitId, SalespersonCode, CustomerNo, ItemNo, LocationCode, SalesAgreementNo, ForecastDate);

    elements
    {
        dataitem(ProductionForecastEntry; "Production Forecast Entry")
        {
            DataItemTableFilter = "BLACC Active" = filter(true), "BLACC Parent Entry" = filter(> 0);
            column(ParentEntry; "BLACC Parent Entry") { }
            column(ItemNo; "Item No.") { }
            column(ItemName; Description) { }
            column(CustomerNo; "BLACC Sell-to Customer No.") { }
            column(CustomerName; "BLACC Customer Name") { }
            column(SalesPool; "BLACC Sales Pool") { }
            column(LocationCode; "Location Code") { }
            column(BusinessUnitId; "BLACC Shortcut Dim 2 Code") { }
            column(SalespersonCode; "BLACC Salesperson Code") { }
            column(SalespersonName; "BLACC Salesperson Name") { }
            column(SalesAgreementNo; "BLACC Sales Agreement No.") { }
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
