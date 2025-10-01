codeunit 51015 "ACC AR Sales Balance"
{
    TableNo = "Cust. Ledger Entry";

    trigger OnRun()
    begin
        //ExportExcelSPO();
    end;

    procedure ExportExcelSPO(StatisticFilter: Text; DateFilter: Date)
    var
        CustTable: Record Customer;
        BusinessUnit: Record "Responsibility Center";
        CustLegEnt: Record "Cust. Ledger Entry";
        Salesperson: Record "Salesperson/Purchaser";

        ExcelBufferTmp: Record "Excel Buffer" temporary;
        ExcelFileName: Label '%1_%2_CongNo.xlsx';

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        FileContent: InStream;
        FileName: Text;

        OverDue: Integer;
        CustomerNo: Text;
        CustomerName: Text;
        AmountLCY: Decimal;
        RemainingLCY: Decimal;
        AmountNotDue: Decimal;
        Amount07Due: Decimal;
        Amount0815Due: Decimal;
        Amount0130Due: Decimal;
        Amount3160Due: Decimal;
        Amount6190Due: Decimal;
        Amount90After: Decimal;
        SalesName: Text;

        TotalAmountLCY: Decimal;
        TotalRemainingLCY: Decimal;
        TotalAmountNotDue: Decimal;
        TotalAmount07Due: Decimal;
        TotalAmount0815Due: Decimal;
        TotalAmount0130Due: Decimal;
        TotalAmount3160Due: Decimal;
        TotalAmount6190Due: Decimal;
        TotalAmount90After: Decimal;
        FromDate: Date;
    begin
        FromDate := 20250501D;
        TotalAmountLCY := 0;
        TotalRemainingLCY := 0;
        TotalAmountNotDue := 0;
        TotalAmount07Due := 0;
        TotalAmount0815Due := 0;
        TotalAmount0130Due := 0;
        TotalAmount3160Due := 0;
        TotalAmount6190Due := 0;
        TotalAmount90After := 0;
        ExcelBufferTmp.Reset();
        ExcelBufferTmp.DeleteAll();
        ExcelBufferTmp.NewRow();
        ExcelBufferTmp.AddColumn('Posting Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Document Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Document No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('External Document No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Customer No.', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Customer Name', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Due Date', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Over Due', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Original Amount', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Balance', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('After 90 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('61 - 90 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('31 - 60 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('16 - 30 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('8 - 15 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('1 - 7 days', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Not Due', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Salesperson', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Credit Limit', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Customer Group', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        CustTable.Reset();
        CustTable.SetCurrentKey("No.");
        CustTable.SetFilter("Statistics Group", StatisticFilter);
        //CustTable.SetAutoCalcFields("Balance (LCY)");
        if CustTable.FindSet() then begin
            repeat
                AmountLCY := 0;
                RemainingLCY := 0;
                AmountNotDue := 0;
                Amount07Due := 0;
                Amount0815Due := 0;
                Amount0130Due := 0;
                Amount3160Due := 0;
                Amount6190Due := 0;
                Amount90After := 0;
                AmountNotDue := 0;
                CustLegEnt.Reset();
                CustLegEnt.SetRange("Customer No.", CustTable."No.");
                CustLegEnt.SetRange("Date Filter", FromDate, DateFilter);
                CustLegEnt.SetFilter("Customer Posting Group", '1|2|3|4|5|6');
                CustLegEnt.SetAutoCalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                if CustLegEnt.FindSet() then begin
                    repeat
                        if CustLegEnt."Remaining Amt. (LCY)" <> 0 then begin
                            CustomerName := 'Total for ' + CustTable.Name;
                            ExcelBufferTmp.NewRow();
                            ExcelBufferTmp.AddColumn(CustLegEnt."Posting Date", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            ExcelBufferTmp.AddColumn(CustLegEnt."Document Date", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            ExcelBufferTmp.AddColumn(CustLegEnt."Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(CustLegEnt."External Document No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(CustLegEnt."Customer No.", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            CustomerNo := CustLegEnt."Customer No.";
                            ExcelBufferTmp.AddColumn(CustTable.Name, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(CustLegEnt."Due Date", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Date);
                            OverDue := DateFilter - CustLegEnt."Due Date";
                            ExcelBufferTmp.AddColumn(OverDue, false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                            ExcelBufferTmp.AddColumn(CustLegEnt."Amount (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            AmountLCY := AmountLCY + CustLegEnt."Amount (LCY)";
                            ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            RemainingLCY := RemainingLCY + CustLegEnt."Remaining Amt. (LCY)";
                            if OverDue > 90 then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                Amount90After := Amount90After + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if (OverDue >= 61) AND (OverDue <= 90) then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                Amount6190Due := Amount6190Due + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if (OverDue >= 31) AND (OverDue <= 60) then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                Amount3160Due := Amount3160Due + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if (OverDue >= 16) AND (OverDue <= 30) then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                Amount0130Due := Amount0130Due + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if (OverDue >= 8) AND (OverDue <= 15) then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                Amount0815Due := Amount0815Due + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if (OverDue >= 1) AND (OverDue <= 7) then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                Amount07Due := Amount07Due + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if OverDue < 1 then begin
                                ExcelBufferTmp.AddColumn(CustLegEnt."Remaining Amt. (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                                AmountNotDue := AmountNotDue + CustLegEnt."Remaining Amt. (LCY)";
                            end else begin
                                ExcelBufferTmp.AddColumn(0, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                            end;
                            if Salesperson.Get(CustLegEnt."Salesperson Code") then begin
                                ExcelBufferTmp.AddColumn(Salesperson.Name, false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Text);
                                SalesName := Salesperson.Name;
                            end else begin
                                ExcelBufferTmp.AddColumn('', false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Text);
                            end;
                            ExcelBufferTmp.AddColumn(CustTable."Credit Limit (LCY)", false, '', false, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Text);
                            ExcelBufferTmp.AddColumn(CustTable."BLACC Customer Group", false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        end;
                    until CustLegEnt.Next() = 0;
                    if AmountLCY <> 0 then begin
                        ExcelBufferTmp.NewRow();
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn(CustomerName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn('', false, '', false, false, false, '', ExcelBufferTmp."Cell Type"::Text);
                        ExcelBufferTmp.AddColumn(AmountLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmountLCY := TotalAmountLCY + AmountLCY;
                        ExcelBufferTmp.AddColumn(RemainingLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalRemainingLCY := TotalRemainingLCY + RemainingLCY;
                        ExcelBufferTmp.AddColumn(Amount90After, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmount90After := TotalAmount90After + Amount90After;
                        ExcelBufferTmp.AddColumn(Amount6190Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmount6190Due := TotalAmount6190Due + Amount6190Due;
                        ExcelBufferTmp.AddColumn(Amount3160Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmount3160Due := TotalAmount3160Due + Amount3160Due;
                        ExcelBufferTmp.AddColumn(Amount0130Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmount0130Due := TotalAmount0130Due + Amount0130Due;
                        ExcelBufferTmp.AddColumn(Amount0815Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmount0815Due := TotalAmount0815Due + Amount0815Due;
                        ExcelBufferTmp.AddColumn(Amount07Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmount07Due := TotalAmount07Due + Amount07Due;
                        ExcelBufferTmp.AddColumn(AmountNotDue, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
                        TotalAmountNotDue := TotalAmountNotDue + AmountNotDue;
                        ExcelBufferTmp.AddColumn(SalesName, false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Number);
                    end;
                end;
            until CustTable.Next() = 0;
        end;
        ExcelBufferTmp.NewRow();
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('Total', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.AddColumn(TotalAmountLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalRemainingLCY, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmount90After, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmount6190Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmount3160Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmount0130Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmount0815Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmount07Due, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn(TotalAmountNotDue, false, '', true, false, false, '#,##0.00', ExcelBufferTmp."Cell Type"::Number);
        ExcelBufferTmp.AddColumn('', false, '', true, false, false, '', ExcelBufferTmp."Cell Type"::Text);
        ExcelBufferTmp.CreateNewBook(StatisticFilter.Replace('|', '.'));
        ExcelBufferTmp.WriteSheet('Detail', 'ACC', UserId);
        ExcelBufferTmp.SetColumnWidth('A', 15);
        ExcelBufferTmp.SetColumnWidth('B', 15);
        ExcelBufferTmp.SetColumnWidth('C', 20);
        ExcelBufferTmp.SetColumnWidth('D', 20);
        ExcelBufferTmp.SetColumnWidth('E', 15);
        ExcelBufferTmp.SetColumnWidth('F', 100);
        ExcelBufferTmp.SetColumnWidth('G', 15);
        ExcelBufferTmp.SetColumnWidth('H', 10);

        ExcelBufferTmp.SetColumnWidth('I', 20);
        ExcelBufferTmp.SetColumnWidth('J', 20);
        ExcelBufferTmp.SetColumnWidth('K', 20);
        ExcelBufferTmp.SetColumnWidth('L', 20);
        ExcelBufferTmp.SetColumnWidth('M', 20);
        ExcelBufferTmp.SetColumnWidth('N', 20);
        ExcelBufferTmp.SetColumnWidth('O', 20);
        ExcelBufferTmp.SetColumnWidth('p', 20);
        ExcelBufferTmp.SetColumnWidth('Q', 35);
        ExcelBufferTmp.SetColumnWidth('R', 20);
        ExcelBufferTmp.SetColumnWidth('S', 20);
        ExcelBufferTmp.SetColumnWidth('T', 20);
        ExcelBufferTmp.CloseBook();

        Clear(TempBlob);
        FileName := StrSubstNo(ExcelFileName, StatisticFilter.Replace('|', '.'), Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
        TempBlob.CreateOutStream(OutStr);
        ExcelBufferTmp.SaveToStream(OutStr, true);
        TempBlob.CreateInStream(FileContent);

        DownloadFromStream(FileContent, '', '', '', FileName);
    end;
}
