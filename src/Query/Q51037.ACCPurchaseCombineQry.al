query 51037 "ACC Purchase Combine Qry"
{
    Caption = 'ACC Purchase Combine Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            DataItemTableFilter = Type = filter("Purchase Line Type"::Item),
                                  "BLACC Process Status" = filter(< 10),
                                  "Outstanding Quantity" = filter(> 0);
            column(LocationCode; "Location Code") { }
            column(SiteId; "Shortcut Dimension 1 Code") { }
            column(ItemNo; "No.") { }
            column(Quantity; "Outstanding Quantity")
            {
                Method = Sum;
            }
            column(ProcessStatus; "BLACC Process Status") { }
            dataitem(ImportEntry; "BLTEC Import Entry")
            {
                DataItemTableFilter = "Delivery Date" = filter(<> 0D),
                                      "Process Status" = filter(< 10);
                DataItemLink = "Purchase Order No." = PurchaseLine."Document No.",
                               "Line No." = PurchaseLine."Line No.";
                SqlJoinType = InnerJoin;
                column(BusinessUnitId; "Shortcut Dimension 2 Code") { }
                column(DeliveryDate; "Delivery Date") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
