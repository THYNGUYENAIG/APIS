codeunit 51014 "ACC MP Excel Consolidate"
{
    trigger OnRun()
    begin
        MergeExcelFile(Today());
    end;

    procedure MergeExcelFileV2(GetDate: Date)
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
        FileContent: InStream;

        BusinessUnit: Record "ACC Business Unit Setup";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        ExcelBufferTmp: Record "Excel Buffer" temporary;
        ExcelFileName: Label 'ACC/Planning/%1_ConsolodateForecast.xlsx';
        BusinessFile: Label '/ACC/%1-%2/%3_%4_Forecast.xlsx';

        ParentEntry: Integer;
        AgreementType: Text;
        ItemNo: Text;
        ItemNum: Integer;
        ItemName: Text;
        CustomerNo: Text;
        CustomerNum: Integer;
        CustomerName: Text;
        CustomerGroup: Text;
        CustomerGroupNum: Integer;
        VendorName: Text;
        SellToSalesPool: Text;
        SalesPool: Text;
        BranchCode: Text;
        BranchCodeNum: Integer;
        LocationCode: Text;
        LocationCodeNum: Integer;
        BUCode: Text;
        BUCodeNum: Integer;
        SalespersonCode: Text;
        SalespersonCodeNum: Integer;
        SalespersonName: Text;
        AgreementNo: Text;
        Planner: Text;
        LeadTime: Text;
        QuantityShipped: Decimal;
        SOBacklog: Decimal;
        CurrentForecast: Decimal;
        ExternalDocumentNo: Text;
        AgreementStart: Date;
        AgreementEnd: Date;
        MinQuantity: Decimal;
        MaxQuantity: Decimal;
        RemainingQuantity: Decimal;
        M3: Decimal;
        M2: Decimal;
        M1: Decimal;
        M0: Decimal;

        Month01ST: Decimal;
        Month02ST: Decimal;
        Month03ST: Decimal;
        Month04ST: Decimal;
        Month05ST: Decimal;
        Month06ST: Decimal;
        Month07ST: Decimal;
        Month08ST: Decimal;
        Month09ST: Decimal;
        Month10ST: Decimal;
        Month11ST: Decimal;
        Month12ST: Decimal;
        Month13ST: Decimal;
        Month14ST: Decimal;
        Month15ST: Decimal;

        StartDate: Date;

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        MimeType: Text;
        CeatedFile: Boolean;

        Window: Dialog;
        MsgLabel: Label 'Reading excel file: #1';
        Progress: Label '%1 of Row no.: %2';
        BusinessFileName: Text;
        RowNo: Integer;
        MaxRowNo: Integer;
        CellValue: Text;
    begin
        CeatedFile := false;
        MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;

        Window.Open(MsgLabel);
        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelHeader(ExcelBufferTmp, GetDate);

        BusinessUnit.Reset();
        BusinessUnit.SetRange(Blocked, false);
        BusinessUnit.SetRange(Forecast, true);
        if BusinessUnit.FindSet() then begin
            repeat
                if not ((BusinessUnit."Parent Code" <> '') AND (BusinessUnit.Code <> BusinessUnit."Parent Code")) then begin
                    BusinessFileName := StrSubstNo(BusinessFile, BusinessUnit.Code, BusinessUnit.Name, BusinessUnit.Code, Format(GetDate, 0, '<Year4><Month,2><Day,2>'));
                    SPODownloadFile(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', BusinessFileName, FileContent);
                    if FileContent.Length > 0 then begin
                        CeatedFile := true;
                        TmpExcelBuffer.Reset();
                        TmpExcelBuffer.DeleteAll();
                        // Load Excel contents into Excel Buffer        
                        TmpExcelBuffer.OpenBookStream(FileContent, BusinessUnit.Code);
                        TmpExcelBuffer.ReadSheet(); // Clear previous data

                        TmpExcelBuffer.Reset();
                        if TmpExcelBuffer.FindLast() then begin
                            MaxRowNo := TmpExcelBuffer."Row No.";
                        end;
                        // Now process the Excel rows      
                        for RowNo := 2 to MaxRowNo do begin
                            ParentEntry := 0;
                            Evaluate(ParentEntry, GetValueAtCell(TmpExcelBuffer, RowNo, 1, 2));
                            AgreementType := '';
                            Evaluate(AgreementType, GetValueAtCell(TmpExcelBuffer, RowNo, 2, 1));
                            ItemNo := '';
                            Evaluate(ItemNo, GetValueAtCell(TmpExcelBuffer, RowNo, 3, 1));
                            ItemName := '';
                            Evaluate(ItemName, GetValueAtCell(TmpExcelBuffer, RowNo, 4, 1));
                            CustomerNo := '';
                            Evaluate(CustomerNo, GetValueAtCell(TmpExcelBuffer, RowNo, 5, 1));
                            CustomerName := '';
                            Evaluate(CustomerName, GetValueAtCell(TmpExcelBuffer, RowNo, 6, 1));
                            CustomerGroup := '';
                            Evaluate(CustomerGroup, GetValueAtCell(TmpExcelBuffer, RowNo, 7, 1));
                            VendorName := '';
                            Evaluate(VendorName, GetValueAtCell(TmpExcelBuffer, RowNo, 8, 1));
                            SellToSalesPool := '';
                            Evaluate(SellToSalesPool, GetValueAtCell(TmpExcelBuffer, RowNo, 9, 1));
                            SalesPool := '';
                            Evaluate(SalesPool, GetValueAtCell(TmpExcelBuffer, RowNo, 10, 1));
                            BranchCode := '';
                            Evaluate(BranchCode, GetValueAtCell(TmpExcelBuffer, RowNo, 11, 1));
                            // Location Check
                            LocationCode := '';
                            Evaluate(LocationCode, GetValueAtCell(TmpExcelBuffer, RowNo, 12, 1));
                            if LocationCode <> '' then begin
                                ExcelBufferTmp.NewRow();
                                ExcelBufferTmp.AddColumn(ParentEntry, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                                ExcelBufferTmp.AddColumn(AgreementType, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(ItemNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(ItemName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(CustomerNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(CustomerName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(CustomerGroup, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(VendorName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(SellToSalesPool, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(SalesPool, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(BranchCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                ExcelBufferTmp.AddColumn(LocationCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                BUCode := '';
                                Evaluate(BUCode, GetValueAtCell(TmpExcelBuffer, RowNo, 13, 1));
                                ExcelBufferTmp.AddColumn(BUCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                SalespersonCode := '';
                                Evaluate(SalespersonCode, GetValueAtCell(TmpExcelBuffer, RowNo, 14, 1));
                                ExcelBufferTmp.AddColumn(SalespersonCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                SalespersonName := '';
                                Evaluate(SalespersonName, GetValueAtCell(TmpExcelBuffer, RowNo, 15, 1));
                                ExcelBufferTmp.AddColumn(SalespersonName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                AgreementNo := '';
                                Evaluate(AgreementNo, GetValueAtCell(TmpExcelBuffer, RowNo, 16, 1));
                                ExcelBufferTmp.AddColumn(AgreementNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                Planner := '';
                                Evaluate(Planner, GetValueAtCell(TmpExcelBuffer, RowNo, 17, 1));
                                ExcelBufferTmp.AddColumn(Planner, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                LeadTime := '';
                                Evaluate(LeadTime, GetValueAtCell(TmpExcelBuffer, RowNo, 18, 1));
                                ExcelBufferTmp.AddColumn(LeadTime, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                QuantityShipped := 0;
                                Evaluate(QuantityShipped, GetValueAtCell(TmpExcelBuffer, RowNo, 19, 2));
                                ExcelBufferTmp.AddColumn(QuantityShipped, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                SOBacklog := 0;
                                Evaluate(SOBacklog, GetValueAtCell(TmpExcelBuffer, RowNo, 20, 2));
                                ExcelBufferTmp.AddColumn(SOBacklog, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                CurrentForecast := 0;
                                Evaluate(CurrentForecast, GetValueAtCell(TmpExcelBuffer, RowNo, 21, 2));
                                ExcelBufferTmp.AddColumn(CurrentForecast, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                ExternalDocumentNo := '';
                                Evaluate(ExternalDocumentNo, GetValueAtCell(TmpExcelBuffer, RowNo, 22, 1));
                                ExcelBufferTmp.AddColumn(ExternalDocumentNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                AgreementStart := 0D;
                                Evaluate(AgreementStart, GetValueAtCell(TmpExcelBuffer, RowNo, 23, 1));
                                ExcelBufferTmp.AddColumn(AgreementStart, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Date);

                                AgreementEnd := 0D;
                                Evaluate(AgreementEnd, GetValueAtCell(TmpExcelBuffer, RowNo, 24, 1));
                                ExcelBufferTmp.AddColumn(AgreementEnd, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Date);

                                MinQuantity := 0;
                                Evaluate(MinQuantity, GetValueAtCell(TmpExcelBuffer, RowNo, 25, 2));
                                ExcelBufferTmp.AddColumn(MinQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                MaxQuantity := 0;
                                Evaluate(MaxQuantity, GetValueAtCell(TmpExcelBuffer, RowNo, 26, 2));
                                ExcelBufferTmp.AddColumn(MaxQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                RemainingQuantity := 0;
                                Evaluate(RemainingQuantity, GetValueAtCell(TmpExcelBuffer, RowNo, 27, 2));
                                ExcelBufferTmp.AddColumn(RemainingQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                M3 := 0;
                                Evaluate(M3, GetValueAtCell(TmpExcelBuffer, RowNo, 28, 2));
                                ExcelBufferTmp.AddColumn(M3, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                M2 := 0;
                                Evaluate(M2, GetValueAtCell(TmpExcelBuffer, RowNo, 29, 2));
                                ExcelBufferTmp.AddColumn(M2, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                M1 := 0;
                                Evaluate(M1, GetValueAtCell(TmpExcelBuffer, RowNo, 30, 2));
                                ExcelBufferTmp.AddColumn(M1, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                M0 := 0;
                                Evaluate(M0, GetValueAtCell(TmpExcelBuffer, RowNo, 31, 2));
                                ExcelBufferTmp.AddColumn(M0, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month01ST := 0;
                                Evaluate(Month01ST, GetValueAtCell(TmpExcelBuffer, RowNo, 32, 2));
                                ExcelBufferTmp.AddColumn(Month01ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month02ST := 0;
                                Evaluate(Month02ST, GetValueAtCell(TmpExcelBuffer, RowNo, 33, 2));
                                ExcelBufferTmp.AddColumn(Month02ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month03ST := 0;
                                Evaluate(Month03ST, GetValueAtCell(TmpExcelBuffer, RowNo, 34, 2));
                                ExcelBufferTmp.AddColumn(Month03ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month04ST := 0;
                                Evaluate(Month04ST, GetValueAtCell(TmpExcelBuffer, RowNo, 35, 2));
                                ExcelBufferTmp.AddColumn(Month04ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month05ST := 0;
                                Evaluate(Month05ST, GetValueAtCell(TmpExcelBuffer, RowNo, 36, 2));
                                ExcelBufferTmp.AddColumn(Month05ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month06ST := 0;
                                Evaluate(Month06ST, GetValueAtCell(TmpExcelBuffer, RowNo, 37, 2));
                                ExcelBufferTmp.AddColumn(Month06ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month07ST := 0;
                                Evaluate(Month07ST, GetValueAtCell(TmpExcelBuffer, RowNo, 38, 2));
                                ExcelBufferTmp.AddColumn(Month07ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month08ST := 0;
                                Evaluate(Month08ST, GetValueAtCell(TmpExcelBuffer, RowNo, 39, 2));
                                ExcelBufferTmp.AddColumn(Month08ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month09ST := 0;
                                Evaluate(Month09ST, GetValueAtCell(TmpExcelBuffer, RowNo, 40, 2));
                                ExcelBufferTmp.AddColumn(Month09ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month10ST := 0;
                                Evaluate(Month10ST, GetValueAtCell(TmpExcelBuffer, RowNo, 41, 2));
                                ExcelBufferTmp.AddColumn(Month10ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month11ST := 0;
                                Evaluate(Month11ST, GetValueAtCell(TmpExcelBuffer, RowNo, 42, 2));
                                ExcelBufferTmp.AddColumn(Month11ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month12ST := 0;
                                Evaluate(Month12ST, GetValueAtCell(TmpExcelBuffer, RowNo, 43, 2));
                                ExcelBufferTmp.AddColumn(Month12ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month13ST := 0;
                                Evaluate(Month13ST, GetValueAtCell(TmpExcelBuffer, RowNo, 44, 2));
                                ExcelBufferTmp.AddColumn(Month13ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month14ST := 0;
                                Evaluate(Month14ST, GetValueAtCell(TmpExcelBuffer, RowNo, 45, 2));
                                ExcelBufferTmp.AddColumn(Month14ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                Month15ST := 0;
                                Evaluate(Month15ST, GetValueAtCell(TmpExcelBuffer, RowNo, 46, 2));
                                ExcelBufferTmp.AddColumn(Month15ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            Window.Update(1, StrSubstNo(Progress, BusinessFileName, RowNo));
                            Sleep(10);
                        end;
                    end;
                end;
            until BusinessUnit.Next() = 0;
            if CeatedFile = true then begin
                ExcelFooter(ExcelBufferTmp, StrSubstNo('%1', Format(GetDate, 0, '<Year4>-<Month,2>-<Day,2>')));

                Clear(TempBlob);
                FileName := StrSubstNo(ExcelFileName, Format(GetDate, 0, '<Year4><Month,2><Day,2>'));
                TempBlob.CreateOutStream(OutStr);
                ExcelBufferTmp.SaveToStream(OutStr, true);
                TempBlob.CreateInStream(InStr);
                UploadFilesSPO(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', InStr, FileName, MimeType);
            end;
        end;
    end;

    procedure MergeExcelFile(GetDate: Date)
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
        FileContent: InStream;

        BusinessUnit: Record "ACC Business Unit Setup";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        ExcelBufferTmp: Record "Excel Buffer" temporary;
        ExcelFileName: Label 'ACC/Planning/%1_ConsolodateForecast.xlsx';
        BusinessFile: Label '/ACC/%1-%2/%3_%4_Forecast_TEST.xlsx';

        ParentEntry: Integer;
        AgreementType: Text;
        ItemNo: Text;
        ItemNum: Integer;
        ItemName: Text;
        CustomerNo: Text;
        CustomerNum: Integer;
        CustomerName: Text;
        CustomerGroup: Text;
        CustomerGroupNum: Integer;
        AgreementGroup: Text;
        AgreementGroupNum: Integer;
        SellToSalesPool: Text;
        SalesPool: Text;
        BranchCode: Text;
        BranchCodeNum: Integer;
        LocationCode: Text;
        LocationCodeNum: Integer;
        BUCode: Text;
        BUCodeNum: Integer;
        SalespersonCode: Text;
        SalespersonCodeNum: Integer;
        SalespersonName: Text;
        AgreementNo: Text;
        Planner: Text;
        LeadTime: Text;
        QuantityShipped: Decimal;
        SOBacklog: Decimal;
        CurrentForecast: Decimal;
        ExternalDocumentNo: Text;
        AgreementStart: Date;
        AgreementEnd: Date;
        MinQuantity: Decimal;
        MaxQuantity: Decimal;
        RemainingQuantity: Decimal;
        M3: Decimal;
        M2: Decimal;
        M1: Decimal;
        M0: Decimal;

        Month01ST: Decimal;
        Month02ST: Decimal;
        Month03ST: Decimal;
        Month04ST: Decimal;
        Month05ST: Decimal;
        Month06ST: Decimal;
        Month07ST: Decimal;
        Month08ST: Decimal;
        Month09ST: Decimal;
        Month10ST: Decimal;
        Month11ST: Decimal;
        Month12ST: Decimal;
        Month13ST: Decimal;
        Month14ST: Decimal;
        Month15ST: Decimal;

        StartDate: Date;

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        MimeType: Text;
        CeatedFile: Boolean;

        Window: Dialog;
        MsgLabel: Label 'Reading excel file: #1';
        Progress: Label '%1 of row no.: %2';
        BusinessFileName: Text;
    begin
        CeatedFile := false;
        MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;

        Window.Open(MsgLabel);
        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelHeader(ExcelBufferTmp, GetDate);

        BusinessUnit.Reset();
        BusinessUnit.SetRange(Blocked, false);
        BusinessUnit.SetRange(Forecast, true);
        if BusinessUnit.FindSet() then begin
            repeat
                if not ((BusinessUnit."Parent Code" <> '') AND (BusinessUnit.Code <> BusinessUnit."Parent Code")) then begin
                    BusinessFileName := StrSubstNo(BusinessFile, BusinessUnit.Code, BusinessUnit.Name, BusinessUnit.Code, Format(GetDate, 0, '<Year4><Month,2><Day,2>'));
                    SPODownloadFile(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', BusinessFileName, FileContent);
                    if FileContent.Length > 0 then begin
                        CeatedFile := true;
                        TmpExcelBuffer.Reset();
                        TmpExcelBuffer.DeleteAll();
                        // Load Excel contents into Excel Buffer        
                        TmpExcelBuffer.OpenBookStream(FileContent, BusinessUnit.Code);
                        TmpExcelBuffer.ReadSheet(); // Clear previous data

                        // Now process the Excel rows        
                        TmpExcelBuffer.SetFilter("Row No.", '>1');
                        if TmpExcelBuffer.FindSet() then begin
                            repeat
                                ParentEntry := 0;
                                GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ParentEntry);

                                AgreementType := '';
                                GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, AgreementType);

                                ItemNo := '';
                                if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ItemNo) then begin
                                    if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ItemNum) then begin
                                        if ItemNum <> 0 then begin
                                            ItemNo := Format(ItemNum);
                                        end else
                                            ItemNo := '';
                                    end;

                                end;

                                ItemName := '';
                                GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, ItemName);

                                CustomerNo := '';
                                if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, CustomerNo) then begin
                                    if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, CustomerNum) then begin
                                        if CustomerNum <> 0 then begin
                                            CustomerNo := Format(CustomerNum);
                                        end else
                                            CustomerNo := '';
                                    end;
                                end;

                                CustomerName := '';
                                GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, CustomerName);

                                CustomerGroup := '';
                                if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 7, CustomerGroup) then begin
                                    if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 7, CustomerGroupNum) then begin
                                        if CustomerGroupNum <> 0 then begin
                                            CustomerGroup := Format(CustomerGroupNum);
                                        end else
                                            CustomerGroup := '';
                                    end;
                                end;

                                AgreementGroup := '';
                                if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 8, AgreementGroup) then begin
                                    if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 8, AgreementGroupNum) then begin
                                        if AgreementGroupNum <> 0 then begin
                                            AgreementGroup := Format(AgreementGroupNum);
                                        end else
                                            AgreementGroup := '';
                                    end;

                                end;

                                SellToSalesPool := '';
                                GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 9, SellToSalesPool);

                                SalesPool := '';
                                GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 10, SalesPool);

                                BranchCode := '';
                                if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, BranchCode) then begin
                                    if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, BranchCodeNum) then begin
                                        if BranchCodeNum <> 0 then begin
                                            BranchCode := Format(BranchCodeNum);
                                        end else
                                            BranchCode := '';
                                    end;
                                end;

                                // Location Check
                                LocationCode := '';
                                if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, LocationCode) then begin
                                    if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, LocationCodeNum) then begin
                                        if LocationCodeNum <> 0 then begin
                                            LocationCode := Format(LocationCodeNum);
                                        end else
                                            LocationCode := '';
                                    end;

                                end;
                                if LocationCode <> '' then begin
                                    ExcelBufferTmp.NewRow();
                                    ExcelBufferTmp.AddColumn(ParentEntry, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                                    ExcelBufferTmp.AddColumn(AgreementType, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(ItemNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(ItemName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(CustomerNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(CustomerName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(CustomerGroup, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(AgreementGroup, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(SellToSalesPool, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(SalesPool, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(BranchCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                                    ExcelBufferTmp.AddColumn(LocationCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    BUCode := '';
                                    if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 13, BUCode) then begin
                                        if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 13, BUCodeNum) then begin
                                            if BUCodeNum <> 0 then begin
                                                BUCode := Format(BUCodeNum);
                                            end else
                                                BUCode := '';
                                        end;

                                    end;
                                    ExcelBufferTmp.AddColumn(BUCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    SalespersonCode := '';
                                    if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 14, SalespersonCode) then begin
                                        if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 14, SalespersonCodeNum) then begin
                                            if SalespersonCodeNum <> 0 then begin
                                                SalespersonCode := Format(SalespersonCodeNum);
                                            end else
                                                SalespersonCode := '';
                                        end;

                                    end;
                                    ExcelBufferTmp.AddColumn(SalespersonCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    SalespersonName := '';
                                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 15, SalespersonName);
                                    ExcelBufferTmp.AddColumn(SalespersonName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    AgreementNo := '';
                                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 16, AgreementNo);
                                    ExcelBufferTmp.AddColumn(AgreementNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    Planner := '';
                                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 17, Planner);
                                    ExcelBufferTmp.AddColumn(Planner, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    LeadTime := '';
                                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 18, LeadTime);
                                    ExcelBufferTmp.AddColumn(LeadTime, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    QuantityShipped := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 19, QuantityShipped);
                                    ExcelBufferTmp.AddColumn(QuantityShipped, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    SOBacklog := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 20, SOBacklog);
                                    ExcelBufferTmp.AddColumn(SOBacklog, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    CurrentForecast := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 21, CurrentForecast);
                                    ExcelBufferTmp.AddColumn(CurrentForecast, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    ExternalDocumentNo := '';
                                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 22, ExternalDocumentNo);
                                    ExcelBufferTmp.AddColumn(ExternalDocumentNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                                    AgreementStart := 0D;
                                    GetDateValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 23, AgreementStart);
                                    ExcelBufferTmp.AddColumn(AgreementStart, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Date);

                                    AgreementEnd := 0D;
                                    GetDateValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 24, AgreementEnd);
                                    ExcelBufferTmp.AddColumn(AgreementEnd, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Date);

                                    MinQuantity := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 25, MinQuantity);
                                    ExcelBufferTmp.AddColumn(MinQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    MaxQuantity := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 26, MaxQuantity);
                                    ExcelBufferTmp.AddColumn(MaxQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    RemainingQuantity := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 27, RemainingQuantity);
                                    ExcelBufferTmp.AddColumn(RemainingQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    M3 := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 28, M3);
                                    ExcelBufferTmp.AddColumn(M3, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    M2 := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 29, M2);
                                    ExcelBufferTmp.AddColumn(M2, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    M1 := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 30, M1);
                                    ExcelBufferTmp.AddColumn(M1, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    M0 := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 31, M0);
                                    ExcelBufferTmp.AddColumn(M0, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month01ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 32, Month01ST);
                                    ExcelBufferTmp.AddColumn(Month01ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month02ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 33, Month02ST);
                                    ExcelBufferTmp.AddColumn(Month02ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month03ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 34, Month03ST);
                                    ExcelBufferTmp.AddColumn(Month03ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month04ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 35, Month04ST);
                                    ExcelBufferTmp.AddColumn(Month04ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month05ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 36, Month05ST);
                                    ExcelBufferTmp.AddColumn(Month05ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month06ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 37, Month06ST);
                                    ExcelBufferTmp.AddColumn(Month06ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month07ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 38, Month07ST);
                                    ExcelBufferTmp.AddColumn(Month07ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month08ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 39, Month08ST);
                                    ExcelBufferTmp.AddColumn(Month08ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month09ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 40, Month09ST);
                                    ExcelBufferTmp.AddColumn(Month09ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month10ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 41, Month10ST);
                                    ExcelBufferTmp.AddColumn(Month10ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month11ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 42, Month11ST);
                                    ExcelBufferTmp.AddColumn(Month11ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month12ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 43, Month12ST);
                                    ExcelBufferTmp.AddColumn(Month12ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month13ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 44, Month13ST);
                                    ExcelBufferTmp.AddColumn(Month13ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month14ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 45, Month14ST);
                                    ExcelBufferTmp.AddColumn(Month14ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                                    Month15ST := 0;
                                    GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 46, Month15ST);
                                    ExcelBufferTmp.AddColumn(Month15ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                                end;
                                Window.Update(1, StrSubstNo(Progress, BusinessFileName, TmpExcelBuffer."Row No."));
                                Sleep(10);
                            until TmpExcelBuffer.Next() = 0;
                        end;
                    end;
                end;
            until BusinessUnit.Next() = 0;
            if CeatedFile = true then begin
                ExcelFooter(ExcelBufferTmp, 'Consolidate');

                Clear(TempBlob);
                FileName := StrSubstNo(ExcelFileName, Format(GetDate, 0, '<Year4><Month,2><Day,2>'));
                TempBlob.CreateOutStream(OutStr);
                ExcelBufferTmp.SaveToStream(OutStr, true);
                TempBlob.CreateInStream(InStr);
                UploadFilesSPO(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', InStr, FileName, MimeType);
            end;
        end;
    end;

    procedure MergeExcelByBuz(GetDate: Date)
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
        FileContent: InStream;

        BusinessUnit: Record "ACC Business Unit Setup";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        ExcelBufferTmp: Record "Excel Buffer" temporary;
        MergeBuzFile: Label 'ACC/%1-%2/%3_%4_Forecast.xlsx';
        BusinessFile: Label '/ACC/%1-%2/%3_%4_Forecast.xlsx';

        ParentEntry: Integer;
        AgreementType: Text;
        ItemNo: Text;
        ItemNum: Integer;
        ItemName: Text;
        CustomerNo: Text;
        CustomerNum: Integer;
        CustomerName: Text;
        CustomerGroup: Text;
        AgreementGroup: Text;
        SellToSalesPool: Text;
        SalesPool: Text;
        BranchCode: Text;
        LocationCode: Text;
        BUCode: Text;
        SalespersonCode: Text;
        SalespersonName: Text;
        AgreementNo: Text;
        Planner: Text;
        LeadTime: Text;
        QuantityShipped: Decimal;
        SOBacklog: Decimal;
        CurrentForecast: Decimal;
        ExternalDocumentNo: Text;
        AgreementStart: Date;
        AgreementEnd: Date;
        MinQuantity: Decimal;
        MaxQuantity: Decimal;
        RemainingQuantity: Decimal;
        M3: Decimal;
        M2: Decimal;
        M1: Decimal;
        M0: Decimal;

        Month01ST: Decimal;
        Month02ST: Decimal;
        Month03ST: Decimal;
        Month04ST: Decimal;
        Month05ST: Decimal;
        Month06ST: Decimal;
        Month07ST: Decimal;
        Month08ST: Decimal;
        Month09ST: Decimal;
        Month10ST: Decimal;
        Month11ST: Decimal;
        Month12ST: Decimal;
        Month13ST: Decimal;
        Month14ST: Decimal;
        Month15ST: Decimal;

        StartDate: Date;

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        MimeType: Text;
        CeatedFile: Boolean;
        MergeTemp: Text;
        MergeCode: Text;
        MergeName: Text;
    begin
        CeatedFile := false;
        MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;

        BusinessUnit.Reset();
        BusinessUnit.SetCurrentKey("Parent Code", "Create File");
        BusinessUnit.SetRange(Blocked, false);
        BusinessUnit.SetRange(Forecast, true);
        BusinessUnit.SetFilter("Parent Code", '<>%1', '');
        if BusinessUnit.FindSet() then begin
            repeat
                if BusinessUnit.Code = BusinessUnit."Parent Code" then begin
                    MergeCode := BusinessUnit."Parent Code";
                    MergeName := BusinessUnit.Name;
                end;
                if MergeTemp <> BusinessUnit."Parent Code" then begin
                    ExcelBufferTmp.Reset();
                    ExcelBufferTmp.DeleteAll();
                    ExcelHeader(ExcelBufferTmp, GetDate);
                end;
                SPODownloadFile(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', StrSubstNo(BusinessFile, BusinessUnit.Code, BusinessUnit.Name, BusinessUnit.Code, Format(GetDate, 0, '<Year4><Month,2><Day,2>')), FileContent);
                if FileContent.Length > 0 then begin
                    CeatedFile := true;
                    TmpExcelBuffer.Reset();
                    TmpExcelBuffer.DeleteAll();
                    // Load Excel contents into Excel Buffer        
                    TmpExcelBuffer.OpenBookStream(FileContent, BusinessUnit.Code);
                    TmpExcelBuffer.ReadSheet(); // Clear previous data

                    // Now process the Excel rows        
                    TmpExcelBuffer.SetFilter("Row No.", '>1');
                    if TmpExcelBuffer.FindSet() then begin
                        repeat
                            ExcelBufferTmp.NewRow();
                            ParentEntry := 0;
                            GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ParentEntry);
                            ExcelBufferTmp.AddColumn(ParentEntry, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            AgreementType := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, AgreementType);
                            ExcelBufferTmp.AddColumn(AgreementType, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ItemNo := '';
                            if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ItemNo) then begin
                                if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ItemNum) then
                                    ItemNo := Format(ItemNum);
                            end;
                            ExcelBufferTmp.AddColumn(ItemNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            ItemName := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, ItemName);
                            ExcelBufferTmp.AddColumn(ItemName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            CustomerNo := '';
                            if not GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, CustomerNo) then begin
                                if GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, CustomerNum) then
                                    CustomerNo := Format(CustomerNum);
                            end;
                            ExcelBufferTmp.AddColumn(CustomerNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            CustomerName := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, CustomerName);
                            ExcelBufferTmp.AddColumn(CustomerName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            CustomerGroup := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 7, CustomerGroup);
                            ExcelBufferTmp.AddColumn(CustomerGroup, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            AgreementGroup := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 8, AgreementGroup);
                            ExcelBufferTmp.AddColumn(AgreementGroup, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            SellToSalesPool := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 9, SellToSalesPool);
                            ExcelBufferTmp.AddColumn(SellToSalesPool, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            SalesPool := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 10, SalesPool);
                            ExcelBufferTmp.AddColumn(SalesPool, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            BranchCode := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, BranchCode);
                            ExcelBufferTmp.AddColumn(BranchCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            LocationCode := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, LocationCode);
                            ExcelBufferTmp.AddColumn(LocationCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            BUCode := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 13, BUCode);
                            ExcelBufferTmp.AddColumn(BUCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            SalespersonCode := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 14, SalespersonCode);
                            ExcelBufferTmp.AddColumn(SalespersonCode, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            SalespersonName := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 15, SalespersonName);
                            ExcelBufferTmp.AddColumn(SalespersonName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            AgreementNo := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 16, AgreementNo);
                            ExcelBufferTmp.AddColumn(AgreementNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            Planner := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 17, Planner);
                            ExcelBufferTmp.AddColumn(Planner, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            LeadTime := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 18, LeadTime);
                            ExcelBufferTmp.AddColumn(LeadTime, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            QuantityShipped := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 19, QuantityShipped);
                            ExcelBufferTmp.AddColumn(QuantityShipped, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            SOBacklog := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 20, SOBacklog);
                            ExcelBufferTmp.AddColumn(SOBacklog, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            CurrentForecast := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 21, CurrentForecast);
                            ExcelBufferTmp.AddColumn(CurrentForecast, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            ExternalDocumentNo := '';
                            GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 22, ExternalDocumentNo);
                            ExcelBufferTmp.AddColumn(ExternalDocumentNo, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);

                            AgreementStart := 0D;
                            GetDateValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 23, AgreementStart);
                            ExcelBufferTmp.AddColumn(AgreementStart, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Date);

                            AgreementEnd := 0D;
                            GetDateValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 24, AgreementEnd);
                            ExcelBufferTmp.AddColumn(AgreementEnd, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Date);

                            MinQuantity := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 25, MinQuantity);
                            ExcelBufferTmp.AddColumn(MinQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            MaxQuantity := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 26, MaxQuantity);
                            ExcelBufferTmp.AddColumn(MaxQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            RemainingQuantity := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 27, RemainingQuantity);
                            ExcelBufferTmp.AddColumn(RemainingQuantity, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            M3 := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 28, M3);
                            ExcelBufferTmp.AddColumn(M3, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            M2 := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 29, M2);
                            ExcelBufferTmp.AddColumn(M2, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            M1 := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 30, M1);
                            ExcelBufferTmp.AddColumn(M1, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            M0 := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 31, M0);
                            ExcelBufferTmp.AddColumn(M0, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month01ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 32, Month01ST);
                            ExcelBufferTmp.AddColumn(Month01ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month02ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 33, Month02ST);
                            ExcelBufferTmp.AddColumn(Month02ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month03ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 34, Month03ST);
                            ExcelBufferTmp.AddColumn(Month03ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month04ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 35, Month04ST);
                            ExcelBufferTmp.AddColumn(Month04ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month05ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 36, Month05ST);
                            ExcelBufferTmp.AddColumn(Month05ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month06ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 37, Month06ST);
                            ExcelBufferTmp.AddColumn(Month06ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month07ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 38, Month07ST);
                            ExcelBufferTmp.AddColumn(Month07ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month08ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 39, Month08ST);
                            ExcelBufferTmp.AddColumn(Month08ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month09ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 40, Month09ST);
                            ExcelBufferTmp.AddColumn(Month09ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month10ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 41, Month10ST);
                            ExcelBufferTmp.AddColumn(Month10ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month11ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 42, Month11ST);
                            ExcelBufferTmp.AddColumn(Month11ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month12ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 43, Month12ST);
                            ExcelBufferTmp.AddColumn(Month12ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month13ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 44, Month13ST);
                            ExcelBufferTmp.AddColumn(Month13ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month14ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 45, Month14ST);
                            ExcelBufferTmp.AddColumn(Month14ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);

                            Month15ST := 0;
                            GetDecimalValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 46, Month15ST);
                            ExcelBufferTmp.AddColumn(Month15ST, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                        until TmpExcelBuffer.Next() = 0;
                    end;
                end;
                MergeTemp := BusinessUnit."Parent Code";
                if BusinessUnit."Create File" = true then begin
                    ExcelFooter(ExcelBufferTmp, MergeCode);
                    Clear(TempBlob);
                    FileName := StrSubstNo(MergeBuzFile, MergeCode, MergeName, MergeCode, Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
                    TempBlob.CreateOutStream(OutStr);
                    ExcelBufferTmp.SaveToStream(OutStr, true);
                    TempBlob.CreateInStream(InStr);
                    UploadFilesSPO(OauthenToken, '740af90e-3d59-4cc0-8af8-d0dcfe3e0eff', 'b!DvkKdFk9wEyK-NDc_j4O_5cx5acbVgBNro5MkjHw8HiGeS4UdoDfS726zU9LEvhy', InStr, FileName, MimeType);
                end;
            until BusinessUnit.Next() = 0;
        end;
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

    local procedure SPODownloadFile(OauthToken: SecretText; SiteId: Text; DriveId: Text; FilePath: Text; var FileContent: InStream)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;
        Headers: HttpHeaders;
    //FileContent: InStream;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/root:%3:/content', SiteId, DriveId, FilePath);
        //Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3/content', SiteId, DriveId, FileId);

        // Prepare HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode then begin
                HttpResponseMessage.Content.ReadAs(FileContent);
            end;
        end;
    end;

    local procedure ExcelHeader(var ExcelBufferTmp: Record "Excel Buffer" temporary; GetDate: Date)
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
        ExcelBufferTmp.AddColumn(Format(GetDate, 0, '<Month Text> <Year4>'), false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        // 1
        StartDate := CalcDate('CM+1D', GetDate);
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

    local procedure ExcelFooter(var ExcelBufferTmp: Record "Excel Buffer" temporary; BUCode: Text)
    var
    begin
        ExcelBufferTmp.CreateNewBook(BUCode);
        ExcelBufferTmp.WriteSheet(BUCode, 'ACC', UserId);

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

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; VarType: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.Get(Row, Col) then begin
            if not TempExcelBuffer.IsEmpty then
                exit(TempExcelBuffer."Cell Value as Text");
        end else begin
            if VarType = 1 then
                exit('');
            if VarType = 2 then
                exit('0');
            if VarType = 3 then
                exit('0D');
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

    local procedure GetIntegerValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Integer): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            IF EVALUATE(Value, TempExcelBuffer."Cell Value as Text") then
                exit(Value <> 0);
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

    local procedure GetDateValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Date): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            IF EVALUATE(Value, TempExcelBuffer."Cell Value as Text") then
                exit(Value <> 0D);
        end;
        exit(false);
    end;
}
