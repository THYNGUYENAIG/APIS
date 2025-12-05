pageextension 52035 "ACC Req. Worksheet Ext" extends "Req. Worksheet"
{
    layout
    {
        addlast(Control1)
        {
            field("ACC Chemical Categorization"; Rec."ACC Chemical Categorization")
            {
                ApplicationArea = Basic;
                ToolTip = 'Chemical categorization identifier used by ACC for classification.';
            }
            field("ACC Origin of Country Code"; Rec."ACC Origin of Country Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Country of origin (ISO code) for the item.';
            }
            field("ACC Origin of Country Name"; Rec."ACC Origin of Country Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Full country name representing the origin of the item.';
            }
        }
    }
}