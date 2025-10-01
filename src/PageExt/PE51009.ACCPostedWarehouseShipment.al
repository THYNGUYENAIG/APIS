pageextension 51009 "ACC Posted Warehouse Shipment" extends "Posted Whse. Shipment List"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area

        addlast(processing)
        {
            group(Report)
            {
                Caption = 'Report';
                action(ACCPackingSlip)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu xuất kho';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataPackingSlip();
                    end;
                }

                action(ACCReturnShipment)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu xuất kho (Return)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataReturnShipment();
                    end;
                }
            }
        }
    }
    local procedure GetDataPackingSlip()
    var
        SalesShipment: Query "ACC Sales Whse. Shipment Qry";
        CustTable: Record Customer;
        Field: Record "Posted Whse. Shipment Header";
        FieldRec: Record "Sales Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        Field01Report: Report "ACC Packing Slip Report";
        Field02Report: Report "ACC Packing Slip - EXP Report";
        Field03Report: Report "ACC Packing Slip - PROD Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        SalesShipment.SetRange(No, SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        if SalesShipment.Open() then begin
            if SalesShipment.Read() then begin
                FieldRec.SetCurrentKey("No.");
                FieldRec.SetFilter("No.", SalesShipment.PostedSourceNo);
                FieldRec.SetFilter("Posting Date", Format(SalesShipment.PostingDate));

                if CustTable.Get(FieldRec."Sell-to Customer No.") then begin
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
        end;
    end;

    local procedure GetDataReturnShipment()
    var
        Field: Record "Posted Whse. Shipment Header";
        ShipmentLine: Record "Posted Whse. Shipment Line";
        FieldRec: Record "Return Shipment Header";

        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Return Shipment Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        ShipmentLine.Reset();
        ShipmentLine.SetRange("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        if ShipmentLine.FindFirst() then begin
            FieldRec.SetCurrentKey("No.");
            FieldRec.SetFilter("No.", ShipmentLine."Posted Source No.");
            FieldReport.SetTableView(FieldRec);
            FieldReport.Run();
        end;
    end;
}
