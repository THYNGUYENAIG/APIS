page 51905 "ACC SP. Attachment Factbox"
{
    Caption = 'Sharepoint';
    PageType = ListPart;
    DeleteAllowed = true;
    DelayedInsert = true;
    InsertAllowed = false;
    SourceTable = "ACC Sharepoint Attachment";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Upload file';
                Image = Import;
                trigger OnAction()
                begin
                    SelectFileDialog();
                end;
            }
            action(OpenInFileViewer)
            {
                ApplicationArea = All;
                Caption = 'View';
                Image = View;
                Scope = Repeater;
                ToolTip = 'View the file. You will be able to download the file from the viewer control. Works only on limited number of file types.';

                trigger OnAction()
                begin
                    Hyperlink(Rec."Document URL");
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
    local procedure SelectFileDialog()
    var
        Vendor: Record Vendor;
        PurchOrder: Record "Purchase Header";
        Item: Record Item;
        Customer: Record Customer;
        SalesOrder: Record "Sales Header";
        PostedGenJour: Record "Posted Gen. Journal Line";

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
        PosSA: Integer;
        PosSQ: Integer;
        MimeType: Text;
    begin
        if UploadIntoStream(UploadMsg, '', '', FileName, FileInstr) then begin
            if SharepointConnector.Get('ATTACHDOC') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SharepointConnectorLine.Get('ATTACHDOC', 1) then begin
                exit;
            end;
            if Rec."No." <> '' then begin
                MimeType := FileManagment.GetFileNameMimeType(FileName);
                if MimeType = '' then begin
                    if FileName.EndsWith('.msg') then
                        MimeType := 'application/vnd.ms-outlook';
                end;
                FileId := BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OauthenToken, '', FileInstr, StrSubstNo('%1.%2', Format(TODAY, 0, '<Year><Month,2><Day,2>'), FileName), MimeType);
                if FileId <> '' then begin
                    Rec."Document URL" := StrSubstNo('%1/%2.%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/Attach', Format(TODAY, 0, '<Year><Month,2><Day,2>'), FileName);
                    Rec."Attached By" := UserSecurityId();
                    Rec."Attached Date" := Today;
                    Rec."File Name" := FileName;
                    Rec."File Extension" := FileManagment.GetExtension(FileName);
                    Rec."File No." := FileId;
                    Rec.Insert();

                    JsonObject.Add('ObjectNo', Rec."No.");
                    case Rec."Table ID" of
                        Database::Item:
                            begin
                                if Item.Get(Rec."No.") then begin
                                    JsonObject.Add('ObjectName', Item.Description);
                                    JsonObject.Add('ObjectType', 'Item');
                                end;
                            end;
                        Database::Customer:
                            begin
                                if Customer.Get(Rec."No.") then begin
                                    JsonObject.Add('ObjectName', Customer.Name);
                                    JsonObject.Add('ObjectType', 'Customer');
                                end;
                            end;
                        Database::"Sales Header":
                            begin
                                if SalesOrder.Get("Sales Document Type"::Order, Rec."No.") then begin
                                    JsonObject.Add('ObjectType', 'Sales Order');
                                    JsonObject.Add('ObjectName', SalesOrder."Sell-to Customer Name");
                                end;
                                if SalesOrder.Get("Sales Document Type"::"BLACC Agreement", Rec."No.") then begin
                                    JsonObject.Add('ObjectType', 'Sales Agreement');
                                    JsonObject.Add('ObjectName', SalesOrder."Sell-to Customer Name");
                                end;
                                if SalesOrder.Get("Sales Document Type"::Quote, Rec."No.") then begin
                                    JsonObject.Add('ObjectType', 'Sales Quote');
                                    JsonObject.Add('ObjectName', SalesOrder."Sell-to Customer Name");
                                end;
                            end;
                        Database::Vendor:
                            begin
                                if Vendor.Get(Rec."No.") then begin
                                    JsonObject.Add('ObjectName', Vendor.Name);
                                    JsonObject.Add('ObjectType', 'Vendor');
                                end;
                            end;
                        Database::"Purchase Header":
                            begin
                                if PurchOrder.Get("Purchase Document Type"::Order, Rec."No.") then begin
                                    JsonObject.Add('ObjectName', PurchOrder."Buy-from Vendor Name");
                                    JsonObject.Add('ObjectType', 'Purchase Order');
                                end;
                            end;
                        Database::"Posted Gen. Journal Line":
                            begin
                                PostedGenJour.Reset();
                                PostedGenJour.SetCurrentKey("Document No.", "Line No.");
                                PostedGenJour.SetRange("Document No.", Rec."No.");
                                if PostedGenJour.FindFirst() then begin
                                    JsonObject.Add('ObjectName', PostedGenJour.Description);
                                    JsonObject.Add('ObjectType', 'Gen. Journal Line');
                                end;
                            end;
                    end;

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
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('ATTACHDOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODownloadFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.", Rec."File Name");
    end;
}
