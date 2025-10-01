page 51035 "ACC Sales Worktime"
{
    ApplicationArea = All;
    Caption = 'ACC Sales Worktime';
    PageType = List;
    SourceTable = "ACC Sales Worktime";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Site No."; Rec."Site No.")
                {
                }
                field("Time"; Rec."Time")
                {
                }
                field("Type"; Rec."Type")
                {
                }
            }
        }
    }
}
