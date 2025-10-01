codeunit 52002 "ACC Calculate Inventory"
{
    SingleInstance = true;

    trigger OnRun()
    var
        dCur: Date;
    // iMonthNo: Integer;
    // iYearNo: Integer;
    begin
        dCur := WorkDate();
        // iYearNo := Date2DMY(dCur, 3);
        // iMonthNo := Date2DMY(dCur, 2);
        // if iMonthNo = 1 then begin
        //     iYearNo -= 1;
        //     dCur := DMY2Date(31, 12, iYearNo);
        // end else begin
        //     iMonthNo -= 1;
        // end;

        CalculateItemInventoryByMonth(dCur);
    end;

    procedure CalculateItemInventoryByMonth(ivd: Date)
    var
        dF: Date;
        dT: Date;
        iMonthNo: Integer;
        iYearNo: Integer;
        iCnt: Integer;
        dFirst: Date;
        qACCILE5: Query "ACC Item Ledger Entry 5 Query";
    begin
        // dT := CalcDate('<CM>', ivd);
        // iYearNo := dT.Year;
        // iMonthNo := dT.Month;
        dT := ivd;
        iYearNo := Date2DMY(dT, 3);
        iMonthNo := Date2DMY(dT, 2);

        recACCIBM.Reset();
        recACCIBM.SetRange("Posting Date", dT);
        if recACCIBM.FindFirst() then recACCIBM.DeleteAll();

        recIP.Reset();
        recIP.SetRange(Closed, true);
        if recIP.FindFirst() then begin
            dFirst := recIP."Ending Date";
        end;

        recIP.Reset();
        recIP.SetRange("Ending Date", dT);
        recIP.SetRange(Closed, true);
        if recIP.FindFirst() then begin
            if recIP."Ending Date" = dFirst then begin
                dF := 0D;
            end else begin
                dF := CalcDate('<-CM>', ivd);
            end;

            Clear(qACCILE5);
            qACCILE5.SetRange(Posting_Date_Filter, dF, dT);
            qACCILE5.Open();
            while qACCILE5.Read() do begin
                recACCIBM.Init();
                recACCIBM."Posting Date" := dT;
                recACCIBM."Location Code" := qACCILE5.Location_Code;
                recACCIBM."Item No" := qACCILE5.Item_No;
                recACCIBM."Lot No" := qACCILE5.Lot_No;
                recACCIBM.Quantity := qACCILE5.QtySum;
                recACCIBM."Cost Amount (Actual)" := qACCILE5.Cost_Amount_Actual;
                recACCIBM.Insert();
            end;
            qACCILE5.Close();
        end;
    end;



    //Global
    var
        recACCIBM: Record "ACC Inventory By Month";
        recIP: Record "Inventory Period";
}