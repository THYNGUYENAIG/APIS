query 51060 "ACC Forecast Agreement Qry"
{
    Caption = 'ACC Forecast Agreement Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ProductionForecastEntry; "Production Forecast Entry")
        {
            DataItemTableFilter = "BLACC Sales Agreement No." = filter(<> 'SALESTOOL2SALESORDER'),
                                  "Item No." = filter(<> ''),
                                  "Forecast Quantity" = filter(> 0),
                                  "Forecast Date" = filter(<> 0D),
                                  "BLACC Active" = filter(true);
            column(LocationCode; "Location Code") { }
            //column(SiteId; "BLACC Shortcut Dim 1 Code") { }
            column(BusinessUnitId; "BLACC Shortcut Dim 2 Code") { }
            column(ItemNo; "Item No.") { }
            column(Quantity; "Forecast Quantity")
            {
                Method = Sum;
            }
            column(DeliveryDate; "Forecast Date") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
