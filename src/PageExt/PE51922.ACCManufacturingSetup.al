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
    }
}
