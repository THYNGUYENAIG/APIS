codeunit 51018 "ACC MP Flag Policy"
{
    procedure PolicyCurrent(SiteNo: Code[20]; ItemNo: Code[20]; Period: Integer): Boolean
    var
        OnQuantity: Decimal;
        FCQuantity: Decimal;
    begin
        OnQuantity := MPPOOnhandCurrent(SiteNo, ItemNo, Period);
        FCQuantity := MPPOSalesCurrent(SiteNo, ItemNo, Period);
        if OnQuantity >= FCQuantity then
            exit(false);
        exit(true);
    end;

    procedure PolicyNextMonth(SiteNo: Code[20]; ItemNo: Code[20]; CurPeriod: Integer; NextPeriod: Integer): Boolean
    var
        OnCurQuantity: Decimal;
        FCCurQuantity: Decimal;
        OnNextQuantity: Decimal;
        FCNextQuantity: Decimal;
    begin
        OnCurQuantity := MPPOOnhandCurrent(SiteNo, ItemNo, CurPeriod);
        FCCurQuantity := MPPOSalesCurrent(SiteNo, ItemNo, CurPeriod);
        OnNextQuantity := MPPOOnhandNextMonth(SiteNo, ItemNo, NextPeriod);
        FCNextQuantity := MPPOSalesNextMonth(SiteNo, ItemNo, NextPeriod);
        if ((OnCurQuantity - FCCurQuantity) + OnNextQuantity) >= FCNextQuantity then
            exit(false);
        exit(true);
    end;

    local procedure MPPOOnhandCurrent(SiteNo: Code[20]; ItemNo: Code[20]; Period: Integer): Decimal
    var
        ItemLedgerRec: Record "ACC MP Item Ledger Available";
        ItemLedgerQry: Query "ACC MP Item Ledger Entry";
        PurchOrderQry: Query "ACC MP Purchase Order";
    begin
        ItemLedgerRec.Reset();
        ItemLedgerRec.DeleteAll();
        ItemLedgerRec.ID := 0;
        ItemLedgerQry.SetRange(ItemNo, ItemNo);
        if ItemLedgerQry.Open() then begin
            while ItemLedgerQry.Read() do begin
                ItemLedgerRec.Init();
                ItemLedgerRec.ID += 1;
                ItemLedgerRec."Item No." := ItemLedgerQry.ItemNo;
                ItemLedgerRec."Location Code" := ItemLedgerQry.LocationCode;
                if ItemLedgerQry.LocationCode = 'INSTRANSIT' then begin
                    ItemLedgerRec."Site No." := CopyStr(ItemLedgerQry.TransferToCode, 1, 2);
                end else
                    ItemLedgerRec."Site No." := CopyStr(ItemLedgerQry.LocationCode, 1, 2);
                ItemLedgerRec.Quantity := ItemLedgerQry.RemainingQuantity;
                Evaluate(ItemLedgerRec.Period, Format(TODAY, 0, '<Year4><Month,2>'));
                ItemLedgerRec.Insert();
            end;
            ItemLedgerQry.Close();
        end;
        PurchOrderQry.SetRange(ItemNo, ItemNo);
        if PurchOrderQry.Open() then begin
            while PurchOrderQry.Read() do begin
                ItemLedgerRec.Init();
                ItemLedgerRec.ID += 1;
                ItemLedgerRec."Item No." := PurchOrderQry.ItemNo;
                ItemLedgerRec."Location Code" := PurchOrderQry.LocationCode;
                ItemLedgerRec."Site No." := CopyStr(PurchOrderQry.LocationCode, 1, 2);
                ItemLedgerRec.Quantity := PurchOrderQry.Quantity;
                ItemLedgerRec.Period := PurchOrderQry.YearDate * 100 + PurchOrderQry.MonthDate;
                if Period = ItemLedgerRec.Period then
                    ItemLedgerRec.Insert();
            end;
            PurchOrderQry.Close();
        end;
        if SiteNo <> '' then begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange("Site No.", SiteNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end else begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end;
        exit(0);
    end;

    local procedure MPPOOnhandNextMonth(SiteNo: Code[20]; ItemNo: Code[20]; Period: Integer): Decimal
    var
        ItemLedgerRec: Record "ACC MP Item Ledger Available";
        ItemLedgerQry: Query "ACC MP Item Ledger Entry";
        PurchOrderQry: Query "ACC MP Purchase Order";
    begin
        ItemLedgerRec.Reset();
        ItemLedgerRec.DeleteAll();
        ItemLedgerRec.ID := 0;
        PurchOrderQry.SetRange(ItemNo, ItemNo);
        if PurchOrderQry.Open() then begin
            while PurchOrderQry.Read() do begin
                ItemLedgerRec.Init();
                ItemLedgerRec.ID += 1;
                ItemLedgerRec."Item No." := PurchOrderQry.ItemNo;
                ItemLedgerRec."Location Code" := PurchOrderQry.LocationCode;
                ItemLedgerRec."Site No." := CopyStr(PurchOrderQry.LocationCode, 1, 2);
                ItemLedgerRec.Quantity := PurchOrderQry.Quantity;
                ItemLedgerRec.Period := PurchOrderQry.YearDate * 100 + PurchOrderQry.MonthDate;
                if Period = ItemLedgerRec.Period then
                    ItemLedgerRec.Insert();
            end;
            PurchOrderQry.Close();
        end;
        if SiteNo <> '' then begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange("Site No.", SiteNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end else begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end;
        exit(0);
    end;

    local procedure MPPOSalesCurrent(SiteNo: Code[20]; ItemNo: Code[20]; Period: Integer): Decimal
    var
        ItemLedgerRec: Record "ACC MP Item Ledger Available";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DemandEntry: Record "BLACC Forecast Entry";
        ForecastEntry: Record "Production Forecast Entry";
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today);
        ToDate := CalcDate('CM', Today);
        ItemLedgerRec.Reset();
        ItemLedgerRec.DeleteAll();
        ItemLedgerRec.ID := 0;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", "Sales Document Type"::Order);
        SalesLine.SetRange(Type, "Sales Line Type"::Item);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetFilter("Outstanding Quantity", '>0');
        if SalesLine.FindSet() then begin
            repeat
                ItemLedgerRec.Init();
                ItemLedgerRec.ID += 1;
                ItemLedgerRec."Item No." := SalesLine."No.";
                ItemLedgerRec."Location Code" := SalesLine."Location Code";
                ItemLedgerRec."Site No." := CopyStr(SalesLine."Location Code", 1, 2);
                ItemLedgerRec.Quantity := SalesLine."Outstanding Quantity";
                if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                    if SalesHeader."Requested Delivery Date" < FromDate then begin
                        Evaluate(ItemLedgerRec.Period, Format(FromDate, 0, '<Year4><Month,2>'));
                        ItemLedgerRec.Insert();
                    end;
                end;
            until SalesLine.Next() = 0;
        end;

        ForecastEntry.Reset();
        ForecastEntry.SetRange("Forecast Date", FromDate, ToDate);
        ForecastEntry.SetRange("BLACC Active", true);
        ForecastEntry.SetRange("Item No.", ItemNo);
        ForecastEntry.SetRange("BLACC No SA", true);
        if ForecastEntry.FindSet() then begin
            ItemLedgerRec.Init();
            ItemLedgerRec.ID += 1;
            ItemLedgerRec."Item No." := ForecastEntry."Item No.";
            ItemLedgerRec."Location Code" := ForecastEntry."Location Code";
            ItemLedgerRec."Site No." := CopyStr(ForecastEntry."Location Code", 1, 2);
            ItemLedgerRec.Quantity := ForecastEntry."Forecast Quantity";
            Evaluate(ItemLedgerRec.Period, Format(ForecastEntry."Forecast Date", 0, '<Year4><Month,2>'));
            ItemLedgerRec.Insert();
        end;

        ForecastEntry.Reset();
        ForecastEntry.SetRange("Forecast Date", FromDate, ToDate);
        ForecastEntry.SetRange("BLACC Active", true);
        ForecastEntry.SetRange("Item No.", ItemNo);
        ForecastEntry.SetRange("BLACC No SA", false);
        if ForecastEntry.FindSet() then begin
            ItemLedgerRec.Init();
            ItemLedgerRec.ID += 1;
            ItemLedgerRec."Item No." := ForecastEntry."Item No.";
            ItemLedgerRec."Location Code" := ForecastEntry."Location Code";
            ItemLedgerRec."Site No." := CopyStr(ForecastEntry."Location Code", 1, 2);
            if DemandEntry.Get(ForecastEntry."BLACC Parent Entry") then begin
                if (DemandEntry."BLACC Agreement EndDate" >= ToDate) AND (DemandEntry.GetRemainingQty() > 0) then begin
                    ItemLedgerRec.Quantity := ForecastEntry."Forecast Quantity";
                    Evaluate(ItemLedgerRec.Period, Format(ForecastEntry."Forecast Date", 0, '<Year4><Month,2>'));
                    ItemLedgerRec.Insert();
                end;
            end;
        end;

        if SiteNo <> '' then begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange("Site No.", SiteNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end else begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end;
        exit(0);
    end;

    local procedure MPPOSalesNextMonth(SiteNo: Code[20]; ItemNo: Code[20]; Period: Integer): Decimal
    var
        ItemLedgerRec: Record "ACC MP Item Ledger Available";
        DemandEntry: Record "BLACC Forecast Entry";
        ForecastEntry: Record "Production Forecast Entry";
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('CM', Today);
        FromDate := CalcDate('+1D', FromDate);
        ToDate := CalcDate('CM', FromDate);
        ItemLedgerRec.Reset();
        ItemLedgerRec.DeleteAll();
        ItemLedgerRec.ID := 0;

        ForecastEntry.Reset();
        ForecastEntry.SetRange("Forecast Date", FromDate, ToDate);
        ForecastEntry.SetRange("BLACC Active", true);
        ForecastEntry.SetRange("Item No.", ItemNo);
        ForecastEntry.SetRange("BLACC No SA", true);
        if ForecastEntry.FindSet() then begin
            ItemLedgerRec.Init();
            ItemLedgerRec.ID += 1;
            ItemLedgerRec."Item No." := ForecastEntry."Item No.";
            ItemLedgerRec."Location Code" := ForecastEntry."Location Code";
            ItemLedgerRec."Site No." := CopyStr(ForecastEntry."Location Code", 1, 2);
            ItemLedgerRec.Quantity := ForecastEntry."Forecast Quantity";
            Evaluate(ItemLedgerRec.Period, Format(ForecastEntry."Forecast Date", 0, '<Year4><Month,2>'));
            ItemLedgerRec.Insert();
        end;

        ForecastEntry.Reset();
        ForecastEntry.SetRange("Forecast Date", FromDate, ToDate);
        ForecastEntry.SetRange("BLACC Active", true);
        ForecastEntry.SetRange("Item No.", ItemNo);
        ForecastEntry.SetRange("BLACC No SA", false);
        if ForecastEntry.FindSet() then begin
            ItemLedgerRec.Init();
            ItemLedgerRec.ID += 1;
            ItemLedgerRec."Item No." := ForecastEntry."Item No.";
            ItemLedgerRec."Location Code" := ForecastEntry."Location Code";
            ItemLedgerRec."Site No." := CopyStr(ForecastEntry."Location Code", 1, 2);
            if DemandEntry.Get(ForecastEntry."BLACC Parent Entry") then begin
                if (DemandEntry."BLACC Agreement EndDate" >= ToDate) AND (DemandEntry.GetRemainingQty() > 0) then begin
                    ItemLedgerRec.Quantity := ForecastEntry."Forecast Quantity";
                    Evaluate(ItemLedgerRec.Period, Format(ForecastEntry."Forecast Date", 0, '<Year4><Month,2>'));
                    ItemLedgerRec.Insert();
                end;
            end;
        end;

        if SiteNo <> '' then begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange("Site No.", SiteNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end else begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange(Period, Period);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end;
        exit(0);
    end;
}
