page 51992 "ACC BU Planning Entry"
{
    ApplicationArea = All;
    Caption = 'ACC BU Planning Entry';
    PageType = List;
    SourceTable = "ACC BU Planning Entry";
    UsageCategory = Lists;
    Permissions = tabledata "No. Series Line" = rm;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Planned No."; Rec."Planned No.") { }
                field("Item No."; Rec."Item No.") { Editable = EditableCell; }
                field("From Site"; Rec."From Site") { Editable = EditableCell; }
                field("From BU"; Rec."From BU") { Editable = EditableCell; }
                field("To Site"; Rec."To Site") { Editable = EditableCell; }
                field("To BU"; Rec."To BU") { Editable = EditableCell; }
                field(Quantity; Rec.Quantity) { Editable = EditableCell; }
                field(Notes; Rec.Notes) { }
                field(Released; Rec.Released) { }
                field(Suggest; Rec.Suggest) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCPlanning)
            {
                ApplicationArea = All;
                Image = ReleaseDoc;
                Visible = ReleaseButton;
                Caption = 'Release';
                trigger OnAction()
                var
                    PlanningEntry: Record "ACC BU Planning Entry";
                begin
                    if not Confirm('Do you want to Release select lines?', true) then
                        exit;
                    CurrPage.SetSelectionFilter(PlanningEntry);
                    if PlanningEntry.FindSet() then begin
                        repeat
                            PlanningEntry.ReleaseInventoryEntry();
                        until PlanningEntry.Next() = 0;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        if ReleaseHandled then begin
            Rec.FilterGroup(2);
            Rec.SetRange(Released, false);
            //Rec.SetRange(Suggest, false);
            Rec.FilterGroup(0);
        end;
        if SuggestHandled then begin
            SuggestPlanningEntry();
            Rec.FilterGroup(2);
            Rec.SetRange(Released, false);
            Rec.SetRange(Suggest, true);
            Rec.FilterGroup(0);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        Onhand: Record "ACC BU Inentory Onhand";
    begin
        if Rec.Released then begin
            Error(StrSubstNo('Giao dịch không được xóa nhé.'));
            exit;
        end else begin
            if Rec.Suggest then begin
                Onhand.Reset();
                Onhand.SetRange("Item No.", Rec."Item No.");
                Onhand.SetRange("Site No.", Rec."To Site");
                Onhand.SetRange("Business Unit", Rec."To BU");
                Onhand.SetRange(Suggest, true);
                if Onhand.FindFirst() then begin
                    Onhand.Suggest := false;
                    Onhand.Modify();
                end;
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        if Rec.Released then begin
            EditableCell := false;
        end else
            EditableCell := true;
    end;

    local procedure SuggestPlanningEntry()
    var
        Onhand: Record "ACC BU Inentory Onhand";
    begin
        if not Confirm('Do you want to Suggest Planning Entry from BU Inventory Onhand?', true) then
            exit;
        Onhand.Reset();
        Onhand.SetAutoCalcFields(Quantity);
        if Onhand.FindSet() then
            repeat
                if Onhand.Quantity < 0 then begin
                    Onhand.SuggestPlanningEntry(Onhand."Item No.", Onhand."Site No.", Onhand."Business Unit", Onhand.Quantity);
                end;
            until Onhand.Next() = 0;
    end;

    procedure PageRelease(ReleaseHandled_: Boolean)
    var
    begin
        ReleaseHandled := ReleaseHandled_;
        ReleaseButton := ReleaseHandled_;
    end;

    procedure PageSuggest(SuggestHandled_: Boolean)
    var
    begin
        SuggestHandled := SuggestHandled_;
        ReleaseButton := SuggestHandled_;
    end;

    var
        ReleaseHandled: Boolean;
        SuggestHandled: Boolean;
        ReleaseButton: Boolean;
        EditableCell: Boolean;
}
