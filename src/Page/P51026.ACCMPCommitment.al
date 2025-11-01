page 51026 "ACC MP Commitment"
{
    ApplicationArea = All;
    Caption = 'APIS MP Commitment - P51026';
    PageType = List;
    SourceTable = "ACC MP Commitment";
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
                field("Site No."; Rec."Site No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Status"; CommitmentStatus) { }
                field("Purch No."; Rec."Purch No.") { }
                field("Transport Method"; Rec."Transport Method") { }
                field("Unit No."; Rec."Unit No.") { }
                field(Quantity; Rec.Quantity)
                {
                    DecimalPlaces = 0 : 3;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    DecimalPlaces = 0 : 2;
                }
                field("Amount"; LineAmount)
                {
                    DecimalPlaces = 0 : 2;
                }
                field("Invoice Date"; Rec."Invoice Date") { }
                field("Days In Inventory"; DaysInInventory) { }
                field("Lot No."; Rec."Lot No.") { }
                field("Manufacturing Date"; Rec."Manufacturing Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("Close Date"; CloseDate) { }
                field("Remain 1/3 Shelf Life"; Remain1p3ShelfLife) { }
                field("Remain 1/2 Shelf Life"; Remain1p2ShelfLife) { }
                field("Remain 2/3 Shelf Life"; Remain2p3ShelfLife) { }
                field("Age Month(s)"; AgeMonths)
                {
                    DecimalPlaces = 0 : 2;
                }
                field("Shelf Life Group"; ShelfLifeReport) { }
                field("Expiration Group"; ExpirationGroup) { }
                field("Stock Group"; StockGroup) { }
                field(State; Rec.Status) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCFCACalc)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Calc';
                trigger OnAction()
                var
                begin
                    MPCommitment();
                end;
            }
        }
    }
    local procedure MPCommitment()
    var
        PurchaseHeader: Record "Purchase Header";
        ItemLedgerEnrtry: Record "Item Ledger Entry";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        ItemTable: Record Item;
        LotInformation: Record "Lot No. Information";
        InventoryUnlocked: Query "ACC Inventory Unlocked";
        InventoryLotLocked: Query "ACC Inventory Lotlocked";
        InventoryBinLocked: Query "ACC Inventory Binlocked";
        InvtCommitmentLine: Query "ACC MP Commitment Line Qry";
        //LotTable: Record "Lot No. Information";

        Commitmnet: Record "ACC MP Commitment";
    begin
        CommitmentLine.Reset();
        CommitmentLine.DeleteAll();
        CommitmentLine.ID := 0;
        ItemLedgerEnrtry.Reset();
        ItemLedgerEnrtry.SetRange("Document Type", "Item Ledger Document Type"::"Transfer Shipment");
        ItemLedgerEnrtry.SetRange("Location Code", 'INSTRANSIT');
        ItemLedgerEnrtry.SetFilter("Remaining Quantity", '>0');
        if ItemLedgerEnrtry.FindSet() then
            repeat
                CommitmentLine.Init();
                CommitmentLine.ID += 1;
                CommitmentLine."Item No." := ItemLedgerEnrtry."Item No.";
                CommitmentLine."Lot No." := ItemLedgerEnrtry."Lot No.";
                CommitmentLine."Unit No." := ItemLedgerEnrtry."Unit of Measure Code";
                CommitmentLine.Quantity := ItemLedgerEnrtry."Remaining Quantity";
                CommitmentLine."Expiration Date" := ItemLedgerEnrtry."Expiration Date";
                CommitmentLine.Status := "ACC Status Type"::Transit;
                if ItemTable.Get(ItemLedgerEnrtry."Item No.") then
                    CommitmentLine."Transport Method" := ItemTable."BLACC Transport Method";
                if LotInformation.Get(ItemLedgerEnrtry."Item No.", ItemLedgerEnrtry."Variant Code", ItemLedgerEnrtry."Lot No.") then begin
                    if LotInformation."BLACC Manufacturing Date" <> 0D then begin
                        CommitmentLine."Manufacturing Date" := LotInformation."BLACC Manufacturing Date";
                    end else
                        CommitmentLine."Manufacturing Date" := Today;
                end else
                    CommitmentLine."Manufacturing Date" := Today;

                if TransferShipmentHeader.Get(ItemLedgerEnrtry."Document No.") then begin
                    CommitmentLine."Location No." := TransferShipmentHeader."Transfer-to Code";
                    CommitmentLine."Site No." := CopyStr(TransferShipmentHeader."Transfer-to Code", 1, 2);
                end;
                CommitmentLine.Insert(true);
            until ItemLedgerEnrtry.Next() = 0;

        InventoryUnlocked.SetFilter(ItemNo, '<>%1', '');
        InventoryUnlocked.SetFilter(Quantity, '<>%1', 0);
        if InventoryUnlocked.Open() then begin
            while InventoryUnlocked.Read() do begin
                CommitmentLine.Init();
                CommitmentLine.ID += 1;
                CommitmentLine."Location No." := InventoryUnlocked.LocationCode;
                CommitmentLine."Site No." := CopyStr(InventoryUnlocked.LocationCode, 1, 2);
                CommitmentLine."Item No." := InventoryUnlocked.ItemNo;
                CommitmentLine."Lot No." := InventoryUnlocked.LotNo;
                CommitmentLine."Unit No." := InventoryUnlocked.Unit;
                CommitmentLine.Quantity := InventoryUnlocked.Quantity;
                if InventoryUnlocked.ManufacturingDate <> 0D then begin
                    CommitmentLine."Manufacturing Date" := InventoryUnlocked.ManufacturingDate;
                end else begin
                    CommitmentLine."Manufacturing Date" := Today();
                end;
                CommitmentLine."Expiration Date" := InventoryUnlocked.ExpirationDate;
                CommitmentLine."Transport Method" := InventoryUnlocked.TransportMethod;
                CommitmentLine.Insert(true);
            end;
            InventoryUnlocked.Close();
        end;

        InventoryLotLocked.SetFilter(ItemNo, '<>%1', '');
        InventoryLotLocked.SetFilter(Quantity, '<>%1', 0);
        if InventoryLotLocked.Open() then begin
            while InventoryLotLocked.Read() do begin
                CommitmentLine.Init();
                CommitmentLine.ID += 1;
                CommitmentLine."Location No." := InventoryLotLocked.LocationCode;
                CommitmentLine."Site No." := CopyStr(InventoryLotLocked.LocationCode, 1, 2);
                CommitmentLine."Item No." := InventoryLotLocked.ItemNo;
                CommitmentLine."Lot No." := InventoryLotLocked.LotNo;
                CommitmentLine."Unit No." := InventoryLotLocked.Unit;
                CommitmentLine.Quantity := InventoryLotLocked.Quantity;
                if InventoryLotLocked.ManufacturingDate <> 0D then begin
                    CommitmentLine."Manufacturing Date" := InventoryLotLocked.ManufacturingDate;
                end else begin
                    CommitmentLine."Manufacturing Date" := Today();
                end;
                CommitmentLine."Expiration Date" := InventoryLotLocked.ExpirationDate;
                CommitmentLine."Transport Method" := InventoryLotLocked.TransportMethod;
                CommitmentLine.Status := "ACC Status Type"::Blocked;
                CommitmentLine.Insert(true);
            end;
            InventoryLotLocked.Close();
        end;

        InventoryBinLocked.SetFilter(ItemNo, '<>%1', '');
        InventoryBinLocked.SetFilter(Quantity, '<>%1', 0);
        if InventoryBinLocked.Open() then begin
            while InventoryBinLocked.Read() do begin
                CommitmentLine.Init();
                CommitmentLine.ID += 1;
                CommitmentLine."Location No." := InventoryBinLocked.LocationCode;
                CommitmentLine."Site No." := CopyStr(InventoryBinLocked.LocationCode, 1, 2);
                CommitmentLine."Item No." := InventoryBinLocked.ItemNo;
                CommitmentLine."Lot No." := InventoryBinLocked.LotNo;
                CommitmentLine."Unit No." := InventoryBinLocked.Unit;
                CommitmentLine.Quantity := InventoryBinLocked.Quantity;
                if InventoryBinLocked.ManufacturingDate <> 0D then begin
                    CommitmentLine."Manufacturing Date" := InventoryBinLocked.ManufacturingDate;
                end else begin
                    CommitmentLine."Manufacturing Date" := Today();
                end;
                CommitmentLine."Expiration Date" := InventoryBinLocked.ExpirationDate;
                CommitmentLine."Transport Method" := InventoryBinLocked.TransportMethod;
                CommitmentLine.Status := "ACC Status Type"::Blocked;
                CommitmentLine.Insert(true);
            end;
            InventoryBinLocked.Close();
        end;

        Commitmnet.Reset();
        Commitmnet.DeleteAll();
        if InvtCommitmentLine.Open() then begin
            while InvtCommitmentLine.Read() do begin

                Commitmnet.Init();
                Commitmnet."Site No." := InvtCommitmentLine.SiteNo;
                Commitmnet."Item No." := InvtCommitmentLine.ItemNo;
                Commitmnet."Lot No." := InvtCommitmentLine.LotNo;
                Commitmnet."Unit No." := InvtCommitmentLine.UnitNo;
                Commitmnet.Quantity := InvtCommitmentLine.Quantity;
                Commitmnet."Manufacturing Date" := InvtCommitmentLine.ManufacturingDate;
                Commitmnet."Expiration Date" := InvtCommitmentLine.ExpirationDate;
                Commitmnet.Status := InvtCommitmentLine.Status;
                Commitmnet.Insert();
                if InvtCommitmentLine.TransportMethod = 'SEA' then begin
                    Commitmnet.Reset();
                    Commitmnet.SetAutoCalcFields("Purch No.");
                    if Commitmnet.Get(InvtCommitmentLine.ItemNo, InvtCommitmentLine.SiteNo, InvtCommitmentLine.LotNo, InvtCommitmentLine.Status) then begin
                        if Commitmnet."Purch No." <> '' then begin
                            PurchaseHeader.Reset();
                            PurchaseHeader.SetRange("No.", Commitmnet."Purch No.");
                            if PurchaseHeader.FindFirst() then begin
                                if PurchaseHeader."Transport Method" = 'AIR' then begin
                                    Commitmnet."Transport Method" := PurchaseHeader."Transport Method";
                                    Commitmnet.Modify();
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            InvtCommitmentLine.Close();
        end;
    end;

    trigger OnAfterGetRecord()
    var
        TodayDate: DateTime;
        InvoiceDate: DateTime;
        Duration: Duration;
        DurationStrg: Text[1024];
        DurationList: List of [Text];

        ProductionDate: DateTime;
        ExpirationDate: DateTime;
        ShelfDuration: Duration;
        ShelfDurationStrg: Text[1024];
        ShelfDurationList: List of [Text];
        DaysInExpiration: Integer;
        _2p3ShelfLife: Date;
        _1p3ShelfLife: Date;
        _1p2ShelfLife: Date;
        TextDay: Text;

        ToDate: Date;
        FromDate: Date;
        To2Date: Date;
        To3Date: Date;
    begin
        FromDate := CalcDate('-CM', Today);
        ToDate := CalcDate('CM', Today);
        To2Date := CalcDate('+1M', ToDate);
        To3Date := CalcDate('+2M', ToDate);

        TodayDate := CreateDateTime(Today, 000000T);
        if Rec.Status = "ACC Status Type"::Blocked then begin
            CommitmentStatus := 'Block';
        end else begin
            CommitmentStatus := 'Available';
        end;
        LineAmount := Rec.Quantity * Rec."Unit Price";
        Rec.SetAutoCalcFields("Invoice Date");
        if Rec."Invoice Date" <> 0D then begin
            if Rec."Invoice Date" <> Today then begin
                InvoiceDate := CreateDateTime(Rec."Invoice Date", 130000T);
                Duration := TodayDate - InvoiceDate;
                DurationStrg := Format(Duration);
                DurationList := DurationStrg.Split(' ');
                TextDay := DurationList.Get(1);
                if TextDay <> '' then
                    Evaluate(DaysInInventory, TextDay);
            end else
                DaysInInventory := 0;
        end else begin
            DaysInInventory := 0;
        end;

        if Rec."Expiration Date" <> 0D then begin
            if Rec."Expiration Date" <> Today() then begin
                ExpirationDate := CreateDateTime(Rec."Expiration Date", 230000T);
                ShelfDuration := ExpirationDate - TodayDate;
                ShelfDurationStrg := Format(ShelfDuration);
                ShelfDurationList := ShelfDurationStrg.Split(' ');
                TextDay := ShelfDurationList.Get(1);
                if TextDay <> '' then begin
                    Evaluate(DaysInExpiration, TextDay);
                    AgeMonths := DaysInExpiration / 30;
                end else begin
                    AgeMonths := 0;
                end;
            end else
                AgeMonths := 0;
        end else begin
            AgeMonths := 0;
        end;

        if (Rec."Expiration Date" <> 0D) AND (Rec."Manufacturing Date" <> 0D) then begin
            ExpirationDate := CreateDateTime(Rec."Expiration Date", 230000T);
            ProductionDate := CreateDateTime(Rec."Manufacturing Date", 000000T);
            ShelfDuration := ExpirationDate - ProductionDate;
            ShelfDurationStrg := Format(ShelfDuration);
            ShelfDurationList := ShelfDurationStrg.Split(' ');
            TextDay := ShelfDurationList.Get(1);
            if TextDay <> '' then begin
                Evaluate(DaysInExpiration, TextDay);
                ShelfLife := DaysInExpiration / 30;
            end else begin
                ShelfLife := 0;
            end;
        end else begin
            ShelfLife := 0;
        end;

        ShelfLifePer := 0;
        if ShelfLife <> 0 then
            ShelfLifePer := (AgeMonths / ShelfLife) * 100;

        ShelfLifeReport := '';
        if ShelfLifePer <= 0 then begin
            ShelfLifeReport := 'Expired';
        end else begin
            if (ShelfLifePer > 0) AND (ShelfLifePer <= 33) then begin
                ShelfLifeReport := 'Under 1/3 shelf life';
            end;
            if (ShelfLifePer > 33) AND (ShelfLifePer <= 50) then begin
                ShelfLifeReport := 'Remain 1/3 shelf life';
            end;
            if (ShelfLifePer > 50) AND (ShelfLifePer <= 67) then begin
                ShelfLifeReport := 'Remain 1/2 shelf life';
            end;
            if (ShelfLifePer > 67) then begin
                ShelfLifeReport := 'Remain 2/3 shelf life';
            end;
        end;

        ExpirationGroup := 'Expired';
        if Rec."Expiration Date" <> 0D then begin
            if Rec."Expiration Date" < FromDate then
                ExpirationGroup := 'Expired';
            if (Rec."Expiration Date" >= FromDate) AND (Rec."Expiration Date" <= ToDate) then
                ExpirationGroup := 'This Month';
            if (Rec."Expiration Date" > ToDate) AND (Rec."Expiration Date" <= To2Date) then
                ExpirationGroup := 'Next month';
            if (Rec."Expiration Date" > To2Date) AND (Rec."Expiration Date" <= To3Date) then
                ExpirationGroup := 'The month after next month';
            if Rec."Expiration Date" > To3Date then begin
                if ShelfLifeReport = 'Under 1/3 shelf life' then begin
                    ExpirationGroup := 'Under 1/3 shelf life';
                end else
                    ExpirationGroup := '0';
            end;
        end;

        StockGroup := '';
        if ExpirationGroup = '0' then begin
            if DaysInInventory > 180 then
                StockGroup := 'Very slow moving';
            if (DaysInInventory >= 90) AND (DaysInInventory <= 180) then
                StockGroup := 'Slow moving stock';
            if DaysInInventory < 90 then
                StockGroup := 'Normal stock';
        end;

        _2p3ShelfLife := Rec."Manufacturing Date" + ROUND((Rec."Expiration Date" - Rec."Manufacturing Date") * 1 / 3, 1);
        _1p2ShelfLife := Rec."Manufacturing Date" + ROUND((Rec."Expiration Date" - Rec."Manufacturing Date") * 1 / 2, 1);
        _1p3ShelfLife := Rec."Manufacturing Date" + ROUND((Rec."Expiration Date" - Rec."Manufacturing Date") * 2 / 3, 1);
        if _2p3ShelfLife > Today() then begin
            Remain2p3ShelfLife := _2p3ShelfLife;
        end else begin
            Remain2p3ShelfLife := 0D;
        end;

        if (_2p3ShelfLife <= Today()) AND (_1p3ShelfLife >= Today()) then begin
            Remain1p3ShelfLife := _1p3ShelfLife;
        end else begin
            Remain1p3ShelfLife := 0D;
        end;

        if _1p3ShelfLife < Today() then begin
            CloseDate := Rec."Expiration Date";
        end else begin
            CloseDate := 0D;
        end;

        if _1p2ShelfLife > Today() then begin
            Remain1p2ShelfLife := _1p2ShelfLife;
        end else begin
            Remain1p2ShelfLife := 0D;
        end;

    end;

    var
        CommitmentLine: Record "ACC MP Commitment Line";
        CommitmentStatus: Text;
        LineAmount: Decimal;
        DaysInInventory: Integer;
        CloseDate: Date;
        Remain1p3ShelfLife: Date;
        Remain1p2ShelfLife: Date;
        Remain2p3ShelfLife: Date;
        AgeMonths: Decimal;
        ShelfLife: Decimal;
        ShelfLifePer: Decimal;
        ShelfLifeReport: Text;
        ExpirationGroup: Text;
        StockGroup: Text;
}
