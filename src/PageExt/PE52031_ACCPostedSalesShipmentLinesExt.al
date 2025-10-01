pageextension 52031 "ACC Sales Shipment. Lines Ext" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("ACC Salesperson Code"; Rec."ACC Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ACC Salesperson Code field.', Comment = '%';
            }
        }
    }
}