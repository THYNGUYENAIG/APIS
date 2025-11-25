page 51909 "ACC Inventory By Bin"
{
    ApplicationArea = All;
    Caption = 'APIS Inventory By Bin - P51909';
    PageType = List;
    SourceTable = "ACC Inventory By Bin";
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
                field("Bin Type Code"; Rec."Bin Type Code") { }
                field("Block Movement"; Rec."Block Movement") { }
                field("Item Conditions"; Rec."Item Conditions") { }
                field("Location Conditions"; Rec."Location Conditions") { }
                field(Remark; Rec.Remark) { }
                field(Quantity; Rec.Quantity)
                {
                    DecimalPlaces = 0 : 3;
                }
                field(Unit; Rec.Unit) { }
                field("Packing Group"; Rec."Packing Group") { }
                field("Quantity (Packing Group)"; Rec."Quantity (Packing Group)") { }
                field("Lot No."; Rec."Lot No.") { }
                field("Manufacturing Date"; Rec."Manufacturing Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("Remark Lot"; Rec."Remark Lot") { }
                field("Receipt Date"; Rec."Receipt Date") { }
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
        if (LocationCode_ <> '') AND (ItemNo_ <> '') AND (LotNo_ <> '') then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Location Code", LocationCode_);
            Rec.SetRange("Item No.", ItemNo_);
            Rec.SetRange("Lot No.", LotNo_);
            Rec.FilterGroup(0);
        end;
    end;

    local procedure RefreshData()
    var
        BCHelper: Codeunit "BC Helper";
        InvBin: Query "ACC Inventory By Bin";
        LotInf: Record "Lot No. Information";
        Locations: Text;
    begin
        if not BCHelper.GetUserSetupByCurUserId() then
            exit;
        Locations := BCHelper.GetWhseByCurUserId();
        Rec.Reset();
        Rec.DeleteAll();
        if Locations <> '' then InvBin.SetFilter(LocationCode, Locations);
        InvBin.SetFilter(Quantity, '<>%1', 0);
        if InvBin.Open() then begin
            while InvBin.Read() do begin
                Rec.Init();
                Rec."Location Code" := InvBin.LocationCode;
                Rec."Item No." := InvBin.ItemNo;
                Rec."Item Name" := InvBin.ItemName;
                Rec."Bin Code" := InvBin.BinCode;
                Rec."Bin Type Code" := InvBin.BinTypeCode;
                Rec."Block Movement" := InvBin.BlockMovement;
                if InvBin.Blocked then begin
                    if InvBin.ItemConditions <> '' then
                        Rec."Item Conditions" := InvBin.ItemConditions
                    else
                        Rec."Item Conditions" := InvBin.LotItemConditions;
                    if InvBin.LocationConditions <> '' then
                        Rec."Location Conditions" := InvBin.LocationConditions
                    else
                        Rec."Location Conditions" := InvBin.LotLocationConditions;
                end else begin
                    Rec."Item Conditions" := InvBin.ItemConditions;
                    Rec."Location Conditions" := InvBin.LocationConditions;
                end;
                Rec.Remark := InvBin.Remark;
                Rec.Unit := InvBin.Unit;
                Rec.Quantity := InvBin.Quantity;
                Rec."Packing Group" := InvBin.PackingGroup;
                if InvBin.GrossWeight <> 0 then begin
                    Rec."Quantity (Packing Group)" := InvBin.Quantity / InvBin.GrossWeight;
                end else begin
                    Rec."Quantity (Packing Group)" := InvBin.Quantity;
                end;
                Rec."Lot No." := InvBin.LotNo;
                if InvBin.ManufacturingDate <> 0D then begin
                    Rec."Manufacturing Date" := InvBin.ManufacturingDate;
                end else begin
                    LotInf.SetAutoCalcFields("BLACC Expiration Date");
                    if LotInf.Get(InvBin.ItemNo, '', InvBin.LotNo) then begin
                        LotInf.CalcShelfLife();
                        LotInf.CalcManufacturingDate();
                        Rec."Manufacturing Date" := LotInf."BLACC Manufacturing Date";
                    end;
                end;
                Rec."Remark Lot" := InvBin.RemarkLot;
                Rec."Receipt Date" := InvBin.ReceiptDate;
                Rec."Expiration Date" := InvBin.ExpirationDate;
                Rec.Blocked := InvBin.Blocked;
                Rec.Insert();
            end;
            InvBin.Close();
        end;
    end;

    procedure SetOnhandFilter(LocationCode: Code[10]; ItemNo: Code[20]; LotNo: Code[30])
    var
    begin
        LocationCode_ := LocationCode;
        ItemNo_ := ItemNo;
        LotNo_ := LotNo;
    end;

    var
        LocationCode_: Code[10];
        ItemNo_: Code[20];
        LotNo_: Code[30];
}
