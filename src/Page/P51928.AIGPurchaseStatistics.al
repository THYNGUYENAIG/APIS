page 51928 "AIG Purchase Statistics"
{
    ApplicationArea = All;
    Caption = 'AIG Purchase Statistics';
    PageType = List;
    SourceTable = "AIG Purchase Statistics";
    UsageCategory = Lists;
    //DeleteAllowed = false;
    InsertAllowed = false;
    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Purchase Order"; Rec."Purchase Order")
                {
                }
                field("Vendor Group"; Rec."Vendor Group")
                {
                }
                field("Vendor Account"; Rec."Vendor Account")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Invoice Account"; Rec."Invoice Account")
                {
                }
                field(Terms; Rec.Terms)
                {
                }
                field("Term Of Payment"; Rec."Term Of Payment")
                {
                }
                field("Buyer Group"; Rec."Buyer Group")
                {
                }
                field("Customs Declaration"; Rec."Customs Declaration")
                {
                }
                field("Item Number"; Rec."Item Number")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Unit; Rec.Unit)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Purchase Tax Amount"; Rec."Purchase Tax Amount")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                }
                field(Site; Rec.Site)
                {
                }
                field(Warehouse; Rec.Warehouse)
                {
                }
                field("Product Receipt"; Rec."Product Receipt")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Invoice No.';
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                { }
                field("BU Code"; Rec."BU Code")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ACCRefeshToday)
            {
                ApplicationArea = All;
                Image = Refresh;
                Caption = 'Refesh Today';
                trigger OnAction()
                var
                    FromDate: Date;
                    ToDate: Date;
                begin
                    FromDate := Today;
                    ToDate := Today;
                    ValueRelation();
                    CostValueEntry(FromDate, ToDate);
                    PurchStatistics(FromDate, ToDate);
                end;
            }

            action(ACCRefeshThisWeek)
            {
                ApplicationArea = All;
                Image = Refresh;
                Caption = 'Refesh This Week';
                trigger OnAction()
                var
                    FromDate: Date;
                    ToDate: Date;
                begin
                    FromDate := CalcDate('-7D', Today);
                    ToDate := Today;
                    ValueRelation();
                    CostValueEntry(FromDate, ToDate);
                    PurchStatistics(FromDate, ToDate);
                end;
            }
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
                    ToDate := Today;
                    ValueRelation();
                    CostValueEntry(FromDate, ToDate);
                    PurchStatistics(FromDate, ToDate);
                end;
            }
            action(ACCRefeshAll)
            {
                ApplicationArea = All;
                Image = Refresh;
                Caption = 'Refesh All';
                trigger OnAction()
                var
                    FromDate: Date;
                    ToDate: Date;
                begin
                    FromDate := 20250601D;
                    ToDate := Today;
                    ValueRelation();
                    CostValueEntry(FromDate, ToDate);
                    PurchStatistics(FromDate, ToDate);
                end;
            }
            action(ACCResetAll)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Reset All';
                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                end;
            }
        }
    }

    local procedure PurchStatistics(FromDate: Date; ToDate: Date)
    var
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        //SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchCrMemosHeader: Record "Purch. Cr. Memo Hdr.";
        //SalesCrMemosHeader: Record "Sales Cr.Memo Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueRelation: Record "AIG Value Entry Relation";
        CostValueEntry: Record "AIG Cost Value Entry";

        PurchStatistics: Record "AIG Purchase Statistics";
        ItemTable: Record Item;
    begin
        CostValueEntry.Reset();
        CostValueEntry.SetCurrentKey("Document No.");
        CostValueEntry.SetRange("Posting Date", FromDate, ToDate);
        CostValueEntry.SetFilter("Document Type", StrSubstNo('%1|%2', "Item Ledger Document Type"::"Purchase Invoice", "Item Ledger Document Type"::"Purchase Credit Memo"));
        if CostValueEntry.FindSet() then begin
            repeat
                if not PurchStatistics.Get(CostValueEntry."Document No.", CostValueEntry."Line No.", CostValueEntry."Posting Date") then begin
                    PurchStatistics.Init();
                    PurchStatistics."Document Type" := CostValueEntry."Document Type";
                    PurchStatistics."Document No." := CostValueEntry."Document No.";
                    PurchStatistics."Line No." := CostValueEntry."Line No.";
                    PurchStatistics."Posting Date" := CostValueEntry."Posting Date";
                    PurchStatistics."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Entry No.", CostValueEntry."Item Ledger Entry No.");
                    if ItemLedgerEntry.FindFirst() then begin
                        PurchStatistics.Warehouse := ItemLedgerEntry."Location Code";
                        PurchStatistics."Product Receipt" := ItemLedgerEntry."Document No.";
                    end;
                    ValueRelation.Reset();
                    ValueRelation.SetRange("Invoice No.", CostValueEntry."Document No.");
                    ValueRelation.SetRange("Invoice Line No.", CostValueEntry."Line No.");
                    if ValueRelation.FindFirst() then begin
                        PurchStatistics."Purchase Order" := ValueRelation."Order No.";
                        PurchStatistics."Vendor Account" := ValueRelation."Source No.";
                        PurchStatistics."Vendor Name" := ValueRelation."Source Name";
                        PurchStatistics."Item Number" := ValueRelation."Item No.";
                        PurchStatistics.Description := ValueRelation."Item Name";
                        PurchStatistics."Search Name" := ValueRelation."Search Name";
                        PurchStatistics.Unit := ValueRelation."Unit Code";
                        PurchStatistics."Invoice Date" := ValueRelation."Posting Date";
                        PurchStatistics."Vendor Invoice No." := ValueRelation."External Document No.";
                        PurchStatistics."BU Code" := ValueRelation."BU Code";
                        PurchStatistics."BU Name" := ValueRelation."BU Name";
                        PurchStatistics."Invoice Account" := ValueRelation."Invoice Account";
                        PurchStatistics."Document Date" := ValueRelation."Document Date";
                        PurchStatistics."Due Date" := ValueRelation."Due Date";
                        PurchStatistics."Customs Declaration" := ValueRelation."Declaration No.";
                        PurchStatistics."Employee Name" := ValueRelation."Sales Taker Name";
                    end;
                    ValueRelation.Reset();
                    ValueRelation.SetRange("Invoice No.", CostValueEntry."Document No.");
                    ValueRelation.SetRange("Invoice Line No.", CostValueEntry."Line No.");
                    ValueRelation.SetRange("Posting Date", CostValueEntry."Posting Date");
                    if ValueRelation.FindFirst() then begin
                        PurchStatistics.Quantity := ValueRelation.Quantity;
                        PurchStatistics."Unit Price" := ValueRelation."Unit Price";
                        PurchStatistics.Amount := ValueRelation."Line Amount";
                        PurchStatistics."Purchase Tax Amount" := ValueRelation."VAT Amount";
                        PurchStatistics."Exchange Rate" := ValueRelation."Exchange Rate";
                        PurchStatistics."Amount (LCY)" := ValueRelation."Line Amount (LCY)";
                    end;
                    PurchStatistics.Insert();
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
        AIGValueEntry.SetPurchValueEntry();
    end;
}
