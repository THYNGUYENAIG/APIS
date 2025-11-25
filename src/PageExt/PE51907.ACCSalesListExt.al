pageextension 51907 "ACC Sales List Ext" extends "Sales Order List"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(SalespersonName; SalespersonName)
            {
                ApplicationArea = All;
                Caption = 'Salesperson Name';
            }
            field("ACC Reason Code"; Rec."ACC Reason Code")
            {
                ApplicationArea = All;
            }
            field(ReasonDescription; ReasonDescription)
            {
                ApplicationArea = All;
                Caption = 'Description';
            }
            field("ACC Reason Comment"; Rec."ACC Reason Comment")
            {
                ApplicationArea = All;
            }
        }
        addafter("BLACC Statistics Group")
        {
            field(ApprovedBy; ApprovedBy)
            {
                ApplicationArea = All;
                Caption = 'Approved By';
            }
            field("Sales Type"; Rec."Sales Type")
            {
                ApplicationArea = All;
            }
            field("Created WS Status"; WSStatus)
            {
                ApplicationArea = All;
            }
            field("Workflow State"; WorkflowState)
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {

            field(ACC_WS_No; arrCellText[1])
            {
                ApplicationArea = All;
                Caption = 'WS No';
            }
            field(ACC_PSS_No; arrCellText[2])
            {
                ApplicationArea = All;
                Caption = 'PSS No';
            }
            field(ACC_PSI_No; arrCellText[3])
            {
                ApplicationArea = All;
                Caption = 'PSI No';
            }

            //field("WS No."; Rec."WS No.") { ApplicationArea = All; }
            //field("PSS No."; Rec."PSS No.") { ApplicationArea = All; }
            //field("PSI No."; Rec."PSI No.") { ApplicationArea = All; }
        }
        addafter("Amount Including VAT")
        {

            field(ACC_Total_Qty; arrCellValue[1])
            {
                ApplicationArea = All;
                Caption = 'Total Quantity';
            }
            //field("Total Quantity"; Rec."Total Quantity") { ApplicationArea = All; }
        }
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Sales Header"),
                              "No." = field("No.");
            }
        }
    }
    actions
    {
        addbefore("Create &Warehouse Shipment")
        {
            action(ACCSalesReview)
            {
                ApplicationArea = All;
                Caption = 'Review';
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    SalesReview: Page "ACC Sales Review";
                    Field: Record "Sales Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    Clear(SalesReview);
                    SalesReview.TestMerge(SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
                    SalesReview.Run();
                end;
            }
            action(ACCWorkflowApproval)
            {
                ApplicationArea = All;
                Caption = 'Workflow Approval';
                Image = Workflow;
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    WorkflowApproval: Page "ACC Approval Entries";
                begin
                    WorkflowApproval.SetRecordFilters(Database::"Sales Header", "Approval Document Type"::Order, Rec."No.");
                    WorkflowApproval.Run();
                end;
            }
        }

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                SalesTime: Codeunit "ACC Sales Worktime";
                ItemNo: Code[20];
                SizeQuantity: Decimal;
            begin
                //if SalesTime.SalesTimeInday(Rec."Requested Delivery Date", Rec."ACC Reason Code") then
                //    Error(StrSubstNo('Hóa đơn phát sinh trong ngày. Anh / chị chọn Reason Code để qua.'));
                //if SalesTime.SalesTimeSubmit(Rec."No.", Rec."Requested Delivery Date", Rec."ACC Reason Code") then
                //    Error(StrSubstNo('Hóa đơn phát sinh sau giờ quy định. Anh / chị chọn Reason Code để qua.'));
                //if ValidatePackingSize(ItemNo, SizeQuantity) then
                //    Error(StrSubstNo('Mã hàng %1 packing size không hợp lệ %2. Anh / chị điều chỉnh lại số lượng hoặc chọn Unset Packing.', ItemNo, SizeQuantity));
            end;
        }

    }

    local procedure ValidatePackingSize(var ItemNo: Code[20]; var SizeQty: Decimal): Boolean
    var
        SalesLine: Record "Sales Line";
        Number01: Decimal;
        Number02: Decimal;
    begin
        if Rec."Unset Packing" then
            exit(false);
        if Rec."Sales Type" = "ACC Sales Type"::Sample then
            exit(false);
        if Rec."BLACC Sales Pool Code" = '3' then
            exit(false);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, "Sales Line Type"::Item);
        SalesLine.SetAutoCalcFields("ACC Packing Size");
        if SalesLine.FindSet() then begin
            repeat
                if SalesLine."ACC Packing Size" > 0 then begin
                    Number01 := SalesLine.Quantity / SalesLine."ACC Packing Size";
                    Number02 := Round(SalesLine.Quantity / SalesLine."ACC Packing Size", 1);
                    if (Number01 - Number02) <> 0 then begin
                        SizeQty := Number01;
                        ItemNo := SalesLine."No.";
                        exit(true);
                    end;
                end;
            until SalesLine.Next() = 0;
        end;
        exit(false);
    end;

    local procedure InvalidLocation(): Boolean
    var
        SalesLine: Record "Sales Line";
        Location: Record Location;
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet() then begin
            repeat
                if not Location.Get(SalesLine."Location Code") then
                    exit(true);
            until SalesLine.Next() = 0;
        end;
        exit(false);
    end;

    local procedure InvalidTrakingLine(): Boolean
    var
        SalesLine: Record "Sales Line";
        QuantityHandled: Decimal;
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet() then begin
            repeat
                QuantityHandled := QuantityTrackingLine(SalesLine);
                if QuantityHandled = 0 then
                    exit(true);
                if QuantityHandled < SalesLine.Quantity then
                    exit(true);
            until SalesLine.Next() = 0;
        end;
        exit(false);
    end;

    local procedure QuantityTrackingLine(SalesLine: Record "Sales Line"): Decimal
    var
        RecLTrackingSpecification: Record "Tracking Specification" temporary;
        QuantityBase: Decimal;
        QuantityHandled: Decimal;
    begin
        Clear(RecLTrackingSpecification);
        CalTrackingFromSalesLine(RecLTrackingSpecification, SalesLine);
        RecLTrackingSpecification.Reset();
        if RecLTrackingSpecification.FindSet() then begin
            repeat
                QuantityBase += RecLTrackingSpecification."Quantity (Base)";
                QuantityHandled += RecLTrackingSpecification."Qty. to Handle (Base)";
            until RecLTrackingSpecification.Next() = 0;
        end;
        exit(QuantityHandled);
    end;

    local procedure CalTrackingFromSalesLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pSalesLine: Record "Sales Line")
    var
        RecLItem: Record Item;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ItemTrckingLines: Page "Item Tracking Lines";
    begin
        if pSalesLine.Type <> pSalesLine.Type::Item then
            exit;
        if pSalesLine."No." = '' then
            exit;

        RecLItem.SetLoadFields("Item Tracking Code");
        RecLItem.Get(pSalesLine."No.");
        if RecLItem."Item Tracking Code" = '' then
            exit;

        Clear(SalesLineReserve);
        SalesLineReserve.InitFromSalesLine(pTrackingSpecification, pSalesLine);
        ItemTrckingLines.SetSourceSpec(pTrackingSpecification, pSalesLine."Shipment Date");
        ItemTrckingLines.GetTrackingSpec(pTrackingSpecification);
    end;

    trigger OnAfterGetRecord()
    var
        ReasonTable: Record "ACC Sales Reason";
        SalesLine: Record "Sales Line";
        SalesQtty: Record "Sales Line";
        ApprovalEntry: Record "Approval Entry";
        Salesperson: Record "Salesperson/Purchaser";
        StatisticsGroup: Record "BLACC Statistics group";
        OverDueBalance: Decimal;
    begin
        ReasonDescription := '';
        if Rec."ACC Reason Code" <> '' then begin
            if ReasonTable.Get(Rec."ACC Reason Code") then
                ReasonDescription := ReasonTable.Description;
        end;
        WorkflowState := '';
        OverDueBalance := Rec.CalcOverdueBalance();
        if Rec."BLACC Not Pass Check MinPrice" then
            WorkflowState := 'Minprice';
        if OverDueBalance > 0 then
            WorkflowState := 'Overdue';
        if Rec."BLACC Not Pass Check MinPrice" AND (OverDueBalance > 0) then
            WorkflowState := 'Minprice & Overdue';

        if Salesperson.Get(Rec."Salesperson Code") then
            SalespersonName := Salesperson.Name;
        if Rec.Status = "Sales Document Status"::"Pending Approval" then begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Table ID", Database::"Sales Header");
            ApprovalEntry.SetRange("Document Type", "Approval Document Type"::Order);
            ApprovalEntry.SetRange("Document No.", Rec."No.");
            ApprovalEntry.SetRange(Status, "Approval Status"::Open);
            if ApprovalEntry.FindFirst() then begin
                if ApprovalEntry."Sequence No." = 1 then begin
                    if StatisticsGroup.Get(Rec."BLACC Statistics Group") then
                        ApprovedBy := StatisticsGroup."BLACC Description";
                end;
                if ApprovalEntry."Sequence No." = 2 then begin
                    ApprovedBy := 'CSR';
                end;
            end;
        end else
            ApprovedBy := '';
        if Rec.Status = "Sales Document Status"::Released then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange("Document No.", Rec."No.");
            SalesLine.SetRange(Type, "Sales Line Type"::Item);
            SalesLine.SetFilter("Warehouse Shipment No", '%1', '');
            if SalesLine.FindFirst() then begin
                SalesQtty.Reset();
                SalesQtty.SetRange("Document Type", Rec."Document Type");
                SalesQtty.SetRange("Document No.", Rec."No.");
                SalesQtty.SetRange(Type, "Sales Line Type"::Item);
                SalesQtty.CalcSums("Outstanding Quantity", Quantity, "Quantity Shipped", "Quantity Invoiced");
                if SalesQtty."Outstanding Quantity" = 0 then begin
                    WSStatus := 'Completed';
                end else begin
                    if SalesQtty."Outstanding Quantity" < SalesQtty.Quantity then begin
                        WSStatus := 'Partially Invoiced';
                    end else
                        WSStatus := 'Partially';
                end;
            end else begin
                if InvalidTrakingLine() then begin
                    WSStatus := 'Lot Cleared';
                end else
                    WSStatus := 'Completed';
            end;
        end else
            WSStatus := '';

        arrCellText[1] := '';
        arrCellText[2] := '';
        arrCellText[3] := '';
        arrCellValue[1] := 0;

        recWSL.Reset();
        recWSL.SetRange("Source Document", "Warehouse Activity Source Document"::"Sales Order");
        recWSL.SetRange("Source No.", Rec."No.");
        if recWSL.FindSet() then
            repeat
                if StrPos(arrCellText[1], StrSubstNo('%1', recWSL."No.")) = 0 then begin
                    cuACCGP.AddString(arrCellText[1], recWSL."No.", ' | ');
                end;
            until recWSL.Next() < 1;

        recSSL.Reset();
        recSSL.SetRange("Order No.", Rec."No.");
        if recSSL.FindSet() then
            repeat
                if StrPos(arrCellText[2], StrSubstNo('%1', recSSL."Document No.")) = 0 then begin
                    cuACCGP.AddString(arrCellText[2], recSSL."Document No.", ' | ');
                end;
            until recSSL.Next() < 1;

        recSIH.Reset();
        recSIH.SetRange("Order No.", Rec."No.");
        if recSIH.FindSet() then
            repeat
                if StrPos(arrCellText[3], StrSubstNo('%1', recSIH."No.")) = 0 then begin
                    cuACCGP.AddString(arrCellText[3], recSIH."No.", ' | ');
                end;
            until recSIH.Next() < 1;

        recSL.Reset();
        recSL.SetRange("Document No.", Rec."No.");
        if recSL.FindFirst() then begin
            recSL.CalcSums(recSL.Quantity);
            arrCellValue[1] := recSL.Quantity;
        end;

    end;

    var
        SalespersonName: Text;
        ApprovedBy: Text;
        WSStatus: Text;
        WorkflowState: Text;

        arrCellText: array[5] of Text;
        arrCellValue: array[5] of Decimal;
        recWSL: Record "Warehouse Shipment Line";
        recSSL: Record "Sales Shipment Line";
        recSIH: Record "Sales Invoice Header";
        cuACCGP: Codeunit "ACC General Process";
        recSL: Record "Sales Line";
        ReasonDescription: Text;
}
