pageextension 51031 "ACC Sales Lines" extends "Sales Lines"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Delivery Address"; Rec."ACC Delivery Address") { ApplicationArea = All; }
            field("Delivery Note"; Rec."ACC Delivery Note") { ApplicationArea = All; }
            field("Salesperson Name"; SalespersonName) { ApplicationArea = All; }
            field("Approved By"; ApprovedBy) { ApplicationArea = All; }
            field("Workflow State"; WorkflowState) { ApplicationArea = All; }
            field("ACC External Document No."; Rec."ACC External Document No.") { ApplicationArea = All; }
            field("ACC Agreement StartDate"; Rec."ACC Agreement StartDate") { ApplicationArea = All; }
            field("ACC Agreement EndDate"; Rec."ACC Agreement EndDate") { ApplicationArea = All; }
            field("ACC Contract Return Date"; Rec."ACC Contract Return Date") { ApplicationArea = All; }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesOrder: Record "Sales Header";
        Salesperson: Record "Salesperson/Purchaser";
        ApprovalEntry: Record "Approval Entry";
        StatisticsGroup: Record "BLACC Statistics group";
        OverDueBalance: Decimal;
    begin
        WorkflowState := '';
        ApprovedBy := '';
        SalesOrder.Reset();
        SalesOrder.SecurityFiltering(SecurityFilter::Ignored);
        SalesOrder.SetAutoCalcFields("BLACC Statistics Group", "BLACC Not Pass Check MinPrice");
        if SalesOrder.Get(Rec."Document Type", Rec."Document No.") then begin
            if Salesperson.Get(SalesOrder."Salesperson Code") then
                SalespersonName := Salesperson.Name;

            if SalesOrder."Document Type" = "Sales Document Type"::Order then begin
                OverDueBalance := SalesOrder.CalcOverdueBalance();
                if SalesOrder."BLACC Not Pass Check MinPrice" then
                    WorkflowState := 'Minprice';
                if OverDueBalance > 0 then
                    WorkflowState := 'Overdue';
                if SalesOrder."BLACC Not Pass Check MinPrice" AND (OverDueBalance > 0) then
                    WorkflowState := 'Minprice & Overdue';

                if SalesOrder.Status = "Sales Document Status"::"Pending Approval" then begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", Database::"Sales Header");
                    ApprovalEntry.SetRange("Document Type", "Approval Document Type"::Order);
                    ApprovalEntry.SetRange("Document No.", SalesOrder."No.");
                    ApprovalEntry.SetRange(Status, "Approval Status"::Open);
                    if ApprovalEntry.FindFirst() then begin
                        if ApprovalEntry."Sequence No." = 1 then begin
                            if StatisticsGroup.Get(SalesOrder."BLACC Statistics Group") then
                                ApprovedBy := StatisticsGroup."BLACC Description";
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            ApprovedBy := 'CSR';
                        end;
                    end;
                end;
            end;
        end;
    end;

    var
        SalespersonName: Text;
        ApprovedBy: Text;
        WorkflowState: Text;
}
