page 51012 "ACC Quality Control Header"
{
    ApplicationArea = All;
    Caption = 'APIS Quality Control Header - P51012';
    CardPageId = "ACC Quality Control Card";
    PageType = List;
    SourceTable = "ACC Quality Control Header";
    UsageCategory = Lists;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code") { }
                field("Truck Number"; Rec."Truck Number")
                {
                    Editable = false;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    Editable = false;
                }
                field("Delivery times"; Rec."Delivery Times")
                {
                    Editable = false;
                }
                field("Container No."; Rec."Container No.")
                {
                    Editable = false;
                }
                field("Seal No."; Rec."Seal No.") { }
                field(Dock; Rec.Dock) { }
                field(TGBD; Rec.TGBD) { }
                field(TGKT; Rec.TGKT) { }
                field(Floor; Rec.Floor) { }
                field(Wall; Rec.Wall) { }
                field(Ceiling; Rec.Ceiling) { }
                field("No Strange Smell"; Rec."No Strange Smell") { }
                field("No Insects"; Rec."No Insects") { }
                field("Vehicle Temperature"; Rec."Vehicle Temperature") { }
                field("Handle (If Any)"; Rec."Handle (If Any)") { }
                field("Line Handle (If Any)"; Rec."Line Handle (If Any)") { }
                field("Type"; Rec."Type")
                {
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            group(ACCReport)
            {
                Caption = 'Report';
                action(ACCTransportInfo)
                {
                    ApplicationArea = All;
                    Caption = 'Get All Transport Information';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        BCHelper: Codeunit "BC Helper";
                    begin
                        BCHelper.WarehouseTransportControl();
                        BCHelper.WarehouseTransportLineControl();
                    end;
                }
                action(ACCQualityReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu kiểm tra hàng nhập';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec.Type = Rec.Type::Input;
                    trigger OnAction();
                    begin
                        GetDataAndQualityReceiptPrint();
                    end;
                }
                action(ACCQualityShipment)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu kiểm tra hàng xuất';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec.Type = Rec.Type::Output;
                    trigger OnAction();
                    begin
                        GetDataAndQualityShipmentPrint();
                    end;
                }
            }
        }
    }

    local procedure GetDataAndQualityReceiptPrint()
    var
        Field: Record "ACC Quality Control Header";
        FieldRec: Record "ACC Quality Control Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Quality Control In Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Location Code", "Truck Number");
        FieldRec.SetFilter("Location Code", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Location Code")));
        FieldRec.SetFilter("Truck Number", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Truck Number")));
        FieldRec.SetFilter("Delivery Date", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Delivery Date")));
        FieldRec.SetFilter("Delivery Times", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Delivery Times")));
        FieldRec.SetFilter(Type, SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo(Type)));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    local procedure GetDataAndQualityShipmentPrint()
    var
        Field: Record "ACC Quality Control Header";
        FieldRec: Record "ACC Quality Control Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Quality Control Out Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Location Code", "Truck Number");
        FieldRec.SetFilter("Location Code", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Location Code")));
        FieldRec.SetFilter("Truck Number", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Truck Number")));
        FieldRec.SetFilter("Delivery Date", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Delivery Date")));
        FieldRec.SetFilter("Delivery Times", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Delivery Times")));
        FieldRec.SetFilter(Type, SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo(Type)));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
