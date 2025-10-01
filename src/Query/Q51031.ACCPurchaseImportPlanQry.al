query 51031 "ACC Purchase Import Plan Qry"
{
    Caption = 'ACC Purchase Import Plan Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ACCImportPlanTable; "ACC Import Plan Table")
        {
            DataItemTableFilter = "Actual Location Code" = filter(<> '');
            column(SourceDocumentNo; "Source Document No.") { }
            column(SourceLineNo; "Source Line No.") { }
            column(ActualLocationCode; "Actual Location Code") { }
            column(Count)
            {
                Method = Count;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
