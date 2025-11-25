codeunit 51013 "ACC MISA Invoice Status"
{
    procedure eInvoiceRegisterModified(FromDate: Date; ToDate: Date)
    var
        BCHelper: Codeunit "BC Helper";
        TemplateHeader: Record "BLTI Template Header";
        eInvoiceToken: SecretText;
        eInvoiceRegister: Record "BLTI eInvoice Register";
        eInvoiceCount: Integer;
        InTransactionFilter: Text;
        InTransactionIDs: List of [Text];
        OutTransactionIDs: List of [Text];
        eInvoiceReservationCode: Text;
        eInvoiceCode: Text;
        eInvoiceList: Text;
    begin
        if TemplateHeader.Get(BCHelper.GeteInvoiceTemplate("AIG eInvoice Type"::"VAT Domestic")) then begin
            eInvoiceToken := GetOAuthTokeneInvoice(TemplateHeader);
        end;
        eInvoiceCount := 0;
        InTransactionFilter := '';
        Clear(InTransactionIDs);
        Clear(OutTransactionIDs);
        eInvoiceRegister.Reset();
        eInvoiceRegister.SetCurrentKey("eInvoice ReservationCode");
        eInvoiceRegister.SetRange("eInvoice Date", FromDate, ToDate);
        eInvoiceRegister.SetRange("eInvoice Code", '');
        eInvoiceRegister.SetFilter("eInvoice ReservationCode", '<>%1', '');
        if eInvoiceRegister.FindSet() then
            repeat
                if InTransactionFilter = '' then begin
                    InTransactionFilter += eInvoiceRegister."eInvoice ReservationCode";
                end else
                    InTransactionFilter += '|' + eInvoiceRegister."eInvoice ReservationCode";

                InTransactionIDs.Add(eInvoiceRegister."eInvoice ReservationCode");
                eInvoiceCount += 1;
                if eInvoiceCount = 20 then
                    break;
            until eInvoiceRegister.Next() = 0;

        if InTransactionIDs.Count >= 1 then begin
            OutTransactionIDs := MISAInvoiceStatus(eInvoiceToken, InTransactionIDs);
        end;

        if InTransactionFilter <> '' then begin
            eInvoiceCount := 0;
            eInvoiceRegister.Reset();
            eInvoiceRegister.SetCurrentKey("eInvoice ReservationCode");
            eInvoiceRegister.SetFilter("eInvoice ReservationCode", InTransactionFilter);
            if eInvoiceRegister.FindSet() then
                repeat
                    if OutTransactionIDs.Count >= 1 then begin
                        eInvoiceCount += 1;
                        eInvoiceList := OutTransactionIDs.Get(eInvoiceCount);
                        eInvoiceReservationCode := SelectStr(1, eInvoiceList);
                        eInvoiceCode := SelectStr(2, eInvoiceList);
                        if eInvoiceReservationCode = eInvoiceRegister."eInvoice ReservationCode" then begin
                            if eInvoiceCode <> '99' then begin
                                eInvoiceRegister."eInvoice Code" := eInvoiceCode;
                                eInvoiceRegister.Modify();
                            end;
                        end;
                    end;
                until eInvoiceRegister.Next() = 0;
        end;
    end;

    local procedure GetOAuthTokeneInvoice(TemplateHeader: Record "BLTI Template Header") AuthToken: SecretText
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
        /*    
        JsonBody.Add('appid', 'b22a8225-a68a-11ec-9122-005056a6f699');
        JsonBody.Add('taxcode', '0304918352');
        JsonBody.Add('username', 'itsupport@asia-chemical.com');
        JsonBody.Add('password', '123456@Abc');
        */
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

    local procedure MISAInvoiceStatus(eInvoiceToken: SecretText; TransactionIDs: List of [Text]): List of [Text]
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

        InvoiceCodeList: List of [Text];
        TransactionId: Text;
        InvoiceCode: Text;

        DataArray: JsonArray;
        i: Integer;
        Convert: Codeunit "Base64 Convert";
        CopyInit: Integer;
        TransTxt: Text;
    begin
        // Create JSON request body
        RequestBody := '[';
        for i := 1 to TransactionIDs.Count() do begin
            if i = 1 then begin
                RequestBody += '"' + TransactionIDs.Get(i) + '"';
            end else begin
                RequestBody += ',"' + TransactionIDs.Get(i) + '"';
            end;
        end;
        RequestBody += ']';

        // Set up the request content
        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        // Create and configure the HTTP request
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri('https://api.meinvoice.vn/api/integration/invoice/status?invoiceWithCode=true&invoiceCalcu=false&inputType=1');
        HttpRequestMessage.Content(HttpContent);

        // Add authorization header with token
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', eInvoiceToken));
        //HttpHeaders.Add('CompanyTaxCode', TemplateHeader."Seller Tax No.");

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
        ResponseText := ResponseText.Replace('InvoiceCode\":null,', 'InvoiceCode\":\"\",');
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
                DataArray.ReadFrom(DataToken.AsValue().AsText());
                for i := 0 to DataArray.Count - 1 do begin
                    DataArray.Get(i, ItemToken);
                    InnerJsonResponse := ItemToken.AsObject();
                    GetJsonTextValue(InnerJsonResponse, 'TransactionID', TransactionId);
                    GetJsonTextValue(InnerJsonResponse, 'InvoiceCode', InvoiceCode);
                    if (StrLen(InvoiceCode) > 5) then begin
                        InvoiceCodeList.Add(TransactionId + ',' + InvoiceCode);
                    end else
                        InvoiceCodeList.Add(TransactionId + ',99');
                end;
            end;
        end;
        exit(InvoiceCodeList);
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
            if Result <> '' then
                exit(true);
        end;
        Result := '';
        exit(false);
    end;
}
