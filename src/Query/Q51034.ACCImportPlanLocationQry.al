query 51034 "ACC Import Plan Location Qry"
{
    Caption = 'APIS Import Plan Location Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ACCImportPlanTable; "ACC Import Plan Table")
        {
            DataItemTableFilter = "Actual Location Code" = filter(<> '');
            column(SourceDocumentNo; "Source Document No.") { }
            //column(SourceLineNo; "Source Line No.") { }
            column(ActualLocationCode; "Actual Location Code") { }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemTableFilter = "Document Type" = filter(Order),
                                      "Outstanding Quantity" = filter(> 0);
                DataItemLink = "Document No." = ACCImportPlanTable."Source Document No.",
                               "Line No." = ACCImportPlanTable."Source Line No.";
                column(OutstandingQuantity; "Outstanding Quantity")
                {
                    Method = Sum;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
