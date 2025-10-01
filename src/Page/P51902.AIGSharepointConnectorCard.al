page 51902 "AIG Sharepoint Connector Card"
{
    ApplicationArea = All;
    Caption = 'AIG Sharepoint Connector Card';
    PageType = Card;
    SourceTable = "AIG Sharepoint Connector";
    //InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Application ID"; Rec."Application ID") { }
                field("Tenant ID"; Rec."Tenant ID") { }
                field("Client ID"; Rec."Client ID") { }
                field("Client Secret"; Rec."Client Secret") { }
                field(Scope; Rec.Scope) { }
                field("Access Token URL"; Rec."Access Token URL") { }
                field("Access Token URL 2"; Rec."Access Token URL 2") { }
                field("Copy Packing Slip"; Rec."Copy Packing Slip") { }
                field("Copy eInvoice"; Rec."Copy eInvoice") { }
            }
            part(SharepointConnectorLine; "AIG Sharepoint Connector Line")
            {
                SubPageLink = "Application ID" = field("Application ID");
                Caption = 'Line';
            }
        }
    }
}
