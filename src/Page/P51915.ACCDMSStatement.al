page 51915 "ACC DMS Statement"
{
    ApplicationArea = All;
    Caption = 'ACC DMS Statement';
    PageType = List;
    SourceTable = "ACC DMS Statement";
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
            }
        }
    }
}
