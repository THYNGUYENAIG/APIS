pageextension 51025 "ACC Posted Sales Shipment Card" extends "Posted Sales Shipment"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addafter("&Navigate")
        {
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
}
