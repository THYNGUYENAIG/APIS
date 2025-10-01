page 51034 "ACC Sales Reason"
{
    ApplicationArea = All;
    Caption = 'AIG Sales Reason';
    PageType = List;
    SourceTable = "ACC Sales Reason";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Type"; Rec."Type")
                {
                }
            }
        }
    }
}
