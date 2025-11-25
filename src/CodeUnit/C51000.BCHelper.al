codeunit 51000 "BC Helper"
{
    procedure AmountInWordsInUSFormat(Amount: Decimal; CurrencyCode: Code[10]) AmountInWords: Text[300]
    var
        ReportCheck: Report Check;
        NoText: array[2] of Text[80];
    begin
        ReportCheck.InitTextVariable();
        ReportCheck.FormatNoText(NoText, Amount, CurrencyCode);
        AmountInWords := NoText[1];
    end;

    procedure WarehouseTransportControl()
    var
        ItemTable: Record Item;
        QualityHeader: Record "ACC Quality Control Header";
        QualityLine: Record "ACC Quality Control Line";
        WhseTransport: Query "ACC Warehouse Transport";
        WhseTransportLine: Query "ACC Warehouse Transport Line";
        TruckNumber: Text;
        NoOfDeliver: Integer;
        TruckORCont: Boolean;
        LineNo: Integer;
        FromDate: Date;
        ToDate: Date;
        HasLine: Boolean;
    begin
        FromDate := CalcDate('-7D', TODAY);
        ToDate := CalcDate('+3D', TODAY);
        WhseTransport.SetRange(PostingDate, FromDate, ToDate);
        WhseTransport.SetFilter(LocationCode, '<>%1', '');
        if WhseTransport.Open() then begin
            while WhseTransport.Read() do begin
                if WhseTransport.TruckNumber <> '' then begin
                    TruckNumber := WhseTransport.TruckNumber;
                    TruckORCont := true;
                end else begin
                    TruckNumber := WhseTransport.ContainerNo;
                    TruckORCont := false;
                end;
                if TruckNumber <> '' then begin
                    if WhseTransport.BLACCNoofTrips = 0 then begin
                        NoOfDeliver := 1;
                    end else begin
                        NoOfDeliver := WhseTransport.BLACCNoofTrips;
                    end;
                    if not QualityHeader.Get(WhseTransport.LocationCode, TruckNumber, WhseTransport.PostingDate, NoOfDeliver) then begin
                        QualityHeader.Init();
                        QualityHeader."Location Code" := WhseTransport.LocationCode;
                        QualityHeader."Truck Number" := TruckNumber;
                        QualityHeader."Delivery Date" := WhseTransport.PostingDate;
                        QualityHeader."Delivery Times" := NoOfDeliver;
                        QualityHeader."Container No." := WhseTransport.ContainerNo;
                        QualityHeader."Seal No." := WhseTransport.SealNo;
                        QualityHeader.Floor := true;
                        QualityHeader.Wall := true;
                        QualityHeader.Ceiling := true;
                        QualityHeader."No Strange Smell" := true;
                        QualityHeader."No Insects" := true;
                        QualityHeader."Vehicle Temperature" := true;
                        if WhseTransport.Type = "BLACC TransportType"::Receiving then begin
                            QualityHeader.Type := "ACC Classification Type"::Input;
                        end else
                            QualityHeader.Type := "ACC Classification Type"::Output;
                        if QualityHeader.Insert() then begin
                            LineNo := 0;
                            HasLine := true;
                            if TruckORCont = true then begin
                                WhseTransportLine.SetRange(TruckNumber, TruckNumber);
                            end else begin
                                WhseTransportLine.SetRange(ContainerNo, TruckNumber);
                            end;
                            WhseTransportLine.SetRange(PostingDate, WhseTransport.PostingDate);
                            WhseTransportLine.SetRange(NoofTrips, WhseTransport.BLACCNoofTrips);
                            WhseTransportLine.SetRange(LocationCode, WhseTransport.LocationCode);
                            WhseTransportLine.SetRange(Type, WhseTransport.Type);
                            if WhseTransportLine.Open() then begin
                                while WhseTransportLine.Read() do begin
                                    LineNo := LineNo + 1;
                                    HasLine := false;
                                    QualityLine.Init();
                                    QualityLine."Location Code" := WhseTransportLine.LocationCode;
                                    QualityLine."Source Document No." := WhseTransportLine.DocumentNo;
                                    QualityLine."Source Document Line No." := WhseTransportLine.DocumentLineNo;
                                    QualityLine."Source Line No." := 0;
                                    QualityLine."Document No." := WhseTransportLine.PurchNo;
                                    QualityLine."Truck Number" := TruckNumber;
                                    QualityLine."Delivery Date" := WhseTransportLine.PostingDate;
                                    QualityLine."Delivery Times" := NoOfDeliver;
                                    QualityLine."Item No." := WhseTransportLine.ItemNo;
                                    QualityLine."Item Name" := WhseTransportLine.Description;
                                    QualityLine."Lot No." := WhseTransportLine.LotNo;
                                    QualityLine."Line No." := LineNo;
                                    QualityLine.Quantity := WhseTransportLine.LotQuantity;
                                    QualityLine."Packaging Label" := true;
                                    QualityLine."Packaging State" := true;
                                    QualityLine."No Strange Smell" := true;
                                    QualityLine."No Insects" := true;
                                    if ItemTable.Get(WhseTransportLine.ItemNo) then begin
                                        QualityLine."Packing No." := ItemTable."BLACC Packing Group";
                                    end;
                                    QualityLine.Type := QualityHeader.Type;
                                    QualityLine.Insert();
                                end;
                                WhseTransportLine.Close();
                            end;
                        end;
                        QualityHeader."Has Line" := HasLine;
                        QualityHeader.Modify(true);
                    end;
                end;
            end;
            WhseTransport.Close();
        end;
    end;

    procedure WarehouseTransportLineControl()
    var
        ItemTable: Record Item;
        QualityHeader: Record "ACC Quality Control Header";
        QualityLine: Record "ACC Quality Control Line";
        WhseTransportLine: Query "ACC Warehouse Transport Line";
        LineNo: Integer;
        FromDate: Date;
        ToDate: Date;
        HasLine: Boolean;
    begin
        QualityHeader.SetRange("Has Line", true);
        if QualityHeader.FindSet() then begin
            repeat
                HasLine := true;
                if QualityHeader."Container No." = '' then begin
                    WhseTransportLine.SetRange(TruckNumber, QualityHeader."Truck Number");
                end else begin
                    WhseTransportLine.SetRange(ContainerNo, QualityHeader."Container No.");
                end;
                WhseTransportLine.SetRange(PostingDate, QualityHeader."Delivery Date");
                WhseTransportLine.SetRange(NoofTrips, QualityHeader."Delivery Times");
                WhseTransportLine.SetRange(LocationCode, QualityHeader."Location Code");
                if QualityHeader.Type = "ACC Classification Type"::Input then begin
                    WhseTransportLine.SetRange(Type, "BLACC TransportType"::Receiving);
                end else
                    WhseTransportLine.SetRange(Type, "BLACC TransportType"::Shipment);
                if WhseTransportLine.Open() then begin
                    while WhseTransportLine.Read() do begin
                        LineNo := LineNo + 1;
                        HasLine := false;
                        QualityLine.Init();
                        QualityLine."Location Code" := QualityHeader."Location Code";
                        QualityLine."Source Document No." := WhseTransportLine.DocumentNo;
                        QualityLine."Source Document Line No." := WhseTransportLine.DocumentLineNo;
                        QualityLine."Source Line No." := 0;
                        QualityLine."Document No." := WhseTransportLine.PurchNo;
                        QualityLine."Truck Number" := QualityHeader."Truck Number";
                        QualityLine."Delivery Date" := QualityHeader."Delivery Date";
                        QualityLine."Delivery Times" := QualityHeader."Delivery Times";
                        QualityLine."Item No." := WhseTransportLine.ItemNo;
                        QualityLine."Item Name" := WhseTransportLine.Description;
                        QualityLine."Lot No." := WhseTransportLine.LotNo;
                        QualityLine."Line No." := LineNo;
                        QualityLine.Quantity := WhseTransportLine.LotQuantity;
                        QualityLine."Packaging Label" := true;
                        QualityLine."Packaging State" := true;
                        QualityLine."No Strange Smell" := true;
                        QualityLine."No Insects" := true;
                        if ItemTable.Get(WhseTransportLine.ItemNo) then begin
                            QualityLine."Packing No." := ItemTable."BLACC Packing Group";
                        end;
                        QualityLine.Type := QualityHeader.Type;
                        QualityLine.Insert();
                    end;
                    WhseTransportLine.Close();
                end;
                QualityHeader."Has Line" := HasLine;
                QualityHeader.Modify(true);
            until QualityHeader.Next() = 0;
        end;
    end;

    procedure GetOAuthTokenSharepointOnline(SharepointConnector: Record "AIG Sharepoint Connector") AuthToken: SecretText
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

    procedure UploadFilesToSharePoint(SharepointConnectorLine: Record "AIG Sharepoint Connector Line"; OauthToken: SecretText; FileNewPath: Text; FileContent: InStream; FileName: Text; MimeType: Text): Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;
        FileId: Text;
    begin
        if FileNewPath <> '' then begin
            SharePointFileUrl := StrSubstNo(SharepointConnectorLine."Create File URL", SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", SharepointConnectorLine."Folder Path" + '/' + FileNewPath, FileName);
        end else begin
            SharePointFileUrl := StrSubstNo(SharepointConnectorLine."Create File URL", SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", SharepointConnectorLine."Folder Path", FileName);
        end;
        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'PUT';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', MimeType);
        HttpRequestMessage.Content.WriteFrom(FileContent);

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                if JsonResponse.Get('id', JsonToken) then begin
                    if not JsonToken.AsValue().IsNull then begin
                        exit(JsonToken.AsValue().AsText());
                    end;
                end;
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to upload files to SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
        exit('');
    end;

    procedure UpdateMetadata(OauthToken: SecretText; JsonText: Text; SiteId: Text; DriveId: Text; FileId: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;

        Headers: HttpHeaders;
    //AccessToken: Text;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3/listItem/fields', SiteId, DriveId, FileId);
        // Prepare HTTP request
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(RequestContentHeaders);
        RequestContentHeaders.Clear();
        RequestContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Graph API');
    end;

    procedure SPODownloadFile(OauthToken: SecretText; SiteId: Text; DriveId: Text; FileId: Text; Filename: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;
        Headers: HttpHeaders;
        FileContent: InStream;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3/content', SiteId, DriveId, FileId);

        // Prepare HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode then begin
                HttpResponseMessage.Content.ReadAs(FileContent);

                DownloadFromStream(FileContent, 'Download', '', '', Filename);
            end;
        end;
    end;

    procedure SPODeleteFile(OauthToken: SecretText; SiteId: Text; DriveId: Text; FileId: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;

        Headers: HttpHeaders;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3', SiteId, DriveId, FileId);

        // Prepare HTTP request
        HttpRequestMessage.Method := 'DELETE';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Graph API');
    end;

    procedure CreateSharePointFolder(SharepointConnectorLine: Record "AIG Sharepoint Connector Line"; OauthToken: SecretText; ParentFolder: Text; NewFolderName: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        ResponseText: Text;
        RequestUrl: Text;
        JsonObject: JsonObject;
        FolderObject: JsonObject;
        JsonText: Text;
    begin
        if SharepointConnectorLine."Folder Path" = '' then begin
            RequestUrl := StrSubstNo(SharepointConnectorLine."Site Url", SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID");
        end else begin
            if ParentFolder = '' then begin
                RequestUrl := StrSubstNo(SharepointConnectorLine."Create Folder Url", SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", SharepointConnectorLine."Folder Path");
            end else begin
                RequestUrl := StrSubstNo(SharepointConnectorLine."Create Folder Url", SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", SharepointConnectorLine."Folder Path" + '/' + ParentFolder);
            end;
        end;
        // Create JSON for the folder creation request
        JsonObject.Add('name', NewFolderName);
        JsonObject.Add('folder', FolderObject);  // Add empty folder object
        JsonObject.Add('@microsoft.graph.conflictBehavior', 'replace');  // Auto-rename if folder exists

        // Prepare HTTP request
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(RequestUrl);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content
        JsonText := Format(JsonObject);
        RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(RequestContentHeaders);
        RequestContentHeaders.Clear();
        RequestContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Graph API');

        // Process the response
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error('Failed to create SharePoint folder. Status code: %1, Response: %2',
                 HttpResponseMessage.HttpStatusCode, ResponseText);
        end;

        exit(true);
    end;

    procedure GetOAuthTokeneInvoice(TemplateHeader: Record "BLTI Template Header") AuthToken: SecretText
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        ResponseText: Text;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;

        RequestBody: Text;
        JsonBody: JsonObject;
    begin
        // Create JSON request body        
        JsonBody.Add('appid', TemplateHeader."Integration ID");
        JsonBody.Add('taxcode', TemplateHeader."Seller Tax No.");
        JsonBody.Add('username', TemplateHeader."Integration UserName");
        JsonBody.Add('password', TemplateHeader."Integration PassWord");
        JsonBody.WriteTo(RequestBody);

        // Set up the request content
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        // Create and configure the HTTP request
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(TemplateHeader."MISA-UrlToken");
        HttpRequestMessage.Content(HttpContent);

        // Add any additional headers if needed
        HttpRequestMessage.GetHeaders(HttpHeaders);

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to MISA Token');

        // Check if the request was successful
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error('MISA Token returned error: Status %1, Response: %2',
                HttpResponseMessage.HttpStatusCode, ResponseText);
        end;

        // Get the response content
        HttpResponseMessage.Content.ReadAs(ResponseText);

        // Process the JSON response
        if not JsonResponse.ReadFrom(ResponseText) then
            Error('Invalid JSON response from MISA Token');

        // Check for Success field in the response
        if JsonResponse.Get('success', JsonToken) then begin
            if not JsonToken.AsValue().AsBoolean() then begin
                if JsonResponse.Get('ErrorCode', JsonToken) and (not JsonToken.AsValue().IsNull) then
                    Error('MISA Token error: %1 - %2',
                        GetJsonValueAsText(JsonResponse, 'ErrorCode'),
                        GetJsonValueAsText(JsonResponse, 'DescriptionErrorCode'));

                Error('MISA Token returned unsuccessful response');
            end;
        end;

        // Extract token from the Data field
        if JsonResponse.Get('data', JsonToken) then begin
            if not JsonToken.AsValue().IsNull then begin
                // For this specific API, the token is likely in the Data field
                // Adjust according to the actual response structure
                exit(JsonToken.AsValue().AsText());
            end;
        end;

        Error('Auth token not found in the response');
    end;

    procedure GetVoucherPaper(TemplateHeader: Record "BLTI Template Header"; eInvoiceToken: SecretText; FileNewPath: Text; FileName: Text; Converter: Text; TransactionIDs: List of [Text]; OauthToken: SecretText): Boolean
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
                        UploadFilesToSharePoint(SharepointConnectorLine, OauthToken, FileNewPath, FileContent, FileName, 'application/pdf');
                        //FileMgt.save(TempBlob, 'HDDT.pdf', true);
                        exit(true);
                    end;
                end;
            end;
        end;
        // Return the full response for further processing
        exit(false);
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

    procedure DownloadFromSharePoint(OauthToken: SecretText; SiteId: Text; DriverId: Text; RootURL: Text; FileName: Text; var FileContent: InStream)
    var

        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;
        Headers: HttpHeaders;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/root:/%3:/content', SiteId, DriverId, RootURL);
        // Prepare HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode then begin
                HttpResponseMessage.Content.ReadAs(FileContent);
            end;
        end;
    end;

    local procedure GetCellValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Text): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            Value := TempExcelBuffer."Cell Value as Text";
            exit(Value <> '');
        end;
        exit(false);
    end;

    procedure UpdateDMSList(OauthToken: SecretText; SiteId: Text; ListId: Text; JsonText: Text; ItemId: Integer): Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;

    begin
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/lists/%2/items/%3/fields', SiteId, ListId, ItemId);
        // Initialize the HTTP request
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        RequestContent.WriteFrom(JsonText);
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
                if JsonResponse.Get('id', JsonToken) then begin
                    if not JsonToken.AsValue().IsNull then begin
                        exit(JsonToken.AsValue().AsText());
                    end;
                end;
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to update List to SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
        exit('');
    end;

    procedure CreateDMSList(OauthToken: SecretText; SiteId: Text; ListId: Text; JsonText: Text): Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;
    begin
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/lists/%2/items', SiteId, ListId);
        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        RequestContent.GetHeaders(ContentHeader);
        RequestContent.WriteFrom(JsonText);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging            
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                if JsonResponse.Get('id', JsonToken) then begin
                    if not JsonToken.AsValue().IsNull then begin
                        exit(JsonToken.AsValue().AsText());
                    end;
                end;
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to upload files to SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
        exit('');
    end;

    procedure GetWhseByCurUserId(): Text
    var
        WhseEmpl: Record "Warehouse Employee";
        UserId: Text;
        Location: Text;
    begin
        Location := '';
        UserId := UserId();
        WhseEmpl.SetRange("User ID", UserId);
        if WhseEmpl.FindSet() then begin
            repeat
                if Location = '' then begin
                    Location := WhseEmpl."Location Code";
                end else begin
                    Location := Location + '|' + WhseEmpl."Location Code";
                end;
            until WhseEmpl.Next() = 0;
        end;
        exit(Location);
    end;

    procedure GetSalesByCurUserId(): Text
    var
        UserSU: Record "User Setup";
        UserId: Text;
        BUID: Text;
    begin
        BUID := '';
        UserId := UserId();
        UserSU.SetRange("User ID", UserId);
        UserSU.SetFilter("Sales Resp. Ctr. Filter", '<> %1', '');
        if UserSU.FindSet() then begin
            repeat
                if BUID = '' then begin
                    BUID := UserSU."Sales Resp. Ctr. Filter";
                end else begin
                    BUID := BUID + '|' + UserSU."Sales Resp. Ctr. Filter";
                end;
            until UserSU.Next() = 0;
        end;
        exit(BUID);
    end;

    procedure GetUserSetupByCurUserId(): Boolean
    var
        UserSU: Record "User Setup";
        UserId: Text;
        BUID: Text;
    begin
        BUID := '';
        UserId := UserId();
        UserSU.SetRange("User ID", UserId);
        UserSU.SetRange("ACC Allow Inventory By Bin", true);
        if UserSU.FindFirst() then
            exit(true);
        exit(false);
    end;

    procedure GeteInvoiceTemplate(eInvoiceType: Enum "AIG eInvoice Type"): Text
    var
        eInvoiceSetup: Record "AIG eInvoice Setup";
    begin
        if eInvoiceSetup.Get(CompanyName, eInvoiceType) then begin
            exit(eInvoiceSetup."eInvoice Template No.");
        end;
        exit('');
    end;

    procedure GetLocationImportPlan(DocumentNo: Code[20]; LineNo: Integer): Integer
    var
        LocationList: List of [Text];
        ImportLocation: Query "ACC Purchase Import Plan Qry";
    Begin
        ImportLocation.SetFilter(SourceDocumentNo, DocumentNo);
        ImportLocation.SetFilter(SourceLineNo, Format(LineNo));
        ImportLocation.SetFilter(ActualLocationCode, '<>%1', '');
        if ImportLocation.Open() then begin
            while ImportLocation.Read() do begin
                LocationList.Add(ImportLocation.ActualLocationCode);
            end;
            ImportLocation.Close();
        end;
        exit(LocationList.Count);
    End;
}
