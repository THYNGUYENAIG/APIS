tableextension 51904 "ACC Import Entry" extends "BLTEC Import Entry"
{
    fields
    {
        field(50001; "ACC Insured Date"; Date)
        {
            Caption = 'Insured Date';
            DataClassification = ToBeClassified;
        }
        field(50002; "ACC Send Docs To Ins. Date"; Date)
        {
            Caption = 'Send Docs To Insurance Company Date';
            DataClassification = ToBeClassified;
        }
    }
}
