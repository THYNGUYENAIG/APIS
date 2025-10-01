pageextension 51036 "ACC Posted Purch. Inv. Lines" extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter(Amount)
        {
            field("ACC Cost Amount Posted"; Rec."ACC Cost Amount Posted")
            {
                ApplicationArea = All;
                Caption = 'Cost Amt.';
            }
            field("ACC Cost Amount Adjustment"; Rec."ACC Cost Amount Adjustment")
            {
                ApplicationArea = All;
                Caption = 'Cost Amt. Adjust.';
            }
        }
    }
}
