pageextension 51040 "ACC Claim Insurance Entry" extends "BLACC Claim Insurance Entry"
{
    layout
    {
        addafter(Note)
        {
            field("Insurance Agent"; Rec."Insurance Agent")
            {
                ApplicationArea = All;
            }
        }
    }
}
