pageextension 51917 "ACC Forecast Tools" extends "BLACC Sales Tools"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ACCForecast)
            {
                ApplicationArea = All;
                Caption = 'Export Forecast To Sales';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    SalesForecast: Codeunit "ACC Sales Forecast Reminder";
                    ConsolidateBU: Codeunit "ACC MP Excel Consolidate";
                begin
                    SalesForecast.ExportForecastEntry();
                    ConsolidateBU.MergeExcelByBuz(Today);
                end;
            }
            action(ACCMPForecast)
            {
                ApplicationArea = All;
                Caption = 'Export Forecast To Planning';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    MPForecast: Codeunit "ACC MP Forecast Reminder";
                begin
                    MPForecast.ExportForecastEntry();
                end;
            }

            action(ACCMPConsolidate)
            {
                ApplicationArea = All;
                Caption = 'Consolidate Forecast';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ConsolidatePage: Page "ACC Excel Consolidate";
                begin
                    ConsolidatePage.Run();
                end;
            }

            action(ACCMPForecastImport)
            {
                ApplicationArea = All;
                Caption = 'Import Forecast';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    MPForecast: Codeunit "ACC MP Forecast Entry";
                begin
                    MPForecast.ForecastEntry();
                end;
            }
            action(ACCMPAdjustment)
            {
                ApplicationArea = All;
                Caption = 'Adjustment (Parent Entry & FC Quantity [16 Columns])';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var

                begin
                    TestAdjustment();
                end;
            }
            /*
            action(ACCMPBlocked)
            {
                ApplicationArea = All;
                Caption = 'Blocked';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    DemandEntry: Record "Production Forecast Entry";
                    FromDate: DateTime;
                    ToDate: DateTime;
                begin
                    FromDate := CreateDateTime(20250930D, 080000T);
                    ToDate := CreateDateTime(20250930D, 120000T);
                    DemandEntry.Reset();
                    DemandEntry.SetRange(SystemModifiedAt, FromDate, ToDate);
                    DemandEntry.SetRange("BLACC Violdate Stock Policy", false);
                    if DemandEntry.FindSet() then
                        repeat
                            DemandEntry."BLACC Violdate Stock Policy" := true;
                            DemandEntry.Modify();
                        until DemandEntry.Next() = 0;
                end;
            }
            */
        }
    }

    local procedure TestAdjustment()
    var
        ProductEntry: Record "Production Forecast Entry";
        TmpExcelBuffer: Record "Excel Buffer" temporary;

        FileName: Text;
        SheetName: Text;
        Instream: InStream;

        ParentEntry: Integer;
        Month01: Decimal;
        Month02: Decimal;
        Month03: Decimal;
        Month04: Decimal;
        Month05: Decimal;
        Month06: Decimal;
        Month07: Decimal;
        Month08: Decimal;
        Month09: Decimal;
        Month10: Decimal;
        Month11: Decimal;
        Month12: Decimal;
        Month13: Decimal;
        Month14: Decimal;
        Month15: Decimal;

        FromDate: Date;
        ToDate: Date;
        ValidFrom: Date;
        ValidTo: Date;
        RowNo: Integer;
        MaxRowNo: Integer;
    begin
        FromDate := CalcDate('CM', Today());
        FromDate := CalcDate('+1D', FromDate);
        ToDate := CalcDate('+15M', FromDate);
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            // Ask the user to select the Excel file
            TmpExcelBuffer.Reset();
            TmpExcelBuffer.DeleteAll();
            // Load Excel contents into Excel Buffer
            SheetName := TmpExcelBuffer.SelectSheetsNameStream(InStream);
            TmpExcelBuffer.OpenBookStream(InStream, SheetName);
            TmpExcelBuffer.ReadSheet(); // Clear previous data

            // Now process the Excel rows
            TmpExcelBuffer.Reset();
            if TmpExcelBuffer.FindLast() then begin
                MaxRowNo := TmpExcelBuffer."Row No.";
            end;

            for RowNo := 2 to MaxRowNo do begin
                ParentEntry := 0;
                GetIntegerValue(TmpExcelBuffer, RowNo, 1, ParentEntry);
                Month01 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 2, Month01);
                Month02 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 3, Month02);
                Month03 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 4, Month03);
                Month04 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 5, Month04);
                Month05 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 6, Month05);
                Month06 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 7, Month06);
                Month07 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 8, Month07);
                Month08 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 9, Month08);
                Month09 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 10, Month09);
                Month10 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 11, Month10);
                Month11 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 12, Month11);
                Month12 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 13, Month12);
                Month13 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 14, Month13);
                Month14 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 15, Month14);
                Month15 := 0;
                GetDecimalValue(TmpExcelBuffer, RowNo, 16, Month15);

                if ParentEntry <> 0 then begin
                    ProductEntry.Reset();
                    ProductEntry.SetCurrentKey("BLACC Parent Entry", "Forecast Date");
                    ProductEntry.SetRange("BLACC Parent Entry", ParentEntry);
                    ProductEntry.SetRange("BLACC Active", true);
                    ProductEntry.SetRange("Forecast Date", FromDate, ToDate);
                    ProductEntry.SetAutoCalcFields("BLACC Applied SO Qty");
                    if ProductEntry.FindSet() then begin
                        repeat
                            // 1
                            ValidFrom := FromDate;
                            ValidTo := CalcDate('CM', FromDate);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month01 then begin
                                    ProductEntry."Forecast Quantity" := Month01;
                                    ProductEntry."Forecast Quantity (Base)" := Month01;
                                end;
                            end;
                            // 2
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month02 then begin
                                    ProductEntry."Forecast Quantity" := Month02;
                                    ProductEntry."Forecast Quantity (Base)" := Month02;
                                end;
                            end;
                            // 3
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month03 then begin
                                    ProductEntry."Forecast Quantity" := Month03;
                                    ProductEntry."Forecast Quantity (Base)" := Month03;
                                end;
                            end;
                            // 4
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month04 then begin
                                    ProductEntry."Forecast Quantity" := Month04;
                                    ProductEntry."Forecast Quantity (Base)" := Month04;
                                end;
                            end;
                            // 5
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month05 then begin
                                    ProductEntry."Forecast Quantity" := Month05;
                                    ProductEntry."Forecast Quantity (Base)" := Month05;
                                end;
                            end;
                            // 6
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month06 then begin
                                    ProductEntry."Forecast Quantity" := Month06;
                                    ProductEntry."Forecast Quantity (Base)" := Month06;
                                end;
                            end;
                            // 7
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month07 then begin
                                    ProductEntry."Forecast Quantity" := Month07;
                                    ProductEntry."Forecast Quantity (Base)" := Month07;
                                end;
                            end;
                            // 8
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month08 then begin
                                    ProductEntry."Forecast Quantity" := Month08;
                                    ProductEntry."Forecast Quantity (Base)" := Month08;
                                end;
                            end;
                            // 9
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month09 then begin
                                    ProductEntry."Forecast Quantity" := Month09;
                                    ProductEntry."Forecast Quantity (Base)" := Month09;
                                end;
                            end;
                            // 10
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month10 then begin
                                    ProductEntry."Forecast Quantity" := Month10;
                                    ProductEntry."Forecast Quantity (Base)" := Month10;
                                end;
                            end;
                            // 11
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month11 then begin
                                    ProductEntry."Forecast Quantity" := Month11;
                                    ProductEntry."Forecast Quantity (Base)" := Month11;
                                end;
                            end;
                            // 12
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month12 then begin
                                    ProductEntry."Forecast Quantity" := Month12;
                                    ProductEntry."Forecast Quantity (Base)" := Month12;
                                end;
                            end;
                            // 13
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month13 then begin
                                    ProductEntry."Forecast Quantity" := Month13;
                                    ProductEntry."Forecast Quantity (Base)" := Month13;
                                end;
                            end;
                            // 14
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month14 then begin
                                    ProductEntry."Forecast Quantity" := Month14;
                                    ProductEntry."Forecast Quantity (Base)" := Month14;
                                end;
                            end;
                            // 15
                            ValidFrom := CalcDate('+1D', ValidTo);
                            ValidTo := CalcDate('CM', ValidFrom);
                            if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                if ProductEntry."BLACC Applied SO Qty" <= Month15 then begin
                                    ProductEntry."Forecast Quantity" := Month15;
                                    ProductEntry."Forecast Quantity (Base)" := Month15;
                                end;
                            end;
                            ProductEntry.Modify();
                        until ProductEntry.Next() = 0;
                    end;
                end;
            end;
        end;
    end;

    local procedure NextAdjustment()
    var
        ProductEntry: Record "Production Forecast Entry";
        TmpExcelBuffer: Record "Excel Buffer" temporary;

        FileName: Text;
        SheetName: Text;
        Instream: InStream;

        ParentEntry: Integer;
        Month01: Decimal;
        Month02: Decimal;
        Month03: Decimal;
        Month04: Decimal;
        Month05: Decimal;
        Month06: Decimal;
        Month07: Decimal;
        Month08: Decimal;
        Month09: Decimal;
        Month10: Decimal;
        Month11: Decimal;
        Month12: Decimal;
        Month13: Decimal;
        Month14: Decimal;
        Month15: Decimal;

        FromDate: Date;
        ToDate: Date;
        ValidFrom: Date;
        ValidTo: Date;
    begin
        FromDate := CalcDate('CM', Today());
        FromDate := CalcDate('+1D', FromDate);
        ToDate := CalcDate('+15M', FromDate);
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            // Ask the user to select the Excel file
            TmpExcelBuffer.Reset();
            TmpExcelBuffer.DeleteAll();
            // Load Excel contents into Excel Buffer
            SheetName := TmpExcelBuffer.SelectSheetsNameStream(InStream);
            TmpExcelBuffer.OpenBookStream(InStream, SheetName);
            TmpExcelBuffer.ReadSheet(); // Clear previous data

            // Now process the Excel rows
            //TmpExcelBuffer.Reset();
            TmpExcelBuffer.SetFilter("Row No.", '>1');
            if TmpExcelBuffer.FindSet() then
                repeat
                    ParentEntry := 0;
                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ParentEntry);
                    Month01 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, Month01);
                    Month02 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, Month02);
                    Month03 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, Month03);
                    Month04 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, Month04);
                    Month05 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, Month05);
                    Month06 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 7, Month06);
                    Month07 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 8, Month07);
                    Month08 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 9, Month08);
                    Month09 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 10, Month09);
                    Month10 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, Month10);
                    Month11 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, Month11);
                    Month12 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 13, Month12);
                    Month13 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 14, Month13);
                    Month14 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 15, Month14);
                    Month15 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 16, Month15);

                    if ParentEntry <> 0 then begin
                        ProductEntry.Reset();
                        ProductEntry.SetCurrentKey("BLACC Parent Entry", "Forecast Date");
                        ProductEntry.SetRange("BLACC Parent Entry", ParentEntry);
                        ProductEntry.SetRange("BLACC Active", true);
                        ProductEntry.SetRange("Forecast Date", FromDate, ToDate);
                        ProductEntry.SetAutoCalcFields("BLACC Applied SO Qty");
                        if ProductEntry.FindSet() then begin
                            repeat
                                // 1
                                ValidFrom := FromDate;
                                ValidTo := CalcDate('CM', FromDate);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month01 then begin
                                        ProductEntry."Forecast Quantity" := Month01;
                                        ProductEntry."Forecast Quantity (Base)" := Month01;
                                    end;
                                end;
                                // 2
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month02 then begin
                                        ProductEntry."Forecast Quantity" := Month02;
                                        ProductEntry."Forecast Quantity (Base)" := Month02;
                                    end;
                                end;
                                // 3
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month03 then begin
                                        ProductEntry."Forecast Quantity" := Month03;
                                        ProductEntry."Forecast Quantity (Base)" := Month03;
                                    end;
                                end;
                                // 4
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month04 then begin
                                        ProductEntry."Forecast Quantity" := Month04;
                                        ProductEntry."Forecast Quantity (Base)" := Month04;
                                    end;
                                end;
                                // 5
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month05 then begin
                                        ProductEntry."Forecast Quantity" := Month05;
                                        ProductEntry."Forecast Quantity (Base)" := Month05;
                                    end;
                                end;
                                // 6
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month06 then begin
                                        ProductEntry."Forecast Quantity" := Month06;
                                        ProductEntry."Forecast Quantity (Base)" := Month06;
                                    end;
                                end;
                                // 7
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month07 then begin
                                        ProductEntry."Forecast Quantity" := Month07;
                                        ProductEntry."Forecast Quantity (Base)" := Month07;
                                    end;
                                end;
                                // 8
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month08 then begin
                                        ProductEntry."Forecast Quantity" := Month08;
                                        ProductEntry."Forecast Quantity (Base)" := Month08;
                                    end;
                                end;
                                // 9
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month09 then begin
                                        ProductEntry."Forecast Quantity" := Month09;
                                        ProductEntry."Forecast Quantity (Base)" := Month09;
                                    end;
                                end;
                                // 10
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month10 then begin
                                        ProductEntry."Forecast Quantity" := Month10;
                                        ProductEntry."Forecast Quantity (Base)" := Month10;
                                    end;
                                end;
                                // 11
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month11 then begin
                                        ProductEntry."Forecast Quantity" := Month11;
                                        ProductEntry."Forecast Quantity (Base)" := Month11;
                                    end;
                                end;
                                // 12
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month12 then begin
                                        ProductEntry."Forecast Quantity" := Month12;
                                        ProductEntry."Forecast Quantity (Base)" := Month12;
                                    end;
                                end;
                                // 13
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month13 then begin
                                        ProductEntry."Forecast Quantity" := Month13;
                                        ProductEntry."Forecast Quantity (Base)" := Month13;
                                    end;
                                end;
                                // 14
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month14 then begin
                                        ProductEntry."Forecast Quantity" := Month14;
                                        ProductEntry."Forecast Quantity (Base)" := Month14;
                                    end;
                                end;
                                // 15
                                ValidFrom := CalcDate('+1D', ValidTo);
                                ValidTo := CalcDate('CM', ValidFrom);
                                if (ValidFrom <= ProductEntry."Forecast Date") AND (ValidTo >= ProductEntry."Forecast Date") then begin
                                    if ProductEntry."BLACC Applied SO Qty" <= Month15 then begin
                                        ProductEntry."Forecast Quantity" := Month15;
                                        ProductEntry."Forecast Quantity (Base)" := Month15;
                                    end;
                                end;
                                ProductEntry.Modify();
                            until ProductEntry.Next() = 0;
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure GetDecimalValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Decimal): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            IF EVALUATE(Value, TempExcelBuffer."Cell Value as Text") then
                exit(Value <> 0);
        end;
        exit(false);
    end;

    local procedure GetIntegerValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Integer): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            IF EVALUATE(Value, TempExcelBuffer."Cell Value as Text") then
                exit(Value <> 0);
        end;
        exit(false);
    end;

    local procedure GetAgreementLineNo(): Integer
    var
        ForecastEntry: Record "BLACC Forecast Entry";
        LineNo: Integer;
    begin
        ForecastEntry.Reset();
        ForecastEntry.SetCurrentKey("BLACC Agreement Line No.");
        ForecastEntry.SetRange("BLACC Sales Agreement No.", 'SALESTOOL2SALESORDER');
        ForecastEntry.SetFilter("BLACC Agreement Line No.", '<>0');
        if ForecastEntry.FindLast() then
            LineNo := ForecastEntry."BLACC Agreement Line No.";
        exit(LineNo);
    end;
}
