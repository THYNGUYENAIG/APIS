page 51017 "ACC MP Combines"
{
    ApplicationArea = All;
    Caption = 'ACC MP Combines - P51017';
    PageType = List;
    SourceTable = "ACC MP Combine Table";
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
                field("Entity ID"; Rec."Entity ID") { }
                field("Dimension Value"; Rec."Dimension Value") { }
                field("Site ID"; Rec."Site ID") { }
                field("Business Unit ID"; Rec."Business Unit ID") { }
                field("SKU ID"; Rec."SKU ID") { }
                field(Period; Rec.Period) { }
                field("Period Date"; Rec."Period Date") { }
                field(Quantity; Rec.Quantity) { }
                field("PO Date Status"; Rec."PO Date Status") { }
                field("Statistic Period Number"; Rec."Statistic Period Number") { }
                field("SA Quantity"; Rec."SA Quantity") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ACCCombine)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Combine';
                trigger OnAction()
                var
                begin
                    RecLine.Reset();
                    RecLine.DeleteAll();
                    RecLine.Init();
                    RecLine.ID := 0;
                    RequisitionWS();
                    PurchaseOpen();
                    SalesInvoice();
                    ItemOnhand();
                    TransferOrder();
                    SalesForecast();
                    CombineMP();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
    end;

    local procedure RequisitionWS()
    var
        //RecLine: Record "ACC MP Combine Line";
        Requisition: Query "ACC Requisition Combine Qry";
        MonPeriod: Integer;
        MonToday: Integer;
        YRPeriod: Integer;

        FromDate: Date;
        ToDate: Date;
        PeriodNumber: Integer;
    begin
        FromDate := CalcDate('-60D', TODAY);
        ToDate := CalcDate('+365D', TODAY);
        Requisition.SetRange(DeliveryDate, FromDate, ToDate);
        if Requisition.Open() then begin
            while Requisition.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'RW';
                RecLine."Site ID" := CopyStr(Requisition.LocationCode, 1, 2);
                RecLine."Location Code" := Requisition.LocationCode;
                RecLine."Business Unit ID" := Requisition.BusinessUnitId;
                RecLine."SKU ID" := Requisition.ItemNo;
                RecLine."Period Date" := Requisition.DeliveryDate;
                RecLine.Period := Format(Requisition.DeliveryDate, 0, '<Year4>-<Month,2>');
                RecLine.Quantity := Requisition.Quantity;
                MonPeriod := Date2DMY(Requisition.DeliveryDate, 2);
                MonToday := Date2DMY(Today, 2);
                YRPeriod := Date2DMY(Requisition.DeliveryDate, 3) - Date2DMY(Today, 3);
                PeriodNumber := (MonPeriod - MonToday) + (YRPeriod * 12);
                RecLine."Statistic Period Number" := PeriodNumber;
                RecLine.Insert(true);
            end;
            Requisition.Close();
        end;
    end;

    local procedure PurchaseOpen()
    var
        //RecLine: Record "ACC MP Combine Line";
        PurchLine: Query "ACC Purchase Combine Qry";
        MonPeriod: Integer;
        MonToday: Integer;
        YRPeriod: Integer;
        SPN: Integer;
    begin
        if PurchLine.Open() then begin
            while PurchLine.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'PO';
                if PurchLine.LocationCode <> '' then begin
                    if CopyStr(PurchLine.LocationCode, 1, 2) <> PurchLine.SiteId then begin
                        RecLine."Site ID" := CopyStr(PurchLine.LocationCode, 1, 2);
                    end else begin
                        RecLine."Site ID" := PurchLine.SiteId;
                    end;
                end else begin
                    RecLine."Site ID" := PurchLine.SiteId;
                end;
                RecLine."Location Code" := PurchLine.LocationCode;
                RecLine."Business Unit ID" := PurchLine.BusinessUnitId;
                RecLine."SKU ID" := PurchLine.ItemNo;
                RecLine."Period Date" := PurchLine.DeliveryDate;
                RecLine.Period := Format(PurchLine.DeliveryDate, 0, '<Year4>-<Month,2>');
                RecLine.Quantity := PurchLine.Quantity;
                MonPeriod := Date2DMY(PurchLine.DeliveryDate, 2);
                MonToday := Date2DMY(Today, 2);
                YRPeriod := Date2DMY(PurchLine.DeliveryDate, 3) - Date2DMY(Today, 3);
                SPN := (MonPeriod - MonToday) + (YRPeriod * 12);
                RecLine."Statistic Period Number" := SPN;
                if SPN < 0 then begin
                    RecLine."PO Date Status" := 'Old date';
                end else begin
                    RecLine."PO Date Status" := 'OK';
                end;
                RecLine.Insert(true);
            end;
            PurchLine.Close();
        end;
    end;

    local procedure SalesInvoice()
    var
        CrediLine: Query "ACC Sales Credit Combine Qry";
        SalesLine: Query "ACC Sales Invoice Combine Qry";

        MonPeriod: Integer;
        MonToday: Integer;
        YRPeriod: Integer;

        FromDate: Date;
        ToDate: Date;
        PeriodNumber: Integer;
    begin
        FromDate := CalcDate('-395D', TODAY);
        ToDate := Today();
        SalesLine.SetRange(DeliveryDate, FromDate, ToDate);
        if SalesLine.Open() then begin
            while SalesLine.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'Sales';
                RecLine."Site ID" := CopyStr(SalesLine.LocationCode, 1, 2);
                RecLine."Location Code" := SalesLine.LocationCode;
                RecLine."Business Unit ID" := SalesLine.BusinessUnitId;
                RecLine."SKU ID" := SalesLine.ItemNo;
                RecLine."Period Date" := SalesLine.DeliveryDate;
                RecLine.Period := Format(SalesLine.DeliveryDate, 0, '<Year4>-<Month,2>');
                RecLine.Quantity := SalesLine.Quantity;
                MonPeriod := Date2DMY(SalesLine.DeliveryDate, 2);
                MonToday := Date2DMY(Today, 2);
                YRPeriod := Date2DMY(SalesLine.DeliveryDate, 3) - Date2DMY(Today, 3);
                PeriodNumber := (MonPeriod - MonToday) + (YRPeriod * 12);
                RecLine."Statistic Period Number" := PeriodNumber;
                if PeriodNumber > -13 then
                    RecLine.Insert(true);
            end;
            SalesLine.Close();
        end;
        CrediLine.SetRange(DeliveryDate, FromDate, ToDate);
        if CrediLine.Open() then begin
            while CrediLine.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'Sales';
                RecLine."Site ID" := CopyStr(CrediLine.LocationCode, 1, 2);
                RecLine."Location Code" := CrediLine.LocationCode;
                RecLine."Business Unit ID" := CrediLine.BusinessUnitId;
                RecLine."SKU ID" := CrediLine.ItemNo;
                RecLine."Period Date" := CrediLine.DeliveryDate;
                RecLine.Period := Format(CrediLine.DeliveryDate, 0, '<Year4>-<Month,2>');
                RecLine.Quantity := -CrediLine.Quantity;
                MonPeriod := Date2DMY(CrediLine.DeliveryDate, 2);
                MonToday := Date2DMY(Today, 2);
                YRPeriod := Date2DMY(CrediLine.DeliveryDate, 3) - Date2DMY(Today, 3);
                PeriodNumber := (MonPeriod - MonToday) + (YRPeriod * 12);
                RecLine."Statistic Period Number" := PeriodNumber;
                if PeriodNumber > -13 then
                    RecLine.Insert(true);
            end;
            CrediLine.Close();
        end;
    end;

    local procedure SalesForecast()
    var
        //RecLine: Record "ACC MP Combine Line";
        ForecastTrans: Query "ACC Forecast Combine Qry";
        ForecastEntry: Query "ACC Forecast Combine Qry";
        Agreement: Query "ACC Forecast Agreement Qry";
        MonPeriod: Integer;
        MonToday: Integer;
        YRPeriod: Integer;

        FromDate: Date;
        ToDate: Date;
        PeriodNumber: Integer;
    begin
        FromDate := CalcDate('-225D', TODAY);
        ToDate := CalcDate('+495D', TODAY);

        ForecastTrans.SetRange(NoSA, false);
        ForecastTrans.SetRange(DeliveryDate, FromDate, ToDate);
        ForecastTrans.SetFilter(SalesPool, '0|2');
        ForecastTrans.SetFilter(AgreementEndDate, '%1..', Today);
        if ForecastTrans.Open() then begin
            while ForecastTrans.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'FC';
                RecLine."Site ID" := CopyStr(ForecastTrans.LocationCode, 1, 2);
                RecLine."Location Code" := ForecastTrans.LocationCode;
                RecLine."Business Unit ID" := ForecastTrans.BusinessUnitId;
                RecLine."SKU ID" := ForecastTrans.ItemNo;
                RecLine."Period Date" := ForecastTrans.DeliveryDate;
                RecLine.Period := Format(ForecastTrans.DeliveryDate, 0, '<Year4>-<Month,2>');
                RecLine.Quantity := ForecastTrans.Quantity;
                MonPeriod := Date2DMY(ForecastTrans.DeliveryDate, 2);
                MonToday := Date2DMY(Today, 2);
                YRPeriod := Date2DMY(ForecastTrans.DeliveryDate, 3) - Date2DMY(Today, 3);
                PeriodNumber := (MonPeriod - MonToday) + (YRPeriod * 12);
                RecLine."Statistic Period Number" := PeriodNumber;
                if (PeriodNumber > -7) AND (PeriodNumber < 16) then begin
                    RecLine.Insert(true);
                end;
            end;
            ForecastTrans.Close();
        end;

        ForecastEntry.SetRange(NoSA, true);
        ForecastEntry.SetRange(DeliveryDate, FromDate, ToDate);
        if ForecastEntry.Open() then begin
            while ForecastEntry.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'FC';
                RecLine."Site ID" := CopyStr(ForecastEntry.LocationCode, 1, 2);
                RecLine."Location Code" := ForecastEntry.LocationCode;
                RecLine."Business Unit ID" := ForecastEntry.BusinessUnitId;
                RecLine."SKU ID" := ForecastEntry.ItemNo;
                RecLine."Period Date" := ForecastEntry.DeliveryDate;
                RecLine.Period := Format(ForecastEntry.DeliveryDate, 0, '<Year4>-<Month,2>');
                RecLine.Quantity := ForecastEntry.Quantity;
                MonPeriod := Date2DMY(ForecastEntry.DeliveryDate, 2);
                MonToday := Date2DMY(Today, 2);
                YRPeriod := Date2DMY(ForecastEntry.DeliveryDate, 3) - Date2DMY(Today, 3);
                PeriodNumber := (MonPeriod - MonToday) + (YRPeriod * 12);
                RecLine."Statistic Period Number" := PeriodNumber;
                if (PeriodNumber > -7) AND (PeriodNumber < 16) then begin
                    RecLine.Insert(true);
                end;
            end;
            ForecastEntry.Close();
        end;

        Agreement.SetRange(DeliveryDate, FromDate, ToDate);
        if Agreement.Open() then begin
            while Agreement.Read() do begin
                RecLine.Reset();
                RecLine.SetRange("Entity ID", 'ACC');
                RecLine.SetRange("Dimension Value", 'FC');
                RecLine.SetRange("SKU ID", Agreement.ItemNo);
                RecLine.SetRange("Business Unit ID", Agreement.BusinessUnitId);
                RecLine.SetRange("Location Code", Agreement.LocationCode);
                RecLine.SetRange("Period Date", Agreement.DeliveryDate);
                if RecLine.FindFirst() then begin
                    RecLine."SA Quantity" := Agreement.Quantity;
                    RecLine.Modify();
                end;
            end;
            Agreement.Close();
        end;
    end;

    local procedure ItemOnhand()
    var
        //RecLine: Record "ACC MP Combine Line";
        Stock: Query "ACC Stock Combine Qry";
        PeriodNumber: Integer;
    begin
        if Stock.Open() then begin
            while Stock.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'Stock';
                RecLine."Site ID" := CopyStr(Stock.LocationCode, 1, 2);
                RecLine."Location Code" := Stock.LocationCode;
                RecLine."Business Unit ID" := Stock.BusinessUnitId;
                RecLine."SKU ID" := Stock.ItemNo;
                RecLine."Period Date" := Today();
                RecLine.Period := Format(Today(), 0, '<Year4>-<Month,2>');
                RecLine.Quantity := Stock.Quantity;
                RecLine."Statistic Period Number" := 0;
                RecLine.Insert(true);
            end;
            Stock.Close();
        end;
    end;

    local procedure TransferOrder()
    var
        Transfer: Query "ACC Transfer Combine Qry";
        PeriodNumber: Integer;
    //RecLine: Record "ACC MP Combine Line";
    begin
        if Transfer.Open() then begin
            while Transfer.Read() do begin
                RecLine.Init();
                RecLine.ID := RecLine.ID + 1;
                RecLine."Entity ID" := 'ACC';
                RecLine."Dimension Value" := 'Stock';
                RecLine."Site ID" := CopyStr(Transfer.LocationCode, 1, 2);
                RecLine."Location Code" := Transfer.LocationCode;
                RecLine."Business Unit ID" := Transfer.BusinessUnitId;
                RecLine."SKU ID" := Transfer.ItemNo;
                RecLine."Period Date" := Today();
                RecLine.Period := Format(Today(), 0, '<Year4>-<Month,2>');
                RecLine.Quantity := Transfer.Quantity;
                RecLine."Statistic Period Number" := 0;
                RecLine.Insert(true);
            end;
            Transfer.Close();
        end;
    end;

    local procedure CombineMP()
    var
        CombineLine: Query "ACC MP Combine Line Qry";
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if CombineLine.Open() then begin
            while CombineLine.Read() do begin
                Rec.Init();
                Rec."Entity ID" := CombineLine.EntityID;
                Rec."Dimension Value" := CombineLine.DimensionValue;
                Rec."Site ID" := CombineLine.SiteId;
                Rec."Business Unit ID" := CombineLine.BusinessUnitId;
                Rec."SKU ID" := CombineLine.SKUID;
                Rec."Period Date" := CombineLine.PeriodDate;
                Rec.Period := CombineLine.Period;
                Rec.Quantity := CombineLine.Quantity;
                Rec."Statistic Period Number" := CombineLine.StatisticPeriodNumber;
                Rec."PO Date Status" := CombineLine.PODateStatus;
                Rec."SA Quantity" := CombineLine.SAQuantity;
                Rec.Insert();
            end;
            CombineLine.Close();
        end;
    end;

    var
        RecLine: Record "ACC MP Combine Line";
}
