pageextension 51903 "ACC Certificate Decla. Ext" extends "BLACC Item Certificate"
{
    layout
    {
        addafter(Type)
        {
            field("Quality Group"; Rec."Quality Group")
            {
                ApplicationArea = ALL;
                Caption = 'Quality Group';
            }
            field("Vendor Code"; Rec."Vendor Code")
            {
                ApplicationArea = ALL;
                Caption = 'Vendor Code';
            }
            field("Vendor Name"; VendName)
            {
                ApplicationArea = ALL;
                Caption = 'Vendor Name';
            }
            field("Supplier Management Name"; SupplierManagementName)
            {
                ApplicationArea = ALL;
                Caption = 'Supplier Management Name';
            }
        }
        addafter("Document URL")
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
                    //if Rec."Document URL" <> '' then begin
                    //    PreviewPage.setURL(Rec."Document URL");
                    //    PreviewPage.Run();
                    //end;
                    Hyperlink(Rec."Document URL");
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
        Item: Record Item;
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
        if Rec."File Name" = '' then begin
            if UploadIntoStream(UploadMsg, '', '', FileName, FileInstr) then begin
                if SharepointConnector.Get('ITEMDOC') then begin
                    OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
                end;
                if not SharepointConnectorLine.Get('ITEMDOC', 1) then begin
                    exit;
                end;

                if Rec.Type = Enum::"BLACC Item Certificate Type"::"Quality Declaration" then begin
                    if Rec."Quality Group" = Enum::"ACC Quality Group"::None then begin
                        exit;
                    end;
                end;

                BCHelper.CreateSharePointFolder(SharepointConnectorLine, OauthenToken, '', Rec."Item No.");
                FileId := BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OauthenToken, Rec."Item No.", FileInstr, FileName, FileManagment.GetFileNameMimeType(FileName));
                if FileId <> '' then begin
                    Rec."Document URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/Items', Rec."Item No.", FileName);
                    Rec."File Name" := FileName;
                    Rec."File Extension" := FileManagment.GetExtension(FileName);
                    Rec."File No." := FileId;
                    Rec.Modify(true);

                    JsonObject.Add('ItemNo', Format(Rec."Item No."));
                    if Item.Get(Rec."Item No.") then
                        JsonObject.Add('ItemName', Format(Item.Description));
                    if Rec."Published Date" <> 0D then
                        JsonObject.Add('PublishDate', Format(Rec."Published Date"));
                    if Rec."Expiration Date" <> 0D then
                        JsonObject.Add('ExpirationDate', Format(Rec."Expiration Date"));
                    JsonObject.Add('_ExtendedDescription', Format(Rec.Description));
                    JsonObject.Add('CertificateType', Format(Rec.Type));
                    JsonText := Format(JsonObject);

                    BCHelper.UpdateMetadata(OauthenToken, JsonText, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);
                end;
            end;
        end else begin
            Message(StrSubstNo('File %1 exists.', Rec."File Name"));
        end;
    end;

    local procedure DownloadFile()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('ITEMDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('ITEMDOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODownloadFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.", Rec."File Name");
    end;

    trigger OnAfterGetRecord()
    var
        VendTable: Record Vendor;
        Salespurchase: Record "Salesperson/Purchaser";
    begin
        if VendTable.Get(Rec."Vendor Code") then begin
            VendName := VendTable.Name;
            if Salespurchase.Get(VendTable."BLACC Supplier Mgt. Code") then
                SupplierManagementName := Salespurchase.Name;
        end;
    end;

    var
        SupplierManagementName: Text;
        VendName: Text;
}
