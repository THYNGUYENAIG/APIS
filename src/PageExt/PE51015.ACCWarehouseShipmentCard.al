pageextension 51015 "ACC Warehouse Shipment Card" extends "Warehouse Shipment"
{
    layout
    {
        addlast(General)
        {
            field("ACC Customer No"; Rec."ACC Customer No")
            {
                ApplicationArea = All;
                Caption = 'Customer/Vendor No';
                Editable = false;
            }
            field("ACC Customer Name"; Rec."ACC Customer Name")
            {
                ApplicationArea = All;
                Caption = 'Customer/Vendor Name';
                Editable = false;
            }
            //field("ACC Delivery Note"; Rec."ACC Delivery Note")
            //{
            //    ApplicationArea = All;
            //    Caption = 'Delivery Note';
            //    Editable = false;
            //}
            field(ACC_Request_Delivery_Date; arrCellDate[1])
            {
                ApplicationArea = All;
                Caption = 'Request Delivery Date';
                Editable = false;
            }
        }
    }
    actions
    {
        modify("Get Source Documents")
        {
            trigger OnAfterAction()
            var
            begin

                recWSL.Reset();
                recWSL.SetRange("No.", Rec."No.");
                if recWSL.FindFirst() then begin
                    case recWSL."Source Document" of
                        "Warehouse Activity Source Document"::"Sales Order":
                            begin
                                recSH.Reset();
                                recSH.SetRange("No.", recWSL."Source No.");
                                if recSH.FindFirst() then arrCellDate[1] := recSH."Requested Delivery Date";
                            end;
                    end;
                end;

            end;
        }
        addlast(processing)
        {
            group(Report)
            {
                action(ACCWhseShipment)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu xuất kho (Unpost)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataWhseShipment();
                    end;
                }
            }
        }
    }
    local procedure GetDataWhseShipment()
    var
        Field: Record "Warehouse Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Packing Slip Unpost Report";
        WSNo: Text;
        ParametersText: Text;
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);
        WSNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No."));
        ParametersText := StrSubstNo('%1%2%3', '<?xml version="1.0" standalone="yes"?><ReportParameters name="ACC Packing Slip Unpost Report" id="51017"><Options><Field name="WhseNo">', WSNo, '</Field></Options><DataItems><DataItem name="WhseShipment">VERSION(1) SORTING(Field51001)</DataItem></DataItems></ReportParameters>');
        //Phương thức dùng để lấy thông tin tham số Parameters XML.
        //Test := FieldReport.RunRequestPage();
        //Message(Test);
        FieldReport.Execute(ParametersText); // Sales AS PDF
    end;

    trigger OnOpenPage()
    var
    begin

        recWSL.Reset();
        recWSL.SetRange("No.", Rec."No.");
        if recWSL.FindFirst() then begin
            case recWSL."Source Document" of
                "Warehouse Activity Source Document"::"Sales Order":
                    begin
                        recSH.Reset();
                        recSH.SetRange("No.", recWSL."Source No.");
                        if recSH.FindFirst() then arrCellDate[1] := recSH."Requested Delivery Date";
                    end;
            end;
        end;

    end;

    var
        arrCellDate: array[5] of Date;
        recSH: Record "Sales Header";
        recWSL: Record "Warehouse Shipment Line";
}
