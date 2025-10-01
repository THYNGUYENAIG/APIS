pageextension 52032 "ACC Get Receipt Lines Ext" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("ACC Purchase Name"; Rec."ACC Purchase Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ACC Purchase Name field.', Comment = '%';
            }
            field("ACC Ecus - Item Name"; Rec."ACC Ecus - Item Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ACC Ecus - Item Name field.', Comment = '%';
            }
        }
    }
}