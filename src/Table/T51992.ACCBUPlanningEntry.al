table 51992 "ACC BU Planning Entry"
{
    Caption = 'APIS BU Planning Adjustment Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Planned No."; Code[20])
        {
            Caption = 'Planned No.';
            Editable = false;
            trigger OnValidate()
            begin
                if "Planned No." <> xRec."Planned No." then begin
                    ManufacturingSetup.Get();
                    NoSeriesMgt.TestManual(ManufacturingSetup."Planned Adjust. Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(30; "From Site"; Code[20])
        {
            Caption = 'From Site';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                if "From Site" <> '' then
                    "To Site" := "From Site";
            end;
        }
        field(40; "From BU"; Code[20])
        {
            Caption = 'From BU';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50; "To Site"; Code[20])
        {
            Caption = 'To Site';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(60; "To BU"; Code[20])
        {
            Caption = 'To BU';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin
                if "From BU" = "To BU" then
                    Error(StrSubstNo('From Bu phải # To BU.'));
            end;
        }
        field(70; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
                if Quantity = 0 then
                    Error(StrSubstNo('Số lượng phải # 0.'));
            end;
        }
        field(80; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(90; "Released"; Boolean)
        {
            Caption = 'Released';
            Editable = false;
        }
        field(100; "Suggest"; Boolean)
        {
            Caption = 'Suggest';
            Editable = false;
        }
        field(110; "Notes"; Text[150])
        {
            Caption = 'Notes';
        }
    }
    keys
    {
        key(PK; "Planned No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
    begin
        if "Planned No." = '' then begin
            ManufacturingSetup.Get();
            ManufacturingSetup.TestField("Planned Adjust. Nos.");
            NoSeriesMgt.InitSeries(ManufacturingSetup."Planned Adjust. Nos.", xRec."Planned No.", 0D, "Planned No.", "No. Series");
        end;
    end;

    procedure ReleaseInventoryEntry()
    var
        BusinessEntry: Record "ACC BU Inventory Entry";
    begin
        CheckMandatory();

        if OnhandOk(Rec."From Site", Rec."From BU", Rec."Item No.", Rec.Quantity) then begin
            BusinessEntry.Init();
            BusinessEntry."Entry Type" := "Item Ledger Entry Type"::"Negative Adjmt.";
            BusinessEntry."Document Type" := "AIG Item Ledger Document Type"::"Planning Shipment";
            BusinessEntry."Order No." := Rec."Planned No.";
            BusinessEntry."Item No." := Rec."Item No.";
            BusinessEntry.Site := Rec."From Site";
            BusinessEntry."Business Unit" := Rec."From BU";
            BusinessEntry.Quantity := -Rec.Quantity;
            BusinessEntry.Insert();
            BusinessEntry.Init();
            BusinessEntry."Entry Type" := "Item Ledger Entry Type"::"Positive Adjmt.";
            BusinessEntry."Document Type" := "AIG Item Ledger Document Type"::"Planning Receipt";
            BusinessEntry."Order No." := Rec."Planned No.";
            BusinessEntry."Item No." := Rec."Item No.";
            BusinessEntry.Site := Rec."To Site";
            BusinessEntry."Business Unit" := Rec."To BU";
            BusinessEntry.Quantity := Rec.Quantity;
            BusinessEntry.Insert();
            Rec.Released := true;
            Rec.Modify();
        end;
    end;

    local procedure OnhandOk(SiteId: Text; BUCode: Text; ItemId: Text; Quantity: Decimal): Boolean
    var
        OnhandEntry: Query "ACC BU Inventory Onhand";
    begin
        OnhandEntry.SetRange(Site, SiteId);
        OnhandEntry.SetRange(BusinessUnit, BUCode);
        OnhandEntry.SetRange(ItemNo, ItemId);
        OnhandEntry.SetFilter(Quantity, '>=%1', Quantity);
        if OnhandEntry.Open() then begin
            while OnhandEntry.Read() do begin
                exit(true);
            end;
            OnhandEntry.Close();
        end;
        exit(false);
    end;

    procedure CheckMandatory()
    begin
        TestField("Item No.");
        TestField("From Site");
        TestField("From BU");
        TestField("To Site");
        TestField("To BU");
        TestField(Quantity);
    end;

    var
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
