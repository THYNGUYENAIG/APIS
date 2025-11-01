page 51916 "ACC DMS ISO Type"
{
    ApplicationArea = All;
    Caption = 'APIS DMS ISO Type';
    PageType = List;
    SourceTable = "ACC DMS ISO Type";
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
