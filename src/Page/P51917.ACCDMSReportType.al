page 51917 "ACC DMS Report Type"
{
    ApplicationArea = All;
    Caption = 'APIS DMS Report Type';
    PageType = List;
    SourceTable = "ACC DMS Report Type";
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
