page 51014 "ACC Quality Control Card"
{
    ApplicationArea = All;
    Caption = 'APIS Quality Control Card - P51014';
    PageType = Card;
    SourceTable = "ACC Quality Control Header";
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Truck Number"; Rec."Truck Number")
                {
                    Editable = false;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    Editable = false;
                }
                field("Delivery times"; Rec."Delivery Times")
                {
                    Editable = false;
                }
                field("Container No."; Rec."Container No.")
                {
                    Editable = false;
                }
                field("Seal No."; Rec."Seal No.") { }
                field(Dock; Rec.Dock) { }
                field(TGBD; Rec.TGBD) { }
                field(TGKT; Rec.TGKT) { }
                field(Floor; Rec.Floor) { }
                field(Wall; Rec.Wall) { }
                field(Ceiling; Rec.Ceiling) { }
                field("No Strange Smell"; Rec."No Strange Smell") { }
                field("No Insects"; Rec."No Insects") { }
                field("Vehicle Temperature"; Rec."Vehicle Temperature") { }
                field("Handle (If Any)"; Rec."Handle (If Any)") { }
                field("Type"; Rec."Type")
                {
                    Editable = false;
                }
            }
            part(QualityControlLine; "ACC Quality Control Line")
            {
                Caption = 'Line';
                SubPageLink = "Location Code" = field("Location Code"), "Truck Number" = field("Truck Number"), "Delivery Date" = field("Delivery Date"), "Delivery Times" = field("Delivery Times");
            }
            group(Details)
            {
                field("Line Handle (If Any)"; Rec."Line Handle (If Any)") { }
            }
        }
    }
}
