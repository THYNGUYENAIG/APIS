pageextension 51044 "ACC Transport Information" extends "BLACC Transport Information"
{
    layout
    {
        addbefore("BLACC Item No.")
        {
            field("Storage Condition"; Rec."ACC Storage Condition")
            {
                ApplicationArea = All;
            }
        }
    }
}
