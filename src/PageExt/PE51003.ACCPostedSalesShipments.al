pageextension 51003 "ACC Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Posted Sales Invoice"; Rec."Posted Sales Invoice")
            {
                ApplicationArea = ALL;
                Caption = 'Posted Sales Invoice';
            }
            field(eInvoice; Rec.eInvoice)
            {
                ApplicationArea = ALL;
                Caption = 'eInvoice';
            }
            field("Tax authority number"; Rec."Tax authority number")
            {
                ApplicationArea = ALL;
                Caption = 'Tax authority number';
            }
            field("Last Message"; Rec."Last Message")
            {
                ApplicationArea = ALL;
                Caption = 'Last Message';
            }
            field("Sales Quantity"; Rec."Sales Quantity")
            {
                ApplicationArea = ALL;
                Caption = 'Sales Quantity';
            }
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            /*
            action(ACCJson)
            {
                ApplicationArea = All;
                Caption = 'Get Json';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ResponseText: Text;
                    JsonResponse: JsonObject;

                    InnerJsonResponse: JsonObject;
                    JsonToken: JsonToken;
                    DataToken: JsonToken;
                    ItemToken: JsonToken;

                    InvoiceCodeList: List of [Text];
                    TransactionId: Text;
                    InvoiceCode: Text;

                    DataArray: JsonArray;
                    i: Integer;
                begin
                    ResponseText := '{"Success":true,"ErrorCode":null,"Errors":[],"data":"{\"TransactionID\":\"1VUQHQ48_\",\"PublishStatus\":1,\"ReferenceType\":0,\"InvoiceCode\":null,\"SendTaxStatus\":2,\"IsSentEmail\":false,\"IsDelete\":false,\"DeletedDate\":null,\"DeletedReason\":null,\"ReceivedStatus\":0},{\"TransactionID\":\"KDU0HQWAB\",\"PublishStatus\":1,\"ReferenceType\":0,\"InvoiceCode\":null,\"SendTaxStatus\":1,\"IsSentEmail\":false,\"IsDelete\":false,\"DeletedDate\":null,\"DeletedReason\":null,\"ReceivedStatus\":0}","CustomData":null}';
                    ResponseText := ResponseText.Replace('InvoiceCode\":null,', 'InvoiceCode\":\"\",');
                    if not JsonResponse.ReadFrom(ResponseText) then begin
                        Message('Error');
                    end else begin
                        if JsonResponse.Get('data', DataToken) then begin
                            if DataToken.IsArray() then begin
                                // For this specific API, the token is likely in the Data field
                                // Adjust according to the actual response structure
                                DataArray := DataToken.AsArray();
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
                            if DataToken.IsObject() then begin
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
                    end;
                end;
            }
            */
            action(ACCUpdate)
            {
                ApplicationArea = All;
                Caption = 'Get eInvoice';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CUInvoiceStatus: Codeunit "ACC MISA Invoice Status";
                    CUSalesShipment: Codeunit "ACC Sales Shipment Event";
                    ShipmentHeader: Record "Sales Shipment Header";
                    FromDate: Date;
                    ToDate: Date;
                begin
                    FromDate := CalcDate('-1D', TODAY);
                    ToDate := Today();
                    CUInvoiceStatus.eInvoiceRegisterModified(FromDate, ToDate);
                    Clear(ShipmentHeader);
                    ShipmentHeader.SetRange("Posting Date", FromDate, ToDate);
                    ShipmentHeader.SetFilter("Tax authority number", '');
                    if ShipmentHeader.FindSet() then begin
                        repeat
                            CUSalesShipment.Run(ShipmentHeader);
                        until ShipmentHeader.Next() = 0;
                    end;
                end;
            }
            action(ACCPackingSlip)
            {
                ApplicationArea = All;
                Caption = 'Phiếu xuất kho';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    CUPrinted: Codeunit "ACC Shipment Print Event";
                begin
                    GetDataPackingSlip();
                    CUPrinted.Run(Rec);
                end;
            }
            action(ACCShipment)
            {
                ApplicationArea = All;
                Caption = 'Phiếu xuất kho (Gộp pdf)';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    RunPage: Page "AIG Shipment Merge PDF";
                    Field: Record "Sales Shipment Header";
                    FieldRec: Record "Sales Shipment Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    Clear(RunPage);
                    RunPage.TestMerge(SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
                    RunPage.Run();
                end;
            }
            action(ACC2eInvoice3Shipment)
            {
                ApplicationArea = All;
                Caption = '2 eInvoice(s) 3 Shipment(s)';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    RunPage: Page "AIG eInvoice Merge PDF";
                    Field: Record "Sales Shipment Header";
                    FieldRec: Record "Sales Shipment Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    Clear(RunPage);
                    RunPage.TestMerge(SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
                    RunPage.Run();
                end;
            }
            action(ACCMergePDF)
            {
                ApplicationArea = All;
                Caption = 'Merge PDF';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    MergePage: Page "AIG Merge PDF Page";
                    Field: Record "Sales Shipment Header";
                    FieldRec: Record "Sales Shipment Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    Clear(MergePage);
                    MergePage.TestMerge(SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")), SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Truck Number")));
                    MergePage.Run();
                end;
            }
        }
    }
    local procedure GetDataPackingSlip()
    var
        CustTable: Record Customer;
        Field: Record "Sales Shipment Header";
        FieldRec: Record "Sales Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        Field01Report: Report "ACC Packing Slip Report";
        Field02Report: Report "ACC Packing Slip - EXP Report";
        Field03Report: Report "ACC Packing Slip - PROD Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        //FieldRec.SetFilter(eInvoice, '<>%1', '');

        if CustTable.Get(SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Sell-to Customer No."))) then begin
            case CustTable."Report Layout" of
                "ACC Packing Slip Layout"::"Layout 01":
                    begin
                        Field01Report.SetTableView(FieldRec);
                        Field01Report.Run();
                    end;
                "ACC Packing Slip Layout"::"Layout 02":
                    begin
                        Field02Report.SetTableView(FieldRec);
                        Field02Report.Run();
                    end;
                "ACC Packing Slip Layout"::"Layout 03":
                    begin
                        Field03Report.SetTableView(FieldRec);
                        Field03Report.Run();
                    end;
                else begin
                    Field01Report.SetTableView(FieldRec);
                    Field01Report.Run();
                end;
            end;
        end else begin
            Field01Report.SetTableView(FieldRec);
            Field01Report.Run();
        end;
    end;

    local procedure GetDataPackingSlipEXP()
    var
        Field: Record "Sales Shipment Header";
        FieldRec: Record "Sales Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Packing Slip - EXP Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    local procedure GetDataPackingSlipPROD()
    var
        Field: Record "Sales Shipment Header";
        FieldRec: Record "Sales Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Packing Slip - PROD Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
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

    trigger OnOpenPage()
    var
        CUInvoiceStatus: Codeunit "ACC MISA Invoice Status";
        CUSalesShipment: Codeunit "ACC Sales Shipment Event";
        ShipmentHeader: Record "Sales Shipment Header";
        FromDate: Date;
        ToDate: Date;
    begin
        //FromDate := CalcDate('-1D', TODAY);
        //ToDate := Today();
        //CUInvoiceStatus.eInvoiceRegisterModified(FromDate, ToDate);
        //Clear(ShipmentHeader);
        //ShipmentHeader.SetRange("Posting Date", FromDate, ToDate);
        //ShipmentHeader.SetFilter("Tax authority number", '');
        //if ShipmentHeader.FindSet() then begin
        //    repeat
        //        CUSalesShipment.Run(ShipmentHeader);
        //    until ShipmentHeader.Next() = 0;
        //end;
    end;
}
