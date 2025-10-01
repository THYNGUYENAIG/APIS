query 51066 "ACC Sales Order Qry"
{
    Caption = 'ACC Sales Order Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = filter("Sales Document Type"::Order), "Outstanding Quantity" = filter(<> 0);
            column(DocumentNo; "Document No.") { }
            column(DocumentType; "Document Type") { }
            column(LineNo; "Line No.") { }
            column(No; "No.") { }
            column(Description; Description) { }
            column(UnitofMeasureCode; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(UnitPrice; "Unit Price") { }
            column(LineAmount; "Line Amount") { }
            dataitem(SalesHeader; "Sales Header")
            {
                DataItemLink = "Document Type" = SalesLine."Document Type",
                               "No." = SalesLine."Document No.";
                column(ExternalDocumentNo; "External Document No.") { }
                column(CustomerNo; "Sell-to Customer No.") { }
                column(CustomerName; "Sell-to Customer Name") { }
                column(SellToPostCode; "Sell-to Post Code") { }
                column(PostingDate; "Posting Date") { }
                column(DocumentDate; "Document Date") { }
                column(RequestedDate; "Requested Delivery Date") { }
                column(BranchCode; "Shortcut Dimension 1 Code") { }
                column(BUCode; "Shortcut Dimension 2 Code") { }
                column(SalespersonCode; "Salesperson Code") { }

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
