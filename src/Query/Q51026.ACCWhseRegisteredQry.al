query 51026 "ACC Whse. Registered Qry"
{
    Caption = 'APIS Whse. Registered Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(RegisteredWhseActivityLine; "Registered Whse. Activity Line")
        {
            DataItemTableFilter = "Action Type" = const(Take);
            column(SourceDocument; "Source Document") { }
            column(SourceNo; "Source No.") { }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
