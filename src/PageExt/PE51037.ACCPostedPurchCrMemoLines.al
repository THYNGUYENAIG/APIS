pageextension 51037 "ACC Posted Purch. CrMemo Lines" extends "Posted Purchase Cr. Memo Lines"
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
