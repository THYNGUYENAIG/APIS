page 51933 "ACC MP Sales Line Available"
{
    ApplicationArea = All;
    Caption = 'APIS MP Sales Line (Available)';
    PageType = List;
    SourceTable = "ACC MP Sales Line Available";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line Created At"; Rec."Line Created At") { }
                field("Sales No."; Rec."Sales No.") { }
                field("Line No."; Rec."Line No.") { }
                field("BU Code"; Rec."BU Code") { }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field("Item Name"; Rec."Item Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Location Code"; Rec."Location Code") { }
                field(Quantity; Rec.Quantity) { }
                field(Onhand; Rec.Onhand) { }
                field(Remaining; Rec.Remaining) { }
                field("Manufacturing Policy"; Rec."Manufacturing Policy") { }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        MPItemLedgerEntry();
        MPSalesLine();
        Rec.SetRange("Sales Filter", true);
    end;



    local procedure CalcPhysicalOnhand(ItemNo: Text; SiteNo: Text; Period: Integer): Decimal
    var
    begin
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

    local procedure MPItemLedgerEntry()
    var
        ItemLedgerQry: Query "ACC MP Item Ledger Entry";
        PurchOrderQry: Query "ACC MP Purchase Order";
    begin
        ItemLedgerRec.ID := 0;
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
        if PurchOrderQry.Open() then begin
            while PurchOrderQry.Read() do begin
                ItemLedgerRec.Init();
                ItemLedgerRec.ID += 1;
                ItemLedgerRec."Item No." := PurchOrderQry.ItemNo;
                ItemLedgerRec."Location Code" := PurchOrderQry.LocationCode;
                ItemLedgerRec."Site No." := CopyStr(PurchOrderQry.LocationCode, 1, 2);
                ItemLedgerRec.Quantity := PurchOrderQry.Quantity;
                ItemLedgerRec.Period := PurchOrderQry.YearDate * 100 + PurchOrderQry.MonthDate;
                ItemLedgerRec.Insert();
            end;
            PurchOrderQry.Close();
        end;
    end;

    local procedure MPSalesLine()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        MPSalesLine: Record "ACC MP Sales Line Available";
        SiteNo: Text;
        TmpNo: Text;
        NoTmp: Text;
        Onhand01: Decimal;
        Onhand02: Decimal;
        Onhand03: Decimal;
        Period01: Integer;
        Period02: Integer;
        Period03: Integer;
        //PeriodTmp: Text;
        //TmpPeriod: Text;
        Remaining01: Decimal;
        Remaining02: Decimal;
        Remaining03: Decimal;
        PeriodInTmp: Integer;
        //FCQuantity: Decimal;
        FromDate: Date;
        ToDate: Date;
        CurDate: Date;
        ForPeriodO1: Boolean;
        ForPeriodO2: Boolean;
    begin
        CurDate := CalcDate('CM', Today);
        ToDate := CalcDate('+2M', CurDate);
        MPSalesLine.Reset();
        MPSalesLine.DeleteAll();

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", "Sales Document Type"::Order);
        SalesHeader.SetFilter("Posting Date", '..%1', ToDate);
        if SalesHeader.FindSet() then
            repeat
                SalesLine.Reset();
                SalesLine.SetCurrentKey("No.", "Location Code");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, "Sales Line Type"::Item);
                SalesLine.SetFilter("No.", '<>SERVICE*');
                if SalesLine.FindSet() then begin
                    repeat
                        SiteNo := CopyStr(SalesLine."Location Code", 1, 2);
                        MPSalesLine.Init();
                        MPSalesLine."Line Created At" := SalesLine.SystemCreatedAt;
                        MPSalesLine."Sales No." := SalesLine."Document No.";
                        MPSalesLine."Line No." := SalesLine."Line No.";
                        MPSalesLine."Item No." := SalesLine."No.";
                        MPSalesLine.Description := SalesLine.Description;
                        MPSalesLine."Item Name" := SalesLine."BLTEC Item Name";
                        MPSalesLine."Location Code" := SalesLine."Location Code";
                        MPSalesLine."Site Code" := SiteNo;
                        MPSalesLine.Quantity := SalesLine.Quantity;

                        MPSalesLine."Posting Date" := SalesHeader."Posting Date";
                        if CurDate >= SalesHeader."Posting Date" then begin
                            Evaluate(MPSalesLine.Period, Format(CurDate, 0, '<Year4><Month,2>'));
                        end else
                            Evaluate(MPSalesLine.Period, Format(SalesHeader."Posting Date", 0, '<Year4><Month,2>'));
                        MPSalesLine."Requested Date" := SalesHeader."Requested Delivery Date";

                        MPSalesLine.Insert();
                    until SalesLine.Next() = 0;
                end;
            until SalesHeader.Next() = 0;
        
        MPSalesLine.Reset();
        MPSalesLine.SetCurrentKey("Item No.", "Site Code", Period, "Posting Date");
        if MPSalesLine.FindSet() then
            repeat
                NoTmp := StrSubstNo('%1-%2', MPSalesLine."Item No.", MPSalesLine."Site Code");
                if TmpNo <> NoTmp then begin
                    ForPeriodO1 := false;
                    ForPeriodO2 := false;
                    Remaining01 := 0;
                    Remaining02 := 0;
                    Remaining03 := 0;
                    PeriodInTmp := 0;
                    FromDate := CalcDate('-CM', Today);
                    Evaluate(Period01, Format(FromDate, 0, '<Year4><Month,2>'));
                    //if Period01 = MPSalesLine.Period then
                    Onhand01 := CalcPhysicalOnhand(MPSalesLine."Item No.", MPSalesLine."Site Code", Period01);
                    FromDate := CalcDate('+1M', FromDate);
                    Evaluate(Period02, Format(FromDate, 0, '<Year4><Month,2>'));
                    //if Period02 = MPSalesLine.Period then
                    Onhand02 := CalcPhysicalOnhand(MPSalesLine."Item No.", MPSalesLine."Site Code", Period02);
                    FromDate := CalcDate('+1M', FromDate);
                    Evaluate(Period03, Format(FromDate, 0, '<Year4><Month,2>'));
                    //if Period03 = MPSalesLine.Period then
                    Onhand03 := CalcPhysicalOnhand(MPSalesLine."Item No.", MPSalesLine."Site Code", Period03);
                    //TmpPeriod := StrSubstNo('%1-%2-%3', MPSalesLine."Item No.", MPSalesLine."Site Code", MPSalesLine.Period);
                end else begin

                    //PeriodTmp := StrSubstNo('%1-%2-%3', MPSalesLine."Item No.", MPSalesLine."Site Code", MPSalesLine.Period);
                    /*
                    if TmpPeriod <> PeriodTmp then begin
                        if (Period02 = MPSalesLine.Period) AND (Onhand02 = 0) then begin
                            Onhand02 := CalcPhysicalOnhand(MPSalesLine."Item No.", MPSalesLine."Site Code", MPSalesLine.Period);
                        end;
                        if (Period03 = MPSalesLine.Period) AND (Onhand03 = 0) then begin
                            Onhand03 := CalcPhysicalOnhand(MPSalesLine."Item No.", MPSalesLine."Site Code", MPSalesLine.Period);
                        end;
                    end;
                    */
                end;
                if Period01 = MPSalesLine.Period then begin
                    ForPeriodO1 := true;
                    if PeriodInTmp <> MPSalesLine.Period then begin
                        MPSalesLine.Onhand := Onhand01;
                    end else
                        MPSalesLine.Onhand := Remaining01;
                    MPSalesLine.Remaining := MPSalesLine.Onhand - MPSalesLine.Quantity;
                    Remaining01 := MPSalesLine.Remaining;
                    PeriodInTmp := MPSalesLine.Period
                end;
                if Period02 = MPSalesLine.Period then begin
                    ForPeriodO2 := true;
                    if Remaining01 > 0 then begin
                        if PeriodInTmp <> MPSalesLine.Period then begin
                            MPSalesLine.Onhand := Onhand02 + Remaining01;
                        end else
                            MPSalesLine.Onhand := Remaining02;
                        MPSalesLine.Remaining := MPSalesLine.Onhand - MPSalesLine.Quantity;
                    end else begin
                        if PeriodInTmp <> MPSalesLine.Period then begin
                            MPSalesLine.Onhand := Onhand02;
                            if ForPeriodO1 = false then
                                MPSalesLine.Onhand := Onhand02 + Onhand01;
                        end else
                            MPSalesLine.Onhand := Remaining02;
                        MPSalesLine.Remaining := MPSalesLine.Onhand - MPSalesLine.Quantity;
                    end;
                    Remaining02 := MPSalesLine.Remaining;
                    PeriodInTmp := MPSalesLine.Period
                end;
                if Period03 = MPSalesLine.Period then begin
                    if Remaining02 > 0 then begin
                        if PeriodInTmp <> MPSalesLine.Period then begin
                            MPSalesLine.Onhand := Onhand03 + Remaining02;
                        end else
                            MPSalesLine.Onhand := Remaining03;
                        MPSalesLine.Remaining := MPSalesLine.Onhand - MPSalesLine.Quantity;
                    end else begin
                        if PeriodInTmp <> MPSalesLine.Period then begin
                            MPSalesLine.Onhand := Onhand03;
                            if ForPeriodO1 then begin
                                if ForPeriodO2 = false then begin
                                    if Remaining01 > 0 then
                                        MPSalesLine.Onhand := Onhand03 + Remaining01;
                                end;
                            end else begin
                                if ForPeriodO2 = false then begin
                                    MPSalesLine.Onhand := Onhand03 + Onhand01;
                                end;
                            end;
                            if ForPeriodO2 = false then
                                MPSalesLine.Onhand += Onhand02;
                        end else
                            MPSalesLine.Onhand := Remaining03;
                        MPSalesLine.Remaining := MPSalesLine.Onhand - MPSalesLine.Quantity;
                    end;
                    Remaining03 := MPSalesLine.Remaining;
                    PeriodInTmp := MPSalesLine.Period;
                end;

                if MPSalesLine.Remaining < 0 then
                    MPSalesLine."Sales Filter" := true;
                MPSalesLine.Modify();
                TmpNo := NoTmp;
            //TmpPeriod := PeriodTmp;
            until MPSalesLine.Next() = 0;
    end;

    var
        ItemLedgerRec: Record "ACC MP Item Ledger Available";

}
