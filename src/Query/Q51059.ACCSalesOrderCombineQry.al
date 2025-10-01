query 51059 "ACC MP Sales Line Qry"
{
    Caption = 'ACC MP Sales Line Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = Quantity = filter(<> 0),
                                  Type = filter("Sales Line Type"::Item),
                                  "No." = filter(<> 'SERVICE*');
            column(OrderNo; "Document No.") { }
            column(DocumentNo; "Document No.") { }
            column(LineNo; "Line No.") { }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
                Caption = 'Customer Code';
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
                Caption = 'Customer Name';
            }
            column(PostingDate; "Posting Date") { }
            column(ItemNo; "No.") { }
            column(ItemName; "BLTEC Item Name") { }
            column(Quantity; Quantity) { }
            column(UnitPrice; "Unit Price") { }
            //column(UnitCost; "Unit Cost") { }
            column(Amount; Amount) { }
            //column(CostAmount; "BLACC Cost Amount") { }
            //column(LineAmount; "Line Amount") { }
            column(SiteId; "Shortcut Dimension 1 Code")
            {
                Caption = 'Branch Code';
            }
            column(LocationCode; "Location Code") { }
            column(BusinessUnit; "Shortcut Dimension 2 Code")
            {
                Caption = 'BU Code';
            }
            column(SystemCreatedAt; SystemCreatedAt) { }
            dataitem(SalesHeader; "Sales Header")
            {
                DataItemTableFilter = "Document Type" = filter("Sales Document Type"::Order);
                DataItemLink = "No." = SalesLine."Document No.";
                SqlJoinType = InnerJoin;
                column(City; "Sell-to City")
                {
                    Caption = 'City';
                }
                dataitem(Salesperson; "Salesperson/Purchaser")
                {
                    DataItemLink = Code = SalesHeader."Salesperson Code";
                    column(SalespersonName; Name)
                    {
                        Caption = 'Sales Person';
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
