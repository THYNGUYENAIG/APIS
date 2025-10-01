codeunit 51011 "ACC MP Forecast Reminder"
{
    TableNo = "Production Forecast Entry";

    trigger OnRun()
    begin
        ExportForecastEntry();
    end;

    procedure ExportForecastEntry()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;

        ItemTbl: Record Item;
        CustTbl: Record Customer;
        Salesperson: Record "Salesperson/Purchaser";

        SalesForecast: Record "BLACC Forecast Entry";
        //ForecastEntry: Record "Production Forecast Entry";
        ForecastEntry: Query "ACC MP Forecast Entry";
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        AgreementEntry: Query "ACC Agreement Entry Qry";
        CustGroupEntry: Query "ACC Forecast Cust Group Entry";
        AgreementGroupEntry: Query "ACC Forecast SA Group Entry";

        ExcelBufferTmp: Record "Excel Buffer" temporary;
        ExcelFileName: Label 'ACC/Planning/%1_AllForecast.xlsx';

        SPOFileID: Text;
        OverDue: Integer;

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        FileContent: InStream;
        FileName: Text;
        MimeType: Text;

        JsonObject: JsonObject;
        JsonText: Text;

        FromDate: Date;
        ToDate: Date;

        StartDate: Date;
        EndDate: Date;

        ValidFrom: Date;
        ValidTo: Date;

        ParentEntryNo: Integer;
        AddColumns: List of [Integer];

        SalesAmount: Decimal;
        ForecQuantity: Decimal;
        ShippQuantity: Decimal;
        SalesQuantity: Decimal;
        CustGroup: Text;
        AgreementGroup: Text;
        FirstDateOfMonth: Date;
        AgreementForecast: Boolean;
        NoncommitForecast: Boolean;
    begin
        FirstDateOfMonth := CalcDate('<-CM>', Today);
        MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        FromDate := CalcDate('-CM', Today());
        ToDate := CalcDate('+14M', FromDate);
        ToDate := CalcDate('CM', ToDate);

        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelHeader(ExcelBufferTmp);
        // SA
        SalesForecast.Reset();
        SalesForecast.SetCurrentKey("Entry No.", "BLACC Shortcut Dim 2 Code");
        SalesForecast.SetRange("No SA", false);
        SalesForecast.SetFilter("BLACC Sales Pool", '0|2');
        SalesForecast.SetFilter("BLACC Agreement EndDate", '%1..', CalcDate('-CM', Today));
        SalesForecast.SetFilter("BLACC Shortcut Dim 2 Code", '<>%1', '3*');
        SalesForecast.SetFilter("No.", '<>%1', '');
        SalesForecast.SetAutoCalcFields("External Document No.", "BLACC Total Current Forecast", "BLACC Outstanding Qty. (SO)", "BLACC Sell-to Sales Pool", "BLACC Sell-to Customer Name", "BLACC Planner", "Lead Time Calculation");
        if SalesForecast.FindSet() then begin
            repeat
                //if SalesForecast.GetRemainingQty() > 0 then begin
                ItemTbl.SetAutoCalcFields("BLACC Vendor Name");
                ItemTbl.Get(SalesForecast."No.");
                AgreementForecast := true;
                ParentEntryNo := 0;
                ForecastEntry.SetRange(ParentEntry, SalesForecast."Entry No.");
                ForecastEntry.SetRange(ForecastDate, FromDate, ToDate);
                if ForecastEntry.Open() then begin
                    while ForecastEntry.Read() do begin
                        AgreementForecast := false;
                        if ParentEntryNo <> ForecastEntry.ParentEntry then begin
                            Clear(AddColumns);
                            ValidFrom := CalcDate('-CM', Today());
                            ValidFrom := CalcDate('-3M', ValidFrom);
                            ValidTo := CalcDate('CM', ValidFrom);
                            ForecQuantity := 0;
                            ShippQuantity := 0;
                            SalesQuantity := 0;
                            ExcelBufferTmp.NewRow();
                            ExcelBufferTmp.AddColumn(SalesForecast."Entry No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            if SalesForecast."No SA" then begin
                                ExcelBufferTmp.AddColumn('Non-committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end else begin
                                ExcelBufferTmp.AddColumn('Committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end;
                            ExcelBufferTmp.AddColumn(SalesForecast."No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast.Description, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            if CustTbl.Get(SalesForecast."BLACC Sell-to Customer No.") then begin
                                CustGroup := CustTbl."BLACC Customer Group";
                                AgreementGroup := CustTbl."BLACC Owner Group";
                            end else begin
                                CustGroup := '';
                                AgreementGroup := '';
                            end;
                            ExcelBufferTmp.AddColumn(CustGroup, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(ItemTbl."BLACC Vendor Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ExcelBufferTmp.AddColumn(CopyStr(SalesForecast."Location Code", 1, 2), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."Location Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Shortcut Dim 2 Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Salesperson Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            if Salesperson.Get(SalesForecast."BLACC Salesperson Code") then begin
                                ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end else begin
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end;
                            if SalesForecast."BLACC Sales Agreement No." = 'SALESTOOL2SALESORDER' then begin
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end else
                                ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Agreement No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Planner", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."Lead Time Calculation", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Quantity Shipped", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Outstanding Qty. (SO)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Total Current Forecast", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement StartDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement EndDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            if SalesForecast."No SA" = false then begin
                                ExcelBufferTmp.AddColumn(SalesForecast."BLACC Min Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                ExcelBufferTmp.AddColumn(SalesForecast."BLACC Max Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                ExcelBufferTmp.AddColumn(SalesForecast."BLACC Remaining Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            // M-3
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-2                                    
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-1
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-0                                    
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        end;
                        // 0
                        StartDate := CalcDate('-CM', Today());
                        EndDate := CalcDate('CM', Today());
                        if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                            ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            AddColumns.Add(1);
                        end;
                        // 1
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                            AddColumns.Add(2);
                            if AddColumns.Count() = 1 then begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        end;
                        // 2
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 3);
                        // 3
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 4);
                        // 4
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 5);
                        // 5
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 6);
                        // 6
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 7);
                        // 7
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 8);
                        // 8
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 9);
                        // 9
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 10);
                        // 10
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 11);
                        // 11
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 12);
                        // 12
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 13);
                        // 13
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 14);
                        // 14
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 15);

                        ParentEntryNo := ForecastEntry.ParentEntry;
                    end;
                    ForecastEntry.Close();
                end;
                if AgreementForecast then begin
                    ValidFrom := CalcDate('-CM', Today());
                    ValidFrom := CalcDate('-3M', ValidFrom);
                    ValidTo := CalcDate('CM', ValidFrom);
                    ForecQuantity := 0;
                    ShippQuantity := 0;
                    SalesQuantity := 0;
                    ExcelBufferTmp.NewRow();
                    ExcelBufferTmp.AddColumn(SalesForecast."Entry No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn('Committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast.Description, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    if CustTbl.Get(SalesForecast."BLACC Sell-to Customer No.") then begin
                        CustGroup := CustTbl."BLACC Customer Group";
                        AgreementGroup := CustTbl."BLACC Owner Group";
                    end else begin
                        CustGroup := '';
                        AgreementGroup := '';
                    end;
                    ExcelBufferTmp.AddColumn(CustGroup, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ItemTbl."BLACC Vendor Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                    ExcelBufferTmp.AddColumn(CopyStr(SalesForecast."Location Code", 1, 2), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."Location Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Shortcut Dim 2 Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Salesperson Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    if Salesperson.Get(SalesForecast."BLACC Salesperson Code") then begin
                        ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end else begin
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end;
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Agreement No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Planner", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."Lead Time Calculation", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Quantity Shipped", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Outstanding Qty. (SO)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Total Current Forecast", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement StartDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement EndDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Min Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Max Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Remaining Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-3
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-2                                    
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-1
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-0                                    
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                    // 0
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 1
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 2
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 3
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 4
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 5
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 6
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 7
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 8
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 9
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 10
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 11
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 12
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 13
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 14
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                end;
            //end;
            until SalesForecast.Next() = 0;
        end;
        // No SA
        SalesForecast.Reset();
        SalesForecast.SetCurrentKey("BLACC Shortcut Dim 2 Code", "Entry No.");
        SalesForecast.SetRange("No SA", true);
        SalesForecast.SetFilter("BLACC Sell-to Customer No.", '<>%1', '');
        SalesForecast.SetFilter("No.", '<>%1', '');
        SalesForecast.SetFilter("BLACC Salesperson Code", '<>%1', '');
        SalesForecast.SetFilter("BLACC Shortcut Dim 1 Code", '<>%1', '');
        SalesForecast.SetFilter("BLACC Shortcut Dim 2 Code", '<>%1', '3*');
        SalesForecast.SetAutoCalcFields("External Document No.", "BLACC Total Current Forecast", "BLACC Outstanding Qty. (SO)", "BLACC Sell-to Sales Pool", "BLACC Sell-to Customer Name", "BLACC Planner", "Lead Time Calculation");
        if SalesForecast.FindSet() then begin
            repeat
                //if SalesForecast.GetRemainingQty() > 0 then begin
                ItemTbl.SetAutoCalcFields("BLACC Vendor Name");
                ItemTbl.Get(SalesForecast."No.");
                NoncommitForecast := true;
                ParentEntryNo := 0;
                ForecastEntry.SetRange(ParentEntry, SalesForecast."Entry No.");
                ForecastEntry.SetRange(ForecastDate, FromDate, ToDate);
                if ForecastEntry.Open() then begin
                    while ForecastEntry.Read() do begin
                        NoncommitForecast := false;
                        if ParentEntryNo <> ForecastEntry.ParentEntry then begin
                            Clear(AddColumns);
                            ValidFrom := CalcDate('-CM', Today());
                            ValidFrom := CalcDate('-3M', ValidFrom);
                            ValidTo := CalcDate('CM', ValidFrom);
                            ForecQuantity := 0;
                            ShippQuantity := 0;
                            SalesQuantity := 0;
                            ExcelBufferTmp.NewRow();
                            ExcelBufferTmp.AddColumn(SalesForecast."Entry No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn('Non-committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast.Description, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            if CustTbl.Get(SalesForecast."BLACC Sell-to Customer No.") then begin
                                CustGroup := CustTbl."BLACC Customer Group";
                                AgreementGroup := CustTbl."BLACC Owner Group";
                            end else begin
                                CustGroup := '';
                                AgreementGroup := '';
                            end;
                            ExcelBufferTmp.AddColumn(CustGroup, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(ItemTbl."BLACC Vendor Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ExcelBufferTmp.AddColumn(CopyStr(SalesForecast."Location Code", 1, 2), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."Location Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Shortcut Dim 2 Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Salesperson Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            if Salesperson.Get(SalesForecast."BLACC Salesperson Code") then begin
                                ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end else begin
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end;
                            if SalesForecast."BLACC Sales Agreement No." = 'SALESTOOL2SALESORDER' then begin
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            end else
                                ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Agreement No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Planner", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."Lead Time Calculation", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Quantity Shipped", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Outstanding Qty. (SO)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Total Current Forecast", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement StartDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement EndDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-3
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-2                                    
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-1
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            // M-0                                    
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                            ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        end;
                        // 0
                        StartDate := CalcDate('-CM', Today());
                        EndDate := CalcDate('CM', Today());
                        if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                            ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            AddColumns.Add(1);
                        end;
                        // 1
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                            AddColumns.Add(2);
                            if AddColumns.Count() = 1 then begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        end;
                        // 2
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 3);
                        // 3
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 4);
                        // 4
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 5);
                        // 5
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 6);
                        // 6
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 7);
                        // 7
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 8);
                        // 8
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 9);
                        // 9
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 10);
                        // 10
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 11);
                        // 11
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 12);
                        // 12
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 13);
                        // 13
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 14);
                        // 14
                        StartDate := CalcDate('+1D', EndDate);
                        EndDate := CalcDate('CM', StartDate);
                        AddForecastLine(ForecastEntry.ForecastDate, ForecastEntry.ForecastQuantity, StartDate, EndDate, ExcelBufferTmp, AddColumns, 15);

                        ParentEntryNo := ForecastEntry.ParentEntry;
                    end;
                    ForecastEntry.Close();
                end;
                if NoncommitForecast then begin
                    ValidFrom := CalcDate('-CM', Today());
                    ValidFrom := CalcDate('-3M', ValidFrom);
                    ValidTo := CalcDate('CM', ValidFrom);
                    ForecQuantity := 0;
                    ShippQuantity := 0;
                    SalesQuantity := 0;
                    ExcelBufferTmp.NewRow();
                    ExcelBufferTmp.AddColumn(SalesForecast."Entry No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn('Non-committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast.Description, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Customer Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    if CustTbl.Get(SalesForecast."BLACC Sell-to Customer No.") then begin
                        CustGroup := CustTbl."BLACC Customer Group";
                        AgreementGroup := CustTbl."BLACC Owner Group";
                    end else begin
                        CustGroup := '';
                        AgreementGroup := '';
                    end;
                    ExcelBufferTmp.AddColumn(CustGroup, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ItemTbl."BLACC Vendor Name", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                    ExcelBufferTmp.AddColumn(CopyStr(SalesForecast."Location Code", 1, 2), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."Location Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Shortcut Dim 2 Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Salesperson Code", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    if Salesperson.Get(SalesForecast."BLACC Salesperson Code") then begin
                        ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end else begin
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end;
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Agreement No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Planner", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."Lead Time Calculation", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Quantity Shipped", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Outstanding Qty. (SO)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Total Current Forecast", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(SalesForecast."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement StartDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                    ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement EndDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                    ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-3
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-2                                    
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-1
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-0                                    
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    SalesAmount := SalesAmount(SalesForecast."BLACC Shortcut Dim 2 Code", SalesForecast."BLACC Sell-to Customer No.", SalesForecast."No.", SalesForecast."BLACC Sales Agreement No.", SalesForecast."BLACC Salesperson Code", SalesForecast."Location Code", ValidFrom, ValidTo, AgreementGroup, CustGroup);
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                    // 0
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 1
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 2
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 3
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 4
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 5
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 6
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 7
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 8
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 9
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 10
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 11
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 12
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 13
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    // 14
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                end;
            //end;
            until SalesForecast.Next() = 0;
        end;
        ExcelFooter(ExcelBufferTmp);

        Clear(TempBlob);
        FileName := StrSubstNo(ExcelFileName, Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
        TempBlob.CreateOutStream(OutStr);
        ExcelBufferTmp.SaveToStream(OutStr, true);
        TempBlob.CreateInStream(FileContent);
        UploadFilesSPO(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', FileContent, FileName, MimeType);
    end;

    procedure ExportExcelSPO()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;

        ItemTbl: Record Item;
        CustTbl: Record Customer;
        Salesperson: Record "Salesperson/Purchaser";

        SalesForecast: Record "BLACC Forecast Entry";
        ForecastEntry: Query "ACC Forecast Entry Qry";
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        AgreementEntry: Query "ACC Agreement Entry Qry";
        CustGroupEntry: Query "ACC Forecast Cust Group Entry";
        AgreementGroupEntry: Query "ACC Forecast SA Group Entry";

        ExcelBufferTmp: Record "Excel Buffer" temporary;
        ExcelFileName: Label 'ACC/Planning/%1_AllForecast.xlsx';

        SPOFileID: Text;
        OverDue: Integer;

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        FileContent: InStream;
        FileName: Text;
        MimeType: Text;

        JsonObject: JsonObject;
        JsonText: Text;

        FromDate: Date;
        ToDate: Date;

        StartDate: Date;
        EndDate: Date;

        ValidFrom: Date;
        ValidTo: Date;

        TempTxt: Text;
        CompTxt: Text;
        AddColumns: List of [Integer];
        StepIndex: Integer;
        LastIndex: Integer;
        IIndex: Integer;
        ICount: Integer;
        SalesAmount: Decimal;
        ForecQuantity: Decimal;
        ShippQuantity: Decimal;
        SalesQuantity: Decimal;
        CustGroup: Text;
        AgreementGroup: Text;
    begin
        MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        FromDate := CalcDate('-CM', Today());
        ToDate := CalcDate('+14M', FromDate);
        ToDate := CalcDate('CM', ToDate);

        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelBufferTmp.NewRow();
        ExcelBufferTmp.AddColumn('Parent Entry No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Type', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Description', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sell-to Customer No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sell-to Customer Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Customer Group', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Agreement Group', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sell-to Sales Pool', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sales Pool', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Branch Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Location Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('BU Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Salesperson Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Salesperson Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sales Agreement No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Planner', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Lead Time Calculation', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Quantity Shipped', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('SO Blacklog', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Total Current Forecast', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('External Document No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Agreement Start Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Agreement End Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Min Quantity', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Max Quantity', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Remaining Quantity', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-3', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-2', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-1', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-0', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 0
        ExcelBufferTmp.AddColumn(Format(Today(), 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 1
        StartDate := CalcDate('CM+1D', Today());
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 2
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 3
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 4
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 5
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 6
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 7
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 8
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 9
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 10
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 11
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 12
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 13
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 14
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

        ForecastEntry.SetRange(ForecastDate, FromDate, ToDate);
        if ForecastEntry.Open() then begin
            while ForecastEntry.Read() do begin
                CompTxt := StrSubstNo('%1%2%3%4%5', ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalespersonCode, ForecastEntry.SalesAgreementNo, ForecastEntry.LocationCode);
                if TempTxt <> CompTxt then begin
                    Clear(AddColumns);
                    ValidFrom := CalcDate('-CM', Today());
                    ValidFrom := CalcDate('-3M', ValidFrom);
                    ValidTo := CalcDate('CM', ValidFrom);
                    ForecQuantity := 0;
                    ShippQuantity := 0;
                    SalesQuantity := 0;
                    ExcelBufferTmp.NewRow();
                    ExcelBufferTmp.AddColumn(ForecastEntry.ParentEntry, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    if ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER' then begin
                        ExcelBufferTmp.AddColumn('Committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end else begin
                        ExcelBufferTmp.AddColumn('Non-committed', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ItemNo, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ForecastEntry.ItemName, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ForecastEntry.CustomerNo, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ForecastEntry.CustomerName, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                    if CustTbl.Get(ForecastEntry.CustomerNo) then begin
                        CustGroup := CustTbl."BLACC Customer Group";
                        AgreementGroup := CustTbl."BLACC Owner Group";
                    end else begin
                        CustGroup := '';
                        AgreementGroup := '';
                    end;
                    ExcelBufferTmp.AddColumn(CustGroup, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(AgreementGroup, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                    SalesForecast.Reset();
                    SalesForecast.SetRange("Entry No.", ForecastEntry.ParentEntry);
                    SalesForecast.SetAutoCalcFields("BLACC Sell-to Sales Pool");
                    if SalesForecast.FindFirst() then begin
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sell-to Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Sales Pool", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end else begin
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end;
                    ExcelBufferTmp.AddColumn(CopyStr(ForecastEntry.LocationCode, 1, 2), false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ForecastEntry.LocationCode, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ForecastEntry.BusinessUnitId, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    ExcelBufferTmp.AddColumn(ForecastEntry.SalespersonCode, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    if Salesperson.Get(ForecastEntry.SalespersonCode) then begin
                        ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end else begin
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end;
                    if ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER' then begin
                        ExcelBufferTmp.AddColumn(ForecastEntry.SalesAgreementNo, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end else begin
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                    end;
                    if ItemTbl.Get(ForecastEntry.ItemNo) then begin
                        ExcelBufferTmp.AddColumn(ItemTbl."BLACC Planner", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn(ItemTbl."Lead Time Calculation", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    end;

                    SalesForecast.Reset();
                    SalesForecast.SetRange("Entry No.", ForecastEntry.ParentEntry);
                    SalesForecast.SetAutoCalcFields("External Document No.", "BLACC Total Current Forecast", "BLACC Outstanding Qty. (SO)");
                    if SalesForecast.FindFirst() then begin
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Quantity Shipped", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Outstanding Qty. (SO)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Total Current Forecast", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        ExcelBufferTmp.AddColumn(SalesForecast."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement StartDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                        ExcelBufferTmp.AddColumn(SalesForecast."BLACC Agreement EndDate", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                        if ForecastEntry.SalesAgreementNo <> 'SALESTOOL2SALESORDER' then begin
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Min Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Max Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(SalesForecast."BLACC Remaining Quantity", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        end else begin
                            //ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            //ExcelBufferTmp.AddColumn(0D, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            //ExcelBufferTmp.AddColumn(0D, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    // M-3
                    SalesAmount := 0;
                    if ForecastEntry.CustomerNo = '90000000' then begin
                        SalesAmount := GeneralGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                    end else begin
                        if (AgreementGroup = '') AND (CustGroup = '') then begin
                            SalesAmount := RealSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                        end else begin
                            if AgreementGroup <> '' then begin
                                if AgreementGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := AgreementGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                            if AgreementGroup = '' then begin
                                if CustGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := CustGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-2
                    SalesAmount := 0;
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    if ForecastEntry.CustomerNo = '90000000' then begin
                        SalesAmount := GeneralGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                    end else begin
                        if (AgreementGroup = '') AND (CustGroup = '') then begin
                            SalesAmount := RealSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                        end else begin
                            if AgreementGroup <> '' then begin
                                if AgreementGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := AgreementGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                            if AgreementGroup = '' then begin
                                if CustGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := CustGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-1
                    SalesAmount := 0;
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    if ForecastEntry.CustomerNo = '90000000' then begin
                        SalesAmount := GeneralGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                    end else begin
                        if (AgreementGroup = '') AND (CustGroup = '') then begin
                            SalesAmount := RealSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                        end else begin
                            if AgreementGroup <> '' then begin
                                if AgreementGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := AgreementGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                            if AgreementGroup = '' then begin
                                if CustGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := CustGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    // M-0
                    SalesAmount := 0;
                    ValidFrom := CalcDate('+1D', ValidTo);
                    ValidTo := CalcDate('CM', ValidFrom);
                    if ForecastEntry.CustomerNo = '90000000' then begin
                        SalesAmount := GeneralGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                    end else begin
                        if (AgreementGroup = '') AND (CustGroup = '') then begin
                            SalesAmount := RealSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                        end else begin
                            if AgreementGroup <> '' then begin
                                if AgreementGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := AgreementGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                            if AgreementGroup = '' then begin
                                if CustGroup = ForecastEntry.CustomerNo then begin
                                    SalesAmount := CustGroupSalesAmount(ForecastEntry.BusinessUnitId, ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalesAgreementNo, ForecastEntry.SalespersonCode, ForecastEntry.LocationCode, ValidFrom, ValidTo);
                                end;
                            end;
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(SalesAmount, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                end;
                // 0
                StartDate := CalcDate('-CM', Today());
                EndDate := CalcDate('CM', Today());
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                    AddColumns.Add(1);
                end;
                // 1
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(2);
                    if AddColumns.Count() = 1 then begin
                        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                end;
                // 2
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(3);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex;
                        if ICount > 1 then begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end else begin
                        for IIndex := 1 to 2 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                end;
                // 3
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(4);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 3 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 4
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(5);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 4 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 5
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(6);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 5 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 6
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(7);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 6 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 7
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(8);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 7 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 8
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(9);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 8 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 9
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(10);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 9 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 10
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(11);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 10 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 11
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(12);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 11 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 12
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(13);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 12 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 13
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(14);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 13 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                // 14
                StartDate := CalcDate('+1D', EndDate);
                EndDate := CalcDate('CM', StartDate);
                if (ForecastEntry.ForecastDate >= StartDate) AND (ForecastEntry.ForecastDate <= EndDate) then begin
                    AddColumns.Add(15);
                    if AddColumns.Count() > 1 then begin
                        LastIndex := AddColumns.Get(AddColumns.Count());
                        StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                        ICount := LastIndex - StepIndex - 1;
                        if ICount >= 1 then begin
                            for IIndex := 1 to ICount do begin
                                ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                        end;
                    end else begin
                        for IIndex := 1 to 14 do begin
                            ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        end;
                    end;
                    ExcelBufferTmp.AddColumn(ForecastEntry.ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);

                end;
                TempTxt := StrSubstNo('%1%2%3%4%5', ForecastEntry.CustomerNo, ForecastEntry.ItemNo, ForecastEntry.SalespersonCode, ForecastEntry.SalesAgreementNo, ForecastEntry.LocationCode);
            end;
            ForecastEntry.Close();
        end;
        ExcelBufferTmp.CreateNewBook('Planning');
        ExcelBufferTmp.WriteSheet('Planning', 'ACC', UserId);

        ExcelBufferTmp.SetColumnWidth('A', 15);
        ExcelBufferTmp.SetColumnWidth('B', 15);
        ExcelBufferTmp.SetColumnWidth('C', 15);
        ExcelBufferTmp.SetColumnWidth('D', 100);
        ExcelBufferTmp.SetColumnWidth('E', 15);
        ExcelBufferTmp.SetColumnWidth('F', 100);
        ExcelBufferTmp.SetColumnWidth('G', 15);
        ExcelBufferTmp.SetColumnWidth('H', 15);
        ExcelBufferTmp.SetColumnWidth('I', 15);
        ExcelBufferTmp.SetColumnWidth('J', 15);

        ExcelBufferTmp.SetColumnWidth('K', 15);
        ExcelBufferTmp.SetColumnWidth('L', 15);
        ExcelBufferTmp.SetColumnWidth('M', 15);
        ExcelBufferTmp.SetColumnWidth('N', 15);
        ExcelBufferTmp.SetColumnWidth('O', 25);
        ExcelBufferTmp.SetColumnWidth('P', 25);
        ExcelBufferTmp.SetColumnWidth('Q', 20);
        ExcelBufferTmp.SetColumnWidth('R', 20);
        ExcelBufferTmp.SetColumnWidth('S', 20);
        ExcelBufferTmp.SetColumnWidth('T', 20);

        ExcelBufferTmp.SetColumnWidth('U', 20);
        ExcelBufferTmp.SetColumnWidth('V', 20);
        ExcelBufferTmp.SetColumnWidth('W', 20);
        ExcelBufferTmp.SetColumnWidth('X', 20);
        ExcelBufferTmp.SetColumnWidth('Y', 20);
        ExcelBufferTmp.SetColumnWidth('Z', 20);
        ExcelBufferTmp.SetColumnWidth('AA', 20);
        ExcelBufferTmp.SetColumnWidth('AB', 20);
        ExcelBufferTmp.SetColumnWidth('AC', 20);
        ExcelBufferTmp.SetColumnWidth('AD', 20);

        ExcelBufferTmp.SetColumnWidth('AE', 20);
        ExcelBufferTmp.SetColumnWidth('AF', 20);
        ExcelBufferTmp.SetColumnWidth('AG', 20);
        ExcelBufferTmp.SetColumnWidth('AH', 20);
        ExcelBufferTmp.SetColumnWidth('AI', 20);
        ExcelBufferTmp.SetColumnWidth('AJ', 20);
        ExcelBufferTmp.SetColumnWidth('AK', 20);
        ExcelBufferTmp.SetColumnWidth('AL', 20);
        ExcelBufferTmp.SetColumnWidth('AM', 20);
        ExcelBufferTmp.SetColumnWidth('AN', 20);

        ExcelBufferTmp.SetColumnWidth('AO', 20);
        ExcelBufferTmp.SetColumnWidth('AP', 20);
        ExcelBufferTmp.SetColumnWidth('AQ', 20);
        ExcelBufferTmp.SetColumnWidth('AR', 20);
        ExcelBufferTmp.SetColumnWidth('AS', 20);
        ExcelBufferTmp.SetColumnWidth('AT', 20);
        ExcelBufferTmp.CloseBook();

        Clear(TempBlob);
        FileName := StrSubstNo(ExcelFileName, Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
        TempBlob.CreateOutStream(OutStr);
        ExcelBufferTmp.SaveToStream(OutStr, true);
        TempBlob.CreateInStream(FileContent);
        UploadFilesSPO(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', FileContent, FileName, MimeType);
    end;

    local procedure UploadFilesSPO(OauthToken: SecretText; SiteId: Text; DriveId: Text; FileContent: InStream; FileName: Text; MimeType: Text): Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;
        FileId: Text;
    begin
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/root:/%3:/content', SiteId, DriveId, FileName);
        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'PUT';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', MimeType);
        HttpRequestMessage.Content.WriteFrom(FileContent);

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging            
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                if JsonResponse.Get('id', JsonToken) then begin
                    if not JsonToken.AsValue().IsNull then begin
                        exit(JsonToken.AsValue().AsText());
                    end;
                end;
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to upload files to SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
        exit('');
    end;

    local procedure ExcelHeader(var ExcelBufferTmp: Record "Excel Buffer" temporary)
    var
        StartDate: Date;
    begin
        ExcelBufferTmp.NewRow();
        ExcelBufferTmp.AddColumn('Parent Entry No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Type', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Description', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sell-to Customer No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sell-to Customer Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Customer Group', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Vendor Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sell-to Sales Pool', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sales Pool', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Branch Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Location Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('BU Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Salesperson Code', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Salesperson Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Sales Agreement No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Planner', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Lead Time Calculation', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Quantity Shipped', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('SO Blacklog', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Total Current Forecast', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('External Document No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Agreement Start Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Agreement End Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Min Quantity', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Max Quantity', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Remaining Quantity', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-3', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-2', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-1', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('M-0', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 0
        ExcelBufferTmp.AddColumn(Format(Today(), 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 1
        StartDate := CalcDate('CM+1D', Today());
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 2
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 3
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 4
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 5
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 6
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 7
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 8
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 9
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 10
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 11
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 12
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 13
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 14
        StartDate := CalcDate('CM+1D', StartDate);
        ExcelBufferTmp.AddColumn(Format(StartDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
    end;

    local procedure ExcelFooter(var ExcelBufferTmp: Record "Excel Buffer" temporary)
    var
    begin
        ExcelBufferTmp.CreateNewBook('Planning');
        ExcelBufferTmp.WriteSheet('Planning', 'ACC', UserId);

        ExcelBufferTmp.SetColumnWidth('A', 15);
        ExcelBufferTmp.SetColumnWidth('B', 15);
        ExcelBufferTmp.SetColumnWidth('C', 15);
        ExcelBufferTmp.SetColumnWidth('D', 100);
        ExcelBufferTmp.SetColumnWidth('E', 15);
        ExcelBufferTmp.SetColumnWidth('F', 100);
        ExcelBufferTmp.SetColumnWidth('G', 15);
        ExcelBufferTmp.SetColumnWidth('H', 15);
        ExcelBufferTmp.SetColumnWidth('I', 15);
        ExcelBufferTmp.SetColumnWidth('J', 15);

        ExcelBufferTmp.SetColumnWidth('K', 15);
        ExcelBufferTmp.SetColumnWidth('L', 15);
        ExcelBufferTmp.SetColumnWidth('M', 15);
        ExcelBufferTmp.SetColumnWidth('N', 15);
        ExcelBufferTmp.SetColumnWidth('O', 25);
        ExcelBufferTmp.SetColumnWidth('P', 25);
        ExcelBufferTmp.SetColumnWidth('Q', 20);
        ExcelBufferTmp.SetColumnWidth('R', 20);
        ExcelBufferTmp.SetColumnWidth('S', 20);
        ExcelBufferTmp.SetColumnWidth('T', 20);

        ExcelBufferTmp.SetColumnWidth('U', 20);
        ExcelBufferTmp.SetColumnWidth('V', 20);
        ExcelBufferTmp.SetColumnWidth('W', 20);
        ExcelBufferTmp.SetColumnWidth('X', 20);
        ExcelBufferTmp.SetColumnWidth('Y', 20);
        ExcelBufferTmp.SetColumnWidth('Z', 20);
        ExcelBufferTmp.SetColumnWidth('AA', 20);
        ExcelBufferTmp.SetColumnWidth('AB', 20);
        ExcelBufferTmp.SetColumnWidth('AC', 20);
        ExcelBufferTmp.SetColumnWidth('AD', 20);

        ExcelBufferTmp.SetColumnWidth('AE', 20);
        ExcelBufferTmp.SetColumnWidth('AF', 20);
        ExcelBufferTmp.SetColumnWidth('AG', 20);
        ExcelBufferTmp.SetColumnWidth('AH', 20);
        ExcelBufferTmp.SetColumnWidth('AI', 20);
        ExcelBufferTmp.SetColumnWidth('AJ', 20);
        ExcelBufferTmp.SetColumnWidth('AK', 20);
        ExcelBufferTmp.SetColumnWidth('AL', 20);
        ExcelBufferTmp.SetColumnWidth('AM', 20);
        ExcelBufferTmp.SetColumnWidth('AN', 20);

        ExcelBufferTmp.SetColumnWidth('AO', 20);
        ExcelBufferTmp.SetColumnWidth('AP', 20);
        ExcelBufferTmp.SetColumnWidth('AQ', 20);
        ExcelBufferTmp.SetColumnWidth('AR', 20);
        ExcelBufferTmp.SetColumnWidth('AS', 20);
        ExcelBufferTmp.SetColumnWidth('AT', 20);
        ExcelBufferTmp.CloseBook();
    end;

    local procedure SalesAmount(BusinessID: Text; CustId: Text; ItemId: Text; AgreementId: Text; SalespersonId: Text; LocationId: Text; FromDate: Date; ToDate: Date; AgreementGroup: Text; CustGroup: Text): Decimal
    var
        SalesAmount: Decimal;
    begin
        if CustId = '90000000' then begin
            SalesAmount := GeneralGroupSalesAmount(BusinessID, CustId, ItemId, AgreementId, SalespersonId, LocationId, FromDate, ToDate);
        end else begin
            if (AgreementGroup = '') AND (CustGroup = '') then begin
                SalesAmount := RealSalesAmount(BusinessID, CustId, ItemId, AgreementId, SalespersonId, LocationId, FromDate, ToDate);
            end else begin
                if AgreementGroup <> '' then begin
                    SalesAmount := AgreementGroupSalesAmount(BusinessID, AgreementGroup, ItemId, AgreementId, SalespersonId, LocationId, FromDate, ToDate);
                end else begin
                    if CustGroup <> '' then begin
                        SalesAmount := CustGroupSalesAmount(BusinessID, CustGroup, ItemId, AgreementId, SalespersonId, LocationId, FromDate, ToDate);
                    end;
                end;
            end;
        end;
        exit(SalesAmount);
    end;

    local procedure RealSalesAmount(BusinessID: Text; CustId: Text; ItemId: Text; AgreementId: Text; SalespersonId: Text; LocationId: Text; FromDate: Date; ToDate: Date): Decimal
    var
        InvoiceEntry: Query "ACC Invoice Entry Qry";
        CreditMemos: Query "ACC Credit Memos Entry Qry";
        SalesAmount: Decimal;
        AgreementFilter: Text;
    begin
        AgreementFilter := StrSubstNo('%1|''''', 'SALESTOOL2SALESORDER');
        SalesAmount := 0;
        InvoiceEntry.SetRange(BusinessUnitID, BusinessID);
        InvoiceEntry.SetRange(CustomerNo, CustId);
        InvoiceEntry.SetRange(ItemNo, ItemId);
        if (AgreementId <> 'SALESTOOL2SALESORDER') AND (AgreementId <> '') then begin
            InvoiceEntry.SetRange(AgreementNo, AgreementId);
        end else begin
            InvoiceEntry.SetFilter(AgreementNo, AgreementFilter);
        end;
        InvoiceEntry.SetRange(SalespersonCode, SalespersonId);
        InvoiceEntry.SetRange(PostingDate, FromDate, ToDate);
        if InvoiceEntry.Open() then begin
            while InvoiceEntry.Read() do begin
                if CopyStr(LocationId, 1, 2) = CopyStr(InvoiceEntry.LocationCode, 1, 2) then
                    SalesAmount := SalesAmount + InvoiceEntry.Quantity;
            end;
            InvoiceEntry.Close();
        end;

        CreditMemos.SetRange(BusinessUnitID, BusinessID);
        CreditMemos.SetRange(CustomerNo, CustId);
        CreditMemos.SetRange(ItemNo, ItemId);
        if (AgreementId <> 'SALESTOOL2SALESORDER') AND (AgreementId <> '') then begin
            CreditMemos.SetRange(AgreementNo, AgreementId);
        end else begin
            CreditMemos.SetFilter(AgreementNo, AgreementFilter);
        end;
        CreditMemos.SetRange(SalespersonCode, SalespersonId);
        CreditMemos.SetRange(PostingDate, FromDate, ToDate);
        if CreditMemos.Open() then begin
            while CreditMemos.Read() do begin
                if CopyStr(LocationId, 1, 2) = CopyStr(CreditMemos.LocationCode, 1, 2) then
                    SalesAmount := SalesAmount + CreditMemos.Quantity;
            end;
            CreditMemos.Close();
        end;
        exit(SalesAmount);
    end;

    local procedure CustGroupSalesAmount(BusinessID: Text; CustId: Text; ItemId: Text; AgreementId: Text; SalespersonId: Text; LocationId: Text; FromDate: Date; ToDate: Date): Decimal
    var
        CustGroupEntry: Query "ACC Forecast Cust Group Entry";
        SalesAmount: Decimal;
        AgreementFilter: Text;
    begin
        AgreementFilter := StrSubstNo('%1|''''', 'SALESTOOL2SALESORDER');
        SalesAmount := 0;
        CustGroupEntry.SetRange(BusinessUnitID, BusinessID);
        CustGroupEntry.SetRange(CustomerGroup, CustId);
        CustGroupEntry.SetRange(ItemNo, ItemId);
        if (AgreementId <> 'SALESTOOL2SALESORDER') AND (AgreementId <> '') then begin
            CustGroupEntry.SetRange(AgreementNo, AgreementId);
        end else begin
            CustGroupEntry.SetFilter(AgreementNo, AgreementFilter);
        end;
        CustGroupEntry.SetRange(SalespersonCode, SalespersonId);
        CustGroupEntry.SetRange(PostingYear, Date2DMY(FromDate, 3));
        CustGroupEntry.SetRange(PostingMonth, Date2DMY(FromDate, 2));
        if CustGroupEntry.Open() then begin
            while CustGroupEntry.Read() do begin
                if CopyStr(LocationId, 1, 2) = CopyStr(CustGroupEntry.LocationCode, 1, 2) then
                    SalesAmount := SalesAmount + CustGroupEntry.Quantity;
            end;
            CustGroupEntry.Close();
        end;
        exit(SalesAmount);
    end;

    local procedure AgreementGroupSalesAmount(BusinessID: Text; CustId: Text; ItemId: Text; AgreementId: Text; SalespersonId: Text; LocationId: Text; FromDate: Date; ToDate: Date): Decimal
    var
        AgreementGroupEntry: Query "ACC Forecast SA Group Entry";
        SalesAmount: Decimal;
        AgreementFilter: Text;
    begin
        AgreementFilter := StrSubstNo('%1|''''', 'SALESTOOL2SALESORDER');
        SalesAmount := 0;
        AgreementGroupEntry.SetRange(BusinessUnitID, BusinessID);
        AgreementGroupEntry.SetRange(AgreementGroup, CustId);
        AgreementGroupEntry.SetRange(ItemNo, ItemId);
        if (AgreementId <> 'SALESTOOL2SALESORDER') AND (AgreementId <> '') then begin
            AgreementGroupEntry.SetRange(AgreementNo, AgreementId);
        end else begin
            AgreementGroupEntry.SetFilter(AgreementNo, AgreementFilter);
        end;
        AgreementGroupEntry.SetRange(SalespersonCode, SalespersonId);
        AgreementGroupEntry.SetRange(PostingYear, Date2DMY(FromDate, 3));
        AgreementGroupEntry.SetRange(PostingMonth, Date2DMY(FromDate, 2));
        if AgreementGroupEntry.Open() then begin
            while AgreementGroupEntry.Read() do begin
                if CopyStr(LocationId, 1, 2) = CopyStr(AgreementGroupEntry.LocationCode, 1, 2) then
                    SalesAmount := SalesAmount + AgreementGroupEntry.Quantity;
            end;
            AgreementGroupEntry.Close();
        end;
        exit(SalesAmount);
    end;

    local procedure GeneralGroupSalesAmount(BusinessID: Text; CustId: Text; ItemId: Text; AgreementId: Text; SalespersonId: Text; LocationId: Text; FromDate: Date; ToDate: Date): Decimal
    var
        GeneralGroup: Query "ACC Forecast Gen. Group Entry";
        SalesAmount: Decimal;
        AgreementFilter: Text;
    begin
        AgreementFilter := StrSubstNo('%1|''''', 'SALESTOOL2SALESORDER');
        SalesAmount := 0;
        GeneralGroup.SetRange(BusinessUnitID, BusinessID);
        //GeneralGroup.SetRange(AgreementGroup, CustId);
        GeneralGroup.SetRange(ItemNo, ItemId);
        if (AgreementId <> 'SALESTOOL2SALESORDER') AND (AgreementId <> '') then begin
            GeneralGroup.SetRange(AgreementNo, AgreementId);
        end else begin
            GeneralGroup.SetFilter(AgreementNo, AgreementFilter);
        end;
        GeneralGroup.SetRange(SalespersonCode, SalespersonId);
        GeneralGroup.SetRange(PostingYear, Date2DMY(FromDate, 3));
        GeneralGroup.SetRange(PostingMonth, Date2DMY(FromDate, 2));
        if GeneralGroup.Open() then begin
            while GeneralGroup.Read() do begin
                if CopyStr(LocationId, 1, 2) = CopyStr(GeneralGroup.LocationCode, 1, 2) then
                    SalesAmount := SalesAmount + GeneralGroup.Quantity;
            end;
            GeneralGroup.Close();
        end;
        exit(SalesAmount);
    end;

    local procedure AddForecastLine(ForecastDate: Date; ForecastQuantity: Decimal; StartDate: Date; EndDate: Date; var ExcelBufferTmp: Record "Excel Buffer" temporary; var AddColumns: List of [Integer]; Monthly: Integer)
    var
        StepIndex: Integer;
        LastIndex: Integer;
        IIndex: Integer;
        ICount: Integer;
    begin
        if (ForecastDate >= StartDate) AND (ForecastDate <= EndDate) then begin
            AddColumns.Add(Monthly);
            if AddColumns.Count() > 1 then begin
                LastIndex := AddColumns.Get(AddColumns.Count());
                StepIndex := AddColumns.Get(AddColumns.Count() - 1);
                ICount := LastIndex - StepIndex - 1;
                if ICount >= 1 then begin
                    for IIndex := 1 to ICount do begin
                        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    end;
                end;
            end else begin
                for IIndex := 1 to (Monthly - 1) do begin
                    ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                end;
            end;
            ExcelBufferTmp.AddColumn(ForecastQuantity, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        end;
    end;
}
