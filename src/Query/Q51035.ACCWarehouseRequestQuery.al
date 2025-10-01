query 51035 "ACC Warehouse Request Query"
{
    Caption = 'ACC Warehouse Request Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(WarehouseRequest; "Warehouse Request")
        {
            column("Type"; "Type")
            {
            }
            column(SourceDocument; "Source Document")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(SourceSubtype; "Source Subtype")
            {
            }
            column(SourceType; "Source Type")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(CompletelyHandled; "Completely Handled")
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
