pageextension 51041 "ACC Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("ACC Packing Size"; Rec."ACC Packing Size")
            {
                ApplicationArea = All;
            }
        }
    }
}
