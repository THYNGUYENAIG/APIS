query 51043 "ACC MP Combine Line Qry"
{
    Caption = 'ACC MP Combine Line Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    elements
    {
        dataitem(ACCMPCombineLine; "ACC MP Combine Line")
        {
            column(EntityID; "Entity ID") { }
            column(SiteID; "Site ID") { }
            column(BusinessUnitID; "Business Unit ID") { }
            column(DimensionValue; "Dimension Value") { }
            column(SKUID; "SKU ID") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(SAQuantity; "SA Quantity")
            {
                Method = Sum;
            }
            column(Period; Period) { }
            column(PeriodDate; "Period Date") { }
            column(StatisticPeriodNumber; "Statistic Period Number") { }
            column(PODateStatus; "PO Date Status") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
