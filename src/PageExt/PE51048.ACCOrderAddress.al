pageextension 51048 "ACC Order Address" extends "Order Address"
{
    layout
    {
        addafter("Address 2")
        {
            field("ACC Vendor Address"; Rec."ACC Vendor Address")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies additional vendor address information.';
            }
        }
    }
}