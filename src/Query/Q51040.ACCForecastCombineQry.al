query 51040 "ACC Forecast Combine Qry"
{
    Caption = 'APIS Forecast Combine Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(ForecastEntry; "BLACC Forecast Entry")
        {
            column(AgreementEndDate; "BLACC Agreement EndDate") { }
            column(SalesPool; "BLACC Sales Pool") { }
            column(LocationCode; "Location Code") { }
            column(BusinessUnitId; "BLACC Shortcut Dim 2 Code") { }
            column(ItemNo; "No.") { }
            column(NoSA; "No SA") { }
            column(SAQuantity; "BLACC Quantity") { }
            dataitem(ProductionForecastEntry; "Production Forecast Entry")
            {
                DataItemTableFilter = "Item No." = filter(<> ''),
                                  "Forecast Quantity" = filter(<> 0),
                                  "Forecast Date" = filter(<> 0D),
                                  "BLACC Active" = filter(true);
                DataItemLink = "BLACC Parent Entry" = ForecastEntry."Entry No.";
                SqlJoinType = InnerJoin;
                column(Quantity; "Forecast Quantity")
                {
                    Method = Sum;
                }
                column(DeliveryDate; "Forecast Date") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
