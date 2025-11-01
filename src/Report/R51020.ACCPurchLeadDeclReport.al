report 51020 "ACC Purch. Lead. Decl. Report"
{
    ApplicationArea = All;
    Caption = 'APIS Purch. Lead. Decl. Report - R51020';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51020.ACCPurchLeadDeclReport.rdl';
    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(BuyfromVendorNo; "Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName; "Buy-from Vendor Name")
            {
            }
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            dataitem(PurchInvLine; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = filter(Item));
                column(OrderNo; "Order No.") { }
                column(ItemNo; "No.") { }
                column(ItemName; Description) { }
                column(UnitCode; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                dataitem(ImportEntry; "BLTEC Import Entry")
                {
                    DataItemLink = "Purchase Order No." = field("Order No."),
                                   "Line No." = field("Order Line No.");
                    column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
                    column(CustomsDeclarationDate; "Customs Declaration Date") { }
                    column(OrderDate; "BLACC Order Date") { }
                    column(OnBoardDate; "On Board Date") { }
                    column(LatestETADate; "Latest ETA Date") { }
                    column(ReleaseDate; "Release Date") { }
                    column(ReceiptDate; "Posted Receipt Date") { }
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = field("Item No.");
                        column(SupplierLeadTime; "BLACC Supplier Lead Time") { }
                        column(SailingLeadTime; "BLACC Sailing Lead Time") { }
                        column(InlandLeadTime; "BLACC Inland Lead Time") { }
                        column(CustomClearanceLeadtime; "BLACC Custom Clearance LT") { }
                    }
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
