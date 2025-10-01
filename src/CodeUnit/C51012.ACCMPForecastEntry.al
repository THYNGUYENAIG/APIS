codeunit 51012 "ACC MP Forecast Entry"
{
    TableNo = "Production Forecast Entry";

    trigger OnRun()
    begin

    end;

    procedure ForecastEntry()
    var
        ItemTable: Record Item;
        CustTable: Record Customer;
        SalesTable: Record "Salesperson/Purchaser";
        LocationTable: Record Location;
        BusinessUnit: Record "ACC Business Unit Setup";
        ForecastEntry: Record "BLACC Forecast Entry";
        ProductEntry: Record "Production Forecast Entry";
        CopyProEntry: Record "Production Forecast Entry";
        TmpExcelBuffer: Record "Excel Buffer" temporary;

        FileName: Text;
        SheetName: Text;
        Instream: InStream;

        ParentEntry: Integer;
        ItemNo: Text;
        CustomerNo: Text;
        SalesPool: Text;
        BranchCode: Text;
        LocationCode: Text;
        BUCode: Text;
        SalespersonCode: Text;
        SalesAgreement: Text;

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

        Consolidate: Date;
        FromDate: Date;
        ToDate: Date;
        ParentLog: Text;

        Window: Dialog;
        MsgLabel: Label 'Processing record(s) #1';
        Progress: Label '%1 of Parent Entry: %2 %3';
        FlagPolicy: Label 'Open policy';
        EntryCounter: Integer;
        RecordType: Text;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            // Ask the user to select the Excel file
            TmpExcelBuffer.Reset();
            TmpExcelBuffer.DeleteAll();
            // Load Excel contents into Excel Buffer
            SheetName := TmpExcelBuffer.SelectSheetsNameStream(InStream);
            TmpExcelBuffer.OpenBookStream(InStream, SheetName);
            TmpExcelBuffer.ReadSheet(); // Clear previous data

            Evaluate(Consolidate, SheetName);
            // Now process the Excel rows
            //TmpExcelBuffer.Reset();
            Clear(EntryCounter);
            Window.Open(MsgLabel);
            TmpExcelBuffer.SetFilter("Row No.", '>1');
            if TmpExcelBuffer.FindSet() then
                repeat
                    ParentEntry := 0;
                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ParentEntry);
                    ItemNo := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ItemNo);
                    CustomerNo := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, CustomerNo);
                    SalesPool := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 9, SalesPool);
                    BranchCode := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, BranchCode);
                    LocationCode := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, LocationCode);
                    BUCode := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 13, BUCode);
                    SalespersonCode := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 14, SalespersonCode);
                    SalesAgreement := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 16, SalesAgreement);
                    Month01 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 32, Month01);
                    Month02 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 33, Month02);
                    Month03 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 34, Month03);
                    Month04 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 35, Month04);
                    Month05 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 36, Month05);
                    Month06 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 37, Month06);
                    Month07 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 38, Month07);
                    Month08 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 39, Month08);
                    Month09 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 40, Month09);
                    Month10 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 41, Month10);
                    Month11 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 42, Month11);
                    Month12 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 43, Month12);
                    Month13 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 44, Month13);
                    Month14 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 45, Month14);
                    Month15 := 0;
                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 46, Month15);
                    FromDate := CalcDate('-CM', Today());
                    ToDate := CalcDate('CM', FromDate);
                    if ParentEntry <> 0 then begin
                        RecordType := 'Modify';
                        // 0  
                        if Consolidate.Month = FromDate.Month then
                            ModifyProductEntry(ParentEntry, FromDate, Month01, SalesAgreement);
                        // 1
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month02, SalesAgreement);
                        // 2
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month03, SalesAgreement);
                        // 3
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month04, SalesAgreement);
                        // 4
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month05, SalesAgreement);
                        // 5
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month06, SalesAgreement);
                        // 6
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month07, SalesAgreement);
                        // 7
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month08, SalesAgreement);
                        // 8
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month09, SalesAgreement);
                        // 9
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month10, SalesAgreement);
                        // 10
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month11, SalesAgreement);
                        // 11
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month12, SalesAgreement);
                        // 12
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month13, SalesAgreement);
                        // 13
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month14, SalesAgreement);
                        // 14
                        FromDate := CalcDate('+1D', ToDate);
                        ToDate := CalcDate('CM', FromDate);
                        ModifyProductEntry(ParentEntry, FromDate, Month15, SalesAgreement);
                    end else begin
                        if (not ItemTable.Get(ItemNo)) OR (not CustTable.Get(CustomerNo)) OR (not SalesTable.Get(SalespersonCode)) OR (not ((BranchCode = '10') OR (BranchCode = '20'))) OR (not BusinessUnit.Get(BUCode)) OR (not LocationTable.Get(LocationCode)) then begin
                            // Notify
                        end else begin
                            // item/customer/Branch(location)/BU/salesperson
                            ForecastEntry.Reset();
                            ForecastEntry.SetRange("No.", ItemNo);
                            ForecastEntry.SetRange("BLACC Sell-to Customer No.", CustomerNo);
                            ForecastEntry.SetRange("Location Code", LocationCode);
                            ForecastEntry.SetRange("BLACC Shortcut Dim 2 Code", BUCode);
                            ForecastEntry.SetRange("BLACC Salesperson Code", SalespersonCode);
                            ForecastEntry.SetRange("No SA", true);
                            if ForecastEntry.Count = 0 then begin
                                RecordType := 'New';
                                Clear(ForecastEntry);
                                CreateForecastEntry(ForecastEntry, CustomerNo, ItemNo, LocationCode, BranchCode, BUCode, SalespersonCode, SalesPool);

                                if Month01 <> 0 then begin
                                    if Consolidate.Month = FromDate.Month then
                                        InsertProductEntry(ForecastEntry, FromDate, Month01, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month02 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month02, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month03 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month03, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month04 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month04, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month05 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month05, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month06 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month06, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month07 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month07, SalesAgreement);
                                end;
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month08 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month08, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month09 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month09, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month10 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month10, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month11 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month11, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month12 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month12, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month13 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month13, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month14 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month14, SalesAgreement);
                                end;

                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                if Month15 <> 0 then begin
                                    InsertProductEntry(ForecastEntry, FromDate, Month15, SalesAgreement);
                                end;
                            end else begin
                                RecordType := 'Modify';
                                ForecastEntry.FindFirst();
                                SalesAgreement := ForecastEntry."BLACC Sales Agreement No.";
                                if SalesAgreement = 'SALESTOOL2SALESORDER' then
                                    SalesAgreement := '';

                                if Consolidate.Month = FromDate.Month then
                                    ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month01, SalesAgreement);
                                // 1
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month02, SalesAgreement);
                                // 2
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month03, SalesAgreement);
                                // 3
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month04, SalesAgreement);
                                // 4
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month05, SalesAgreement);
                                // 5
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month06, SalesAgreement);
                                // 6
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month07, SalesAgreement);
                                // 7
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month08, SalesAgreement);
                                // 8
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month09, SalesAgreement);
                                // 9
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month10, SalesAgreement);
                                // 10
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month11, SalesAgreement);
                                // 11
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month12, SalesAgreement);
                                // 12
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month13, SalesAgreement);
                                // 13
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month14, SalesAgreement);
                                // 14
                                FromDate := CalcDate('+1D', ToDate);
                                ToDate := CalcDate('CM', FromDate);
                                ModifyProductEntry(ForecastEntry."Entry No.", FromDate, Month15, SalesAgreement);
                            end;
                        end;
                    end;
                    EntryCounter += 1;
                    Window.Update(1, StrSubstNo(Progress, EntryCounter, ParentEntry, RecordType));
                    Sleep(50);
                until TmpExcelBuffer.Next() = 0;            
        end;
    end;

    local procedure InsertProductEntry(ForecastEntry: Record "BLACC Forecast Entry"; FromDate: Date; Quantity: Decimal; SalesAgreement: Text)
    var

        ItemTable: Record Item;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ProductEntry: Record "Production Forecast Entry";
        CopyProEntry: Record "Production Forecast Entry";

    begin


        //if SalesAgreement <> '' then
        //    exit;
        if ItemTable.Get(ForecastEntry."No.") then begin
        end;
        ProductEntry.Reset();
        ProductEntry.SetRange("BLACC Parent Entry", ForecastEntry."Entry No.");
        ProductEntry.SetRange("Forecast Date", FromDate);
        if not ProductEntry.FindFirst() then begin
            CopyProEntry.Reset();
            CopyProEntry.SetRange("BLACC Parent Entry", ForecastEntry."Entry No.");
            CopyProEntry.SetRange("BLACC Active", true);
            if CopyProEntry.FindFirst() then begin
                Clear(ProductEntry);
                ProductEntry.Init();
                ProductEntry.Copy(CopyProEntry);
                ProductEntry."Entry No." := ProductEntry.GetLastEntryNo() + 1;
                ProductEntry."Forecast Date" := FromDate;
                ProductEntry."Forecast Quantity" := Quantity;
                ProductEntry."Forecast Quantity (Base)" := Quantity;
                ProductEntry."BLACC Last Forcecast Qty." := 0;
                if ProductEntry."Unit of Measure Code" = '' then
                    ProductEntry."Unit of Measure Code" := ItemTable."Base Unit of Measure";
                ItemUnitofMeasure.Get(ForecastEntry."No.", ItemTable."Base Unit of Measure");
                ProductEntry."Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                ProductEntry."BLACC Violdate Stock Policy" := true;
                ProductEntry.Insert();
            end else begin
                Clear(ProductEntry);
                ProductEntry.Init();
                ProductEntry."Entry No." := ProductEntry.GetLastEntryNo() + 1;
                ProductEntry."BLACC Parent Entry" := ForecastEntry."Entry No.";
                ProductEntry."BLACC Sell-to Customer No." := ForecastEntry."BLACC Sell-to Customer No.";
                ProductEntry."BLACC Sales Agreement No." := ForecastEntry."BLACC Sales Agreement No.";
                ProductEntry."BLACC Agreement Line No." := ForecastEntry."BLACC Agreement Line No.";
                ProductEntry."BLACC Salesperson Code" := ForecastEntry."BLACC Salesperson Code";
                ProductEntry."BLACC Sales Pool" := ForecastEntry."BLACC Sales Pool";
                ProductEntry."BLACC Shortcut Dim 1 Code" := ForecastEntry."BLACC Shortcut Dim 1 Code";
                ProductEntry."BLACC Shortcut Dim 2 Code" := ForecastEntry."BLACC Shortcut Dim 2 Code";
                ProductEntry."BLACC Active" := true;
                ProductEntry."Production Forecast Name" := 'ACTIVE';
                ProductEntry."Item No." := ForecastEntry."No.";
                ProductEntry.Description := ItemTable.Description;
                ProductEntry."Unit of Measure Code" := ItemTable."Base Unit of Measure";
                ItemUnitofMeasure.Get(ForecastEntry."No.", ItemTable."Base Unit of Measure");
                ProductEntry."Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                ProductEntry."Location Code" := ForecastEntry."Location Code";
                ProductEntry."Forecast Date" := FromDate;
                ProductEntry."Forecast Quantity" := Quantity;
                ProductEntry."Forecast Quantity (Base)" := Quantity;
                ProductEntry."BLACC Last Forcecast Qty." := 0;
                ProductEntry."BLACC No SA" := ForecastEntry."No SA";
                ProductEntry."BLACC Violdate Stock Policy" := true;
                ProductEntry.Insert();
            end;
        end;
    end;

    local procedure ModifyProductEntry(ParentEntry: Integer; FromDate: Date; Quantity: Decimal; SalesAgreement: Text)
    var

        SalesForecast: Record "BLACC Forecast Entry";
        ProductEntry: Record "Production Forecast Entry";
        CopyProEntry: Record "Production Forecast Entry";
        ItemTable: Record Item;
        ItemUnitofMeasure: Record "Item Unit of Measure";

    begin

        //if SalesAgreement <> '' then
        //    exit;
        ProductEntry.Reset();
        ProductEntry.SetRange("BLACC Parent Entry", ParentEntry);
        ProductEntry.SetRange("Forecast Date", FromDate);
        ProductEntry.SetRange("BLACC Active", true);
        ProductEntry.SetAutoCalcFields("BLACC Applied SO Qty");
        if ProductEntry.FindFirst() then begin
            ItemTable.Get(ProductEntry."Item No.");
            if Quantity <> 0 then begin
                if ProductEntry."Forecast Quantity" <> Quantity then begin
                    if ProductEntry."BLACC Applied SO Qty" <= Quantity then begin
                        ProductEntry."BLACC Last Forcecast Qty." := ProductEntry."Forecast Quantity";
                        ProductEntry."Forecast Quantity" := Quantity;
                        ProductEntry."Forecast Quantity (Base)" := Quantity;
                        if ProductEntry."Unit of Measure Code" = '' then
                            ProductEntry."Unit of Measure Code" := ItemTable."Base Unit of Measure";
                        ItemUnitofMeasure.Get(ProductEntry."Item No.", ItemTable."Base Unit of Measure");
                        ProductEntry."Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                        ProductEntry."BLACC Violdate Stock Policy" := true;
                        ProductEntry.Modify();
                    end;
                end;
            end else begin
                if ProductEntry."BLACC Applied SO Qty" = 0 then begin
                    ProductEntry."BLACC Last Forcecast Qty." := ProductEntry."Forecast Quantity";
                    ProductEntry."Forecast Quantity" := Quantity;
                    ProductEntry."Forecast Quantity (Base)" := Quantity;
                    if ProductEntry."Unit of Measure Code" = '' then
                        ProductEntry."Unit of Measure Code" := ItemTable."Base Unit of Measure";
                    ItemUnitofMeasure.Get(ProductEntry."Item No.", ItemTable."Base Unit of Measure");
                    ProductEntry."Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                    ProductEntry.Modify();
                end;
            end;
        end else begin
            if Quantity <> 0 then begin
                CopyProEntry.Reset();
                CopyProEntry.SetRange("BLACC Parent Entry", ParentEntry);
                CopyProEntry.SetRange("BLACC Active", true);
                if CopyProEntry.FindFirst() then begin
                    ItemTable.Get(CopyProEntry."Item No.");
                    Clear(ProductEntry);
                    ProductEntry.Init();
                    ProductEntry.Copy(CopyProEntry);
                    ProductEntry."Entry No." := ProductEntry.GetLastEntryNo() + 1;
                    ProductEntry."Forecast Date" := FromDate;
                    ProductEntry."Forecast Quantity" := Quantity;
                    ProductEntry."Forecast Quantity (Base)" := Quantity;
                    ProductEntry."BLACC Last Forcecast Qty." := 0;
                    if ProductEntry."Unit of Measure Code" = '' then
                        ProductEntry."Unit of Measure Code" := ItemTable."Base Unit of Measure";
                    ItemUnitofMeasure.Get(ProductEntry."Item No.", ItemTable."Base Unit of Measure");
                    ProductEntry."Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                    ProductEntry."BLACC Violdate Stock Policy" := true;
                    ProductEntry.Insert();
                end else begin
                    SalesForecast.Reset();
                    SalesForecast.SetRange("Entry No.", ParentEntry);
                    if SalesForecast.FindFirst() then begin
                        ItemTable.Get(SalesForecast."No.");
                        Clear(ProductEntry);
                        ProductEntry.Init();
                        ProductEntry."Entry No." := ProductEntry.GetLastEntryNo() + 1;
                        ProductEntry."BLACC Parent Entry" := SalesForecast."Entry No.";
                        ProductEntry."BLACC Sell-to Customer No." := SalesForecast."BLACC Sell-to Customer No.";
                        ProductEntry."BLACC Sales Agreement No." := SalesForecast."BLACC Sales Agreement No.";
                        ProductEntry."BLACC Agreement Line No." := SalesForecast."BLACC Agreement Line No.";
                        ProductEntry."BLACC Salesperson Code" := SalesForecast."BLACC Salesperson Code";
                        ProductEntry."BLACC Sales Pool" := SalesForecast."BLACC Sales Pool";
                        ProductEntry."BLACC Shortcut Dim 1 Code" := SalesForecast."BLACC Shortcut Dim 1 Code";
                        ProductEntry."BLACC Shortcut Dim 2 Code" := SalesForecast."BLACC Shortcut Dim 2 Code";
                        ProductEntry."BLACC Active" := true;
                        ProductEntry."Production Forecast Name" := 'ACTIVE';
                        ProductEntry."Item No." := SalesForecast."No.";
                        ProductEntry.Description := ItemTable.Description;
                        ProductEntry."Unit of Measure Code" := ItemTable."Base Unit of Measure";
                        ItemUnitofMeasure.Get(SalesForecast."No.", ItemTable."Base Unit of Measure");
                        ProductEntry."Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                        ProductEntry."Location Code" := SalesForecast."Location Code";
                        ProductEntry."Forecast Date" := FromDate;
                        ProductEntry."Forecast Quantity" := Quantity;
                        ProductEntry."Forecast Quantity (Base)" := Quantity;
                        ProductEntry."BLACC Last Forcecast Qty." := 0;
                        ProductEntry."BLACC No SA" := SalesForecast."No SA";
                        ProductEntry."BLACC Violdate Stock Policy" := true;
                        ProductEntry.Insert();
                    end;
                end;
            end;
        end;
    end;

    local procedure GetCellValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Text): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            Value := TempExcelBuffer."Cell Value as Text";
            exit(Value <> '');
        end;
        exit(false);
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

    local procedure CreateForecastEntry(var ForecastEntry: Record "BLACC Forecast Entry"; CustomerNo: Text; ItemNo: Text; LocationCode: Text; BranchCode: Text; BUCode: Text; Salesperson: Text; SalesPool: Text)
    var
        ItemTable: Record Item;
        ForecastDraft: Record "BLACC Forecast Draft Entry";
        ForecastDraftTmp: Record "BLACC Forecast Draft Entry" temporary;
    begin
        ItemTable.Get(ItemNo);
        ForecastDraft.Init();
        ForecastDraft."BLACC Sell-to Customer No." := CustomerNo;
        ForecastDraft."BLACC Sales Pool" := CustSalesPool(CustomerNo, SalesPool);
        ForecastDraft."No." := ItemNo;
        ForecastDraft.Description := ItemTable.Description;
        ForecastDraft."Location Code" := LocationCode;
        ForecastDraft."BLACC Shortcut Dim 1 Code" := BranchCode;
        ForecastDraft."BLACC Shortcut Dim 2 Code" := BUCode;
        ForecastDraft."BLACC Salesperson Code" := Salesperson;
        ForecastDraft.Insert();

        ForecastDraft.ReleaseForecast();

        Clear(ForecastDraftTmp);
        ForecastDraftTmp := ForecastDraft;
        ForecastDraftTmp.Insert();

        Clear(ForecastDraftTmp);
        if ForecastDraftTmp.FindSet() then
            repeat
                ForecastDraft := ForecastDraftTmp;
                ForecastDraft.Delete();
            until ForecastDraftTmp.Next() = 0;

        ForecastEntry.SetCurrentKey("Entry No.");
        ForecastEntry.SetRange("BLACC Sales Agreement No.", 'SALESTOOL2SALESORDER');
        if ForecastEntry.FindLast() then;
    end;

    local procedure CustSalesPool(CustomerNo: Text; SalesPool: Text): Text
    var
        SelltoCustomer_: Record Customer;
    begin
        if SalesPool <> '' then
            exit(SalesPool);
        if CustomerNo = '' then
            if SelltoCustomer_.Get(CustomerNo) then
                exit(SelltoCustomer_."BLACC Sales Pool");
        exit('3');
    end;

    local procedure SetSalesPolicy()
    var
        SalesPolicy: Codeunit "ACC MP Flag Policy";
        ForecastEntry: Record "BLACC Forecast Entry";
        DemandEntry: Record "Production Forecast Entry";
        CurrPeriod: Integer;
        NextPeriod: Integer;
        CompPeriod: Integer;
        NextDate: Date;
        FromDate: Date;
        ToDate: Date;
        ForModify: Boolean;
    begin
        FromDate := CalcDate('-CM', Today);
        NextDate := CalcDate('CM', Today);
        NextDate := CalcDate('+1D', NextDate);
        ToDate := CalcDate('CM', NextDate);
        Evaluate(CurrPeriod, Format(TODAY, 0, '<Year4><Month,2>'));
        Evaluate(NextPeriod, Format(NextDate, 0, '<Year4><Month,2>'));

        ForecastEntry.Reset();
        ForecastEntry.SetRange("No SA", false);
        ForecastEntry.SetFilter("BLACC Sales Pool", '0|2');
        ForecastEntry.SetFilter("BLACC Agreement EndDate", '%1..', Today);
        ForecastEntry.SetFilter("BLACC Agreement StartDate", '..%1', Today);
        if ForecastEntry.FindSet() then begin
            repeat
                if ForecastEntry.GetRemainingQty() > 0 then begin
                    DemandEntry.Reset();
                    DemandEntry.SetRange("BLACC Active", true);
                    DemandEntry.SetRange("BLACC Violdate Stock Policy", true);
                    DemandEntry.SetRange("BLACC Parent Entry", ForecastEntry."Entry No.");
                    DemandEntry.SetRange("Forecast Date", FromDate, ToDate);
                    DemandEntry.SetFilter("Forecast Quantity", '>0');
                    if DemandEntry.FindSet() then begin
                        repeat
                            ForModify := DemandEntry."BLACC Violdate Stock Policy";
                            Evaluate(CompPeriod, Format(DemandEntry."Forecast Date", 0, '<Year4><Month,2>'));
                            if CurrPeriod = CompPeriod then begin
                                DemandEntry."BLACC Violdate Stock Policy" := SalesPolicy.PolicyCurrent(CopyStr(DemandEntry."Location Code", 1, 2), DemandEntry."Item No.", CurrPeriod);
                            end;
                            if NextPeriod = CompPeriod then begin
                                DemandEntry."BLACC Violdate Stock Policy" := SalesPolicy.PolicyNextMonth(CopyStr(DemandEntry."Location Code", 1, 2), DemandEntry."Item No.", CurrPeriod, NextPeriod);
                            end;
                            if ForModify <> DemandEntry."BLACC Violdate Stock Policy" then begin
                                if DemandEntry."BLACC Violdate Leadtime" then
                                    DemandEntry."BLACC Violdate Leadtime" := false;
                                DemandEntry.Modify();
                            end;
                        until DemandEntry.Next() = 0;
                    end;
                end;
            until ForecastEntry.Next() = 0;
        end;

        ForecastEntry.Reset();
        ForecastEntry.SetRange("No SA", true);
        ForecastEntry.SetFilter("BLACC Sell-to Customer No.", '<>%1', '');
        ForecastEntry.SetFilter("No.", '<>%1', '');
        ForecastEntry.SetFilter("BLACC Salesperson Code", '<>%1', '');
        ForecastEntry.SetFilter("BLACC Shortcut Dim 2 Code", '<>%1', '3*');
        if ForecastEntry.FindSet() then begin
            repeat
                DemandEntry.Reset();
                DemandEntry.SetRange("BLACC Active", true);
                DemandEntry.SetRange("BLACC Violdate Stock Policy", true);
                DemandEntry.SetRange("BLACC Parent Entry", ForecastEntry."Entry No.");
                DemandEntry.SetRange("Forecast Date", FromDate, ToDate);
                DemandEntry.SetFilter("Forecast Quantity", '>0');
                if DemandEntry.FindSet() then begin
                    repeat
                        ForModify := DemandEntry."BLACC Violdate Stock Policy";
                        Evaluate(CompPeriod, Format(DemandEntry."Forecast Date", 0, '<Year4><Month,2>'));
                        if CurrPeriod = CompPeriod then begin
                            DemandEntry."BLACC Violdate Stock Policy" := SalesPolicy.PolicyCurrent(CopyStr(DemandEntry."Location Code", 1, 2), DemandEntry."Item No.", CurrPeriod);
                        end;
                        if NextPeriod = CompPeriod then begin
                            DemandEntry."BLACC Violdate Stock Policy" := SalesPolicy.PolicyNextMonth(CopyStr(DemandEntry."Location Code", 1, 2), DemandEntry."Item No.", CurrPeriod, NextPeriod);
                        end;
                        if ForModify <> DemandEntry."BLACC Violdate Stock Policy" then begin
                            if DemandEntry."BLACC Violdate Leadtime" then
                                DemandEntry."BLACC Violdate Leadtime" := false;
                            DemandEntry.Modify();
                        end;
                    until DemandEntry.Next() = 0;
                end;
            until ForecastEntry.Next() = 0;
        end;
    end;
}
