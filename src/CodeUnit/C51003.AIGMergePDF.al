codeunit 51003 "AIG Merge PDF"
{
    //HOW TO USE
    //Just call the AddReportToMerge or AddBase64pdf functions as many times as needed and later get call the GetJArray function.
    //You will get an array with all your pdfs in base64 to provide to the javascript function of the controladd-in
    //In case you want to deploy the Azure Function provided, call the CallService procedure
    procedure AddPdfToMerge()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        TemplateHeader: Record "BLTI Template Header";
        SalesInvoice: Query "ACC Sales Invoice SPO Qry";
        ShipmentHeader: Record "Sales Shipment Header";
        LocationTable: Record Location;
        CustTable: Record Customer;
        RecRef: RecordRef;

        eInvoiceToken: SecretText;
        OAuthToken: SecretText;
        TransactionIDsList: List of [Text];

        DateFolder: Text;
        LocationFolder: Text;
        TempLocation: Text;
        eInvoiceInt: Integer;
        copyInt: Integer;
    begin
        DateFolder := StrSubstNo('%1_HDPXK_BC', Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
        if TemplateHeader.Get('MISA-1C25TSG') then begin
            eInvoiceToken := BCHelper.GetOAuthTokeneInvoice(TemplateHeader);
        end;

        if SharepointConnector.Get('INVSHIPPDF') then begin
            OAuthToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            eInvoiceInt := SharepointConnector."Copy Packing Slip" + SharepointConnector."Copy eInvoice";
            if not SharepointConnectorLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            BCHelper.CreateSharePointFolder(SharepointConnectorLine, OAuthToken, '', DateFolder);
            SalesInvoice.SetFilter(eInvoiceNo, '>%1', '');
            SalesInvoice.SetFilter(PostingDate, Format(TODAY));
            //SalesInvoice.SetFilter(PostingDate, Format(CalcDate('-2D', TODAY)));
            if SalesInvoice.Open() then begin
                while SalesInvoice.Read() do begin
                    if TempLocation <> SalesInvoice.LocationCode then begin
                        LocationFolder := SalesInvoice.LocationCode;
                        LocationTable.Get(SalesInvoice.LocationCode);
                        BCHelper.CreateSharePointFolder(SharepointConnectorLine, OAuthToken, DateFolder, LocationFolder);
                    end;
                    ShipmentHeader.Get(SalesInvoice.DocumentNo);
                    RecRef.GetTable(ShipmentHeader);
                    ShipmentHeader.SetRecFilter();
                    if CustTable.Get(ShipmentHeader."Sell-to Customer No.") then begin
                        case CustTable."Report Layout" of
                            "ACC Packing Slip Layout"::"Layout 01":
                                AddShipmentToMerge(51002, RecRef, SharepointConnector."Copy Packing Slip");
                            "ACC Packing Slip Layout"::"Layout 02":
                                AddShipmentToMerge(51003, RecRef, SharepointConnector."Copy Packing Slip");
                            "ACC Packing Slip Layout"::"Layout 03":
                                AddShipmentToMerge(51004, RecRef, SharepointConnector."Copy Packing Slip");
                        end;
                    end;

                    // eInvoice Download                    
                    TransactionIDsList.Add(SalesInvoice.ReservationCode);
                    AddVoucherToMerge(TemplateHeader, eInvoiceToken, LocationTable.Contact, TransactionIDsList, SharepointConnector."Copy eInvoice");
                    TempLocation := SalesInvoice.LocationCode;
                end;
                SalesInvoice.Close();
            end;
        end;
    end;

    procedure AddReportToMerge(ReportID: Integer; RecRef: RecordRef)
    var
        Tempblob: Codeunit "Temp Blob";
        Ins: InStream;
        Outs: OutStream;
        Parameters: Text;
        Convert: Codeunit "Base64 Convert";
    begin
        Tempblob.CreateInStream(Ins);
        Tempblob.CreateOutStream(Outs);
        Parameters := '';
        Report.SaveAs(ReportID, Parameters, ReportFormat::Pdf, Outs, RecRef);
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', Convert.ToBase64(Ins));
        JArrayPDFToMerge.Add(JObjectPDFToMerge);
    end;

    procedure AddShipmentToMerge(ReportID: Integer; RecRef: RecordRef; NumberOfCopies: Integer)
    var
        Tempblob: Codeunit "Temp Blob";
        Ins: InStream;
        Outs: OutStream;
        Parameters: Text;
        Convert: Codeunit "Base64 Convert";
        CopyInit: Integer;
    begin
        Tempblob.CreateInStream(Ins);
        Tempblob.CreateOutStream(Outs);
        Parameters := '';
        Report.SaveAs(ReportID, Parameters, ReportFormat::Pdf, Outs, RecRef);
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', Convert.ToBase64(Ins));
        for CopyInit := 1 to NumberOfCopies do begin
            JArrayPDFToMerge.Add(JObjectPDFToMerge);
        end;
    end;

    procedure AddVoucherToMerge(TemplateHeader: Record "BLTI Template Header"; eInvoiceToken: SecretText; Converter: Text; TransactionIDs: List of [Text]; NumberOfCopies: Integer)
    var
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
        Convert: Codeunit "Base64 Convert";
        CopyInit: Integer;
    begin
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
                        Clear(JObjectPDFToMerge);
                        JObjectPDFToMerge.Add('pdf', Convert.ToBase64(FileContent));
                        for CopyInit := 1 to NumberOfCopies do begin
                            JArrayPDFToMerge.Add(JObjectPDFToMerge);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure AddVoucherToMergeV2(TemplateHeader: Record "BLTI Template Header"; eInvoiceToken: SecretText; Converter: Text; TransactionIDs: List of [Text]; NumberOfCopies: Integer): Text
    var
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
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        FileContent: InStream;
        OutStream: OutStream;
        Base64Data: Text;
        DataArray: JsonArray;
        i: Integer;
        Convert: Codeunit "Base64 Convert";
        CopyInit: Integer;
        MISAUrl: Text;
        JsonText: Text;
        TransId: Text;
        NoDataTransIds: Text;
    begin
        NoDataTransIds := '';
        MISAUrl := StrSubstNo('%1?invoiceWithCode=true&invoiceCalcu=false&Converter=%2&ConvertDate=%3', TemplateHeader."MISA-UrlExchange", Converter, Format(Today, 0, '<Year4>-<Month,2>-<Day,2>'));
        RequestBody := '[';
        for i := 1 to TransactionIDs.Count() do begin
            if i = 1 then begin
                RequestBody += '"' + TransactionIDs.Get(i) + '"';
            end else begin
                RequestBody += ',"' + TransactionIDs.Get(i) + '"';
            end;
        end;
        RequestBody += ']';
        // Create JSON request body                
        // Set up the request content
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        // Create and configure the HTTP request
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(MISAUrl);
        HttpRequestMessage.Content(HttpContent);

        // Add authorization header with token
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', eInvoiceToken));

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
        if JsonResponse.Get('success', JsonToken) then begin
            if not JsonToken.AsValue().AsBoolean() then begin
                if JsonResponse.Get('ErrorCode', JsonToken) and (not JsonToken.AsValue().IsNull) then
                    Error('MISA API error: %1 - %2',
                        GetJsonValueAsText(JsonResponse, 'ErrorCode'),
                        GetJsonValueAsText(JsonResponse, 'DescriptionErrorCode'));

                Error('MISA API returned unsuccessful response');
            end;
        end;
        if JsonResponse.Get('data', DataToken) then begin
            if not DataToken.AsValue().IsNull then begin
                // For this specific API, the token is likely in the Data field
                // Adjust according to the actual response structure
                JsonText := DataToken.AsValue().AsText();
                if StrPos(JsonText, ':null') > 1 then begin
                    JsonText := JsonText.Replace(':null', ':""');
                end;
                DataArray.ReadFrom(JsonText);
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
                        Clear(JObjectPDFToMerge);
                        JObjectPDFToMerge.Add('pdf', Convert.ToBase64(FileContent));
                        for CopyInit := 1 to NumberOfCopies do begin
                            JArrayPDFToMerge.Add(JObjectPDFToMerge);
                        end;
                    end else begin
                        if NoDataTransIds = '' then begin
                            if GetJsonTextValue(InnerJsonResponse, 'TransactionID', TransId) then
                                NoDataTransIds := TransId;
                        end else
                            if GetJsonTextValue(InnerJsonResponse, 'TransactionID', TransId) then
                                NoDataTransIds += '|' + TransId;
                    end;
                end;
            end;
        end;
        exit(NoDataTransIds);
    end;

    procedure AddBase64pdf(base64pdf: text)
    begin
        Clear(JObjectPDFToMerge);
        JObjectPDFToMerge.Add('pdf', base64pdf);
        JArrayPDFToMerge.Add(JObjectPDFToMerge);
    end;

    procedure ClearPDF()
    begin
        Clear(JArrayPDFToMerge);
    end;

    procedure GetJArray() JArrayPDF: JsonArray;
    begin
        JArrayPDF := JArrayPDFToMerge;
    end;

    local procedure GetJsonTextValue(JsonObj: JsonObject; PropertyName: Text; var Result: Text): Boolean
    var
        JsonToken: JsonToken;
    begin
        if JsonObj.Get(PropertyName, JsonToken) then begin
            Result := JsonToken.AsValue().AsText();
            if Result <> '' then
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
    /*
    procedure CallService() ResponseText: Text
    var
        MergePDFSetup: Record "Merge PDF Setup";
        SetupErr: Label 'Please setup Merge PDF page';
        URLErr: Label 'Please set the Azure Function Service URL';
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        contentHeaders: HttpHeaders;
        RequestUrl: Text;
        Body: Text;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
    begin
        if not MergePDFSetup.Get() then
            Error(SetupErr);
        if MergePDFSetup."Merge PDF Service" = '' then
            Error(URLErr);
        RequestUrl := MergePDFSetup."Merge PDF Service";
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestContent.WriteFrom(format(GetJArray()));
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Client.Post(RequestURL, RequestContent, ResponseMessage);
        if ResponseMessage.IsSuccessStatusCode then
            ResponseMessage.Content().ReadAs(ResponseText);
    end;
    */

    var
        JObjectPDFToMerge: JsonObject;
        JArrayPDFToMerge: JsonArray;
        JObjectPDF: JsonObject;
}