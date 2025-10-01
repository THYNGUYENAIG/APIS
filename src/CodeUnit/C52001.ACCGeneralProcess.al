codeunit 52001 "ACC General Process"
{
    SingleInstance = true;

    trigger OnRun()
    begin

    end;

    procedure GetValueFromFilter(var TempRecRef: RecordRef; SelectionFieldID: Integer): List of [Text]
    var
        cuSFM: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
        lstFilter: List of [Text];
    begin
        if TempRecRef.IsTemporary then begin
            RecRef := TempRecRef.Duplicate();
            RecRef.Reset();
        end else
            RecRef.Open(TempRecRef.Number, false, TempRecRef.CurrentCompany);

        TempRecRefCount := TempRecRef.Count();
        if TempRecRefCount > 0 then begin
            TempRecRef.Ascending(true);
            TempRecRef.Find('-');
            while TempRecRefCount > 0 do begin
                TempRecRefCount := TempRecRefCount - 1;
                RecRef.SetPosition(TempRecRef.GetPosition());
                RecRef.Find();
                FieldRef := RecRef.Field(SelectionFieldID);
                FirstRecRef := Format(FieldRef.Value);
                LastRecRef := FirstRecRef;
                lstFilter.Add(cuSFM.AddQuotes(LastRecRef));
                More := TempRecRefCount > 0;
                while More do
                    if RecRef.Next() = 0 then
                        More := false
                    else begin
                        SavePos := TempRecRef.GetPosition();
                        TempRecRef.SetPosition(RecRef.GetPosition());
                        if not TempRecRef.Find() then begin
                            More := false;
                            TempRecRef.SetPosition(SavePos);
                        end else begin
                            FieldRef := RecRef.Field(SelectionFieldID);
                            LastRecRef := Format(FieldRef.Value);
                            lstFilter.Add(cuSFM.AddQuotes(LastRecRef));
                            TempRecRefCount := TempRecRefCount - 1;
                            if TempRecRefCount = 0 then
                                More := false;
                        end;
                    end;

                if TempRecRefCount > 0 then
                    TempRecRef.Next();
            end;
            exit(lstFilter);
        end;
    end;

    // procedure GetManuFacturingDateFromItemLedgerEntries(ivtItem: Text; ivtLot: Text) ovdRt: Date
    // var
    //     LotTable: Record "Lot No. Information";
    // begin
    //     LotTable.SetAutoCalcFields("BLACC Expiration Date");
    //     // if LotTable.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
    //     if LotTable.Get(ivtItem, '', ivtLot) then begin
    //         LotTable.CalcManufacturingDate();
    //         ovdRt := LotTable."BLACC Manufacturing Date";
    //     end;
    // end;

    procedure AddString(var vtStrAdd: Text; ivtStrAdd: Text; ivtSplit: Text)
    begin
        if vtStrAdd = '' then begin
            vtStrAdd += StrSubstNo('%1', ivtStrAdd)
        end else begin
            vtStrAdd += ivtSplit + StrSubstNo('%1', ivtStrAdd);
        end;
    end;

    //Get Original Invoice By Line
    //Input: Type (0: Purchase - 1: Sales): Text ID: Text - Line - Integer
    //Output: List of Text: Posted Invoice No - Posted Shipment No
    procedure GetOrigInvByLine(iviType: Integer; ivtID: Text; iviLine: Integer) ovlst: List of [Text]
    var
        recPCML: Record "Purch. Cr. Memo Line";
        recSCML: Record "Sales Cr.Memo Line";
        tDesc: Text;
        iIndex: Integer;
        tInv: Text;
        iLenInv: Integer;
        tShip: Text;
    begin
        case iviType of
            0:
                begin
                    recPCML.SetRange("Document No.", ivtID);
                    recPCML.SetFilter("Line No.", '< %1', iviLine);
                    recPCML.SetRange(Type, "Purchase Line Type"::" ");
                    recPCML.Ascending(false);
                    if recPCML.FindFirst() then tDesc := recPCML.Description;
                end;
            1:
                begin
                    recSCML.SetRange("Document No.", ivtID);
                    recSCML.SetFilter("Line No.", '< %1', iviLine);
                    recSCML.SetRange(Type, "Sales Line Type"::" ");
                    recSCML.Ascending(false);
                    if recSCML.FindFirst() then tDesc := recSCML.Description;
                end;
        end;

        if tDesc <> '' then begin
            if tDesc.Contains('Shpt.') then begin
                iIndex := tDesc.IndexOf('Shpt.');
                tInv := tDesc.Substring(1, iIndex - 3);

                iLenInv := StrLen(tInv) + 3;
                tShip := tDesc.Substring(iIndex, StrLen(tDesc) - iLenInv);

                tInv := tInv.Replace('Inv. No. ', '');
                tShip := tShip.Replace('Shpt. No. ', '');
            end;
        end;

        ovlst.Add(tInv);
        ovlst.Add(tShip);
    end;

    //Convert Blob Data To Text
    //Input: Value: InStream
    //Output: Text
    procedure ConvertBlobDataToText(ivinStreamVal: InStream) ovt: Text
    var
        tLine: Text;
    begin
        while not (ivinStreamVal.EOS) do begin
            ivinStreamVal.ReadText(tLine);
            ovt += tLine;
        end;

        exit(ovt);
    end;

    //Get Invoice From Posted Purchase Credit Memo
    //Input: ID: Text
    //Output: Posted Purchase Invoice No
    procedure GetInvFromPPCM(ivtID: Text) ovt: Text
    var
        recVLE: Record "Vendor Ledger Entry";
        recVLE_Inv: Record "Vendor Ledger Entry";
    begin
        recVLE.Reset();
        recVLE.SetRange("Document Type", "Gen. Journal Document Type"::"Credit Memo");
        recVLE.SetRange("Document No.", ivtID);
        if recVLE.FindFirst() then begin
            if recVLE."Closed by Entry No." = 0 then begin
                recVLE_Inv.Reset();
                recVLE_Inv.SetRange("Document Type", "Gen. Journal Document Type"::Invoice);
                recVLE_Inv.SetRange("Closed by Entry No.", recVLE."Entry No.");
                if recVLE_Inv.FindFirst() then ovt := recVLE_Inv."Document No.";
            end else begin
                recVLE_Inv.Reset();
                recVLE_Inv.SetRange("Document Type", "Gen. Journal Document Type"::Invoice);
                recVLE_Inv.SetRange("Entry No.", recVLE."Closed by Entry No.");
                if recVLE_Inv.FindFirst() then ovt := recVLE_Inv."Document No.";
            end;
        end;

        exit(ovt);
    end;

    //Get Invoice From Posted Sales Credit Memo
    //Input: ID: Text
    //Output: Posted Sales Invoice No
    procedure GetInvFromPSCM(ivtID: Text) ovt: Text
    var
        recCLE: Record "Cust. Ledger Entry";
        recCLE_Inv: Record "Cust. Ledger Entry";
    begin
        recCLE.Reset();
        recCLE.SetRange("Document Type", "Gen. Journal Document Type"::"Credit Memo");
        recCLE.SetRange("Document No.", ivtID);
        if recCLE.FindFirst() then begin
            if recCLE."Closed by Entry No." = 0 then begin
                recCLE_Inv.Reset();
                recCLE_Inv.SetRange("Document Type", "Gen. Journal Document Type"::Invoice);
                recCLE_Inv.SetRange("Closed by Entry No.", recCLE."Entry No.");
                if recCLE_Inv.FindFirst() then ovt := recCLE_Inv."Document No.";
            end else begin
                recCLE_Inv.Reset();
                recCLE_Inv.SetRange("Document Type", "Gen. Journal Document Type"::Invoice);
                recCLE_Inv.SetRange("Entry No.", recCLE."Closed by Entry No.");
                if recCLE_Inv.FindFirst() then ovt := recCLE_Inv."Document No.";
            end;
        end;
        exit(ovt);
    end;

    //Get Date Range
    //Input: Date Text
    //Output: list of Date: From Date - To Date
    procedure GetDateRange(ivtDate: Text) ovlstRangeDate: List of [Date];
    var
        dF: Date;
        dT: Date;
        lstDate: List of [Text];
        iCnt: Integer;
        tDate: Text;
    begin
        dF := 0D;
        dT := 0D;

        if ivtDate.Contains('..') then begin
            lstDate := ivtDate.Split('..');
            for iCnt := 1 to lstDate.Count do begin
                tDate := lstDate.Get(iCnt);

                case iCnt of
                    1:
                        begin
                            if tDate <> '' then dF := BuildDateFromText(tDate);
                        end;

                    2:
                        begin
                            if tDate <> '' then begin
                                if tDate = 't' then
                                    dT := Today
                                else
                                    dT := BuildDateFromText(tDate);
                            end;
                        end;
                end;
            end;
        end else begin
            dF := BuildDateFromText(ivtDate);
            dT := dF;
        end;

        ovlstRangeDate.Add(dF);
        ovlstRangeDate.Add(dT);

        exit(ovlstRangeDate);
    end;

    //Build Date From Text
    //Input: Date Text - Length Text
    //Output: Date
    procedure BuildDateFromText(ivtDate: Text) ovd: Date
    var
        iD: Integer;
        iM: Integer;
        iY: Integer;
        iLen: Integer;
    begin
        ovd := 0D;
        if ivtDate = 't' then begin
            ovd := Today;
            exit(ovd);
        end;

        iLen := StrLen(ivtDate);

        if (iLen = 4) or (iLen = 6) or (iLen = 8) then begin
            Evaluate(iD, ivtDate.Substring(1, 2));
            Evaluate(iM, ivtDate.Substring(3, 2));
            case iLen of
                4:
                    begin
                        iY := Date2DMY(Today, 3);
                        ovd := DMY2Date(iD, iM, iY);
                    end;

                6:
                    begin
                        Evaluate(iY, ivtDate.Substring(5, 2));
                        iY += 2000;
                        ovd := DMY2Date(iD, iM, iY);
                    end;

                8:
                    begin
                        Evaluate(iY, ivtDate.Substring(5, 4));
                        ovd := DMY2Date(iD, iM, iY);
                    end;
            end;
        end;
    end;

    //Divider
    //Input: Num 1 - Num 2
    //Output: result Num 1 / Num 2
    procedure Divider(ivdecNum1: Decimal; ivdecNum2: Decimal) ovdec: Decimal
    var
    begin
        if ivdecNum2 = 0 then ovdec := 0 else ovdec := ivdecNum1 / ivdecNum2;

        exit(ovdec);
    end;

    /// <summary>
    /// Get Dimension Code Value
    /// </summary>
    /// <param name="Dimension Set ID">Integer</param>
    /// <param name="Dimension Code">Text</param>
    /// <returns>Return Dimension Value of type Text.</returns>
    procedure GetDimensionCodeValue(iviDimId: Integer; ivtDimCode: Text[20]) ovt: Text
    var
        recDSE: Record "Dimension Set Entry";
    begin
        recDSE.SetRange("Dimension Set ID", iviDimId);
        recDSE.SetRange("Dimension Code", ivtDimCode);
        if recDSE.FindFirst() then begin
            ovt := recDSE."Dimension Value Code";
        end;

        exit(ovt);
    end;

    //Get All Dimension Code Value
    //Input: Dimension Set ID
    //Output: List Dimension Value: 1: BRANCH - 2: BUSINESSUNIT - 3: C_COSTCENTER - 4: EMPLOYEE - 5: EXPENSETYPE
    //Output: List Dimension Value: 6: DIVISION - 7: PRODCATEGORY - 8: CUSTOMER
    procedure GetAllDimensionCodeValue(iviDimId: Integer) ovlstDimSet: List of [Text]
    var
        recDSE: Record "Dimension Set Entry";
        tBranch: Text;
        tBusinessUnit: Text;
        tCostCenter: Text;
        tEmployee: Text;
        tExpeseType: Text;
        tDivision: Text;
        tProdCategory: Text;
        tCustomer: Text;
    begin
        recDSE.SetRange("Dimension Set ID", iviDimId);
        if recDSE.FindSet() then begin
            repeat
                case recDSE."Dimension Code" of
                    'BRANCH':
                        tBranch := recDSE."Dimension Value Code";
                    'BUSINESSUNIT':
                        tBusinessUnit := recDSE."Dimension Value Code";
                    'COSTCENTER':
                        tCostCenter := recDSE."Dimension Value Code";
                    'EMPLOYEE':
                        tEmployee := recDSE."Dimension Value Code";
                    'EXPENSETYPE':
                        tExpeseType := recDSE."Dimension Value Code";
                    'DIVISION':
                        tDivision := recDSE."Dimension Value Code";
                    'PRODCATEGORY':
                        tProdCategory := recDSE."Dimension Value Code";
                    'CUSTOMER':
                        tCustomer := recDSE."Dimension Value Code";
                end;
            until recDSE.Next() < 1;
        end;

        ovlstDimSet.Add(tBranch);
        ovlstDimSet.Add(tBusinessUnit);
        ovlstDimSet.Add(tCostCenter);
        ovlstDimSet.Add(tEmployee);
        ovlstDimSet.Add(tExpeseType);
        ovlstDimSet.Add(tDivision);
        ovlstDimSet.Add(tProdCategory);
        ovlstDimSet.Add(tCustomer);

        exit(ovlstDimSet);
    end;

    //Add Time
    //Input: Date Time - Type - Time Add
    procedure AddTime(var vdtDateTime: DateTime; ivtType: Text; iviTimeAdd: Integer)
    var
        iTimeToAdd: Integer;
    begin
        case ivtType of
            'h':
                iTimeToAdd := iviTimeAdd * 3600;
            'm':
                iTimeToAdd := iviTimeAdd * 60;
            's':
                iTimeToAdd := iviTimeAdd;
        end;

        vdtDateTime := vdtDateTime + iTimeToAdd * 1000;
    end;

    //Get Exchange Rate
    //Input: Currency - Date Exchange
    //Output: Exchange Rate
    procedure GetExchRate(ivtCurrency: Text[10]; ivdExch: Date) ovdecRate: Decimal
    var
        recCER: Record "Currency Exchange Rate";
    begin
        ovdecRate := 0;
        if (ivtCurrency = '') or (ivtCurrency = 'VND') then exit(1);

        recCER.SetRange("Currency Code", ivtCurrency);
        recCER.SetFIlter("Starting Date", '<= %1', ivdExch);
        recCER.SetAscending("Starting Date", false);
        if recCER.FindFirst() then ovdecRate := recCER."Relational Exch. Rate Amount";

        exit(ovdecRate);
    end;

    //Get Paym Doc For Vendor
    //Input: Entry No - var Payment Document - var Date Document - var Payment Total - var Payment Total LYC
    procedure GetPaymDocForVend(iviEntryNo: Integer; var vtPaymDoc: Text; var vtDateDoc: Text; var vdecPaymTotal: Decimal; var vdecPaymTotalLYC: Decimal)
    var
        recVLE: Record "Vendor Ledger Entry";
        recDVLE1: Record "Detailed Vendor Ledg. Entry";
        recDVLE2: Record "Detailed Vendor Ledg. Entry";
        tPaymDoc: Text;
        tDateDoc: Text;
        // lstPaymDoc: List of [Text];
        iCnt: Integer;
    begin
        recDVLE1.SetCurrentKey("Vendor Ledger Entry No.");
        recDVLE1.SetRange("Vendor Ledger Entry No.", iviEntryNo);
        recDVLE1.SetFilter("Applied Vend. Ledger Entry No.", '<> %1', 0);
        recDVLE1.SetRange(Unapplied, false);
        if recDVLE1.Find('-') then begin
            repeat
                if recDVLE1."Vendor Ledger Entry No." =
                   recDVLE1."Applied Vend. Ledger Entry No."
                then begin
                    recDVLE2.Init();
                    recDVLE2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    recDVLE2.SetRange(
                      "Applied Vend. Ledger Entry No.", recDVLE1."Applied Vend. Ledger Entry No.");
                    recDVLE2.SetRange("Entry Type", recDVLE2."Entry Type"::Application);
                    recDVLE2.SetRange(Unapplied, false);
                    if recDVLE2.Find('-') then
                        repeat
                            if recDVLE2."Vendor Ledger Entry No." <>
                               recDVLE2."Applied Vend. Ledger Entry No."
                            then begin
                                recVLE.SetCurrentKey("Entry No.");
                                recVLE.SetRange("Entry No.", recDVLE2."Vendor Ledger Entry No.");
                                if recVLE.Find('-') then begin
                                    if not tPaymDoc.Contains(recVLE."Document No.") then begin
                                        // lstPaymDoc.Add(recVLE."Document No.");
                                        tPaymDoc += recVLE."Document No." + ',';
                                        tDateDoc += Format(recVLE."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + ',';
                                    end;
                                end;
                            end;
                        until recDVLE2.Next() = 0;
                end else begin
                    recVLE.SetCurrentKey("Entry No.");
                    recVLE.SetRange("Entry No.", recDVLE1."Applied Vend. Ledger Entry No.");
                    if recVLE.Find('-') then begin
                        if not tPaymDoc.Contains(recVLE."Document No.") then begin
                            // lstPaymDoc.Add(recVLE."Document No.");
                            tPaymDoc += recVLE."Document No." + ',';
                            tDateDoc += Format(recVLE."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + ',';
                        end;
                    end;
                end;
            until recDVLE1.Next() = 0;
        end;

        if tPaymDoc <> '' then vtPaymDoc := tPaymDoc.Substring(1, StrLen(tPaymDoc) - 1);
        if tDateDoc <> '' then vtDateDoc := tDateDoc.Substring(1, StrLen(tDateDoc) - 1);

        recDVLE1.Reset();
        recDVLE1.SetRange("Vendor Ledger Entry No.", iviEntryNo);
        recDVLE1.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
        if recDVLE1.FindFirst() then begin
            recDVLE1.CalcSums(Amount, "Amount (LCY)");
            vdecPaymTotal := recDVLE1.Amount;
            vdecPaymTotalLYC := recDVLE1."Amount (LCY)";
        end;
    end;

    //Get Paym Doc For Customer
    //Input: Entry No - var Payment Document - var Date Document - var Payment Total - var Payment Total LCY
    procedure GetPaymDocForCust(iviEntryNo: Integer; var vtPaymDoc: Text; var vtDateDoc: Text; var vdecPaymTotal: Decimal; var vdecPaymTotalLCY: Decimal)
    var
        recCLE: Record "Cust. Ledger Entry";
        recDCLE1: Record "Detailed Cust. Ledg. Entry";
        recDCLE2: Record "Detailed Cust. Ledg. Entry";
        tPaymDoc: Text;
        // decAmt: Decimal;
        tDateDoc: Text;
    begin
        recDCLE1.SetCurrentKey("Cust. Ledger Entry No.");
        recDCLE1.SetRange("Cust. Ledger Entry No.", iviEntryNo);
        recDCLE1.SetFilter("Applied Cust. Ledger Entry No.", '<> %1', 0);
        recDCLE1.SetRange(Unapplied, false);
        if recDCLE1.Find('-') then begin
            repeat
                if recDCLE1."Cust. Ledger Entry No." =
                   recDCLE1."Applied Cust. Ledger Entry No."
                then begin
                    recDCLE2.Init();
                    recDCLE2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    recDCLE2.SetRange(
                      "Applied Cust. Ledger Entry No.", recDCLE1."Applied Cust. Ledger Entry No.");
                    recDCLE2.SetRange("Entry Type", recDCLE2."Entry Type"::Application);
                    recDCLE2.SetRange(Unapplied, false);
                    if recDCLE2.Find('-') then
                        repeat
                            if recDCLE2."Cust. Ledger Entry No." <>
                               recDCLE2."Applied Cust. Ledger Entry No."
                            then begin
                                recCLE.SetCurrentKey("Entry No.");
                                recCLE.SetRange("Entry No.", recDCLE2."Cust. Ledger Entry No.");
                                if recCLE.Find('-') then begin
                                    // recCLE.CalcFields(recCLE."Amount (LCY)");
                                    // decAmt += recCLE."Amount (LCY)";
                                    if not tPaymDoc.Contains(recCLE."Document No.") then begin
                                        tPaymDoc += recCLE."Document No." + ',';
                                        tDateDoc += Format(recCLE."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + ',';
                                    end;
                                end;
                            end;
                        until recDCLE2.Next() = 0;
                end else begin
                    recCLE.SetCurrentKey("Entry No.");
                    recCLE.SetRange("Entry No.", recDCLE1."Applied Cust. Ledger Entry No.");
                    if recCLE.Find('-') then begin
                        // recCLE.CalcFields(recCLE."Amount (LCY)");
                        // decAmt += recCLE."Amount (LCY)";
                        if not tPaymDoc.Contains(recCLE."Document No.") then begin
                            tPaymDoc += recCLE."Document No." + ',';
                            tDateDoc += Format(recCLE."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + ',';
                        end;
                    end;
                end;
            until recDCLE1.Next() = 0;
        end;

        if tPaymDoc <> '' then vtPaymDoc := tPaymDoc.Substring(1, StrLen(tPaymDoc) - 1);
        if tDateDoc <> '' then vtDateDoc := tDateDoc.Substring(1, StrLen(tDateDoc) - 1);
        // vdecPaymTotal := decAmt;

        recDCLE1.Reset();
        recDCLE1.SetRange("Cust. Ledger Entry No.", iviEntryNo);
        recDCLE1.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
        if recDCLE1.FindFirst() then begin
            recDCLE1.CalcSums(Amount, "Amount (LCY)");
            vdecPaymTotal := recDCLE1.Amount;
            vdecPaymTotalLCY := recDCLE1."Amount (LCY)";
        end;
    end;

    //Global
    var
        recSIL: Record "Sales Invoice Line";
}