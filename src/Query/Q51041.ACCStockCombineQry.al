query 51041 "ACC Stock Combine Qry"
{
    Caption = 'ACC Stock Combine Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Remaining Quantity" = filter(<> 0),
                                  "Location Code" = filter(<> 'INSTRANSIT');
            column(LocationCode; "Location Code") { }
            //column(SiteId; "Global Dimension 1 Code") { }
            column(BusinessUnitId; "Global Dimension 2 Code") { }
            column(ItemNo; "Item No.") { }
            column(Quantity; "Remaining Quantity")
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
