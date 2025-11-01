page 51911 "ACC Contract Document"
{
    ApplicationArea = All;
    Caption = 'APIS Contract Document';
    PageType = List;
    SourceTable = "ACC Contract Document";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Doc No."; Rec."Doc No.")
                {
                }
                field("Doc Name"; Rec."Doc Name")
                {
                }
                field("Doc Address"; Rec."Doc Address")
                {
                }
            }
        }
    }
}
