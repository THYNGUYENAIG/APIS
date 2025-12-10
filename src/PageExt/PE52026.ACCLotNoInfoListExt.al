pageextension 52026 "ACC Lot No Info List Ext" extends "Lot No. Information List"
{
    layout
    {
        addlast(Control1)
        {
            field("ACC Receipt Date"; Rec."ACC Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Date field.', Comment = '%';
            }
            field("ACC Receipt Location"; Rec."ACC Receipt Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Date field.', Comment = '%';
            }
            field("ACC Custom Declaration No"; Rec."ACC Custom Declaration No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Declaration No. field.', Comment = '%';
            }
            field("ACC PO No"; Rec."ACC PO No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Location field.', Comment = '%';
            }
        }
    }
}