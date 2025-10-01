pageextension 51028 "ACC Salesperson/Purchaser Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("Phone No.")
        {
            field("SPO Email No."; Rec."SPO Email No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
