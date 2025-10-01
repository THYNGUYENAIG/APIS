page 51018 "ACC MP Forecast Accuracy"
{
    ApplicationArea = All;
    Caption = 'ACC MP Forecast Accuracy - P51018';
    PageType = List;
    SourceTable = "ACC Forecast Accuracy";
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
                field("Branch Code"; Rec."Branch Code") { }
                field("BU Code"; Rec."BU Code") { }
                field(Salesperson; Rec.Salesperson) { }
                field("Item No."; Rec."Item No.") { }
                field("YM No."; Rec."YM No.") { }
                field("Period Date"; Rec."Period Date") { }
                field("Sales Quantity"; Rec."Sales Quantity") { }
                field("FC T0"; Rec."FC T0") { }
                field("FC T-1"; Rec."FC T-1") { }
                field("FC T-2"; Rec."FC T-2") { }
                field("FC T-3"; Rec."FC T-3") { }
                field(Budget; Rec.Budget) { }
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
                    AccuracyLine.Reset();
                    AccuracyLine.DeleteAll();
                    AccuracyLine.Init();
                    AccuracyLine.ID := 0;
                    CalcForecastAccuracy();
                    CalcLastForecastAccuracy();
                end;
            }
        }
    }
    local procedure CalcForecastAccuracy()
    var
        ForecastEntry: Query "ACC Forecast Entry Qry";
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        ForeAccuracy: Record "ACC Forecast Accuracy";

        ACLineQuery: Query "ACC MP Forecast Accuracy Line";

        FromDate: Date;
        ToDate: Date;

        StartDate: Date;
        EndDate: Date;
        TempTxt: Text;
        CompTxt: Text;
    begin
        FromDate := CalcDate('-CM', Today());
        FromDate := CalcDate('-3M', FromDate);
        ToDate := CalcDate('CM', Today());
        //AccuracyLine.Reset();
        //AccuracyLine.SetRange("YM No.", Format(ToDate, 0, '<Year4>-<Month,2>'));
        //if AccuracyLine.FindSet() then begin
        //    repeat
        //        AccuracyLine.Delete();
        //    until AccuracyLine.Next() = 0;
        //end;

        ForecastEntry.SetRange(ForecastDate, FromDate, ToDate);
        if ForecastEntry.Open() then begin
            while ForecastEntry.Read() do begin
                CompTxt := StrSubstNo('%1%2%3%4%5', ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalespersonCode, ForecastEntry.SalesAgreementNo, ForecastEntry.LocationCode);
                if CompTxt <> TempTxt then begin
                    AccuracyLine.Init();
                    AccuracyLine.ID := AccuracyLine.ID + 1;
                    AccuracyLine."Branch Code" := CopyStr(ForecastEntry.LocationCode, 1, 2);
                    AccuracyLine."Location Code" := ForecastEntry.LocationCode;
                    AccuracyLine.Salesperson := ForecastEntry.SalespersonCode;
                    AccuracyLine."Customer No." := ForecastEntry.CustomerNo;
                    AccuracyLine."Item No." := ForecastEntry.ItemNo;
                    AccuracyLine."BU Code" := ForecastEntry.BusinessUnitId;
                    AccuracyLine."Sales Agreement No." := ForecastEntry.SalesAgreementNo;
                    AccuracyLine."Sales Quantity" := SalesInvoice(ForecastEntry);
                end;
                StartDate := FromDate;
                EndDate := CalcDate('CM', FromDate);
                AccuracyLine."FC T-3" := ForecastUnactive(Format(EndDate, 0, '<Year4>-<Month,2>'), ForecastEntry);
                //if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then
                //    AccuracyLine."FC T-3" := ForecastEntry.ForecastQuantity;

                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                AccuracyLine."FC T-2" := ForecastUnactive(Format(EndDate, 0, '<Year4>-<Month,2>'), ForecastEntry);
                //if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then
                //    AccuracyLine."FC T-2" := ForecastEntry.ForecastQuantity;

                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                AccuracyLine."FC T-1" := ForecastUnactive(Format(EndDate, 0, '<Year4>-<Month,2>'), ForecastEntry);
                //if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then
                //    AccuracyLine."FC T-1" := ForecastEntry.ForecastQuantity;

                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AccuracyLine."FC T0" := ForecastEntry.ForecastQuantity;
                end;
                if CompTxt <> TempTxt then begin
                    AccuracyLine."Period Date" := StartDate;
                    AccuracyLine."YM No." := Format(StartDate, 0, '<Year4>-<Month,2>');
                    AccuracyLine.Insert();
                end;
                TempTxt := StrSubstNo('%1%2%3%4%5', ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalespersonCode, ForecastEntry.SalesAgreementNo, ForecastEntry.LocationCode);
            end;
            ForecastEntry.Close();
        end;

        ForeAccuracy.Reset();
        ForeAccuracy.SetRange("YM No.", Format(ToDate, 0, '<Year4>-<Month,2>'));
        if ForeAccuracy.FindSet() then begin
            repeat
                ForeAccuracy.Delete();
            until ForeAccuracy.Next() = 0;
        end;
        ACLineQuery.SetRange(YMNo, Format(ToDate, 0, '<Year4>-<Month,2>'));
        if ACLineQuery.Open() then begin
            while ACLineQuery.Read() do begin
                ForeAccuracy.Init();
                ForeAccuracy."Period Date" := ACLineQuery.PeriodDate;
                ForeAccuracy."Item No." := ACLineQuery.ItemNo;
                ForeAccuracy."Branch Code" := ACLineQuery.BranchCode;
                ForeAccuracy."BU Code" := ACLineQuery.BUCode;
                ForeAccuracy.Salesperson := ACLineQuery.Salesperson;
                ForeAccuracy."Sales Quantity" := ACLineQuery.SalesQuantity;
                ForeAccuracy."FC T0" := ACLineQuery.FCT0;
                ForeAccuracy."FC T-1" := ACLineQuery.FCT1;
                ForeAccuracy."FC T-2" := ACLineQuery.FCT2;
                ForeAccuracy."FC T-3" := ACLineQuery.FCT3;
                ForeAccuracy.Budget := ACLineQuery.Budget;
                ForeAccuracy."YM No." := ACLineQuery.YMNo;
                ForeAccuracy.Insert();
            end;
            ACLineQuery.Close();
        end;
    end;

    local procedure CalcLastForecastAccuracy()
    var
        ForecastEntry: Query "ACC Last Forecast Entry Qry";
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        ForeAccuracy: Record "ACC Forecast Accuracy";

        ACLineQuery: Query "ACC MP Forecast Accuracy Line";

        FromDate: Date;
        ToDate: Date;

        StartDate: Date;
        EndDate: Date;
        TempTxt: Text;
        CompTxt: Text;
    begin
        FromDate := CalcDate('-CM', Today());
        FromDate := CalcDate('-4M', FromDate);
        ToDate := CalcDate('+3M', FromDate);
        ToDate := CalcDate('CM', ToDate);
        //AccuracyLine.Reset();
        //AccuracyLine.SetRange("YM No.", Format(ToDate, 0, '<Year4>-<Month,2>'));
        //if AccuracyLine.FindSet() then begin
        //    repeat
        //        AccuracyLine.Delete();
        //    until AccuracyLine.Next() = 0;
        //end;
        //AccuracyLine.ID := 0;
        ForecastEntry.SetRange(ForecastName, Format(ToDate, 0, '<Year4>-<Month,2>'));
        ForecastEntry.SetRange(ForecastDate, FromDate, ToDate);
        if ForecastEntry.Open() then begin
            while ForecastEntry.Read() do begin
                CompTxt := StrSubstNo('%1%2%3%4%5', ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalespersonCode, ForecastEntry.SalesAgreementNo, ForecastEntry.LocationCode);
                if CompTxt <> TempTxt then begin
                    AccuracyLine.Init();
                    AccuracyLine.ID := AccuracyLine.ID + 1;
                    AccuracyLine."Branch Code" := CopyStr(ForecastEntry.LocationCode, 1, 2);
                    AccuracyLine."Location Code" := ForecastEntry.LocationCode;
                    AccuracyLine.Salesperson := ForecastEntry.SalespersonCode;
                    AccuracyLine."Customer No." := ForecastEntry.CustomerNo;
                    AccuracyLine."Item No." := ForecastEntry.ItemNo;
                    AccuracyLine."BU Code" := ForecastEntry.BusinessUnitId;
                    AccuracyLine."Sales Agreement No." := ForecastEntry.SalesAgreementNo;
                    AccuracyLine."Sales Quantity" := SalesLastInvoice(ForecastEntry);
                end;
                StartDate := FromDate;
                EndDate := CalcDate('CM', FromDate);
                AccuracyLine."FC T-3" := ForecastLastUnactive(Format(EndDate, 0, '<Year4>-<Month,2>'), ForecastEntry);
                //if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then
                //    AccuracyLine."FC T-3" := ForecastEntry.ForecastQuantity;

                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                AccuracyLine."FC T-2" := ForecastLastUnactive(Format(EndDate, 0, '<Year4>-<Month,2>'), ForecastEntry);
                //if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then
                //    AccuracyLine."FC T-2" := ForecastEntry.ForecastQuantity;

                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                AccuracyLine."FC T-1" := ForecastLastUnactive(Format(EndDate, 0, '<Year4>-<Month,2>'), ForecastEntry);
                //if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then
                //    AccuracyLine."FC T-1" := ForecastEntry.ForecastQuantity;

                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AccuracyLine."FC T0" := ForecastEntry.ForecastQuantity;
                end;
                if CompTxt <> TempTxt then begin
                    AccuracyLine."Period Date" := StartDate;
                    AccuracyLine."YM No." := Format(StartDate, 0, '<Year4>-<Month,2>');
                    AccuracyLine.Insert();
                end;
                TempTxt := StrSubstNo('%1%2%3%4%5', ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalespersonCode, ForecastEntry.SalesAgreementNo, ForecastEntry.LocationCode);
            end;
            ForecastEntry.Close();
        end;

        ForeAccuracy.Reset();
        ForeAccuracy.SetRange("YM No.", Format(ToDate, 0, '<Year4>-<Month,2>'));
        if ForeAccuracy.FindSet() then begin
            repeat
                ForeAccuracy.Delete();
            until ForeAccuracy.Next() = 0;
        end;
        ACLineQuery.SetRange(YMNo, Format(ToDate, 0, '<Year4>-<Month,2>'));
        if ACLineQuery.Open() then begin
            while ACLineQuery.Read() do begin
                ForeAccuracy.Init();
                ForeAccuracy."Period Date" := ACLineQuery.PeriodDate;
                ForeAccuracy."Item No." := ACLineQuery.ItemNo;
                ForeAccuracy."Branch Code" := ACLineQuery.BranchCode;
                ForeAccuracy."BU Code" := ACLineQuery.BUCode;
                ForeAccuracy.Salesperson := ACLineQuery.Salesperson;
                ForeAccuracy."Sales Quantity" := ACLineQuery.SalesQuantity;
                ForeAccuracy."FC T0" := ACLineQuery.FCT0;
                ForeAccuracy."FC T-1" := ACLineQuery.FCT1;
                ForeAccuracy."FC T-2" := ACLineQuery.FCT2;
                ForeAccuracy."FC T-3" := ACLineQuery.FCT3;
                ForeAccuracy.Budget := ACLineQuery.Budget;
                ForeAccuracy."YM No." := ACLineQuery.YMNo;
                ForeAccuracy.Insert();
            end;
            ACLineQuery.Close();
        end;
    end;

    local procedure SalesInvoice(ForecastEntry: Query "ACC Forecast Entry Qry"): Decimal
    var
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        CreditMemos: Query "ACC Credit Memos Entry Qry";
        SalesQty: Decimal;
        AgreementFilter: Text;
    begin
        SalesQty := 0;
        AgreementFilter := StrSubstNo('%1|''''', 'SALESTOOL2SALESORDER');
        InvoiceEntry.SetRange(BusinessUnitID, ForecastEntry.BusinessUnitId);
        InvoiceEntry.SetRange(CustomerNo, ForecastEntry.CustomerNo);
        InvoiceEntry.SetRange(ItemNo, ForecastEntry.ItemNo);
        if (ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER') AND (ForecastEntry.SalesAgreementNo <> '') then begin
            InvoiceEntry.SetRange(AgreementNo, ForecastEntry.SalesAgreementNo);
        end else begin
            InvoiceEntry.SetFilter(AgreementNo, AgreementFilter);
        end;
        InvoiceEntry.SetRange(SalespersonCode, ForecastEntry.SalespersonCode);
        InvoiceEntry.SetRange(PostingDate, CalcDate('-CM', Today()), CalcDate('CM', Today()));
        if InvoiceEntry.Open() then begin
            while InvoiceEntry.Read() do begin
                if CopyStr(ForecastEntry.LocationCode, 1, 2) = CopyStr(InvoiceEntry.LocationCode, 1, 2) then
                    SalesQty := SalesQty + InvoiceEntry.Quantity;
            end;
            InvoiceEntry.Close();
        end;

        CreditMemos.SetRange(BusinessUnitID, ForecastEntry.BusinessUnitId);
        CreditMemos.SetRange(CustomerNo, ForecastEntry.CustomerNo);
        CreditMemos.SetRange(ItemNo, ForecastEntry.ItemNo);
        if (ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER') AND (ForecastEntry.SalesAgreementNo <> '') then begin
            CreditMemos.SetRange(AgreementNo, ForecastEntry.SalesAgreementNo);
        end else begin
            CreditMemos.SetFilter(AgreementNo, AgreementFilter);
        end;
        CreditMemos.SetRange(SalespersonCode, ForecastEntry.SalespersonCode);
        CreditMemos.SetRange(PostingDate, CalcDate('-CM', Today()), CalcDate('CM', Today()));
        if CreditMemos.Open() then begin
            while CreditMemos.Read() do begin
                if CopyStr(ForecastEntry.LocationCode, 1, 2) = CopyStr(CreditMemos.LocationCode, 1, 2) then
                    SalesQty := SalesQty + CreditMemos.Quantity;
            end;
            CreditMemos.Close();
        end;

        exit(SalesQty);
    end;

    local procedure SalesLastInvoice(ForecastEntry: Query "ACC Last Forecast Entry Qry"): Decimal
    var
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        CreditMemos: Query "ACC Credit Memos Entry Qry";
        SalesQty: Decimal;
        AgreementFilter: Text;
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today());
        FromDate := CalcDate('-1M', FromDate);
        ToDate := CalcDate('CM', FromDate);
        SalesQty := 0;
        AgreementFilter := StrSubstNo('%1|''''', 'SALESTOOL2SALESORDER');
        InvoiceEntry.SetRange(BusinessUnitID, ForecastEntry.BusinessUnitId);
        InvoiceEntry.SetRange(CustomerNo, ForecastEntry.CustomerNo);
        InvoiceEntry.SetRange(ItemNo, ForecastEntry.ItemNo);
        if (ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER') AND (ForecastEntry.SalesAgreementNo <> '') then begin
            InvoiceEntry.SetRange(AgreementNo, ForecastEntry.SalesAgreementNo);
        end else begin
            InvoiceEntry.SetFilter(AgreementNo, AgreementFilter);
        end;
        InvoiceEntry.SetRange(SalespersonCode, ForecastEntry.SalespersonCode);
        InvoiceEntry.SetRange(PostingDate, FromDate, ToDate);
        if InvoiceEntry.Open() then begin
            while InvoiceEntry.Read() do begin
                if CopyStr(ForecastEntry.LocationCode, 1, 2) = CopyStr(InvoiceEntry.LocationCode, 1, 2) then
                    SalesQty := SalesQty + InvoiceEntry.Quantity;
            end;
            InvoiceEntry.Close();
        end;

        CreditMemos.SetRange(BusinessUnitID, ForecastEntry.BusinessUnitId);
        CreditMemos.SetRange(CustomerNo, ForecastEntry.CustomerNo);
        CreditMemos.SetRange(ItemNo, ForecastEntry.ItemNo);
        if (ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER') AND (ForecastEntry.SalesAgreementNo <> '') then begin
            CreditMemos.SetRange(AgreementNo, ForecastEntry.SalesAgreementNo);
        end else begin
            CreditMemos.SetFilter(AgreementNo, AgreementFilter);
        end;
        CreditMemos.SetRange(SalespersonCode, ForecastEntry.SalespersonCode);
        CreditMemos.SetRange(PostingDate, FromDate, ToDate);
        if CreditMemos.Open() then begin
            while CreditMemos.Read() do begin
                if CopyStr(ForecastEntry.LocationCode, 1, 2) = CopyStr(CreditMemos.LocationCode, 1, 2) then
                    SalesQty := SalesQty + CreditMemos.Quantity;
            end;
            CreditMemos.Close();
        end;

        exit(SalesQty);
    end;

    local procedure ForecastUnactive(ForecastName: Text; ForecastEntry: Query "ACC Forecast Entry Qry"): Decimal
    var
        ForecastUnactive: Query "ACC Forecast Unactive Qry";
        ForecastQuantity: Decimal;
    begin
        ForecastQuantity := 0;
        ForecastUnactive.SetRange(ItemNo, ForecastEntry.ItemNo);
        ForecastUnactive.SetRange(CustomerNo, ForecastEntry.CustomerNo);
        ForecastUnactive.SetRange(SalespersonCode, ForecastEntry.SalespersonCode);
        ForecastUnactive.SetRange(BusinessUnitId, ForecastEntry.BusinessUnitId);
        ForecastUnactive.SetRange(LocationCode, ForecastEntry.LocationCode);
        ForecastUnactive.SetRange(SalesAgreementNo, ForecastEntry.SalesAgreementNo);
        ForecastUnactive.SetRange(ForecastName, ForecastName);
        ForecastUnactive.SetRange(ForecastDate, CalcDate('-CM', Today), CalcDate('CM', Today));
        if ForecastUnactive.Open() then begin
            while ForecastUnactive.Read() do begin
                ForecastQuantity += ForecastUnactive.ForecastQuantity;
            end;
            ForecastUnactive.Close();
        end;
        exit(ForecastQuantity);
    end;

    local procedure ForecastLastUnactive(ForecastName: Text; ForecastEntry: Query "ACC Last Forecast Entry Qry"): Decimal
    var
        ForecastUnactive: Query "ACC Forecast Unactive Qry";
        ForecastQuantity: Decimal;
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today());
        FromDate := CalcDate('-1M', FromDate);
        ToDate := CalcDate('CM', FromDate);
        ForecastQuantity := 0;
        ForecastUnactive.SetRange(ItemNo, ForecastEntry.ItemNo);
        ForecastUnactive.SetRange(CustomerNo, ForecastEntry.CustomerNo);
        ForecastUnactive.SetRange(SalespersonCode, ForecastEntry.SalespersonCode);
        ForecastUnactive.SetRange(BusinessUnitId, ForecastEntry.BusinessUnitId);
        ForecastUnactive.SetRange(LocationCode, ForecastEntry.LocationCode);
        ForecastUnactive.SetRange(SalesAgreementNo, ForecastEntry.SalesAgreementNo);
        ForecastUnactive.SetRange(ForecastName, ForecastName);
        ForecastUnactive.SetRange(ForecastDate, FromDate, ToDate);
        if ForecastUnactive.Open() then begin
            while ForecastUnactive.Read() do begin
                ForecastQuantity += ForecastUnactive.ForecastQuantity;
            end;
            ForecastUnactive.Close();
        end;
        exit(ForecastQuantity);
    end;

    var
        AccuracyLine: Record "ACC Forecast Accuracy Line";
}
