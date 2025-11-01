page 51904 "ACC Certificate Declaration"
{
    ApplicationArea = All;
    Caption = 'APIS Certificate Declaration';
    PageType = List;
    SourceTable = "ACC Certificate Declaration";
    UsageCategory = Tasks;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Certificate Type"; Rec."Certificate Type")
                {
                }
                field("Certificate No."; Rec."Certificate No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Release Date"; Rec."Release Date")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field("File Name"; Rec."File Name")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UploadFile)
            {
                Caption = 'Upload file';
                trigger OnAction()
                var
                begin
                    SelectFileDialog();
                end;
            }
            action(BrowserFile)
            {
                Caption = 'Browser file';
                trigger OnAction()
                var
                begin

                end;
            }
            action(DeleteFile)
            {
                Caption = 'Delete file';
                trigger OnAction()
                var
                begin

                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine();
    end;

    trigger OnModifyRecord(): Boolean
    var
        Item: Record Item;
    begin
        if Rec."Item Name" = '' then begin
            if Item.Get(Rec."Item No.") then
                Rec."Item Name" := Item.Description;
        end;
    end;

    local procedure SelectFileDialog()
    var
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
            if SharepointConnector.Get('ITEMDOC') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SharepointConnectorLine.Get('ITEMDOC', 1) then begin
                exit;
            end;
            BCHelper.CreateSharePointFolder(SharepointConnectorLine, OauthenToken, '', Rec."Item No.");
            FileId := BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OauthenToken, Rec."Item No.", FileInstr, StrSubstNo('%1.%2', Format(TODAY, 0, '<Year4><Month,2><Day,2>'), FileName), FileManagment.GetFileNameMimeType(FileName));
            if FileId <> '' then begin

                JsonObject.Add('ObjectNumber', Format(Rec."Item No."));
                JsonObject.Add('ObjectName', Format(Rec."Item Name"));
                JsonObject.Add('ReleaseDate', Format(Rec."Release Date"));
                JsonObject.Add('ExpirationDate', Format(Rec."Expiration Date"));
                JsonObject.Add('CertificateType', Format(Rec."Certificate Type"));
                JsonText := Format(JsonObject);

                BCHelper.UpdateMetadata(OauthenToken, JsonText, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);

                Rec."File Name" := StrSubstNo('%1.%2', Format(TODAY, 0, '<Year4><Month,2><Day,2>'), FileName);
                Rec."File Name Orig." := FileName;
                Rec."File No." := FileId;
                Rec.Modify();
                //Message(Msg, FileName);
            end;
        end;
    end;

}
