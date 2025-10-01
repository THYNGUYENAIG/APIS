codeunit 51009 "ACC Sales Balance Reminder"
{
    TableNo = "Cust. Ledger Entry";

    trigger OnRun()
    begin
        ExportExcelSPO();
    end;

    procedure ExportExcelSPO()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;

        BusinessUnit: Record "ACC Business Unit Setup";
        //DimValue: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
        CustLegEnt: Record "Cust. Ledger Entry";
        Salesperson: Record "Salesperson/Purchaser";

        ExcelBufferTmp: Record "Excel Buffer" temporary;
        ExcelFileName: Label '%1_%2_CongNo.xlsx';

        SPOFileID: Text;
        OverDue: Integer;

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        FileContent: InStream;
        FileName: Text;
        MimeType: Text;

        JsonObject: JsonObject;
        JsonText: Text;

        CustomerNo: Text;
        CustomerName: Text;
        AmountLCY: Decimal;
        RemainingLCY: Decimal;
        AmountNotDue: Decimal;
        Amount0130Due: Decimal;
        Amount3160Due: Decimal;
        Amount6190Due: Decimal;
        Amount90After: Decimal;
        SalesName: Text;

        TotalAmountLCY: Decimal;
        TotalRemainingLCY: Decimal;
        TotalAmountNotDue: Decimal;
        TotalAmount0130Due: Decimal;
        TotalAmount3160Due: Decimal;
        TotalAmount6190Due: Decimal;
        TotalAmount90After: Decimal;
    begin
        MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        //DimValue.SetAscending(Code, true);
        //DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
        //DimValue.SetRange(Blocked, false);
        BusinessUnit.Reset();
        BusinessUnit.SetRange(Blocked, false);
        BusinessUnit.SetFilter(Email, '<>%1', '');
        if BusinessUnit.FindSet() then begin
            repeat
                TotalAmountLCY := 0;
                TotalRemainingLCY := 0;
                TotalAmountNotDue := 0;
                TotalAmount0130Due := 0;
                TotalAmount3160Due := 0;
                TotalAmount6190Due := 0;
                TotalAmount90After := 0;
                ExcelBufferTmp.Reset();
                ExcelBufferTmp.DeleteAll();
                ExcelBufferTmp.NewRow();
                ExcelBufferTmp.AddColumn('Posting Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Document Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Document No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('External Document No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Customer No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Due Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Over Due', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Original Amount', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Balance', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('After 90 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('61 - 90 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('31 - 60 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('1 - 30 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Not Due', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Salesperson', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                DefaultDim.Reset();
                DefaultDim.SetAscending("No.", true);
                DefaultDim.SetRange("Table ID", 18);
                DefaultDim.SetRange("Dimension Code", 'BUSINESSUNIT');
                DefaultDim.SetRange("Dimension Value Code", BusinessUnit.Code);
                if DefaultDim.FindSet() then begin
                    repeat
                        AmountLCY := 0;
                        RemainingLCY := 0;
                        AmountNotDue := 0;
                        Amount0130Due := 0;
                        Amount3160Due := 0;
                        Amount6190Due := 0;
                        Amount90After := 0;
                        AmountNotDue := 0;
                        CustLegEnt.Reset();
                        CustLegEnt.SetRange("Customer No.", DefaultDim."No.");
                        CustLegEnt.SetFilter("Customer Posting Group", '1|2|3|4|5|6');
                        CustLegEnt.SetAutoCalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                        if CustLegEnt.FindSet() then begin
                            repeat
                                if CustLegEnt."Remaining Amt. (LCY)" <> 0 then begin
                                    ExcelBufferTmp.NewRow();
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Posting Date", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Document Date", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(CustLegEnt."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Customer No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    CustomerNo := CustLegEnt."Customer No.";
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Customer Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    CustomerName := 'Total for ' + CustLegEnt."Customer Name";
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Due Date", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                                    OverDue := Today() - CustLegEnt."Due Date";
                                    ExcelBufferTmp.AddColumn(OverDue, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Amount (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    AmountLCY := AmountLCY + CustLegEnt."Amount (LCY)";
                                    ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    RemainingLCY := RemainingLCY + CustLegEnt."Remaining Amt. (LCY)";
                                    if OverDue > 90 then begin
                                        ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                        Amount90After := Amount90After + CustLegEnt."Remaining Amt. (LCY)";
                                    end else begin
                                        ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    end;
                                    if (OverDue >= 61) AND (OverDue <= 90) then begin
                                        ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                        Amount6190Due := Amount6190Due + CustLegEnt."Remaining Amt. (LCY)";
                                    end else begin
                                        ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    end;
                                    if (OverDue >= 31) AND (OverDue <= 60) then begin
                                        ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                        Amount3160Due := Amount3160Due + CustLegEnt."Remaining Amt. (LCY)";
                                    end else begin
                                        ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    end;
                                    if (OverDue >= 1) AND (OverDue <= 30) then begin
                                        ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                        Amount0130Due := Amount0130Due + CustLegEnt."Remaining Amt. (LCY)";
                                    end else begin
                                        ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    end;
                                    if OverDue < 1 then begin
                                        ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                        AmountNotDue := AmountNotDue + CustLegEnt."Remaining Amt. (LCY)";
                                    end else begin
                                        ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                    end;
                                    if Salesperson.Get(CustLegEnt."Salesperson Code") then begin
                                        ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Text);
                                        SalesName := Salesperson.Name;
                                    end else begin
                                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Text);
                                    end;
                                end;
                            until CustLegEnt.Next() = 0;
                            if AmountLCY <> 0 then begin
                                ExcelBufferTmp.NewRow();
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(CustomerName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(AmountLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalAmountLCY := TotalAmountLCY + AmountLCY;
                                ExcelBufferTmp.AddColumn(RemainingLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalRemainingLCY := TotalRemainingLCY + RemainingLCY;
                                ExcelBufferTmp.AddColumn(Amount90After, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalAmount90After := TotalAmount90After + Amount90After;
                                ExcelBufferTmp.AddColumn(Amount6190Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalAmount6190Due := TotalAmount6190Due + Amount6190Due;
                                ExcelBufferTmp.AddColumn(Amount3160Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalAmount3160Due := TotalAmount3160Due + Amount3160Due;
                                ExcelBufferTmp.AddColumn(Amount0130Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalAmount0130Due := TotalAmount0130Due + Amount0130Due;
                                ExcelBufferTmp.AddColumn(AmountNotDue, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                TotalAmountNotDue := TotalAmountNotDue + AmountNotDue;
                                ExcelBufferTmp.AddColumn(SalesName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    until DefaultDim.Next() = 0;
                end;
                ExcelBufferTmp.NewRow();
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('Total for ' + BusinessUnit.Name, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.AddColumn(TotalAmountLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn(TotalRemainingLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn(TotalAmount90After, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn(TotalAmount6190Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn(TotalAmount3160Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn(TotalAmount0130Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn(TotalAmountNotDue, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                ExcelBufferTmp.CreateNewBook(BusinessUnit.Code);
                ExcelBufferTmp.WriteSheet('Detail', 'ACC', UserId);
                ExcelBufferTmp.SetColumnWidth('A', 15);
                ExcelBufferTmp.SetColumnWidth('B', 15);
                ExcelBufferTmp.SetColumnWidth('C', 20);
                ExcelBufferTmp.SetColumnWidth('D', 20);
                ExcelBufferTmp.SetColumnWidth('E', 15);
                ExcelBufferTmp.SetColumnWidth('F', 100);
                ExcelBufferTmp.SetColumnWidth('G', 15);
                ExcelBufferTmp.SetColumnWidth('H', 10);

                ExcelBufferTmp.SetColumnWidth('I', 20);
                ExcelBufferTmp.SetColumnWidth('J', 20);
                ExcelBufferTmp.SetColumnWidth('K', 20);
                ExcelBufferTmp.SetColumnWidth('L', 20);
                ExcelBufferTmp.SetColumnWidth('M', 20);
                ExcelBufferTmp.SetColumnWidth('N', 20);
                ExcelBufferTmp.SetColumnWidth('O', 20);
                ExcelBufferTmp.SetColumnWidth('P', 35);
                ExcelBufferTmp.CloseBook();

                Clear(TempBlob);
                FileName := StrSubstNo(ExcelFileName, BusinessUnit.Code, Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
                TempBlob.CreateOutStream(OutStr);
                ExcelBufferTmp.SaveToStream(OutStr, true);
                TempBlob.CreateInStream(FileContent);
                SPOFileID := UploadFilesSPO(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn-bCGfD_pp2Q6CM9ASdiUZN', FileContent, FileName, MimeType);
                if SPOFileID <> '' then begin
                    Clear(JsonObject);
                    JsonObject.Add('Title', 'Sales balance');
                    JsonObject.Add('CustomerAccount', BusinessUnit.Code);
                    JsonObject.Add('CustomerName', BusinessUnit.Name);
                    JsonObject.Add('Email', BusinessUnit.Email);
                    JsonObject.Add('AREmail', BusinessUnit."CC Email");
                    JsonObject.Add('_ExtendedDescription', 'Business unit notify');
                    JsonText := Format(JsonObject);
                    UpdateMetadata(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn-bCGfD_pp2Q6CM9ASdiUZN', SPOFileID, JsonText);
                end;
            until BusinessUnit.Next() = 0;
        end;
    end;

    local procedure UploadFilesSPO(OauthToken: SecretText; SiteId: Text; DriveId: Text; FileContent: InStream; FileName: Text; MimeType: Text): Text
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
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/root:/%3:/content', SiteId, DriveId, FileName);
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

    local procedure UpdateMetadata(OauthToken: SecretText; SiteId: Text; DriveId: Text; FileId: Text; JsonText: Text)
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
}
