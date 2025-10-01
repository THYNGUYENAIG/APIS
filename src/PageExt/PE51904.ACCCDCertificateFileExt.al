pageextension 51904 "ACC CD Certificate File Ext" extends "BLACC CD Certificate Files"
{
    layout
    {
        addafter("BLACC Document URL")
        {
            field("File Name"; Rec."File Name")
            {
                ApplicationArea = ALL;
                Caption = 'File Name';
            }
            field("File Extension"; Rec."File Extension")
            {
                ApplicationArea = ALL;
                Caption = 'File Extension';
            }
            field("File Type"; Rec."File Type")
            {
                ApplicationArea = ALL;
                Caption = 'File Type';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(UploadFile)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Upload file';
                trigger OnAction()
                var
                begin
                    SelectFileDialog();
                end;
            }
            action(OpenInFileViewer)
            {
                ApplicationArea = All;
                Image = View;
                Caption = 'View';
                trigger OnAction()
                var
                //PreviewPage: Page "ACC Preview Files";
                begin
                    //if Rec."BLACC Document URL" <> '' then begin
                    //    PreviewPage.setURL(Rec."BLACC Document URL");
                    //    PreviewPage.Run();
                    //end;
                    Hyperlink(Rec."BLACC Document URL");
                end;
            }
            action(DownloadInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                trigger OnAction()
                var
                begin
                    DownloadFile();
                end;
            }
        }
    }

    local procedure SelectFileDialog()
    var
        CertificateCU: Codeunit "ACC CD Certificate File Event";
        CDCertificate: Record "BLACC CD Certificate";
        CDCertificateFile: Record "BLACC CD Certificate Files";
        CustomsDecla: Record "BLTEC Customs Declaration";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;

        FileManagment: Codeunit "File Management";
        BCHelper: Codeunit "BC Helper";

        FileInstr: InStream;
        FileName: Text[250];
        UploadMsg: Label 'Please choose the file...';
        Msg: Label 'Upload file name: %1 successful.';
        FileId: Text;
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if UploadIntoStream(UploadMsg, '', '', FileName, FileInstr) then begin
            if SharepointConnector.Get('CUSTOMSDOC') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SharepointConnectorLine.Get('CUSTOMSDOC', 1) then begin
                exit;
            end;
            BCHelper.CreateSharePointFolder(SharepointConnectorLine, OauthenToken, '', Rec."BLACC Customs Declaration No.");
            FileId := BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OauthenToken, Rec."BLACC Customs Declaration No.", FileInstr, FileName, FileManagment.GetFileNameMimeType(FileName));
            if FileId <> '' then begin
                Clear(CDCertificateFile);
                if CDCertificateFile.Get(Rec."BLACC Customs Declaration No.", Rec."BLACC Certificate Type", Rec."BLACC Line No.") then begin
                    CDCertificateFile."BLACC Document URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/CusCert', Rec."BLACC Customs Declaration No.", FileName);
                    CDCertificateFile."File Name" := FileName;
                    CDCertificateFile."File Extension" := FileManagment.GetExtension(FileName);
                    CDCertificateFile."File No." := FileId;
                    CertificateCU.Run(CDCertificateFile);
                    JsonObject.Add('DeclarationNo', Rec."BLACC Customs Declaration No.");
                    if CDCertificate.Get(Rec."BLACC Customs Declaration No.") then begin
                        JsonObject.Add('ItemList', CDCertificate."BLACC Item List");
                        JsonObject.Add('LotList', CDCertificate."BLACC Lot List");
                    end;
                    JsonObject.Add('CertificateNo', Rec."BLACC Certificate No.");
                    JsonObject.Add('_ExtendedDescription', Rec."BLACC Description");
                    if Rec."BLACC Valid From" <> 0D then
                        JsonObject.Add('ValidFrom', Format(Rec."BLACC Valid From"));
                    if Rec."BLACC Valid To" <> 0D then
                        JsonObject.Add('ValidTo', Format(Rec."BLACC Valid To"));
                    JsonObject.Add('CertificateType', Format(Rec."BLACC Certificate Type"));
                    JsonText := Format(JsonObject);
                    BCHelper.UpdateMetadata(OauthenToken, JsonText, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);
                end;
            end;
        end;
    end;

    local procedure DownloadFile()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('CUSTOMSDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('CUSTOMSDOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODownloadFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.", Rec."File Name");
    end;
}
