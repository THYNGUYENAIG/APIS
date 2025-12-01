page 51901 "AIG Sharepoint Connector Line"
{
    ApplicationArea = All;
    Caption = 'AIG Sharepoint Connector Line';
    PageType = ListPart;
    SourceTable = "AIG Sharepoint Connector Line";
    UsageCategory = Administration;
    AutoSplitKey = true;
    //DelayedInsert = false;
    //InsertAllowed = false;
    //LinksAllowed = false;
    //MultipleNewLines = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application ID"; Rec."Application ID") { }
                field("Line No."; Rec."Line No.") { }
                field("Sharepoint Type"; Rec."Sharepoint Type") { }
                field("Site ID"; Rec."Site ID") { }
                field("Drive ID"; Rec."Drive ID") { }
                field("Folder Path"; Rec."Folder Path") { }
                field("Site Url"; Rec."Site Url") { }
                field("Create Folder Url"; Rec."Create Folder Url") { }
                field("Create File URL"; Rec."Create File URL") { }
                field("Synchronize URL"; Rec."Synchronize URL") { }
            }
        }
    }
}
