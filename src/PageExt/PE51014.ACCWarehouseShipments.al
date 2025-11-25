pageextension 51014 "ACC Warehouse Shipments" extends "Warehouse Shipment List"
{
    layout
    {
        addlast(Control1)
        {
            field(ACC_Source_Doc; arrCellText[1])
            {
                ApplicationArea = All;
                Caption = 'Source Document';
                // Editable = false;
            }
            field(ACC_Source_No; Rec."ACC Source No.")
            {
                ApplicationArea = All;
                Caption = 'Source No';
                // Editable = false;
            }
            field("ACC Requested Delivery Date"; Rec."ACC Requested Delivery Date")
            {
                ApplicationArea = All;
                Caption = 'Delivery Date';
            }
            field("ACC Customer No"; Rec."ACC Customer No")
            {
                ApplicationArea = All;
                Caption = 'Customer/Vendor No';
            }
            field("ACC Customer Name"; Rec."ACC Customer Name")
            {
                ApplicationArea = All;
                Caption = 'Customer/Vendor Name';
            }
            field("ACC Delivery Address"; Rec."ACC Delivery Address")
            {
                ApplicationArea = All;
                Caption = 'Delivery Address';
            }
            field("ACC Delivery Note"; Rec."ACC Delivery Note")
            {
                ApplicationArea = All;
                Caption = 'Delivery Note';
            }
            /*
            field(ACC_Total_Qty; arrCellValue[1])
            {
                ApplicationArea = All;
                Caption = 'Total Qty';
                DecimalPlaces = 0 : 2;
                // Editable = false;
            }
            field(ACC_Total_Qty_OutStanding; arrCellValue[2])
            {
                ApplicationArea = All;
                Caption = 'Total Qty Out Standing';
                DecimalPlaces = 0 : 2;
                // Editable = false;
            }
            */
            field("ACC Total Quantity"; Rec."ACC Total Quantity") { ApplicationArea = All; }
            field("ACC Total OutStanding"; Rec."ACC Total OutStanding") { ApplicationArea = All; }
            field(ACC_Create_Pick; arrCellBoolean[1])
            {
                ApplicationArea = All;
                Caption = 'Create Pick';
                // Editable = false;
            }
            /*
            field(ACC_Qty_Picked; arrCellValue[3])
            {
                ApplicationArea = All;
                Caption = 'Qty Picked';
                DecimalPlaces = 0 : 2;
                // Editable = false;
            }
            */
            field("ACC Quantity Picked"; Rec."ACC Quantity Picked") { ApplicationArea = All; }
            field("Printed No."; Rec."Printed No.")
            {
                ApplicationArea = All;
                Caption = 'Printed No.';
                Editable = false;
            }
        }

        modify("Posting Date")
        {
            Visible = true;
        }

        modify("Document Status")
        {
            Visible = true;
        }
    }
    actions
    {
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
                action(ACCGetWhseShipment)
                {
                    ApplicationArea = All;
                    Caption = 'Get Warehouse Shipment(s)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        WhseShipment();
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
        FieldReport.Execute(ParametersText); // Sales AS PDF
    end;

    local procedure WhseShipment()
    var
    //WhseShipment: Query "ACC Sales Whse Shipment Qry";
    begin
        recWSH.Reset();
        recWSH.SetRange("ACC Source No.", '');
        if recWSH.FindSet() then
            repeat
                recWSL.Reset();
                recWSL.SetRange("No.", recWSH."No.");
                recWSL.SetFilter("Source No.", '<> %1', '');
                recWSL.SetFilter("Source Document", '%1 | %2 | %3', "Warehouse Activity Source Document"::"Sales Order", "Warehouse Activity Source Document"::"Purchase Return Order", "Warehouse Activity Source Document"::"Outbound Transfer");
                if recWSL.FindFirst() then begin
                    case recWSL."Source Document" of
                        "Warehouse Activity Source Document"::"Sales Order":
                            begin
                                recSH.Reset();
                                recSH.SetRange("No.", recWSL."Source No.");
                                if recSH.FindFirst() then begin
                                    recWSH."ACC Source No." := recWSL."Source No.";
                                    recWSH."ACC Requested Delivery Date" := recSH."Requested Delivery Date";
                                    recWSH."ACC Customer No" := recSH."Sell-to Customer No.";
                                    recWSH."ACC Customer Name" := recSH."Sell-to Customer Name";
                                    recWSH."ACC Delivery Address" := recSH."Ship-to Address" + ' ' + recSH."Ship-to Address 2";
                                    recWSH."ACC Delivery Note" := recSH."BLACC Delivery Note";
                                    recWSH.Modify();
                                end;
                            end;
                        "Warehouse Activity Source Document"::"Purchase Return Order":
                            begin
                                recPH.Reset();
                                recPH.SetRange("No.", recWSL."Source No.");
                                if recPH.FindFirst() then begin
                                    recWSH."ACC Source No." := recWSL."Source No.";
                                    recWSH."ACC Requested Delivery Date" := recPH."Requested Receipt Date";
                                    recWSH."ACC Customer No" := recPH."Buy-from Vendor No.";
                                    recWSH."ACC Customer Name" := recPH."Buy-from Vendor Name";
                                    recWSH."ACC Delivery Address" := recPH."Ship-to Address" + ' ' + recPH."Ship-to Address 2";
                                    recWSH.Modify();
                                end;
                            end;
                        else begin
                            recWSH."ACC Source No." := recWSL."Source No.";
                            recWSH.Modify();
                        end;
                    end;
                end;
            until recWSH.Next() < 1;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        arrCellText[1] := '';
        arrCellText[2] := '';
        arrCellText[3] := '';
        arrCellText[4] := '';
        arrCellText[5] := '';
        arrCellText[6] := '';
        arrCellValue[1] := 0;
        arrCellValue[2] := 0;
        arrCellValue[3] := 0;
        arrCellBoolean[1] := false;

        recWSL.Reset();
        recWSL.SetRange("No.", Rec."No.");
        if recWSL.FindSet() then
            repeat
                if StrPos(arrCellText[1], StrSubstNo('%1', recWSL."Source Document")) = 0 then begin
                    cuACCGP.AddString(arrCellText[1], StrSubstNo('%1', recWSL."Source Document"), ' | ');
                end;
            //arrCellValue[1] += recWSL.Quantity;
            //arrCellValue[2] += recWSL."Qty. Outstanding";
            until recWSL.Next() < 1;

        recWAL.Reset();
        recWAL.SetRange("Whse. Document No.", Rec."No.");
        if recWAL.FindFirst() then
            arrCellBoolean[1] := true;
        /*
        recWE.Reset();
        recWE.SetRange("Whse. Document No.", Rec."No.");
        recWE.SetRange("Zone Code", 'PUTPICK');
        if recWE.FindFirst() then begin
            recWE.CalcSums(Quantity);
            arrCellValue[3] := -recWE.Quantity;
        end;
        */
    end;

    var
        CustomerName: Text;
        arrCellText: array[6] of Text;
        arrCellValue: array[5] of Decimal;
        arrCellBoolean: array[5] of Boolean;
        recWSL: Record "Warehouse Shipment Line";
        recSH: Record "Sales Header";
        recPH: Record "Purchase Header";
        cuACCGP: Codeunit "ACC General Process";
        recWAL: Record "Warehouse Activity Line";
        recRWAL: Record "Registered Whse. Activity Line";
        recWE: Record "Warehouse Entry";
        recWSH: Record "Warehouse Shipment Header";
}
