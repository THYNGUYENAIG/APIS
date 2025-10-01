pageextension 51043 "ACC Sales Order Archive" extends "Sales Order Archive"
{
    layout
    {
        addafter(Status)
        {
            field("Sales Type"; Rec."Sales Type")
            {
                ApplicationArea = All;
            }
            field("Unset Packing"; Rec."Unset Packing")
            {
                ApplicationArea = All;
            }
        }
    }
}
