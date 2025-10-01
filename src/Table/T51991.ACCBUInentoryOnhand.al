table 51991 "ACC BU Inentory Onhand"
{
    Caption = 'ACC BU Inentory Onhand';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Site No."; Code[20])
        {
            Caption = 'Site No.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(2; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
            CalcFormula = sum("ACC BU Inventory Entry".Quantity where(Site = field("Site No."),
                                                                      "Business Unit" = field("Business Unit"),
                                                                      "Item No." = field("Item No.")));
        }
        field(5; Suggest; Boolean)
        {
            Caption = 'Suggest';
            trigger OnValidate()
            var
            begin
                if Suggest then begin
                    Rec.SuggestPlanningEntry(Rec."Item No.", Rec."Site No.", Rec."Business Unit", Rec.Quantity);
                end else begin
                    Rec.DeletePlanningEntry(Rec."Item No.", Rec."Site No.", Rec."Business Unit");
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Site No.", "Business Unit", "Item No.")
        {
            Clustered = true;
        }
    }

    procedure SuggestPlanningEntry(ItemNo: Text; SiteId: Text; BUCode: Text; Quantity: Decimal)
    var
        PlanningEntry: Record "ACC BU Planning Entry";
    begin
        if ExistEntry(ItemNo, SiteId, BUCode) then
            exit;
        PlanningEntry.Init();
        PlanningEntry."Planned No." := '';
        PlanningEntry."Item No." := ItemNo;
        PlanningEntry."From Site" := SiteId;
        PlanningEntry."To Site" := SiteId;
        PlanningEntry."To BU" := BUCode;
        PlanningEntry.Quantity := -Quantity;
        PlanningEntry.Suggest := true;
        PlanningEntry.Insert(true);
        Rec.Suggest := true;
        Rec.Modify();
    end;

    procedure DeletePlanningEntry(ItemNo: Text; SiteId: Text; BUCode: Text)
    var
        PlanningEntry: Record "ACC BU Planning Entry";
    begin
        PlanningEntry.Reset();
        PlanningEntry.SetRange("Item No.", ItemNo);
        PlanningEntry.SetRange("To Site", SiteId);
        PlanningEntry.SetRange("To BU", BUCode);
        PlanningEntry.SetRange(Suggest, true);
        PlanningEntry.SetRange(Released, false);
        if PlanningEntry.FindFirst() then begin
            PlanningEntry.Delete();
        end else begin
            Rec.Suggest := true;
            Rec.Modify();
        end;
    end;

    local procedure ExistEntry(ItemNo: Text; SiteId: Text; BUCode: Text): Boolean
    var
        PlanningEntry: Record "ACC BU Planning Entry";
    begin
        PlanningEntry.Reset();
        PlanningEntry.SetRange("Item No.", ItemNo);
        PlanningEntry.SetRange("To Site", SiteId);
        PlanningEntry.SetRange("To BU", BUCode);
        PlanningEntry.SetRange(Suggest, true);
        PlanningEntry.SetRange(Released, false);
        if PlanningEntry.FindFirst() then
            exit(true);
        exit(false);
    end;
}
