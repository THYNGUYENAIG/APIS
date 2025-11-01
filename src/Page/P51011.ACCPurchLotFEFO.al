page 51011 "ACC Purch Lot FEFO"
{
    ApplicationArea = All;
    Caption = 'APIS Purch Lot FEFO - P51011';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Source No."; Rec."Source No.")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {

                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
            }
        }
    }
}
