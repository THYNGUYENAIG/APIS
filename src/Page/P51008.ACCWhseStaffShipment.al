page 51008 "ACC Whse. Staff Shipment"
{
    ApplicationArea = All;
    Caption = 'ACC Warehouse Staff - P51008';
    PageType = List;
    SourceTable = "ACC Whse. Staff Shipment";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code") { }
                field("Whse. Order Printer"; Rec."Whse. Order Printer") { }
                field("Whse. Order Printer Name"; Rec."Whse. Order Printer Name") { }
                field("Whse. Keeper"; Rec."Whse. Keeper") { }
                field("Whse. Keeper Name"; Rec."Whse. Keeper Name") { }
                field("PO Order Printer"; Rec."PO Order Printer") { }
                field("PO Order Printer Name"; Rec."PO Order Printer Name") { }
                field("PO Keeper"; Rec."PO Keeper") { }
                field("PO Keeper Name"; Rec."PO Keeper Name") { }
                field("Active Print "; Rec."Active Print ") { }
            }
        }
    }
}
