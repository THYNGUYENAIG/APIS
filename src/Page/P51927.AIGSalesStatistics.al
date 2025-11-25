page 51927 "AIG Sales Statistics"
{
    ApplicationArea = All;
    Caption = 'AIG Sales Statistics';
    PageType = List;
    SourceTable = "AIG Sales Statistics";
    UsageCategory = ReportsAndAnalysis;
    //DeleteAllowed = false;
    InsertAllowed = false;
    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sales District"; Rec."Sales District") { }
                field("Sales Taker"; Rec."Sales Taker") { }
                field("Sales Taker Name"; Rec."Sales Taker Name") { }
                field("Branch Code"; Rec."Branch Code") { }
                field("Branch Name"; Rec."Branch Name") { }
                field("BU Code"; Rec."BU Code") { }
                field("BU Name"; Rec."BU Name") { }
                field("Cost Center"; Rec."Cost Center") { }
                field("Cost Center Name"; Rec."Cost Center Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Invoice';
                }
                field("Line No."; Rec."Line No.") { }
                field("Invoice Account"; Rec."Invoice Account") { }
                field("Invoice Name"; Rec."Invoice Name") { }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    Caption = 'eInvocie Date';
                }
                field("Invoice No."; Rec."Invoice No.") { }
                field("eInvoice Series"; Rec."eInvoice Series") { }
                field("Sales Order"; Rec."Sales Order") { }
                field("Credit Note"; Rec."Credit Note") { }
                field("Customer Account"; Rec."Customer Account") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Customer Group Name"; Rec."Customer Group Name") { }
                field("Vendor No."; Rec."Vendor No.") { }
                field("Item Number"; Rec."Item Number") { }
                field("Search Name"; Rec."Search Name") { }
                field(Description; Rec.Description) { }
                field(Unit; Rec.Unit) { }
                field(Quantity; Rec.Quantity) { }
                field("Unit Price"; Rec."Unit Price") { }
                field(Amount; Rec.Amount) { }
                field("Exchange Rate"; Rec."Exchange Rate") { }
                field("Amount (LCY)"; Rec."Amount (LCY)") { }
                field("Cost Amount"; Rec."Cost Amount") { }
                field("Cost Amount Adjust."; Rec."Cost Amount Adjust.") { }
                field(GM1; GM1)
                {
                    ApplicationArea = All;
                    Caption = 'GM1';
                }
                field("Charge Amount"; Rec."Charge Amount") { }
                field(GM2; GM2)
                {
                    ApplicationArea = All;
                    Caption = 'GM2';
                }
                field("Sales Tax Amount"; Rec."Sales Tax Amount") { }
                field("VAT %"; Rec."VAT %") { }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group") { }
                field(Warehouse; Rec.Warehouse) { }
                field("Packing Slip"; Rec."Packing Slip") { }
                field("Physical Date"; Rec."Physical Date") { }
                field("Orig Invoice No."; Rec."Orig Invoice No.") { }
                field("Orig eInvoice No."; Rec."Orig eInvoice No.") { }
                field("Orig Invoice Date"; Rec."Orig Invoice Date") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCRefeshThisMonth)
            {
                ApplicationArea = All;
                Image = Refresh;
                Caption = 'Refesh This Month';
                trigger OnAction()
                var
                    FromDate: Date;
                    ToDate: Date;
                begin
                    FromDate := CalcDate('-CM', Today);
                    FromDate := CalcDate('-1M', FromDate);
                    ToDate := Today;
                    ValueRelation();
                    CostValueEntry(FromDate, ToDate);
                    SalesStatistics('', FromDate, ToDate);
                    ServiceRevenue('', FromDate, ToDate);
                    GiftRevenue('', FromDate, ToDate);
                end;
            }
            action(ACCReset)
            {
                ApplicationArea = All;
                Image = ResetStatus;
                Caption = 'Select Reset';
                trigger OnAction()
                var
                    SalesStatistics: Record "AIG Sales Statistics";
                    TempStatistics: Record "AIG Sales Statistics" temporary;
                    ValueEntry: Record "AIG Value Entry Relation";
                begin
                    CurrPage.SetSelectionFilter(SalesStatistics);
                    if SalesStatistics.FindSet() then
                        repeat
                            Clear(TempStatistics);
                            TempStatistics := SalesStatistics;
                            TempStatistics.Insert();
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Invoice No.", SalesStatistics."Document No.");
                            if ValueEntry.FindSet() then
                                ValueEntry.Delete();
                        until SalesStatistics.Next() = 0;

                    ValueRelation();
                    Clear(TempStatistics);
                    if TempStatistics.FindSet() then
                        repeat
                            SalesStatistics := TempStatistics;
                            SalesStatistics.Delete();
                            SalesStatistics(TempStatistics."Document No.", 0D, 0D);
                            ServiceRevenue(TempStatistics."Document No.", 0D, 0D);
                            GiftRevenue(TempStatistics."Document No.", 0D, 0D);
                        until TempStatistics.Next() = 0;
                end;
            }
        }
    }

    local procedure SalesStatistics(DocumentNo: Code[20]; FromDate: Date; ToDate: Date)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        eInvoiceHeader: Record "Sales Invoice Header";
        eInvoiceRegister: Record "BLTI eInvoice Register";
        SalesCrMemosHeader: Record "Sales Cr.Memo Header";
        SalesCrMemosLine: Record "Sales Cr.Memo Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueRelation: Record "AIG Value Entry Relation";
        CostValueEntry: Record "AIG Cost Value Entry";
        SalesStatistics: Record "AIG Sales Statistics";
        ItemTable: Record Item;
        CustTable: Record Customer;
        CustGroup: Record "BLACC Customer Group";
    begin
        CostValueEntry.Reset();
        CostValueEntry.SetCurrentKey("Document No.");
        if DocumentNo <> '' then begin
            CostValueEntry.SetRange("Document No.", DocumentNo);
        end else
            CostValueEntry.SetRange("Posting Date", FromDate, ToDate);
        CostValueEntry.SetFilter("Document Type", StrSubstNo('%1|%2', "Item Ledger Document Type"::"Sales Invoice", "Item Ledger Document Type"::"Sales Credit Memo"));
        if CostValueEntry.FindSet() then begin
            repeat
                if not SalesStatistics.Get(CostValueEntry."Document No.", CostValueEntry."Line No.", CostValueEntry."Posting Date") then begin
                    SalesStatistics.Init();
                    SalesStatistics."Document Type" := CostValueEntry."Document Type";
                    SalesStatistics."Document No." := CostValueEntry."Document No.";
                    SalesStatistics."Line No." := CostValueEntry."Line No.";
                    SalesStatistics."Posting Date" := CostValueEntry."Posting Date";
                    SalesStatistics."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Entry No.", CostValueEntry."Item Ledger Entry No.");
                    if ItemLedgerEntry.FindFirst() then begin
                        SalesStatistics.Warehouse := ItemLedgerEntry."Location Code";
                        SalesStatistics."Packing Slip" := ItemLedgerEntry."Document No.";
                        SalesStatistics."Physical Date" := ItemLedgerEntry."Posting Date";
                    end;
                    ValueRelation.Reset();
                    ValueRelation.SetRange("Invoice No.", CostValueEntry."Document No.");
                    ValueRelation.SetRange("Invoice Line No.", CostValueEntry."Line No.");
                    if ValueRelation.FindFirst() then begin
                        SalesStatistics."Sales Order" := ValueRelation."Order No.";
                        SalesStatistics."Customer Account" := ValueRelation."Source No.";
                        SalesStatistics."Item Number" := ValueRelation."Item No.";
                        SalesStatistics.Description := ValueRelation."Item Name";
                        SalesStatistics."Search Name" := ValueRelation."Search Name";
                        SalesStatistics.Unit := ValueRelation."Unit Code";
                        SalesStatistics."Invoice Date" := ValueRelation."Posting Date";
                        SalesStatistics."Invoice No." := ValueRelation."External Document No.";
                        SalesStatistics."Sales District" := ValueRelation."Sales District";
                        SalesStatistics."Sales Taker" := ValueRelation."Sales Taker";
                        SalesStatistics."Sales Taker Name" := ValueRelation."Sales Taker Name";
                        SalesStatistics."Branch Code" := ValueRelation."Branch Code";
                        SalesStatistics."Branch Name" := ValueRelation."Branch Name";
                        SalesStatistics."BU Code" := ValueRelation."BU Code";
                        SalesStatistics."BU Name" := ValueRelation."BU Name";
                        SalesStatistics."Cost Center" := ValueRelation."Cost Center";
                        SalesStatistics."Cost Center Name" := ValueRelation."Cost Center Name";
                        SalesStatistics."Invoice Account" := ValueRelation."Invoice Account";
                        if ItemTable.Get(ValueRelation."Item No.") then SalesStatistics."Vendor No." := ItemTable."Vendor No.";
                        if CustTable.Get(ValueRelation."Source No.") then begin
                            SalesStatistics."Customer Group" := CustTable."BLACC Customer Group";
                            SalesStatistics."Customer Name" := CustTable.Name;
                            if CustGroup.Get(CustTable."BLACC Customer Group") then SalesStatistics."Customer Group Name" := CustGroup.Description;
                        end;
                        if CustTable.Get(ValueRelation."Invoice Account") then begin
                            SalesStatistics."Invoice Name" := CustTable.Name;
                        end;
                    end;
                    ValueRelation.Reset();
                    ValueRelation.SetRange("Invoice No.", CostValueEntry."Document No.");
                    ValueRelation.SetRange("Invoice Line No.", CostValueEntry."Line No.");
                    ValueRelation.SetRange("Posting Date", CostValueEntry."Posting Date");
                    if ValueRelation.FindFirst() then begin
                        SalesStatistics.Quantity := ValueRelation.Quantity;
                        SalesStatistics."Unit Price" := ValueRelation."Unit Price";
                        SalesStatistics.Amount := ValueRelation."Line Amount";
                        SalesStatistics."Sales Tax Amount" := ValueRelation."VAT Amount";
                        SalesStatistics."Item Sales Tax Group" := ValueRelation."Item Tax Group";
                        SalesStatistics."VAT %" := ValueRelation."VAT %";
                        SalesStatistics."Exchange Rate" := ValueRelation."Exchange Rate";
                        SalesStatistics."Amount (LCY)" := ValueRelation."Line Amount (LCY)";
                    end;
                    if CostValueEntry."Document Type" = "Item Ledger Document Type"::"Sales Credit Memo" then begin
                        SalesCrMemosLine.Reset();
                        SalesCrMemosLine.SetRange("Document No.", CostValueEntry."Document No.");
                        SalesCrMemosLine.SetRange("Line No.", CostValueEntry."Line No.");
                        SalesCrMemosLine.SetRange("Posting Date", CostValueEntry."Posting Date");
                        if SalesCrMemosLine.FindFirst() then
                            SalesStatistics."VAT Prod. Posting Group" := SalesCrMemosLine."VAT Prod. Posting Group";
                        SalesStatistics."Credit Note" := true;
                        SalesCrMemosHeader.Reset();
                        SalesCrMemosHeader.SetRange("No.", SalesStatistics."Document No.");
                        SalesCrMemosHeader.SetRange("Posting Date", SalesStatistics."Invoice Date");
                        SalesCrMemosHeader.SetFilter("BLTI Original eInvoice No.", '<>%1', '');
                        if SalesCrMemosHeader.FindFirst() then begin
                            eInvoiceHeader.Reset();
                            eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesCrMemosHeader."BLTI Original eInvoice No.");
                            if eInvoiceHeader.FindFirst() then begin
                                SalesStatistics."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                                SalesStatistics."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                                SalesStatistics."Sales Order" := eInvoiceHeader."Order No.";
                                SalesStatistics."Orig Invoice No." := eInvoiceHeader."No.";
                            end;
                        end;
                    end;
                    if CostValueEntry."Document Type" = "Item Ledger Document Type"::"Sales Invoice" then begin
                        SalesInvoiceLine.Reset();
                        SalesInvoiceLine.SetRange("Document No.", CostValueEntry."Document No.");
                        SalesInvoiceLine.SetRange("Line No.", CostValueEntry."Line No.");
                        SalesInvoiceLine.SetRange("Posting Date", CostValueEntry."Posting Date");
                        if SalesInvoiceLine.FindFirst() then
                            SalesStatistics."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                        SalesInvoiceHeader.Reset();
                        SalesInvoiceHeader.SetRange("No.", SalesStatistics."Document No.");
                        SalesInvoiceHeader.SetRange("Posting Date", SalesStatistics."Invoice Date");
                        SalesInvoiceHeader.SetFilter("BLTI Original eInvoice No.", '<>%1', '');
                        if SalesInvoiceHeader.FindFirst() then begin
                            eInvoiceHeader.Reset();
                            eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesInvoiceHeader."BLTI Original eInvoice No.");
                            if eInvoiceHeader.FindFirst() then begin
                                SalesStatistics."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                                SalesStatistics."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                                SalesStatistics."Sales Order" := eInvoiceHeader."Order No.";
                                SalesStatistics."Orig Invoice No." := eInvoiceHeader."No.";
                            end;
                        end;
                    end;
                    SalesStatistics.Insert();
                end;
            until CostValueEntry.Next() = 0;
        end;
    end;

    local procedure CostValueEntry(FromDate: Date; ToDate: Date)
    var
        CostValueQuery: Query "AIG Cost Value Entry";
        CostValueEntry: Record "AIG Cost Value Entry";
    begin
        CostValueQuery.SetRange(PostingDate, FromDate, ToDate);
        CostValueQuery.SetRange(Adjustment, false);
        if CostValueQuery.Open() then begin
            while CostValueQuery.Read() do begin
                if not CostValueEntry.Get(CostValueQuery.DocumentNo, CostValueQuery.DocumentLineNo, CostValueQuery.ItemLedgerEntryNo, CostValueQuery.PostingDate) then begin
                    CostValueEntry.Init();
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Invoice" then CostValueEntry."Table No." := 113;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Credit Memo" then CostValueEntry."Table No." := 115;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Invoice" then CostValueEntry."Table No." := 123;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Credit Memo" then CostValueEntry."Table No." := 125;
                    CostValueEntry."Document Type" := CostValueQuery.DocumentType;
                    CostValueEntry."Document No." := CostValueQuery.DocumentNo;
                    CostValueEntry."Line No." := CostValueQuery.DocumentLineNo;
                    CostValueEntry."Item Ledger Entry No." := CostValueQuery.ItemLedgerEntryNo;
                    CostValueEntry."Posting Date" := CostValueQuery.PostingDate;
                    CostValueEntry."AIG Cost Amount" := CostValueQuery.CostAmountActual;
                    CostValueEntry.Insert();
                end;
            end;
            CostValueQuery.Close();
        end;

        CostValueQuery.SetRange(PostingDate, FromDate, ToDate);
        CostValueQuery.SetRange(Adjustment, true);
        if CostValueQuery.Open() then begin
            while CostValueQuery.Read() do begin
                if CostValueEntry.Get(CostValueQuery.DocumentNo, CostValueQuery.DocumentLineNo, CostValueQuery.ItemLedgerEntryNo, CostValueQuery.PostingDate) then begin
                    if CostValueEntry."AIG Cost Amount Adjustment" <> CostValueQuery.CostAmountActual then begin
                        CostValueEntry."AIG Cost Amount Adjustment" := CostValueQuery.CostAmountActual;
                        CostValueEntry.Modify();
                    end;
                end else begin
                    CostValueEntry.Init();
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Invoice" then CostValueEntry."Table No." := 113;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Credit Memo" then CostValueEntry."Table No." := 115;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Invoice" then CostValueEntry."Table No." := 123;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Credit Memo" then CostValueEntry."Table No." := 125;
                    CostValueEntry."Document Type" := CostValueQuery.DocumentType;
                    CostValueEntry."Document No." := CostValueQuery.DocumentNo;
                    CostValueEntry."Line No." := CostValueQuery.DocumentLineNo;
                    CostValueEntry."Item Ledger Entry No." := CostValueQuery.ItemLedgerEntryNo;
                    CostValueEntry."Posting Date" := CostValueQuery.PostingDate;
                    CostValueEntry."AIG Cost Amount Adjustment" := CostValueQuery.CostAmountActual;
                    CostValueEntry.Insert();
                end;
            end;
            CostValueQuery.Close();
        end;
    end;

    local procedure ValueRelation()
    var
        AIGValueEntry: Codeunit "AIG Value Entry Relation";
    begin
        AIGValueEntry.SetSalesValueEntry();
    end;

    local procedure ServiceRevenue(DocumentNo: Code[20]; FromDate: Date; ToDate: Date)
    var
        SalesStatistics: Record "AIG Sales Statistics";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        eInvoiceHeader: Record "Sales Invoice Header";
        eInvoiceRegister: Record "BLTI eInvoice Register";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemosHeader: Record "Sales Cr.Memo Header";
        SalesCrMemosLine: Record "Sales Cr.Memo Line";
        Salesperson: Record "Salesperson/Purchaser";
        CustTable: Record Customer;
        CustGroup: Record "BLACC Customer Group";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange(Type, "Sales Line Type"::"G/L Account");
        if DocumentNo <> '' then begin
            SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        end else
            SalesInvoiceLine.SetRange("Posting Date", FromDate, ToDate);
        SalesInvoiceLine.SetFilter("No.", '511*|515*|6428*');
        if SalesInvoiceLine.FindSet() then
            repeat
                if not SalesStatistics.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Posting Date") then begin
                    SalesStatistics."Document Type" := "Item Ledger Document Type"::"Sales Invoice";
                    SalesStatistics."Document No." := SalesInvoiceLine."Document No.";
                    SalesStatistics."Line No." := SalesInvoiceLine."Line No.";
                    SalesStatistics."Posting Date" := SalesInvoiceLine."Posting Date";
                    //SalesStatistics."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    SalesStatistics."Sales Order" := SalesInvoiceLine."Order No.";
                    SalesStatistics."Customer Account" := SalesInvoiceLine."Sell-to Customer No.";
                    SalesStatistics."Item Number" := SalesInvoiceLine."No.";
                    SalesStatistics.Description := SalesInvoiceLine."BLTEC Item Name";
                    SalesStatistics."Search Name" := SalesInvoiceLine.Description;
                    SalesStatistics.Unit := SalesInvoiceLine."Unit of Measure Code";
                    SalesStatistics."Invoice Date" := SalesInvoiceLine."Posting Date";
                    SalesStatistics."Invoice No." := SalesInvoiceLine."BLTI eInvoice No.";
                    if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then begin
                        SalesStatistics."Sales Taker" := SalesInvoiceHeader."Salesperson Code";
                        SalesStatistics."Sales District" := SalesInvoiceHeader."Sell-to City";
                        if Salesperson.Get(SalesInvoiceHeader."Salesperson Code") then
                            SalesStatistics."Sales Taker Name" := Salesperson.Name;
                    end;
                    DimArray := GetAllDimensionCodeValue(SalesInvoiceLine."Dimension Set ID");
                    SalesStatistics."Branch Code" := DimArray.Get(1);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BRANCH');
                    DimValue.SetRange(Code, SalesStatistics."Branch Code");
                    if DimValue.FindFirst() then SalesStatistics."Branch Name" := DimValue.Name;
                    SalesStatistics."BU Code" := DimArray.Get(2);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                    DimValue.SetRange(Code, SalesStatistics."BU Code");
                    if DimValue.FindFirst() then SalesStatistics."BU Name" := DimValue.Name;
                    SalesStatistics."Cost Center" := DimArray.Get(3);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'COSTCENTER');
                    DimValue.SetRange(Code, SalesStatistics."Cost Center");
                    if DimValue.FindFirst() then SalesStatistics."Cost Center Name" := DimValue.Name;
                    SalesStatistics."Invoice Account" := SalesInvoiceLine."Bill-to Customer No.";
                    if CustTable.Get(SalesInvoiceLine."Sell-to Customer No.") then begin
                        SalesStatistics."Customer Group" := CustTable."BLACC Customer Group";
                        SalesStatistics."Customer Name" := CustTable.Name;
                        if CustGroup.Get(CustTable."BLACC Customer Group") then SalesStatistics."Customer Group Name" := CustGroup.Description;
                    end;
                    if CustTable.Get(SalesInvoiceLine."Bill-to Customer No.") then begin
                        SalesStatistics."Invoice Name" := CustTable.Name;
                    end;
                    SalesStatistics.Quantity := SalesInvoiceLine.Quantity;
                    SalesStatistics."Unit Price" := SalesInvoiceLine."Unit Price";
                    SalesStatistics.Amount := SalesInvoiceLine."Line Amount";
                    SalesStatistics."Sales Tax Amount" := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount";
                    SalesStatistics."Item Sales Tax Group" := SalesInvoiceLine."Tax Group Code";
                    SalesStatistics."VAT %" := SalesInvoiceLine."VAT %";
                    SalesStatistics."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                    SalesStatistics."Exchange Rate" := 1;
                    SalesStatistics."Amount (LCY)" := SalesInvoiceLine."Line Amount";

                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetRange("No.", SalesStatistics."Document No.");
                    SalesInvoiceHeader.SetRange("Posting Date", SalesStatistics."Invoice Date");
                    SalesInvoiceHeader.SetFilter("BLTI Original eInvoice No.", '<>%1', '');
                    if SalesInvoiceHeader.FindFirst() then begin
                        eInvoiceHeader.Reset();
                        eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesInvoiceHeader."BLTI Original eInvoice No.");
                        if eInvoiceHeader.FindFirst() then begin
                            SalesStatistics."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                            SalesStatistics."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                            SalesStatistics."Sales Order" := eInvoiceHeader."Order No.";
                            SalesStatistics."Orig Invoice No." := eInvoiceHeader."No.";
                        end;
                    end;
                    //eInvoiceRegister.Reset();
                    //eInvoiceRegister.SetRange("Document No.", SalesInvoiceLine."Document No.");
                    //eInvoiceRegister.SetRange("Document Date", SalesInvoiceLine."Posting Date");
                    //if eInvoiceRegister.FindFirst() then
                    //    SalesStatistics."eInvoice Series" := eInvoiceRegister."eInvoice Series";
                    SalesStatistics.Insert();
                end;
            until SalesInvoiceLine.Next() = 0;

        SalesCrMemosLine.Reset();
        SalesCrMemosLine.SetRange(Type, "Sales Line Type"::"G/L Account");
        if DocumentNo <> '' then begin
            SalesCrMemosLine.SetRange("Document No.", DocumentNo);
        end else
            SalesCrMemosLine.SetRange("Posting Date", FromDate, ToDate);
        SalesCrMemosLine.SetFilter("No.", '511*|515*|6428*');
        if SalesCrMemosLine.FindSet() then
            repeat
                if not SalesStatistics.Get(SalesCrMemosLine."Document No.", SalesCrMemosLine."Line No.", SalesCrMemosLine."Posting Date") then begin
                    SalesStatistics."Document Type" := "Item Ledger Document Type"::"Sales Invoice";
                    SalesStatistics."Document No." := SalesCrMemosLine."Document No.";
                    SalesStatistics."Line No." := SalesCrMemosLine."Line No.";
                    SalesStatistics."Posting Date" := SalesCrMemosLine."Posting Date";
                    //SalesStatistics."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    SalesStatistics."Sales Order" := SalesCrMemosLine."Order No.";
                    SalesStatistics."Customer Account" := SalesCrMemosLine."Sell-to Customer No.";
                    SalesStatistics."Item Number" := SalesCrMemosLine."No.";
                    SalesStatistics.Description := SalesCrMemosLine."BLTEC Item Name";
                    SalesStatistics."Search Name" := SalesCrMemosLine.Description;
                    SalesStatistics.Unit := SalesCrMemosLine."Unit of Measure Code";
                    SalesStatistics."Invoice Date" := SalesCrMemosLine."Posting Date";
                    SalesStatistics."Invoice No." := SalesCrMemosLine."BLTI eInvoice No.";
                    if SalesCrMemosHeader.Get(SalesCrMemosLine."Document No.") then begin
                        SalesStatistics."Sales Taker" := SalesCrMemosHeader."Salesperson Code";
                        SalesStatistics."Sales District" := SalesCrMemosHeader."Sell-to City";
                        if Salesperson.Get(SalesCrMemosHeader."Salesperson Code") then
                            SalesStatistics."Sales Taker Name" := Salesperson.Name;
                    end;
                    DimArray := GetAllDimensionCodeValue(SalesCrMemosLine."Dimension Set ID");
                    SalesStatistics."Branch Code" := DimArray.Get(1);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BRANCH');
                    DimValue.SetRange(Code, SalesStatistics."Branch Code");
                    if DimValue.FindFirst() then SalesStatistics."Branch Name" := DimValue.Name;
                    SalesStatistics."BU Code" := DimArray.Get(2);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                    DimValue.SetRange(Code, SalesStatistics."BU Code");
                    if DimValue.FindFirst() then SalesStatistics."BU Name" := DimValue.Name;
                    SalesStatistics."Cost Center" := DimArray.Get(3);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'COSTCENTER');
                    DimValue.SetRange(Code, SalesStatistics."Cost Center");
                    if DimValue.FindFirst() then SalesStatistics."Cost Center Name" := DimValue.Name;
                    SalesStatistics."Invoice Account" := SalesCrMemosLine."Bill-to Customer No.";
                    if CustTable.Get(SalesCrMemosLine."Sell-to Customer No.") then begin
                        SalesStatistics."Customer Group" := CustTable."BLACC Customer Group";
                        SalesStatistics."Customer Name" := CustTable.Name;
                        if CustGroup.Get(CustTable."BLACC Customer Group") then SalesStatistics."Customer Group Name" := CustGroup.Description;
                    end;
                    if CustTable.Get(SalesCrMemosLine."Bill-to Customer No.") then begin
                        SalesStatistics."Invoice Name" := CustTable.Name;
                    end;
                    SalesStatistics.Quantity := -SalesCrMemosLine.Quantity;
                    SalesStatistics."Unit Price" := SalesCrMemosLine."Unit Price";
                    SalesStatistics.Amount := -SalesCrMemosLine."Line Amount";
                    SalesStatistics."Sales Tax Amount" := -(SalesCrMemosLine."Amount Including VAT" - SalesCrMemosLine."VAT Base Amount");
                    SalesStatistics."Item Sales Tax Group" := SalesCrMemosLine."Tax Group Code";
                    SalesStatistics."VAT %" := SalesCrMemosLine."VAT %";
                    SalesStatistics."Exchange Rate" := 1;
                    SalesStatistics."VAT Prod. Posting Group" := SalesCrMemosLine."VAT Prod. Posting Group";
                    SalesStatistics."Amount (LCY)" := -SalesCrMemosLine."Line Amount";
                    SalesStatistics."Credit Note" := true;
                    SalesCrMemosHeader.Reset();
                    SalesCrMemosHeader.SetRange("No.", SalesStatistics."Document No.");
                    SalesCrMemosHeader.SetRange("Posting Date", SalesStatistics."Invoice Date");
                    SalesCrMemosHeader.SetFilter("BLTI Original eInvoice No.", '<>%1', '');
                    if SalesCrMemosHeader.FindFirst() then begin
                        eInvoiceHeader.Reset();
                        eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesCrMemosHeader."BLTI Original eInvoice No.");
                        if eInvoiceHeader.FindFirst() then begin
                            SalesStatistics."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                            SalesStatistics."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                            SalesStatistics."Sales Order" := eInvoiceHeader."Order No.";
                            SalesStatistics."Orig Invoice No." := eInvoiceHeader."No.";
                        end;
                    end;
                    //eInvoiceRegister.Reset();
                    //eInvoiceRegister.SetRange("Document No.", SalesCrMemosLine."Document No.");
                    //eInvoiceRegister.SetRange("Document Date", SalesCrMemosLine."Posting Date");
                    //if eInvoiceRegister.FindFirst() then
                    //    SalesStatistics."eInvoice Series" := eInvoiceRegister."eInvoice Series";
                    SalesStatistics.Insert();
                end;
            until SalesCrMemosLine.Next() = 0;
    end;

    local procedure GiftRevenue(DocumentNo: Code[20]; FromDate: Date; ToDate: Date)
    var
        SalesStatistics: Record "AIG Sales Statistics";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        eInvoiceHeader: Record "Sales Invoice Header";
        eInvoiceRegister: Record "BLTI eInvoice Register";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemosHeader: Record "Sales Cr.Memo Header";
        SalesCrMemosLine: Record "Sales Cr.Memo Line";
        Salesperson: Record "Salesperson/Purchaser";
        CustTable: Record Customer;
        CustGroup: Record "BLACC Customer Group";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange(Type, "Sales Line Type"::"G/L Account");
        if DocumentNo <> '' then begin
            SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        end else
            SalesInvoiceLine.SetRange("Posting Date", FromDate, ToDate);
        SalesInvoiceLine.SetRange("No.", '333110');
        SalesInvoiceLine.SetFilter("VAT Prod. Posting Group", 'F-*');
        if SalesInvoiceLine.FindSet() then
            repeat
                if not SalesStatistics.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."Posting Date") then begin
                    SalesStatistics."Document Type" := "Item Ledger Document Type"::"Sales Invoice";
                    SalesStatistics."Document No." := SalesInvoiceLine."Document No.";
                    SalesStatistics."Line No." := SalesInvoiceLine."Line No.";
                    SalesStatistics."Posting Date" := SalesInvoiceLine."Posting Date";
                    //SalesStatistics."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    SalesStatistics."Sales Order" := SalesInvoiceLine."Order No.";
                    SalesStatistics."Customer Account" := SalesInvoiceLine."Sell-to Customer No.";
                    SalesStatistics."Item Number" := SalesInvoiceLine."No.";
                    SalesStatistics.Description := SalesInvoiceLine."BLTEC Item Name";
                    SalesStatistics."Search Name" := SalesInvoiceLine.Description;
                    SalesStatistics.Unit := SalesInvoiceLine."Unit of Measure Code";
                    SalesStatistics."Invoice Date" := SalesInvoiceLine."Posting Date";
                    SalesStatistics."Invoice No." := SalesInvoiceLine."BLTI eInvoice No.";
                    if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then begin
                        SalesStatistics."Sales Taker" := SalesInvoiceHeader."Salesperson Code";
                        SalesStatistics."Sales District" := SalesInvoiceHeader."Sell-to City";
                        if Salesperson.Get(SalesInvoiceHeader."Salesperson Code") then
                            SalesStatistics."Sales Taker Name" := Salesperson.Name;
                    end;
                    DimArray := GetAllDimensionCodeValue(SalesInvoiceLine."Dimension Set ID");
                    SalesStatistics."Branch Code" := DimArray.Get(1);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BRANCH');
                    DimValue.SetRange(Code, SalesStatistics."Branch Code");
                    if DimValue.FindFirst() then SalesStatistics."Branch Name" := DimValue.Name;
                    SalesStatistics."BU Code" := DimArray.Get(2);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                    DimValue.SetRange(Code, SalesStatistics."BU Code");
                    if DimValue.FindFirst() then SalesStatistics."BU Name" := DimValue.Name;
                    SalesStatistics."Cost Center" := DimArray.Get(3);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'COSTCENTER');
                    DimValue.SetRange(Code, SalesStatistics."Cost Center");
                    if DimValue.FindFirst() then SalesStatistics."Cost Center Name" := DimValue.Name;
                    SalesStatistics."Invoice Account" := SalesInvoiceLine."Bill-to Customer No.";
                    if CustTable.Get(SalesInvoiceLine."Sell-to Customer No.") then begin
                        SalesStatistics."Customer Group" := CustTable."BLACC Customer Group";
                        SalesStatistics."Customer Name" := CustTable.Name;
                        if CustGroup.Get(CustTable."BLACC Customer Group") then SalesStatistics."Customer Group Name" := CustGroup.Description;
                    end;
                    if CustTable.Get(SalesInvoiceLine."Bill-to Customer No.") then begin
                        SalesStatistics."Invoice Name" := CustTable.Name;
                    end;
                    SalesStatistics.Quantity := SalesInvoiceLine.Quantity;
                    //SalesStatistics."Unit Price" := SalesInvoiceLine."Unit Price";
                    //SalesStatistics.Amount := SalesInvoiceLine."Line Amount";
                    SalesStatistics."Sales Tax Amount" := SalesInvoiceLine."Unit Price";
                    SalesStatistics."Item Sales Tax Group" := SalesInvoiceLine."Tax Group Code";
                    SalesStatistics."VAT %" := SalesInvoiceLine."VAT %";
                    SalesStatistics."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                    SalesStatistics."Exchange Rate" := 1;
                    //SalesStatistics."Amount (LCY)" := SalesInvoiceLine."Line Amount";
                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetRange("No.", SalesStatistics."Document No.");
                    SalesInvoiceHeader.SetRange("Posting Date", SalesStatistics."Invoice Date");
                    SalesInvoiceHeader.SetFilter("BLTI Original eInvoice No.", '<>%1', '');
                    if SalesInvoiceHeader.FindFirst() then begin
                        eInvoiceHeader.Reset();
                        eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesInvoiceHeader."BLTI Original eInvoice No.");
                        if eInvoiceHeader.FindFirst() then begin
                            SalesStatistics."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                            SalesStatistics."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                            SalesStatistics."Sales Order" := eInvoiceHeader."Order No.";
                            SalesStatistics."Orig Invoice No." := eInvoiceHeader."No.";
                        end;
                    end;
                    //eInvoiceRegister.Reset();
                    //eInvoiceRegister.SetRange("Document No.", SalesInvoiceLine."Document No.");
                    //eInvoiceRegister.SetRange("Document Date", SalesInvoiceLine."Posting Date");
                    //if eInvoiceRegister.FindFirst() then
                    //    SalesStatistics."eInvoice Series" := eInvoiceRegister."eInvoice Series";
                    SalesStatistics.Insert();
                end;
            until SalesInvoiceLine.Next() = 0;

        SalesCrMemosLine.Reset();
        SalesCrMemosLine.SetRange(Type, "Sales Line Type"::"G/L Account");
        if DocumentNo <> '' then begin
            SalesCrMemosLine.SetRange("Document No.", DocumentNo);
        end else
            SalesCrMemosLine.SetRange("Posting Date", FromDate, ToDate);
        SalesCrMemosLine.SetRange("No.", '333110');
        SalesInvoiceLine.SetFilter("VAT Prod. Posting Group", 'F-*');
        if SalesCrMemosLine.FindSet() then
            repeat
                if not SalesStatistics.Get(SalesCrMemosLine."Document No.", SalesCrMemosLine."Line No.", SalesCrMemosLine."Posting Date") then begin
                    SalesStatistics."Document Type" := "Item Ledger Document Type"::"Sales Invoice";
                    SalesStatistics."Document No." := SalesCrMemosLine."Document No.";
                    SalesStatistics."Line No." := SalesCrMemosLine."Line No.";
                    SalesStatistics."Posting Date" := SalesCrMemosLine."Posting Date";
                    //SalesStatistics."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    SalesStatistics."Sales Order" := SalesCrMemosLine."Order No.";
                    SalesStatistics."Customer Account" := SalesCrMemosLine."Sell-to Customer No.";
                    SalesStatistics."Item Number" := SalesCrMemosLine."No.";
                    SalesStatistics.Description := SalesCrMemosLine."BLTEC Item Name";
                    SalesStatistics."Search Name" := SalesCrMemosLine.Description;
                    SalesStatistics.Unit := SalesCrMemosLine."Unit of Measure Code";
                    SalesStatistics."Invoice Date" := SalesCrMemosLine."Posting Date";
                    SalesStatistics."Invoice No." := SalesCrMemosLine."BLTI eInvoice No.";
                    if SalesCrMemosHeader.Get(SalesCrMemosLine."Document No.") then begin
                        SalesStatistics."Sales Taker" := SalesCrMemosHeader."Salesperson Code";
                        SalesStatistics."Sales District" := SalesCrMemosHeader."Sell-to City";
                        if Salesperson.Get(SalesCrMemosHeader."Salesperson Code") then
                            SalesStatistics."Sales Taker Name" := Salesperson.Name;
                    end;
                    DimArray := GetAllDimensionCodeValue(SalesCrMemosLine."Dimension Set ID");
                    SalesStatistics."Branch Code" := DimArray.Get(1);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BRANCH');
                    DimValue.SetRange(Code, SalesStatistics."Branch Code");
                    if DimValue.FindFirst() then SalesStatistics."Branch Name" := DimValue.Name;
                    SalesStatistics."BU Code" := DimArray.Get(2);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                    DimValue.SetRange(Code, SalesStatistics."BU Code");
                    if DimValue.FindFirst() then SalesStatistics."BU Name" := DimValue.Name;
                    SalesStatistics."Cost Center" := DimArray.Get(3);
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'COSTCENTER');
                    DimValue.SetRange(Code, SalesStatistics."Cost Center");
                    if DimValue.FindFirst() then SalesStatistics."Cost Center Name" := DimValue.Name;
                    SalesStatistics."Invoice Account" := SalesCrMemosLine."Bill-to Customer No.";
                    if CustTable.Get(SalesCrMemosLine."Sell-to Customer No.") then begin
                        SalesStatistics."Customer Group" := CustTable."BLACC Customer Group";
                        SalesStatistics."Customer Name" := CustTable.Name;
                        if CustGroup.Get(CustTable."BLACC Customer Group") then SalesStatistics."Customer Group Name" := CustGroup.Description;
                    end;
                    if CustTable.Get(SalesCrMemosLine."Bill-to Customer No.") then begin
                        SalesStatistics."Invoice Name" := CustTable.Name;
                    end;
                    SalesStatistics.Quantity := -SalesCrMemosLine.Quantity;
                    //SalesStatistics."Unit Price" := SalesCrMemosLine."Unit Price";
                    //SalesStatistics.Amount := -SalesCrMemosLine."Line Amount";
                    SalesStatistics."Sales Tax Amount" := -SalesCrMemosLine."Unit Price";
                    SalesStatistics."Item Sales Tax Group" := SalesCrMemosLine."Tax Group Code";
                    SalesStatistics."VAT %" := SalesCrMemosLine."VAT %";
                    SalesStatistics."VAT Prod. Posting Group" := SalesCrMemosLine."VAT Prod. Posting Group";
                    SalesStatistics."Exchange Rate" := 1;
                    //SalesStatistics."Amount (LCY)" := -SalesCrMemosLine."Line Amount";
                    SalesStatistics."Credit Note" := true;
                    SalesCrMemosHeader.Reset();
                    SalesCrMemosHeader.SetRange("No.", SalesStatistics."Document No.");
                    SalesCrMemosHeader.SetRange("Posting Date", SalesStatistics."Invoice Date");
                    SalesCrMemosHeader.SetFilter("BLTI Original eInvoice No.", '<>%1', '');
                    if SalesCrMemosHeader.FindFirst() then begin
                        eInvoiceHeader.Reset();
                        eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesCrMemosHeader."BLTI Original eInvoice No.");
                        if eInvoiceHeader.FindFirst() then begin
                            SalesStatistics."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                            SalesStatistics."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                            SalesStatistics."Sales Order" := eInvoiceHeader."Order No.";
                            SalesStatistics."Orig Invoice No." := eInvoiceHeader."No.";
                        end;
                    end;
                    //eInvoiceRegister.Reset();
                    //eInvoiceRegister.SetRange("Document No.", SalesCrMemosLine."Document No.");
                    //eInvoiceRegister.SetRange("Document Date", SalesCrMemosLine."Posting Date");
                    //if eInvoiceRegister.FindFirst() then
                    //    SalesStatistics."eInvoice Series" := eInvoiceRegister."eInvoice Series";
                    SalesStatistics.Insert();
                end;
            until SalesCrMemosLine.Next() = 0;
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

    local procedure UpdateExternalDocument()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemosHeader: Record "Sales Cr.Memo Header";
        SalesStatistics: Record "AIG Sales Statistics";
        FormDate: Date;
        ToDate: Date;
    begin
        FormDate := CalcDate('-CM', Today);
        FormDate := CalcDate('-1M', FormDate);
        ToDate := CalcDate('CM', Today);
        SalesStatistics.Reset();
        SalesStatistics.SetRange("Invoice Date", FormDate, ToDate);
        if SalesStatistics.FindSet() then begin
            repeat
                if SalesStatistics."Document Type" = "Item Ledger Document Type"::"Sales Invoice" then begin
                    if SalesInvoiceHeader.Get(SalesStatistics."Document No.") then begin
                        if SalesInvoiceHeader."External Document No." <> SalesStatistics."Invoice No." then begin
                            SalesStatistics."Invoice No." := SalesInvoiceHeader."External Document No.";
                            SalesStatistics.Modify();
                        end;
                    end;
                end;
                if SalesStatistics."Document Type" = "Item Ledger Document Type"::"Sales Credit Memo" then begin
                    if SalesInvoiceHeader.Get(SalesStatistics."Document No.") then begin
                        if SalesCrMemosHeader."External Document No." <> SalesStatistics."Invoice No." then begin
                            SalesStatistics."Invoice No." := SalesCrMemosHeader."External Document No.";
                            SalesStatistics.Modify();
                        end;
                    end;
                end;
            until SalesStatistics.Next() = 0;
        end;
    end;

    trigger OnOpenPage()
    var
        FromDate: Date;
    begin
        FromDate := Today - 3;
        ValueRelation();
        CostValueEntry(FromDate, Today);
        SalesStatistics('', FromDate, Today);
        ServiceRevenue('', FromDate, Today);
        GiftRevenue('', FromDate, Today);
        UpdateExternalDocument();
    end;

    trigger OnAfterGetRecord()
    var
    begin
        GM1 := Rec."Amount (LCY)" - (Rec."Cost Amount" + Rec."Cost Amount Adjust.");
        GM2 := GM1 - Rec."Charge Amount";
    end;

    var
        GM1: Decimal;
        GM2: Decimal;
}
