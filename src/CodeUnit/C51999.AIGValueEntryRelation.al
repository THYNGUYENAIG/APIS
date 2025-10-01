codeunit 51999 "AIG Value Entry Relation"
{
    TableNo = "AIG Value Entry Relation";

    trigger OnRun()
    begin

    end;

    procedure SetInitValueEntry()
    var
    begin
        SetSalesInvoice('', 0);
        SetSalesCrMemo('', 0);
        SetPurchInvoice('', 0);
        SetPurchCrMemo('', 0);
    end;

    procedure SetSalesValueEntry()
    var
        SalesEntry: Query "AIG Sales Invoice Value Entry";
        CrMemoEntry: Query "AIG Sales CrMemo Value Entry";
    begin
        SalesEntry.SetRange(TableNo, 0);
        if SalesEntry.Open() then begin
            while SalesEntry.Read() do begin
                SetSalesInvoice(SalesEntry.DocumentNo, SalesEntry.LineNo);
            end;
            SalesEntry.Close();
        end;

        CrMemoEntry.SetRange(TableNo, 0);
        if CrMemoEntry.Open() then begin
            while CrMemoEntry.Read() do begin
                SetSalesCrMemo(CrMemoEntry.DocumentNo, CrMemoEntry.LineNo);
            end;
            CrMemoEntry.Close();
        end;
    end;

    local procedure SetSalesInvoice(DocumentNo: Code[20]; LineNo: Integer)
    var
        ValueEntry: Record "Value Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        InventTable: Record Item;
        CustTable: Record Customer;
        Salesperson: Record "Salesperson/Purchaser";
        DimValue: Record "Dimension Value";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        AIGValueEntry: Record "AIG Value Entry Relation";
        DimArray: List of [Text];
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetCurrentKey("Document No.", "Line No.");
        if (DocumentNo <> '') AND (LineNo <> 0) then begin
            SalesInvoiceLine.SetRange("Document No.", DocumentNo);
            SalesInvoiceLine.SetRange("Line No.", LineNo);
        end;
        if SalesInvoiceLine.FindSet() then begin
            repeat

                AIGValueEntry.Reset();
                AIGValueEntry.Init();
                AIGValueEntry."Source Row ID" := ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line", 0, SalesInvoiceLine."Document No.", '', 0, SalesInvoiceLine."Line No.");
                AIGValueEntry."Table No." := Database::"Sales Invoice Line";
                AIGValueEntry."Invoice No." := SalesInvoiceLine."Document No.";
                AIGValueEntry."Invoice Line No." := SalesInvoiceLine."Line No.";
                AIGValueEntry."Order No." := SalesInvoiceLine."Order No.";
                AIGValueEntry."Order Line No." := SalesInvoiceLine."Order Line No.";
                AIGValueEntry."Source No." := SalesInvoiceLine."Sell-to Customer No.";
                AIGValueEntry."Item No." := SalesInvoiceLine."No.";
                AIGValueEntry."Search Name" := SalesInvoiceLine.Description;
                AIGValueEntry."Item Name" := SalesInvoiceLine."BLTEC Item Name";
                AIGValueEntry."Item Type" := SalesInvoiceLine.Type;
                AIGValueEntry."Unit Code" := SalesInvoiceLine."Unit of Measure Code";
                AIGValueEntry.Quantity := SalesInvoiceLine.Quantity;
                AIGValueEntry."Unit Price" := SalesInvoiceLine."Unit Price";
                AIGValueEntry."Line Amount" := SalesInvoiceLine."Line Amount";
                AIGValueEntry."Posting Date" := SalesInvoiceLine."Posting Date";
                AIGValueEntry."Unit Cost" := SalesInvoiceLine."Unit Cost";
                AIGValueEntry."Unit Cost (LCY)" := SalesInvoiceLine."Unit Cost (LCY)";
                AIGValueEntry."Charge Amount" := SalesInvoiceLine."BLACC CommissionExpenseAmount";
                If SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then begin
                    AIGValueEntry."Source Name" := SalesInvoiceHeader."Sell-to Customer Name";
                    AIGValueEntry."Invoice Account" := SalesInvoiceHeader."Bill-to Customer No.";
                    AIGValueEntry."Invoice Name" := SalesInvoiceHeader."Bill-to Name";
                    AIGValueEntry."External Document No." := SalesInvoiceHeader."External Document No.";
                    AIGValueEntry."Document Date" := SalesInvoiceHeader."Document Date";
                    AIGValueEntry."Due Date" := SalesInvoiceHeader."Due Date";
                    AIGValueEntry."Whse. Date" := SalesInvoiceHeader."Shipment Date";
                    AIGValueEntry."Exchange Rate" := 1;
                    AIGValueEntry."Sales Taker" := SalesInvoiceHeader."Salesperson Code";
                    AIGValueEntry."Sales District" := SalesInvoiceHeader."Sell-to City";
                    if Salesperson.Get(SalesInvoiceHeader."Salesperson Code") then
                        AIGValueEntry."Sales Taker Name" := Salesperson.Name;
                    if SalesInvoiceHeader."Currency Factor" <> 0 then
                        AIGValueEntry."Exchange Rate" := 1 / SalesInvoiceHeader."Currency Factor";
                end;
                AIGValueEntry."Line Amount (LCY)" := SalesInvoiceLine."Line Amount" * AIGValueEntry."Exchange Rate";
                AIGValueEntry."VAT Amount" := (SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine.Amount) * AIGValueEntry."Exchange Rate";
                AIGValueEntry."Item Tax Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                AIGValueEntry."VAT %" := SalesInvoiceLine."VAT %";
                DimArray := GetAllDimensionCodeValue(SalesInvoiceLine."Dimension Set ID");
                AIGValueEntry."Branch Code" := DimArray.Get(1);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BRANCH');
                DimValue.SetRange(Code, AIGValueEntry."Branch Code");
                if DimValue.FindFirst() then AIGValueEntry."Branch Name" := DimValue.Name;
                AIGValueEntry."BU Code" := DimArray.Get(2);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                DimValue.SetRange(Code, AIGValueEntry."BU Code");
                if DimValue.FindFirst() then AIGValueEntry."BU Name" := DimValue.Name;
                AIGValueEntry."Cost Center" := DimArray.Get(3);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'COSTCENTER');
                DimValue.SetRange(Code, AIGValueEntry."Cost Center");
                if DimValue.FindFirst() then AIGValueEntry."Cost Center Name" := DimValue.Name;
                AIGValueEntry.Insert();
            until SalesInvoiceLine.Next() = 0;
        end;
    end;

    local procedure SetSalesCrMemo(DocumentNo: Code[20]; LineNo: Integer)
    var
        ValueEntry: Record "Value Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        InventTable: Record Item;
        CustTable: Record Customer;
        Salesperson: Record "Salesperson/Purchaser";
        DimValue: Record "Dimension Value";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        AIGValueEntry: Record "AIG Value Entry Relation";
        DimArray: List of [Text];
    begin
        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetCurrentKey("Document No.", "Line No.");

        if (DocumentNo <> '') AND (LineNo <> 0) then begin
            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
            SalesCrMemoLine.SetRange("Line No.", LineNo);
        end;

        if SalesCrMemoLine.FindSet() then begin
            repeat
                AIGValueEntry.Reset();
                AIGValueEntry.Init();
                AIGValueEntry."Source Row ID" := ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Cr.Memo Line", 0, SalesCrMemoLine."Document No.", '', 0, SalesCrMemoLine."Line No.");
                AIGValueEntry."Table No." := Database::"Sales Cr.Memo Line";
                AIGValueEntry."Invoice No." := SalesCrMemoLine."Document No.";
                AIGValueEntry."Invoice Line No." := SalesCrMemoLine."Line No.";
                AIGValueEntry."Order No." := SalesCrMemoLine."Order No.";
                AIGValueEntry."Order Line No." := SalesCrMemoLine."Order Line No.";
                AIGValueEntry."Source No." := SalesCrMemoLine."Sell-to Customer No.";

                AIGValueEntry."Item No." := SalesCrMemoLine."No.";
                AIGValueEntry."Search Name" := SalesCrMemoLine.Description;
                AIGValueEntry."Item Name" := SalesCrMemoLine."BLTEC Item Name";
                AIGValueEntry."Item Type" := SalesCrMemoLine.Type;
                AIGValueEntry."Unit Code" := SalesCrMemoLine."Unit of Measure Code";
                AIGValueEntry.Quantity := SalesCrMemoLine.Quantity * -1;
                AIGValueEntry."Unit Price" := SalesCrMemoLine."Unit Price";
                AIGValueEntry."Line Amount" := SalesCrMemoLine."Line Amount" * -1;

                AIGValueEntry."Posting Date" := SalesCrMemoLine."Posting Date";
                AIGValueEntry."Unit Cost" := SalesCrMemoLine."Unit Cost";
                AIGValueEntry."Unit Cost (LCY)" := SalesCrMemoLine."Unit Cost (LCY)";
                AIGValueEntry."Charge Amount" := -SalesCrMemoLine."BLACC CommissionExpenseAmount";
                If SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then begin
                    AIGValueEntry."Source Name" := SalesCrMemoHeader."Sell-to Customer Name";
                    AIGValueEntry."Invoice Account" := SalesCrMemoHeader."Bill-to Customer No.";
                    AIGValueEntry."Invoice Name" := SalesCrMemoHeader."Bill-to Name";
                    AIGValueEntry."External Document No." := SalesCrMemoHeader."External Document No.";
                    AIGValueEntry."Document Date" := SalesCrMemoHeader."Document Date";
                    AIGValueEntry."Due Date" := SalesCrMemoHeader."Due Date";
                    AIGValueEntry."Whse. Date" := SalesCrMemoHeader."Shipment Date";
                    AIGValueEntry."Exchange Rate" := 1;
                    AIGValueEntry."Sales Taker" := SalesCrMemoHeader."Salesperson Code";
                    AIGValueEntry."Sales District" := SalesCrMemoHeader."Sell-to City";
                    if Salesperson.Get(SalesCrMemoHeader."Salesperson Code") then
                        AIGValueEntry."Sales Taker Name" := Salesperson.Name;
                    if SalesCrMemoHeader."Currency Factor" <> 0 then
                        AIGValueEntry."Exchange Rate" := 1 / SalesCrMemoHeader."Currency Factor";
                end;
                AIGValueEntry."Line Amount (LCY)" := SalesCrMemoLine."Line Amount" * AIGValueEntry."Exchange Rate" * -1;
                AIGValueEntry."VAT Amount" := (SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount) * AIGValueEntry."Exchange Rate" * -1;
                AIGValueEntry."Item Tax Group" := SalesCrMemoLine."VAT Prod. Posting Group";
                AIGValueEntry."VAT %" := SalesCrMemoLine."VAT %";
                DimArray := GetAllDimensionCodeValue(SalesCrMemoLine."Dimension Set ID");
                AIGValueEntry."Branch Code" := DimArray.Get(1);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BRANCH');
                DimValue.SetRange(Code, AIGValueEntry."Branch Code");
                if DimValue.FindFirst() then AIGValueEntry."Branch Name" := DimValue.Name;
                AIGValueEntry."BU Code" := DimArray.Get(2);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                DimValue.SetRange(Code, AIGValueEntry."BU Code");
                if DimValue.FindFirst() then AIGValueEntry."BU Name" := DimValue.Name;
                AIGValueEntry."Cost Center" := DimArray.Get(3);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'COSTCENTER');
                DimValue.SetRange(Code, AIGValueEntry."Cost Center");
                if DimValue.FindFirst() then AIGValueEntry."Cost Center Name" := DimValue.Name;
                AIGValueEntry.Insert();
            until SalesCrMemoLine.Next() = 0;
        end;
    end;

    procedure SetPurchValueEntry()
    var
        PurchEntry: Query "AIG Purch Invoice Value Entry";
        CrMemoEntry: Query "AIG Purch CrMemo Value Entry";
    begin
        PurchEntry.SetRange(TableNo, 0);
        if PurchEntry.Open() then begin
            while PurchEntry.Read() do begin
                SetPurchInvoice(PurchEntry.DocumentNo, PurchEntry.LineNo);
            end;
            PurchEntry.Close();
        end;
        CrMemoEntry.SetRange(TableNo, 0);
        if CrMemoEntry.Open() then begin
            while CrMemoEntry.Read() do begin
                SetPurchCrMemo(CrMemoEntry.DocumentNo, CrMemoEntry.LineNo);
            end;
            CrMemoEntry.Close();
        end;
    end;

    local procedure SetPurchInvoice(DocumentNo: Code[20]; LineNo: Integer)
    var
        ValueEntry: Record "Value Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        PurchInvoiceLine: Record "Purch. Inv. Line";
        Purchaser: Record "Salesperson/Purchaser";
        AIGValueEntry: Record "AIG Value Entry Relation";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
    begin
        PurchInvoiceLine.Reset();
        PurchInvoiceLine.SetCurrentKey("Document No.", "Line No.");

        if (DocumentNo <> '') AND (LineNo <> 0) then begin
            PurchInvoiceLine.SetRange("Document No.", DocumentNo);
            PurchInvoiceLine.SetRange("Line No.", LineNo);
        end;

        if PurchInvoiceLine.FindSet() then begin
            repeat
                AIGValueEntry.Reset();
                AIGValueEntry.Init();
                AIGValueEntry."Source Row ID" := ItemTrackingMgt.ComposeRowID(DATABASE::"Purch. Inv. Line", 0, PurchInvoiceLine."Document No.", '', 0, PurchInvoiceLine."Line No.");
                AIGValueEntry."Table No." := Database::"Purch. Inv. Line";
                AIGValueEntry."Invoice No." := PurchInvoiceLine."Document No.";
                AIGValueEntry."Invoice Line No." := PurchInvoiceLine."Line No.";
                AIGValueEntry."Order No." := PurchInvoiceLine."Order No.";
                AIGValueEntry."Order Line No." := PurchInvoiceLine."Order Line No.";
                AIGValueEntry."Source No." := PurchInvoiceLine."Buy-from Vendor No.";
                AIGValueEntry."Item No." := PurchInvoiceLine."No.";
                AIGValueEntry."Item Name" := PurchInvoiceLine.Description;
                AIGValueEntry."Item Type" := PurchInvoiceLine.Type;
                AIGValueEntry."Unit Code" := PurchInvoiceLine."Unit of Measure Code";
                AIGValueEntry.Quantity := PurchInvoiceLine.Quantity;
                AIGValueEntry."Unit Price" := PurchInvoiceLine."Direct Unit Cost";
                AIGValueEntry."Line Amount" := PurchInvoiceLine."Line Amount";
                AIGValueEntry."VAT Amount" := PurchInvoiceLine."Amount Including VAT" - PurchInvoiceLine.Amount;
                AIGValueEntry."Posting Date" := PurchInvoiceLine."Posting Date";
                AIGValueEntry."Unit Cost" := PurchInvoiceLine."Unit Cost";
                AIGValueEntry."Unit Cost (LCY)" := PurchInvoiceLine."Unit Cost (LCY)";
                AIGValueEntry."Declaration No." := PurchInvoiceLine."BLTEC Customs Declaration No.";
                If PurchInvoiceHeader.Get(PurchInvoiceLine."Document No.") then begin
                    AIGValueEntry."Invoice Account" := PurchInvoiceHeader."Pay-to Vendor No.";
                    AIGValueEntry."Invoice Name" := PurchInvoiceHeader."Pay-to Name";
                    AIGValueEntry."Source Name" := PurchInvoiceHeader."Buy-from Vendor Name";
                    AIGValueEntry."Document Date" := PurchInvoiceHeader."Document Date";
                    AIGValueEntry."Due Date" := PurchInvoiceHeader."Due Date";
                    AIGValueEntry."Whse. Date" := PurchInvoiceHeader."Expected Receipt Date";
                    AIGValueEntry."Currency Code" := PurchInvoiceHeader."Currency Code";
                    AIGValueEntry."Exchange Rate" := 1;
                    AIGValueEntry."Sales Taker" := PurchInvoiceHeader."Purchaser Code";
                    AIGValueEntry."External Document No." := PurchInvoiceHeader."Vendor Invoice No.";
                    if Purchaser.Get(PurchInvoiceHeader."Purchaser Code") then
                        AIGValueEntry."Sales Taker Name" := Purchaser.Name;
                    if PurchInvoiceHeader."Currency Factor" <> 0 then
                        AIGValueEntry."Exchange Rate" := 1 / PurchInvoiceHeader."Currency Factor";
                end;
                AIGValueEntry."Line Amount (LCY)" := PurchInvoiceLine."Line Amount" * AIGValueEntry."Exchange Rate";
                AIGValueEntry."VAT Amount" := (PurchInvoiceLine."Amount Including VAT" - PurchInvoiceLine.Amount) * AIGValueEntry."Exchange Rate";
                DimArray := GetAllDimensionCodeValue(PurchInvoiceLine."Dimension Set ID");
                AIGValueEntry."Branch Code" := DimArray.Get(1);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BRANCH');
                DimValue.SetRange(Code, AIGValueEntry."Branch Code");
                if DimValue.FindFirst() then AIGValueEntry."Branch Name" := DimValue.Name;
                AIGValueEntry."BU Code" := DimArray.Get(2);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                DimValue.SetRange(Code, AIGValueEntry."BU Code");
                if DimValue.FindFirst() then AIGValueEntry."BU Name" := DimValue.Name;
                AIGValueEntry."Cost Center" := DimArray.Get(3);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'COSTCENTER');
                DimValue.SetRange(Code, AIGValueEntry."Cost Center");
                if DimValue.FindFirst() then AIGValueEntry."Cost Center Name" := DimValue.Name;
                AIGValueEntry.Insert();
            until PurchInvoiceLine.Next() = 0;
        end;
    end;

    local procedure SetPurchCrMemo(DocumentNo: Code[20]; LineNo: Integer)
    var
        ValueEntry: Record "Value Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        Purchaser: Record "Salesperson/Purchaser";
        AIGValueEntry: Record "AIG Value Entry Relation";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
    begin
        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetCurrentKey("Document No.", "Line No.");
        if (DocumentNo <> '') AND (LineNo <> 0) then begin
            PurchCrMemoLine.SetRange("Document No.", DocumentNo);
            PurchCrMemoLine.SetRange("Line No.", LineNo);
        end;

        if PurchCrMemoLine.FindSet() then begin
            repeat
                AIGValueEntry.Reset();
                AIGValueEntry.Init();
                AIGValueEntry."Source Row ID" := ItemTrackingMgt.ComposeRowID(DATABASE::"Purch. Cr. Memo Line", 0, PurchCrMemoLine."Document No.", '', 0, PurchCrMemoLine."Line No.");
                AIGValueEntry."Table No." := Database::"Purch. Cr. Memo Line";
                AIGValueEntry."Invoice No." := PurchCrMemoLine."Document No.";
                AIGValueEntry."Invoice Line No." := PurchCrMemoLine."Line No.";
                AIGValueEntry."Order No." := PurchCrMemoLine."Order No.";
                AIGValueEntry."Order Line No." := PurchCrMemoLine."Order Line No.";
                AIGValueEntry."Source No." := PurchCrMemoLine."Buy-from Vendor No.";

                AIGValueEntry."Item No." := PurchCrMemoLine."No.";
                AIGValueEntry."Item Name" := PurchCrMemoLine.Description;
                AIGValueEntry."Item Type" := PurchCrMemoLine.Type;
                AIGValueEntry."Unit Code" := PurchCrMemoLine."Unit of Measure Code";
                AIGValueEntry.Quantity := -PurchCrMemoLine.Quantity;
                AIGValueEntry."Unit Price" := PurchCrMemoLine."Direct Unit Cost";
                AIGValueEntry."Line Amount" := -PurchCrMemoLine."Line Amount";
                //AIGValueEntry."VAT Amount" := -(PurchCrMemoLine."Amount Including VAT" - PurchCrMemoLine.Amount);
                AIGValueEntry."Posting Date" := PurchCrMemoLine."Posting Date";
                AIGValueEntry."Unit Cost" := PurchCrMemoLine."Unit Cost";
                AIGValueEntry."Unit Cost (LCY)" := PurchCrMemoLine."Unit Cost (LCY)";

                If PurchCrMemoHeader.Get(PurchCrMemoLine."Document No.") then begin
                    AIGValueEntry."Source Name" := PurchCrMemoHeader."Buy-from Vendor Name";
                    AIGValueEntry."Document Date" := PurchCrMemoHeader."Document Date";
                    AIGValueEntry."Due Date" := PurchCrMemoHeader."Due Date";
                    AIGValueEntry."Whse. Date" := PurchCrMemoHeader."Expected Receipt Date";
                    AIGValueEntry."Exchange Rate" := 1;
                    AIGValueEntry."Sales Taker" := PurchCrMemoHeader."Purchaser Code";
                    AIGValueEntry."External Document No." := PurchCrMemoHeader."Vendor Cr. Memo No.";
                    if Purchaser.Get(PurchCrMemoHeader."Purchaser Code") then
                        AIGValueEntry."Sales Taker Name" := Purchaser.Name;
                    if PurchCrMemoHeader."Currency Factor" <> 0 then
                        AIGValueEntry."Exchange Rate" := 1 / PurchCrMemoHeader."Currency Factor";
                end;
                AIGValueEntry."Line Amount (LCY)" := -(PurchCrMemoLine."Line Amount" * AIGValueEntry."Exchange Rate");
                AIGValueEntry."VAT Amount" := -(PurchCrMemoLine."Amount Including VAT" - PurchCrMemoLine.Amount) * AIGValueEntry."Exchange Rate";
                DimArray := GetAllDimensionCodeValue(PurchCrMemoLine."Dimension Set ID");
                AIGValueEntry."Branch Code" := DimArray.Get(1);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BRANCH');
                DimValue.SetRange(Code, AIGValueEntry."Branch Code");
                if DimValue.FindFirst() then AIGValueEntry."Branch Name" := DimValue.Name;
                AIGValueEntry."BU Code" := DimArray.Get(2);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                DimValue.SetRange(Code, AIGValueEntry."BU Code");
                if DimValue.FindFirst() then AIGValueEntry."BU Name" := DimValue.Name;
                AIGValueEntry."Cost Center" := DimArray.Get(3);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'COSTCENTER');
                DimValue.SetRange(Code, AIGValueEntry."Cost Center");
                if DimValue.FindFirst() then AIGValueEntry."Cost Center Name" := DimValue.Name;
                AIGValueEntry.Insert();
            until PurchCrMemoLine.Next() = 0;
        end;
    end;

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
}
