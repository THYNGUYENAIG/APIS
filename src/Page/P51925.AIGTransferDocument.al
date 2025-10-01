page 51925 "AIG Transfer Document"
{
    ApplicationArea = All;
    Caption = 'AIG Transfer Document';
    PageType = List;
    SourceTable = "AIG Transfer Document";
    UsageCategory = ReportsAndAnalysis;
    //InsertAllowed = false;
    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type") { }
                field("Transfer Shipment No."; Rec."Transfer Shipment No.") { }
                field("Transfer Order No."; Rec."Transfer Order No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("From Location Code"; Rec."From Location Code") { }
                field("To Location Code"; Rec."To Location Code") { }
                field("eInvoice No."; Rec."eInvoice No.") { }
                field("File Name"; Rec."File Name") { }
                field("Doc URL"; Rec."Doc URL") { }
                field("SPO No."; Rec."SPO No.") { }
                field("File No."; Rec."File No.") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            /*
            action(SyncFile)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Synchronize';

                trigger OnAction()
                var
                begin

                end;
            }
            */
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
                begin
                    Hyperlink(Rec."Doc URL");
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
    local procedure SynchronizeFile()
    var
    begin

    end;

    local procedure GetVoucherPaper(TemplateHeader: Record "BLTI Template Header"; eInvoiceToken: SecretText; FileNewPath: Text; FileName: Text; Converter: Text; TransactionIDs: List of [Text]; OauthToken: SecretText): Boolean
    var
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;

        ResponseText: Text;
        JsonResponse: JsonObject;
        InnerJsonResponse: JsonObject;
        JsonToken: JsonToken;
        DataToken: JsonToken;
        ItemToken: JsonToken;

        RequestBody: Text;
        JsonBody: JsonObject;
        TransactionIDArray: JsonArray;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        FileContent: InStream;
        OutStream: OutStream;
        Base64Data: Text;
        DataArray: JsonArray;

        i: Integer;
    begin
        if not SharepointConnectorLine.Get('INVSHIPPDF', 1) then begin
            exit;
        end;
        // Create JSON array for TransactionIDList
        for i := 1 to TransactionIDs.Count() do
            TransactionIDArray.Add(TransactionIDs.Get(i));

        // Create JSON request body
        JsonBody.Add('Converter', Converter);
        JsonBody.Add('ConvertDate', Format(Today, 0, '<Year4>/<Month,2>/<Day,2>'));
        JsonBody.Add('TransactionIDList', TransactionIDArray);
        JsonBody.WriteTo(RequestBody);

        // Set up the request content
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        // Create and configure the HTTP request
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri('https://api.meinvoice.vn/api/v3/code/itg/invoicepublished/voucher-paper');
        //HttpRequestMessage.SetRequestUri(TemplateHeader."MISA-UrlExchange");
        HttpRequestMessage.Content(HttpContent);

        // Add authorization header with token
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', eInvoiceToken));
        HttpHeaders.Add('CompanyTaxCode', TemplateHeader."Seller Tax No.");

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to MISA API');

        // Check if the request was successful
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error('MISA API returned error: Status %1, Response: %2',
                HttpResponseMessage.HttpStatusCode, ResponseText);
        end;

        // Get the response content
        HttpResponseMessage.Content.ReadAs(ResponseText);

        // Process the JSON response
        if not JsonResponse.ReadFrom(ResponseText) then
            Error('Invalid JSON response from MISA API');

        // Check for Success field in the response
        if JsonResponse.Get('Success', JsonToken) then begin
            if not JsonToken.AsValue().AsBoolean() then begin
                if JsonResponse.Get('ErrorCode', JsonToken) and (not JsonToken.AsValue().IsNull) then
                    Error('MISA API error: %1 - %2',
                        GetJsonValueAsText(JsonResponse, 'ErrorCode'),
                        GetJsonValueAsText(JsonResponse, 'DescriptionErrorCode'));

                Error('MISA API returned unsuccessful response');
            end;
        end;
        if JsonResponse.Get('Data', DataToken) then begin
            if not DataToken.AsValue().IsNull then begin
                // For this specific API, the token is likely in the Data field
                // Adjust according to the actual response structure
                DataArray.ReadFrom(DataToken.AsValue().AsText());
                for i := 0 to DataArray.Count - 1 do begin
                    DataArray.Get(i, ItemToken);
                    InnerJsonResponse := ItemToken.AsObject();
                    if GetJsonTextValue(InnerJsonResponse, 'Data', Base64Data) then begin
                        Clear(TempBlob);
                        // Generate PDF for this transaction
                        TempBlob.CreateOutStream(OutStream);
                        // Decode the Base64 string to binary
                        Base64Convert.FromBase64(Base64Data, OutStream);
                        // Create an InStream to read the binary data
                        TempBlob.CreateInStream(FileContent);
                        //UploadFilesToSharePoint(SharepointConnectorLine, OauthToken, FileNewPath, FileContent, FileName, 'application/pdf');
                        //FileMgt.save(TempBlob, 'HDDT.pdf', true);
                        exit(true);
                    end;
                end;
            end;
        end;
        // Return the full response for further processing
        exit(false);
    end;

    local procedure GetJsonValueAsText(JsonObj: JsonObject; PropertyName: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObj.Get(PropertyName, JsonToken) then begin
            if not JsonToken.AsValue().IsNull then
                exit(JsonToken.AsValue().AsText());
        end;
        exit('');
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
        SPOID: Integer;
    begin

        if Rec."File Name" = '' then begin
            if UploadIntoStream(UploadMsg, '', '', FileName, FileInstr) then begin
                if SharepointConnector.Get('TODOC') then begin
                    OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
                end;
                if not SharepointConnectorLine.Get('TODOC', 1) then begin
                    exit;
                end;

                BCHelper.CreateSharePointFolder(SharepointConnectorLine, OauthenToken, '', Rec."Transfer Order No.");
                FileId := BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OauthenToken, Rec."Transfer Order No.", FileInstr, FileName, FileManagment.GetFileNameMimeType(FileName));
                if FileId <> '' then begin
                    SPOID := GetSPOMetaID(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);
                    Rec."Doc URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/TODoc', Rec."Transfer Order No.", FileName);
                    Rec."File Name" := FileName;
                    Rec."File No." := FileId;
                    Rec.Modify(true);
                    if Rec."SPO No." <> SPOID then
                        Rec.Rename(SPOID);
                    //JsonText := Format(JsonObject);

                    //BCHelper.UpdateMetadata(OauthenToken, JsonText, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);
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
        if SharepointConnector.Get('TODOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('TODOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODownloadFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.", Rec."File Name");
    end;

    local procedure GetSPOMetaID(OauthToken: SecretText; SiteId: Text; DriveId: Text; FileNo: Text): Integer
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        JsonItemResponse: JsonObject;
        JsonItemToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;
    begin
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3?expand=listItem', SiteId, DriveId, FileNo);
        // Initialize the HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        //RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;
        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging            
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                if JsonResponse.Get('listItem', JsonToken) then begin
                    JsonItemResponse := JsonToken.AsObject();
                    if JsonItemResponse.Get('id', JsonItemToken) then begin
                        if not JsonItemToken.AsValue().IsNull then begin
                            exit(JsonItemToken.AsValue().AsInteger());
                        end;
                    end;
                end;
            end else begin
                exit(0);
            end;
        end else
            exit(0);
        exit(0);
    end;
}
