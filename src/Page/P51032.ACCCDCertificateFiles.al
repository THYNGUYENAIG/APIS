page 51032 "ACC CD Certificate Files"
{
    ApplicationArea = All;
    Caption = 'APIS CD Certificate Files - P51032';
    PageType = List;
    SourceTable = "BLACC CD Certificate Files";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("BLACC Customs Declaration No."; Rec."BLACC Customs Declaration No.") { }
                field("BLACC Certificate Type"; Rec."BLACC Certificate Type") { }
                field("BLACC Certificate No."; Rec."BLACC Certificate No.") { }
                field("BLACC Valid From"; Rec."BLACC Valid From") { }
                field(ItemList; ItemList) { Caption = 'Item List'; }
                field(LotNList; LotNList) { Caption = 'Lot List'; }
                field("BLACC Document URL"; Rec."BLACC Document URL") { }
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
                    Hyperlink(Rec."BLACC Document URL");
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

        if Rec."File No." <> '' then
            BCHelper.SPODownloadFile(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn90V6QIz1SSSL9gtBSX-P3u', Rec."File No.", Rec."File Name");
    end;

    trigger OnAfterGetRecord()
    var
        CDCertificate: Record "BLACC CD Certificate";
    begin
        CDCertificate.Reset();
        CDCertificate.SetRange("BLACC Customs Declaration No.", Rec."BLACC Customs Declaration No.");
        if CDCertificate.FindFirst() then begin
            ItemList := CDCertificate."BLACC Item List";
            LotNList := CDCertificate."BLACC Lot List";
        end;
    end;

    var
        ItemList: Text;
        LotNList: Text;
}
