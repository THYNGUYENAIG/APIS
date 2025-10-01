page 51913 "ACC DMS Document Library"
{
    ApplicationArea = All;
    Caption = 'DMS Document Library';
    PageType = List;
    SourceTable = "ACC DMS Library";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = where("File No" = filter(<> ''), "Out Date" = filter(false), "Content Type" = filter(<> "ACC DOC Content Type"::"Business Review" & <> "ACC DOC Content Type"::"Distributor Agreement" & <> "ACC DOC Content Type"::"Suppier Presentation"));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Content Type"; Rec."Content Type") { }
                field("File Name"; Rec."File Name") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Vendor Group"; Rec."Vendor Group") { }
                field("Supplier Management Name"; Rec."Supplier Management Name") { }
                field("Item Code"; Rec."Item Code") { }
                field("Item Name"; Rec."Item Name") { }
                field("ECUS Name"; Rec."ECUS Name") { }
                field(Description; Rec.Description) { }
                field("Effective Date"; Rec."Effective Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("DMS ISO Type"; Rec."DMS ISO Type") { }
                field("DMS Report Type"; Rec."DMS Report Type") { }
                field("DMS Statement Type"; Rec."DMS Statement Type") { }
                field(Note; Rec.Note) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewInRepeater)
            {
                ApplicationArea = All;
                Caption = 'View';
                Image = View;
                Scope = Repeater;
                ToolTip = 'Download the file to your device. Depending on the file, you will need an app to view or edit the file.';

                trigger OnAction()
                begin
                    Hyperlink(Rec.URL);
                end;
            }
            action(DownloadInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                Scope = Repeater;
                ToolTip = 'Download the file to your device. Depending on the file, you will need an app to view or edit the file.';

                trigger OnAction()
                begin
                    DownloadFile();
                end;
            }
        }
    }

    local procedure DownloadFile()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('ITEMDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;

        if Rec."File No" <> '' then
            BCHelper.SPODownloadFile(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn90V6QIz1SSSL9gtBSX-P3u', Rec."File No", Rec."File Name");
    end;


}
