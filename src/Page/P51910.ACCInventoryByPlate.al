page 51910 "ACC Inventory By Plate"
{
    ApplicationArea = All;
    Caption = 'ACC Inventory By Plate - P51910';
    PageType = List;
    SourceTable = "ACC Inventory By Plate";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Bin Code"; Rec."Bin Code") { }
                field("License Plate No."; Rec."License Plate No.") { }
                field("Block Movement"; Rec."Block Movement") { }
                field("Item Conditions"; Rec."Item Conditions") { }
                field("Location Conditions"; Rec."Location Conditions") { }
                field(Remark; Rec.Remark) { }
                field(Quantity; Rec.Quantity) { DecimalPlaces = 0 : 3; }
                field(Unit; Rec.Unit) { }
                field("Lot No."; Rec."Lot No.") { }
                field("Manufacturing Date"; Rec."Manufacturing Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field(Blocked; Rec.Blocked) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RefreshInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                Scope = Repeater;
                trigger OnAction()
                begin
                    RefreshData();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        RefreshData();
    end;

    local procedure RefreshData()
    var
        BCHelper: Codeunit "BC Helper";
        InvPlate: Query "ACC Inventory By Plate";
        LotInf: Record "Lot No. Information";
    begin
        Rec.Reset();
        Rec.DeleteAll();
        InvPlate.SetFilter(LocationCode, BCHelper.GetWhseByCurUserId());
        InvPlate.SetFilter(Quantity, '<>%1', 0);
        if InvPlate.Open() then begin
            while InvPlate.Read() do begin
                Rec.Init();
                Rec."Location Code" := InvPlate.LocationCode;
                Rec."Item No." := InvPlate.ItemNo;
                Rec."Item Name" := InvPlate.ItemName;
                Rec."Bin Code" := InvPlate.BinCode;
                Rec."License Plate No." := InvPlate.LicensePlateNo;
                Rec."Block Movement" := InvPlate.BlockMovement;
                Rec."Item Conditions" := InvPlate.ItemConditions;
                Rec."Location Conditions" := InvPlate.LocationConditions;
                Rec.Remark := InvPlate.Remark;
                Rec.Unit := InvPlate.UnitCode;
                Rec.Quantity := InvPlate.Quantity;
                Rec."Lot No." := InvPlate.LotNo;
                if InvPlate.ManufacturingDate <> 0D then begin
                    Rec."Manufacturing Date" := InvPlate.ManufacturingDate;
                end else begin
                    LotInf.SetAutoCalcFields("BLACC Expiration Date");
                    if LotInf.Get(InvPlate.ItemNo, '', InvPlate.LotNo) then begin
                        LotInf.CalcShelfLife();
                        LotInf.CalcManufacturingDate();
                        Rec."Manufacturing Date" := LotInf."BLACC Manufacturing Date";
                    end;
                end;
                Rec."Expiration Date" := InvPlate.ExpirationDate;
                Rec.Blocked := InvPlate.Blocked;
                Rec.Insert();
            end;
            InvPlate.Close();
        end;
    end;
}
