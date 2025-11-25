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
            action(ACCUpdate)
            {
                ApplicationArea = All;
                Caption = 'Get eInvoice';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    eInvoiceSetup: Record "AIG eInvoice Setup";
                    CUInvoiceStatus: Codeunit "ACC MISA Invoice Status";
                    CUSalesShipment: Codeunit "ACC Sales Shipment Event";
                    ShipmentHeader: Record "Sales Shipment Header";
                    FromDate: Date;
                    ToDate: Date;
                begin
                    eInvoiceSetup.Get(CompanyName, "AIG eInvoice Type"::"VAT Domestic");
                    FromDate := Today - eInvoiceSetup.Days;
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
                    CUPrinted: Codeunit "ACC Shipment Print Event";
                    MergePage: Page "AIG Merge PDF Page";
                    Field: Record "Sales Shipment Header";
                    FieldRec: Record "Sales Shipment Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    CUPrinted.Run(Rec);
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
