pageextension 51922 "ACC Manufacturing Setup" extends "Manufacturing Setup"
{
    layout
    {
        addafter("Planned Order Nos.")
        {
            field("Planned Adjust. Nos."; Rec."Planned Adjust. Nos.")
            {
                Caption = 'Planned Adjust. Nos.';
                ApplicationArea = All;
            }
        }
        addafter(Numbering)
        {
            group(SalesOrder)
            {
                Caption = 'Sales';
                field("Payment Method Code"; Rec."Payment Method Code") { ApplicationArea = All; }
                field("Posting Description"; Rec."Posting Description") { ApplicationArea = All; }
            }
        }
    }
}
