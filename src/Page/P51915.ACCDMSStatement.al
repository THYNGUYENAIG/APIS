page 51915 "ACC DMS Statement"
{
    ApplicationArea = All;
    Caption = 'APIS DMS Statement';
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
