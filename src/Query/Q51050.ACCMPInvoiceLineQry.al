query 51050 "ACC MP Invoice Line Qry"
{
    Caption = 'ACC MP Invoice Line - Q51050';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(LotNoInformation; "Lot No. Information")
        {
            column(LotNo; "Lot No.") { }
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                //DataItemTableFilter = "Document Type" = filter("Item Ledger Document Type"::"Sales Invoice");
                DataItemLink = "Item No." = LotNoInformation."Item No.", "Variant Code" = LotNoInformation."Variant Code", "Lot No." = LotNoInformation."Lot No.";
                SqlJoinType = InnerJoin;
                column(Quantity; Quantity) { Method = Sum; }
                dataitem(ValueEntry; "Value Entry")
                {
                    DataItemTableFilter = Adjustment = filter(false),
                                          "Document Type" = filter("Item Ledger Document Type"::"Sales Invoice");
                    DataItemLink = "Item Ledger Entry No." = ItemLedgerEntry."Entry No.";
                    SqlJoinType = InnerJoin;
                    column(InvoiceNo; "Document No.") { }
                    dataitem(SalesInvoiceLine; "Sales Invoice Line")
                    {
                        DataItemTableFilter = Quantity = filter(<> 0),
                                  Type = filter("Sales Line Type"::Item),
                                  "No." = filter(<> 'SERVICE*');
                        DataItemLink = "Document No." = ValueEntry."Document No.",
                                       "Line No." = ValueEntry."Document Line No.";
                        SqlJoinType = InnerJoin;
                        column(OrderNo; "Order No.") { }
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
                        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
                        {
                            DataItemLink = "No." = SalesInvoiceLine."Document No.";
                            SqlJoinType = InnerJoin;
                            column(City; "Sell-to City")
                            {
                                Caption = 'City';
                            }
                            dataitem(Salesperson; "Salesperson/Purchaser")
                            {
                                DataItemLink = Code = SalesInvoiceHeader."Salesperson Code";
                                column(SalespersonName; Name)
                                {
                                    Caption = 'Sales Person';
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}