query 51032 "ACC Delivery Import Plan Qry"
{
    Caption = 'ACC Delivery Import Plan Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    OrderBy = descending(DeliveryDate);

    elements
    {
        dataitem(ACCImportPlanTable; "ACC Import Plan Table")
        {
            DataItemTableFilter = "Delivery Date" = filter(<> 0D);
            column(SourceDocumentNo; "Source Document No.") { }
            column(SourceLineNo; "Source Line No.") { }
            column(DeliveryDate; "Delivery Date") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
