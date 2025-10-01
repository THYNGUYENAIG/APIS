pageextension 51035 "ACC Posted Sales Cr.Memo Lines" extends "Posted Sales Credit Memo Lines"
{
    layout
    {
        addafter(Amount)
        {
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
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
            field("Return Reason Code"; Rec."Return Reason Code") { ApplicationArea = All; }
            field("Return Reason Name"; Rec."Return Reason Name") { ApplicationArea = All; }
            field("BLACC Remark"; Rec."BLACC Remark") { ApplicationArea = All; }
        }
    }
}
