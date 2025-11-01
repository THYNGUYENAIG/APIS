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
            action(SyncACC)
            {
                ApplicationArea = All;
                Image = OutlookSyncFields;
                Caption = 'Synchronize';

                trigger OnAction()
                var
                    ItemTable: Record Item;
                    OauthenToken: SecretText;
                begin
                    if GetToken(OauthenToken) then begin
                        ItemTable.Reset();
                        ItemTable.SetRange(Blocked, false);
                        ItemTable.SetFilter("Inventory Posting Group", 'A-01|B-01');
                        if ItemTable.FindSet() then
                            repeat
                                SetItemCertificate(ItemTable."No.", OauthenToken);
                            until ItemTable.Next() = 0;
                    end;
                end;
            }
            action(UploadFile)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Upload file';

                trigger OnAction()
                var
                begin
                    if not GetItemCertificate(Rec."Item No.") then
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
    local procedure GetToken(var OauthenToken: SecretText): Boolean
    var
        SharepointConnector: Record "AIG Sharepoint Connector";
        ItemCertificate: Record "BLACC Item Certificate";
    begin
        if SharepointConnector.Get('ACCAPIConnector') then begin
            OauthenToken := GetOAuthTokenSharepointOnline(SharepointConnector);
            if not OauthenToken.IsEmpty() then
                exit(true);
        end;
        exit(false);
    end;

    local procedure GetItemCertificate(ItemNo: Code[20]): Boolean
    var
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
        ItemCertificate: Record "BLACC Item Certificate";
    begin
        if SharepointConnector.Get('ACCAPIConnector') then begin
            OauthenToken := GetOAuthTokenSharepointOnline(SharepointConnector);
            if not OauthenToken.IsEmpty() then begin
                exit(SetItemCertificate(ItemNo, OauthenToken));
            end;
        end;
        exit(false);
    end;

    local procedure SetItemCertificate(ItemNo: Code[20]; OauthToken: SecretText): Boolean
    var
        SharepointLine: Record "AIG Sharepoint Connector Line";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        ResponseText: Text;
        URI: Text;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ArrayToken: JsonToken;
        TokenText: Text;
    begin
        if not SharepointLine.Get('ITEMDOC', 1) then begin
            exit;
        end;
        URI := StrSubstNo(SharepointLine."Synchronize URL", ItemNo);
        // Create and configure the HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(URI);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        //HttpClient.DefaultRequestHeaders().Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        // Send the request
        //if HttpClient.Get(URI, HttpResponseMessage) then begin
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Clear(JsonObject);
                if not JsonObject.ReadFrom(ResponseText) then
                    Error('Invalid JSON format');
                if JsonObject.Get('value', JsonToken) then begin
                    JsonArray := JsonToken.AsArray();
                    if JsonArray.Count >= 1 then begin
                        foreach ArrayToken in JsonArray do
                            ProcessItemCertificate(ArrayToken.AsObject());
                        exit(true);
                    end;
                    exit(false);
                end;
            end else begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('API returned error: Status %1, Response: %2',
                    HttpResponseMessage.HttpStatusCode, ResponseText);
                exit(false);
            end;
        end;
        // Return the full response for further processing
        exit(false);
    end;

    local procedure ProcessItemCertificate(JObject: JsonObject)
    var
        ItemCertifiCate: Record "BLACC Item Certificate";
        CertificateType: Enum "BLACC Item Certificate Type";
        QualityGroup: Enum "ACC Quality Group";

        ItemNo: Code[20];
        LineNo: Integer;
        FileNo: Text;
    begin

        // Extract all fields from the JSON object
        ItemNo := GetJsonValueAsCode(JObject, 'itemNo');
        LineNo := GetJsonValueAsInteger(JObject, 'lineNo');
        FileNo := GetJsonValueAsText(JObject, 'fileNo');
        if FileNo = '' then
            exit;
        if ItemCertifiCate.Get(ItemNo, LineNo) then begin
            Evaluate(ItemCertifiCate.Type, GetJsonValueAsText(JObject, 'type'));
            ItemCertifiCate."No." := GetJsonValueAsText(JObject, 'no');
            ItemCertifiCate."BLACC OutDate" := GetJsonValueAsBoolean(JObject, 'blaccOutDate');
            ItemCertifiCate.Description := GetJsonValueAsText(JObject, 'description');
            ItemCertifiCate."Document URL" := GetJsonValueAsText(JObject, 'documentURL');
            ItemCertifiCate."Expiration Date" := GetJsonValueAsDate(JObject, 'expirationDate');
            ItemCertifiCate."File Extension" := GetJsonValueAsText(JObject, 'fileExtension');
            ItemCertifiCate."File Name" := GetJsonValueAsText(JObject, 'fileName');
            ItemCertifiCate."File No." := FileNo;
            Evaluate(ItemCertifiCate."File Type", GetJsonValueAsText(JObject, 'fileType'));
            ItemCertifiCate."Published Date" := GetJsonValueAsDate(JObject, 'publishedDate');
            Evaluate(ItemCertifiCate."Quality Group", GetJsonValueAsCode(JObject, 'qualityGroup'));
            //ItemCertifiCate."Storage Condition" := GetJsonValueAsText(JObject, 'storageCondition');
            //ItemCertifiCate."Vendor Code" := GetJsonValueAsCode(JObject, 'vendorCode');
            ItemCertifiCate."Is Synchronize" := true;
            ItemCertifiCate.Modify();
        end else begin
            ItemCertifiCate.Init();
            ItemCertifiCate."Item No." := GetJsonValueAsCode(JObject, 'itemNo');
            ItemCertifiCate."Line No." := GetJsonValueAsInteger(JObject, 'lineNo');
            Evaluate(ItemCertifiCate.Type, GetJsonValueAsText(JObject, 'type'));
            ItemCertifiCate."No." := GetJsonValueAsText(JObject, 'no');
            ItemCertifiCate."BLACC OutDate" := GetJsonValueAsBoolean(JObject, 'blaccOutDate');
            ItemCertifiCate.Description := GetJsonValueAsText(JObject, 'description');
            ItemCertifiCate."Document URL" := GetJsonValueAsText(JObject, 'documentURL');
            ItemCertifiCate."Expiration Date" := GetJsonValueAsDate(JObject, 'expirationDate');
            ItemCertifiCate."File Extension" := GetJsonValueAsText(JObject, 'fileExtension');
            ItemCertifiCate."File Name" := GetJsonValueAsText(JObject, 'fileName');
            ItemCertifiCate."File No." := FileNo;
            Evaluate(ItemCertifiCate."File Type", GetJsonValueAsText(JObject, 'fileType'));
            ItemCertifiCate."Published Date" := GetJsonValueAsDate(JObject, 'publishedDate');
            Evaluate(ItemCertifiCate."Quality Group", GetJsonValueAsCode(JObject, 'qualityGroup'));
            ItemCertifiCate."Is Synchronize" := true;
            ItemCertifiCate.Insert();
        end;
    end;

    local procedure GetJsonValueAsText(JObject: JsonObject; KeyName: Text): Text
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsText());
        exit('');
    end;

    local procedure GetJsonValueAsCode(JObject: JsonObject; KeyName: Text): Code[20]
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsCode());
        exit('');
    end;

    local procedure GetJsonValueAsInteger(JObject: JsonObject; KeyName: Text): Integer
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsInteger());
        exit(0);
    end;

    local procedure GetJsonValueAsBoolean(JObject: JsonObject; KeyName: Text): Boolean
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsBoolean());
        exit(false);
    end;

    local procedure GetJsonValueAsDate(JObject: JsonObject; KeyName: Text): Date
    var
        JToken: JsonToken;
        DateText: Text;
        ResultDate: Date;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then begin
            DateText := JToken.AsValue().AsText();
            if Evaluate(ResultDate, DateText) then
                exit(ResultDate);
        end;
        exit(0D);
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Counld not find a token with key %1', TokenKey);
    end;

    local procedure GetJsonTextValue(JsonObj: JsonObject; PropertyName: Text; var Result: Text): Boolean
    var
        JsonToken: JsonToken;
    begin
        if JsonObj.Get(PropertyName, JsonToken) then begin
            Result := JsonToken.AsValue().AsText();
            exit(true);
        end;

        Result := '';
        exit(false);
    end;

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

    local procedure GetOAuthTokenSharepointOnline(SharepointConnector: Record "AIG Sharepoint Connector") AuthToken: SecretText
    var
        //SharepointConnector: Record "AIG Sharepoint Connector";
        ClientID: Text;
        ClientSecret: Text;
        TenantID: Text;
        AccessTokenURL: Text;
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        //if SharepointConnector.Get('INVSHIPPDF') then begin
        ClientID := SharepointConnector."Client ID";
        ClientSecret := SharepointConnector."Client Secret";
        TenantID := SharepointConnector."Tenant ID";
        AccessTokenURL := StrSubstNo(SharepointConnector."Access Token URL", SharepointConnector."Tenant ID"); // https://login.microsoftonline.com/%1/oauth2/v2.0/token
        Scopes.Add(SharepointConnector.Scope); // https://graph.microsoft.com/.default
        if not OAuth2.AcquireTokenWithClientCredentials(ClientID, ClientSecret, AccessTokenURL, '', Scopes, AuthToken) then
            Error('Failed to get access token from response\%1', GetLastErrorText());
        //end;
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
