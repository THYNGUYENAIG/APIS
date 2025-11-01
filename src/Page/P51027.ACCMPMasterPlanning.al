page 51027 "ACC MP Master Planning"
{
    ApplicationArea = All;
    Caption = 'APIS MP Master Planning - P51027';
    PageType = List;
    SourceTable = "ACC MP Master Planning";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    //Editable = false;
    layout
    {
        area(Content)
        {
            group(Option)
            {
                Caption = 'Options';
                field("Select Item No."; SelectItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Select Item No.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        Clear(Text);
                        Clear(SelectItemNo);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            Text += ItemList.GetSelectionFilter();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }

            }
            repeater(General)
            {
                field("Site No."; Rec."Site No.") { }

                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Min Stock"; Rec."Min Stock") { }
                field(Onhand; Rec.Onhand) { Caption = 'Tổn kho'; }
                field("Q Onhand"; Rec."Q Onhand") { Caption = 'Tổn kho Q'; }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    Caption = 'Hàng đã bán trong tháng';
                }
                field("Quantity AVG Invoiced"; Rec."Quantity AVG Invoiced")
                {
                    Caption = 'BQ Hàng đã bán trong 3 tháng';
                }
                //field("Quantity Received"; Rec."Quantity Received") { }
                field("Requisition Worksheet 01 ST"; Rec."Requisition Worksheet 01 ST")
                {
                    CaptionClass = GetCaptionPR(1);
                }
                field("Open Order 01 ST"; Rec."Open Order 01 ST")
                {
                    CaptionClass = GetCaptionPO(1);
                }
                field("Demand Forecast 01 ST"; Rec."Demand Forecast 01 ST")
                {
                    CaptionClass = GetCaptionDF(1);
                }
                field("Onhand Forecast 01 ST"; Rec."Onhand Forecast 01 ST")
                {
                    CaptionClass = GetCaptionOF(1);
                }
                field("Requisition Worksheet 02 ST"; Rec."Requisition Worksheet 02 ST")
                {
                    CaptionClass = GetCaptionPR(2);
                }
                field("Open Order 02 ST"; Rec."Open Order 02 ST")
                {
                    CaptionClass = GetCaptionPO(2);
                }
                field("Demand Forecast 02 ST"; Rec."Demand Forecast 02 ST")
                {
                    CaptionClass = GetCaptionDF(2);
                }
                field("Onhand Forecast 02 ST"; Rec."Onhand Forecast 02 ST")
                {
                    CaptionClass = GetCaptionOF(2);
                }
                field("Requisition Worksheet 03 ST"; Rec."Requisition Worksheet 03 ST")
                {
                    CaptionClass = GetCaptionPR(3);
                }
                field("Open Order 03 ST"; Rec."Open Order 03 ST")
                {
                    CaptionClass = GetCaptionPO(3);
                }
                field("Demand Forecast 03 ST"; Rec."Demand Forecast 03 ST")
                {
                    CaptionClass = GetCaptionDF(3);
                }
                field("Onhand Forecast 03 ST"; Rec."Onhand Forecast 03 ST")
                {
                    CaptionClass = GetCaptionOF(3);
                }
                field("Requisition Worksheet 04 ST"; Rec."Requisition Worksheet 04 ST")
                {
                    CaptionClass = GetCaptionPR(4);
                }
                field("Open Order 04 ST"; Rec."Open Order 04 ST")
                {
                    CaptionClass = GetCaptionPO(4);
                }
                field("Demand Forecast 04 ST"; Rec."Demand Forecast 04 ST")
                {
                    CaptionClass = GetCaptionDF(4);
                }
                field("Onhand Forecast 04 ST"; Rec."Onhand Forecast 04 ST")
                {
                    CaptionClass = GetCaptionOF(4);
                }
                field("Requisition Worksheet 05 ST"; Rec."Requisition Worksheet 05 ST")
                {
                    CaptionClass = GetCaptionPR(5);
                }
                field("Open Order 05 ST"; Rec."Open Order 05 ST")
                {
                    CaptionClass = GetCaptionPO(5);
                }
                field("Demand Forecast 05 ST"; Rec."Demand Forecast 05 ST")
                {
                    CaptionClass = GetCaptionDF(5);
                }
                field("Onhand Forecast 05 ST"; Rec."Onhand Forecast 05 ST")
                {
                    CaptionClass = GetCaptionOF(5);
                }
                field("Requisition Worksheet 06 ST"; Rec."Requisition Worksheet 06 ST")
                {
                    CaptionClass = GetCaptionPR(6);
                }
                field("Open Order 06 ST"; Rec."Open Order 06 ST")
                {
                    CaptionClass = GetCaptionPO(6);
                }
                field("Demand Forecast 06 ST"; Rec."Demand Forecast 06 ST")
                {
                    CaptionClass = GetCaptionDF(6);
                }
                field("Onhand Forecast 06 ST"; Rec."Onhand Forecast 06 ST")
                {
                    CaptionClass = GetCaptionOF(6);
                }
                field("Requisition Worksheet 07 ST"; Rec."Requisition Worksheet 07 ST")
                {
                    CaptionClass = GetCaptionPR(7);
                }
                field("Open Order 07 ST"; Rec."Open Order 07 ST")
                {
                    CaptionClass = GetCaptionPO(7);
                }
                field("Demand Forecast 07 ST"; Rec."Demand Forecast 07 ST")
                {
                    CaptionClass = GetCaptionDF(7);
                }
                field("Onhand Forecast 07 ST"; Rec."Onhand Forecast 07 ST")
                {
                    CaptionClass = GetCaptionOF(7);
                }
                field("Requisition Worksheet 08 ST"; Rec."Requisition Worksheet 08 ST")
                {
                    CaptionClass = GetCaptionPR(8);
                }
                field("Open Order 08 ST"; Rec."Open Order 08 ST")
                {
                    CaptionClass = GetCaptionPO(8);
                }
                field("Demand Forecast 08 ST"; Rec."Demand Forecast 08 ST")
                {
                    CaptionClass = GetCaptionDF(8);
                }
                field("Onhand Forecast 08 ST"; Rec."Onhand Forecast 08 ST")
                {
                    CaptionClass = GetCaptionOF(8);
                }
                field("Requisition Worksheet 09 ST"; Rec."Requisition Worksheet 09 ST")
                {
                    CaptionClass = GetCaptionPR(9);
                }
                field("Open Order 09 ST"; Rec."Open Order 09 ST")
                {
                    CaptionClass = GetCaptionPO(9);
                }
                field("Demand Forecast 09 ST"; Rec."Demand Forecast 09 ST")
                {
                    CaptionClass = GetCaptionDF(9);
                }
                field("Onhand Forecast 09 ST"; Rec."Onhand Forecast 09 ST")
                {
                    CaptionClass = GetCaptionOF(9);
                }
                field("Requisition Worksheet 10 ST"; Rec."Requisition Worksheet 10 ST")
                {
                    CaptionClass = GetCaptionPR(10);
                }
                field("Open Order 10 ST"; Rec."Open Order 10 ST")
                {
                    CaptionClass = GetCaptionPO(10);
                }
                field("Demand Forecast 10 ST"; Rec."Demand Forecast 10 ST")
                {
                    CaptionClass = GetCaptionDF(10);
                }
                field("Onhand Forecast 10 ST"; Rec."Onhand Forecast 10 ST")
                {
                    CaptionClass = GetCaptionOF(10);
                }
                field("Requisition Worksheet 11 ST"; Rec."Requisition Worksheet 11 ST")
                {
                    CaptionClass = GetCaptionPR(11);
                }
                field("Open Order 11 ST"; Rec."Open Order 11 ST")
                {
                    CaptionClass = GetCaptionPO(11);
                }
                field("Demand Forecast 11 ST"; Rec."Demand Forecast 11 ST")
                {
                    CaptionClass = GetCaptionDF(11);
                }
                field("Onhand Forecast 11 ST"; Rec."Onhand Forecast 11 ST")
                {
                    CaptionClass = GetCaptionOF(11);
                }
                field("Requisition Worksheet 12 ST"; Rec."Requisition Worksheet 12 ST")
                {
                    CaptionClass = GetCaptionPR(12);
                }
                field("Open Order 12 ST"; Rec."Open Order 12 ST")
                {
                    CaptionClass = GetCaptionPO(12);
                }
                field("Demand Forecast 12 ST"; Rec."Demand Forecast 12 ST")
                {
                    CaptionClass = GetCaptionDF(12);
                }
                field("Onhand Forecast 12 ST"; Rec."Onhand Forecast 12 ST")
                {
                    CaptionClass = GetCaptionOF(12);
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCMPCalc)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Calc';
                trigger OnAction()
                var
                begin
                    CalcData();
                    CalcMP();
                end;
            }
        }
    }

    local procedure CalcOnhand(_ItemNo: Text; _SiteNo: Text): Decimal
    var
        DemandEntry: Query "ACC Master Forecast Entry Qry";
        Onhand: Decimal;
    begin
        Onhand := 0;
        DemandEntry.SetRange(ItemNo, _ItemNo);
        DemandEntry.SetRange(SiteNo, _SiteNo);
        DemandEntry.SetFilter(Type, StrSubstNo('%1|%2|%3', 'Unlocked', 'LotLocked', 'BinLocked'));
        if DemandEntry.Open() then begin
            while DemandEntry.Read() do begin
                Onhand += DemandEntry.ForecastQuantity;
            end;
            DemandEntry.Close();
        end;
        exit(Onhand);
    end;

    local procedure CalcOnhandQ(_ItemNo: Text; _SiteNo: Text): Decimal
    var
        DemandEntry: Query "ACC Master Forecast Entry Qry";
        Onhand: Decimal;
    begin
        Onhand := 0;
        DemandEntry.SetRange(ItemNo, _ItemNo);
        DemandEntry.SetRange(SiteNo, _SiteNo);
        DemandEntry.SetFilter(Type, StrSubstNo('%1|%2|%3', 'LotLocked', 'BinLocked'));
        if DemandEntry.Open() then begin
            while DemandEntry.Read() do begin
                Onhand += DemandEntry.ForecastQuantity;
            end;
            DemandEntry.Close();
        end;
        exit(Onhand);
    end;

    local procedure CalcInvoiceAVG(_ItemNo: Text; _SiteNo: Text): Decimal
    var
        DemandEntry: Query "ACC Master Forecast Entry Qry";
        Onhand: Decimal;
    begin
        Onhand := 0;
        DemandEntry.SetRange(ItemNo, _ItemNo);
        DemandEntry.SetRange(SiteNo, _SiteNo);
        DemandEntry.SetFilter(Type, StrSubstNo('%1|%2', 'Invoice', 'Memos'));
        if DemandEntry.Open() then begin
            while DemandEntry.Read() do begin
                Onhand += DemandEntry.ForecastQuantity;
            end;
            DemandEntry.Close();
        end;
        if Date2DMY(Today(), 2) = 7 then begin
            Onhand := Onhand / 2;
        end else begin
            Onhand := Onhand / 3;
        end;
        exit(Onhand);
    end;

    local procedure CalcInvoice(_ItemNo: Text; _SiteNo: Text): Decimal
    var
        DemandEntry: Query "ACC Master Forecast Entry Qry";
        Onhand: Decimal;
    begin
        Onhand := 0;
        DemandEntry.SetRange(ItemNo, _ItemNo);
        DemandEntry.SetRange(SiteNo, _SiteNo);
        DemandEntry.SetRange(ForecastDate, CalcDate('-CM', Today), CalcDate('CM', Today));
        DemandEntry.SetFilter(Type, StrSubstNo('%1|%2', 'Invoice', 'Memos'));
        if DemandEntry.Open() then begin
            while DemandEntry.Read() do begin
                Onhand += DemandEntry.ForecastQuantity;
            end;
            DemandEntry.Close();
        end;
        exit(Onhand);
    end;

    local procedure CalcMP()
    var
        MasterPlan: Record "ACC MP Master Planning";
        DemandEntry: Query "ACC Master Forecast Entry Qry";
        DataMaster: Query "ACC Data MP Entry Qry";

        FromDate: Date;
        ToDate: Date;
        ValidFromDate: Date;
        ValidToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today());
        ToDate := CalcDate('+11M', FromDate);
        MasterPlan.Reset();
        MasterPlan.DeleteAll();
        if DataMaster.Open() then begin
            while DataMaster.Read() do begin
                MasterPlan.Init();
                MasterPlan."Site No." := DataMaster.SiteNo;
                MasterPlan."Item No." := DataMaster.ItemNo;
                MasterPlan.Onhand := CalcOnhand(DataMaster.ItemNo, DataMaster.SiteNo);
                MasterPlan."Q Onhand" := CalcOnhandQ(DataMaster.ItemNo, DataMaster.SiteNo);
                MasterPlan."Quantity AVG Invoiced" := CalcInvoiceAVG(DataMaster.ItemNo, DataMaster.SiteNo);
                MasterPlan."Quantity Invoiced" := CalcInvoice(DataMaster.ItemNo, DataMaster.SiteNo);
                // Forecast
                MasterPlan."Demand Forecast 01 ST" := 0;
                MasterPlan."Demand Forecast 02 ST" := 0;
                MasterPlan."Demand Forecast 03 ST" := 0;
                MasterPlan."Demand Forecast 04 ST" := 0;
                MasterPlan."Demand Forecast 05 ST" := 0;
                MasterPlan."Demand Forecast 06 ST" := 0;
                MasterPlan."Demand Forecast 07 ST" := 0;
                MasterPlan."Demand Forecast 08 ST" := 0;
                MasterPlan."Demand Forecast 09 ST" := 0;
                MasterPlan."Demand Forecast 10 ST" := 0;
                MasterPlan."Demand Forecast 11 ST" := 0;
                MasterPlan."Demand Forecast 12 ST" := 0;
                DemandEntry.SetRange(ItemNo, DataMaster.ItemNo);
                DemandEntry.SetRange(SiteNo, DataMaster.SiteNo);
                DemandEntry.SetRange(ForecastDate, FromDate, ToDate);
                DemandEntry.SetFilter(Type, 'Demand');
                if DemandEntry.Open() then begin
                    while DemandEntry.Read() do begin
                        ValidFromDate := FromDate;
                        ValidToDate := CalcDate('CM', FromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 01 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 02 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 03 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 04 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 05 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 06 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 07 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 08 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 09 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 10 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 11 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Demand Forecast 12 ST" := DemandEntry.ForecastQuantity;
                    end;
                    DemandEntry.Close();
                end;

                // Requisition
                MasterPlan."Requisition Worksheet 01 ST" := 0;
                MasterPlan."Requisition Worksheet 02 ST" := 0;
                MasterPlan."Requisition Worksheet 03 ST" := 0;
                MasterPlan."Requisition Worksheet 04 ST" := 0;
                MasterPlan."Requisition Worksheet 05 ST" := 0;
                MasterPlan."Requisition Worksheet 06 ST" := 0;
                MasterPlan."Requisition Worksheet 07 ST" := 0;
                MasterPlan."Requisition Worksheet 08 ST" := 0;
                MasterPlan."Requisition Worksheet 09 ST" := 0;
                MasterPlan."Requisition Worksheet 10 ST" := 0;
                MasterPlan."Requisition Worksheet 11 ST" := 0;
                MasterPlan."Requisition Worksheet 12 ST" := 0;
                DemandEntry.SetRange(ItemNo, DataMaster.ItemNo);
                DemandEntry.SetRange(SiteNo, DataMaster.SiteNo);
                DemandEntry.SetRange(ForecastDate, FromDate, ToDate);
                DemandEntry.SetFilter(Type, 'Requisition');
                if DemandEntry.Open() then begin
                    while DemandEntry.Read() do begin
                        ValidFromDate := FromDate;
                        ValidToDate := CalcDate('CM', FromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 01 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 02 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 03 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 04 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 05 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 06 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 07 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 08 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 09 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 10 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 11 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Requisition Worksheet 12 ST" := DemandEntry.ForecastQuantity;
                    end;
                    DemandEntry.Close();
                end;

                // Purchase
                MasterPlan."Open Order 01 ST" := 0;
                MasterPlan."Open Order 02 ST" := 0;
                MasterPlan."Open Order 03 ST" := 0;
                MasterPlan."Open Order 04 ST" := 0;
                MasterPlan."Open Order 05 ST" := 0;
                MasterPlan."Open Order 06 ST" := 0;
                MasterPlan."Open Order 07 ST" := 0;
                MasterPlan."Open Order 08 ST" := 0;
                MasterPlan."Open Order 09 ST" := 0;
                MasterPlan."Open Order 10 ST" := 0;
                MasterPlan."Open Order 11 ST" := 0;
                MasterPlan."Open Order 12 ST" := 0;
                DemandEntry.SetRange(ItemNo, DataMaster.ItemNo);
                DemandEntry.SetRange(SiteNo, DataMaster.SiteNo);
                DemandEntry.SetRange(ForecastDate, FromDate, ToDate);
                DemandEntry.SetFilter(Type, 'Purchase');
                if DemandEntry.Open() then begin
                    while DemandEntry.Read() do begin
                        ValidFromDate := FromDate;
                        ValidToDate := CalcDate('CM', FromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 01 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 02 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 03 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 04 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 05 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 06 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 07 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 08 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 09 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 10 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 11 ST" := DemandEntry.ForecastQuantity;
                        ValidFromDate := CalcDate('+1D', ValidToDate);
                        ValidToDate := CalcDate('CM', ValidFromDate);
                        if (ValidFromDate <= DemandEntry.ForecastDate) AND (ValidToDate >= DemandEntry.ForecastDate) then
                            MasterPlan."Open Order 12 ST" := DemandEntry.ForecastQuantity;
                    end;
                    DemandEntry.Close();
                end;

                // Onhand Forecast
                if MasterPlan."Quantity Invoiced" < MasterPlan."Demand Forecast 01 ST" then begin
                    MasterPlan."Onhand Forecast 01 ST" := MasterPlan.Onhand + MasterPlan."Open Order 01 ST" + MasterPlan."Requisition Worksheet 01 ST" - (MasterPlan."Demand Forecast 01 ST" - MasterPlan."Quantity Invoiced");
                end else
                    MasterPlan."Onhand Forecast 01 ST" := MasterPlan.Onhand + MasterPlan."Open Order 01 ST" + MasterPlan."Requisition Worksheet 01 ST";
                MasterPlan."Onhand Forecast 02 ST" := MasterPlan."Onhand Forecast 01 ST" + MasterPlan."Open Order 02 ST" + MasterPlan."Requisition Worksheet 02 ST" - MasterPlan."Demand Forecast 02 ST";
                MasterPlan."Onhand Forecast 03 ST" := MasterPlan."Onhand Forecast 02 ST" + MasterPlan."Open Order 03 ST" + MasterPlan."Requisition Worksheet 03 ST" - MasterPlan."Demand Forecast 03 ST";
                MasterPlan."Onhand Forecast 04 ST" := MasterPlan."Onhand Forecast 03 ST" + MasterPlan."Open Order 04 ST" + MasterPlan."Requisition Worksheet 04 ST" - MasterPlan."Demand Forecast 04 ST";
                MasterPlan."Onhand Forecast 05 ST" := MasterPlan."Onhand Forecast 04 ST" + MasterPlan."Open Order 05 ST" + MasterPlan."Requisition Worksheet 05 ST" - MasterPlan."Demand Forecast 05 ST";
                MasterPlan."Onhand Forecast 06 ST" := MasterPlan."Onhand Forecast 05 ST" + MasterPlan."Open Order 06 ST" + MasterPlan."Requisition Worksheet 06 ST" - MasterPlan."Demand Forecast 06 ST";
                MasterPlan."Onhand Forecast 07 ST" := MasterPlan."Onhand Forecast 06 ST" + MasterPlan."Open Order 07 ST" + MasterPlan."Requisition Worksheet 07 ST" - MasterPlan."Demand Forecast 07 ST";
                MasterPlan."Onhand Forecast 08 ST" := MasterPlan."Onhand Forecast 07 ST" + MasterPlan."Open Order 08 ST" + MasterPlan."Requisition Worksheet 08 ST" - MasterPlan."Demand Forecast 08 ST";
                MasterPlan."Onhand Forecast 09 ST" := MasterPlan."Onhand Forecast 08 ST" + MasterPlan."Open Order 09 ST" + MasterPlan."Requisition Worksheet 09 ST" - MasterPlan."Demand Forecast 09 ST";
                MasterPlan."Onhand Forecast 10 ST" := MasterPlan."Onhand Forecast 09 ST" + MasterPlan."Open Order 10 ST" + MasterPlan."Requisition Worksheet 10 ST" - MasterPlan."Demand Forecast 10 ST";
                MasterPlan."Onhand Forecast 11 ST" := MasterPlan."Onhand Forecast 10 ST" + MasterPlan."Open Order 11 ST" + MasterPlan."Requisition Worksheet 11 ST" - MasterPlan."Demand Forecast 11 ST";
                MasterPlan."Onhand Forecast 12 ST" := MasterPlan."Onhand Forecast 11 ST" + MasterPlan."Open Order 12 ST" + MasterPlan."Requisition Worksheet 12 ST" - MasterPlan."Demand Forecast 12 ST";

                MasterPlan.Insert();
            end;
            DataMaster.Close();
        end;
    end;

    local procedure CalcData()
    var
        DemandForecast: Record "ACC MP Demand Forecast";
        ForecastEntry: Query "ACC Forecast Combine Qry";
        RequisitionEntry: Query "ACC Requisition Combine Qry";
        PurchaseEntry: Query "ACC Purchase Combine Qry";
        InvoiceEntry: Query "ACC Sales Invoice Combine Qry";
        CreditMemosEntry: Query "ACC Sales Credit Combine Qry";
        InventoryEntry: Query "ACC MP Inventory Unlocked";
        LotEntry: Query "ACC MP Inventory Lotlocked";
        BinEntry: Query "ACC MP Inventory Binlocked";
        FromDate: Date;
        ToDate: Date;
        InvFromDate: Date;
        InvToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today());
        ToDate := CalcDate('+11M', FromDate);
        if Date2DMY(Today(), 2) = 7 then begin
            InvFromDate := CalcDate('-CM', Today());
            InvFromDate := CalcDate('-2M', InvFromDate);
            InvToDate := CalcDate('CM', Today());
        end else begin
            InvFromDate := CalcDate('-CM', Today());
            InvFromDate := CalcDate('-3M', InvFromDate);
            InvToDate := CalcDate('CM', Today());
        end;
        DemandForecast.Reset();
        DemandForecast.DeleteAll();
        ForecastEntry.SetRange(DeliveryDate, FromDate, ToDate);
        ForecastEntry.SetFilter(ItemNo, SelectItemNo);
        if ForecastEntry.Open() then begin
            while ForecastEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Business Unit" := ForecastEntry.BusinessUnitId;
                DemandForecast."Location Code" := ForecastEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(ForecastEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := ForecastEntry.ItemNo;
                DemandForecast."Forecast Date" := ForecastEntry.DeliveryDate;
                DemandForecast."Forecast Quantity" := ForecastEntry.Quantity;
                DemandForecast.Type := 'Demand';
                DemandForecast.Insert();
            end;
            ForecastEntry.Close();
        end;
        RequisitionEntry.SetRange(DeliveryDate, FromDate, ToDate);
        RequisitionEntry.SetFilter(ItemNo, SelectItemNo);
        if RequisitionEntry.Open() then begin
            while RequisitionEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Business Unit" := RequisitionEntry.BusinessUnitId;
                DemandForecast."Location Code" := RequisitionEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(RequisitionEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := RequisitionEntry.ItemNo;
                DemandForecast."Forecast Date" := RequisitionEntry.DeliveryDate;
                DemandForecast."Forecast Quantity" := RequisitionEntry.Quantity;
                DemandForecast.Type := 'Requisition';
                DemandForecast.Insert();
            end;
            RequisitionEntry.Close();
        end;

        PurchaseEntry.SetRange(DeliveryDate, FromDate, ToDate);
        PurchaseEntry.SetFilter(ItemNo, SelectItemNo);
        if PurchaseEntry.Open() then begin
            while PurchaseEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Business Unit" := PurchaseEntry.BusinessUnitId;
                DemandForecast."Location Code" := PurchaseEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(PurchaseEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := PurchaseEntry.ItemNo;
                DemandForecast."Forecast Date" := PurchaseEntry.DeliveryDate;
                DemandForecast."Forecast Quantity" := PurchaseEntry.Quantity;
                DemandForecast.Type := 'Purchase';
                DemandForecast.Insert();
            end;
            PurchaseEntry.Close();
        end;

        InvoiceEntry.SetRange(DeliveryDate, InvFromDate, InvToDate);
        InvoiceEntry.SetFilter(ItemNo, SelectItemNo);
        if InvoiceEntry.Open() then begin
            while InvoiceEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Business Unit" := InvoiceEntry.BusinessUnitId;
                DemandForecast."Location Code" := InvoiceEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(InvoiceEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := InvoiceEntry.ItemNo;
                DemandForecast."Forecast Date" := InvoiceEntry.DeliveryDate;
                DemandForecast."Forecast Quantity" := InvoiceEntry.Quantity;
                DemandForecast.Type := 'Invoice';
                DemandForecast.Insert();
            end;
            InvoiceEntry.Close();
        end;

        CreditMemosEntry.SetRange(DeliveryDate, InvFromDate, InvToDate);
        CreditMemosEntry.SetFilter(ItemNo, SelectItemNo);
        if CreditMemosEntry.Open() then begin
            while CreditMemosEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Business Unit" := CreditMemosEntry.BusinessUnitId;
                DemandForecast."Location Code" := CreditMemosEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(CreditMemosEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := CreditMemosEntry.ItemNo;
                DemandForecast."Forecast Date" := CreditMemosEntry.DeliveryDate;
                DemandForecast."Forecast Quantity" := CreditMemosEntry.Quantity;
                DemandForecast.Type := 'Memos';
                DemandForecast.Insert();
            end;
            CreditMemosEntry.Close();
        end;

        InventoryEntry.SetFilter(ItemNo, SelectItemNo);
        if InventoryEntry.Open() then begin
            while InventoryEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Location Code" := InventoryEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(InventoryEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := InventoryEntry.ItemNo;
                DemandForecast."Forecast Quantity" := InventoryEntry.Quantity;
                DemandForecast.Type := 'Unlocked';
                DemandForecast.Insert();
            end;
            InventoryEntry.Close();
        end;

        LotEntry.SetFilter(ItemNo, SelectItemNo);
        if LotEntry.Open() then begin
            while LotEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Location Code" := LotEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(LotEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := LotEntry.ItemNo;
                DemandForecast."Forecast Quantity" := LotEntry.Quantity;
                DemandForecast.Type := 'LotLocked';
                DemandForecast.Insert();
            end;
            LotEntry.Close();
        end;

        BinEntry.SetFilter(ItemNo, SelectItemNo);
        if BinEntry.Open() then begin
            while BinEntry.Read() do begin
                DemandForecast.Init();
                DemandForecast."Location Code" := BinEntry.LocationCode;
                DemandForecast."Site No." := CopyStr(BinEntry.LocationCode, 1, 2);
                DemandForecast."Item No." := BinEntry.ItemNo;
                DemandForecast."Forecast Quantity" := BinEntry.Quantity;
                DemandForecast.Type := 'BinLocked';
                DemandForecast.Insert();
            end;
            BinEntry.Close();
        end;
    end;

    local procedure GetCaptionPR(Months: Integer): Text
    var
        MonthDate: Date;
    begin
        if Months = 1 then begin
            MonthDate := CalcDate('-CM', Today);
        end else begin
            MonthDate := CalcDate('-CM', Today);
            MonthDate := CalcDate('+' + Format(Months - 1) + 'M', MonthDate);
        end;

        exit('PR Order ' + Format(MonthDate, 0, '<Month,2>/<Year4>'));
    end;

    local procedure GetCaptionPO(Months: Integer): Text
    var
        MonthDate: Date;
    begin
        if Months = 1 then begin
            MonthDate := CalcDate('-CM', Today);
        end else begin
            MonthDate := CalcDate('-CM', Today);
            MonthDate := CalcDate('+' + Format(Months - 1) + 'M', MonthDate);
        end;

        exit('PO Order ' + Format(MonthDate, 0, '<Month,2>/<Year4>'));
    end;

    local procedure GetCaptionDF(Months: Integer): Text
    var
        MonthDate: Date;
    begin
        if Months = 1 then begin
            MonthDate := CalcDate('-CM', Today);
        end else begin
            MonthDate := CalcDate('-CM', Today);
            MonthDate := CalcDate('+' + Format(Months - 1) + 'M', MonthDate);
        end;

        exit('Dự kiến bán hàng ' + Format(MonthDate, 0, '<Month,2>/<Year4>'));
    end;

    local procedure GetCaptionOF(Months: Integer): Text
    var
        MonthDate: Date;
    begin
        if Months = 1 then begin
            MonthDate := CalcDate('-CM', Today);
        end else begin
            MonthDate := CalcDate('-CM', Today);
            MonthDate := CalcDate('+' + Format(Months - 1) + 'M', MonthDate);
        end;

        exit('Dự kiến tồn kho ' + Format(MonthDate, 0, '<Month,2>/<Year4>'));
    end;

    var
        SelectItemNo: Text;

}
