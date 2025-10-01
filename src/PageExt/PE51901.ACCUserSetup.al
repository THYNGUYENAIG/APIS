pageextension 51901 "ACC User Setup" extends "User Setup"
{
    layout
    {
        addafter("BLTEC Allow Edit ImportEntry")
        {
            field("ACC Allow Inventory By Bin"; Rec."ACC Allow Inventory By Bin")
            {
                ApplicationArea = All;
            }
        }
    }
}
