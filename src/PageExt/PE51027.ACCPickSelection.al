pageextension 51027 "ACC Pick Selection" extends "Pick Selection"
{
    layout
    {
        addafter("Location Code")
        {
            field("Delivery Date"; Rec."Delivery Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
