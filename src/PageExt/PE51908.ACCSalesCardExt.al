pageextension 51908 "ACC Sales Card Ext" extends "Sales Order"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                CustTable: Record Customer;
            begin
                CustTable.Reset();
                CustTable.SetRange("BLACC Sales Pool", '3');
                CustTable.SetRange(Blocked, "Customer Blocked"::" ");
                if Page.RunModal(Page::"Customer List", CustTable) = Action::LookupOK then begin
                    Text := CustTable."No.";
                    exit(true);
                end;
            end;

            trigger OnAfterValidate()
            var
                CustTable: Record Customer;
            begin
                if CustTable.Get(Rec."Sell-to Customer No.") then begin
                    if CustTable."BLACC Sales Pool" <> '3' then
                        Error(StrSubstNo('This customer cannot create a manual sale order.'));
                end;
            end;
        }
        addafter(Status)
        {
            field("Sales Type"; Rec."Sales Type")
            {
                ApplicationArea = All;
            }
            field("Unset Packing"; Rec."Unset Packing")
            {
                ApplicationArea = All;
            }
            field("ACC Reason Code"; Rec."ACC Reason Code")
            {
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                var
                    ReasonCode: Record "ACC Sales Reason";
                begin
                    ReasonCode.Reset();
                    ReasonCode.SetFilter(Type, '1|2|3');
                    if Page.RunModal(Page::"ACC Sales Reason", ReasonCode) = Action::LookupOK then begin
                        Text := ReasonCode.Code;
                        exit(true);
                    end;
                end;
            }
            field("ACC Reason Comment"; Rec."ACC Reason Comment")
            {
                ApplicationArea = All;
            }
        }
        addafter(SalesDocCheckFactbox)
        {
            part(ACCICF_Factbox; "ACC Item Cert FactBox")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "No." = field("No.");
            }
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
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addafter("Create &Warehouse Shipment")
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
                //if SalesTime.SalesTimeSubmit(Rec."Shortcut Dimension 1 Code", Rec."Requested Delivery Date", Rec."ACC Reason Code") then
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

    trigger OnDeleteRecord(): Boolean
    var
        CompanyId: Text;
    begin
        CompanyId := CompanyName;
        if CompanyId <> 'AIG' then begin
            if Rec."ACC Reason Code" = '' then begin
                Message('Reason code has not been selected yet.');
                exit(false);
            end else
                exit(true);
        end;
        /*
        if not DeleteWithCommentDialog() then begin
            Error('Deletion cancelled by user.');
            exit(false);
        end;
        exit(true);
        */
    end;

    local procedure DeleteWithCommentDialog(): Boolean
    var
        SalesHeader: Record "Sales Header";
        DeletionDialog: Page "ACC Sales Reason Card";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        // Set up the dialog
        DeletionDialog.SetSalesOrder(Rec."No.");
        // Run the dialog
        if DeletionDialog.RunModal() <> ACTION::OK then
            exit(false);
        exit(true);
    end;
}
