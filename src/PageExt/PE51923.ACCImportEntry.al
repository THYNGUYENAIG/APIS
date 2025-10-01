pageextension 51923 "ACC Import Entry" extends "BLTEC Import Entry Mgt."
{
    layout
    {
        addafter("Insurance No.")
        {
            field("Insured Date"; Rec."ACC Insured Date")
            {
                ApplicationArea = All;
            }
            field("Send Docs To Ins. Company Date"; Rec."ACC Send Docs To Ins. Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
