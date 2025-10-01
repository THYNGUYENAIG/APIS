pageextension 52029 "ACC Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addbefore("Remit-to Code")
        {
            field("ACC Dimension Value ID"; Rec."ACC Dimension Value ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dimension Value ID field.', Comment = '%';
                Visible = false;
            }
            field("ACC Customer Name Dimension"; Rec."ACC Customer Name Dimension")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name Dimension field.', Comment = '%';
                Caption = 'Customer Name';
            }
        }
    }
}