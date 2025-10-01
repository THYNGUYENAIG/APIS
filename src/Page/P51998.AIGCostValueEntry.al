page 51998 "AIG Cost Value Entry"
{
    ApplicationArea = All;
    Caption = 'AIG Cost Value Entry';
    PageType = List;
    SourceTable = "AIG Cost Value Entry";
    UsageCategory = Administration;
    //DeleteAllowed = false;
    InsertAllowed = false;
    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type") { }
                field("Document No."; Rec."Document No.") { }
                field("Line No."; Rec."Line No.") { }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Cost Amount"; Rec."Cost Amount") { }
                field("Cost Amount Adjustment"; Rec."Cost Amount Adjustment") { }
                field("AIG Cost Amount"; Rec."AIG Cost Amount") { }
                field("AIG Cost Amount Adjustment"; Rec."AIG Cost Amount Adjustment") { }
                field("Table No."; Rec."Table No.") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCCalc)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Calc';
                trigger OnAction()
                begin
                    CostValueEntry();
                end;
            }
            action(ACCReset)
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Reset';
                trigger OnAction()
                var
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                end;
            }
        }
    }

    local procedure CostValueEntry()
    var
        CostValueQuery: Query "AIG Cost Value Entry";
        CostValueEntry: Record "AIG Cost Value Entry";

        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today);
        FromDate := CalcDate('-1M', FromDate);
        ToDate := CalcDate('CM', Today);

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

        CostValueEntry.Reset();
        CostValueEntry.SetRange("Posting Date", FromDate, ToDate);
        CostValueEntry.SetFilter("Document Type", '2|4');
        CostValueEntry.SetAutoCalcFields("Cost Amount", "Cost Amount Adjustment");
        if CostValueEntry.FindSet() then begin
            repeat
                if (CostValueEntry."Cost Amount" <> CostValueEntry."AIG Cost Amount") OR (CostValueEntry."Cost Amount Adjustment" <> CostValueEntry."AIG Cost Amount Adjustment") then begin
                    CostValueEntry."AIG Cost Amount" := CostValueEntry."Cost Amount";
                    CostValueEntry."AIG Cost Amount Adjustment" := CostValueEntry."Cost Amount Adjustment";
                    CostValueEntry.Modify();
                end;
            until CostValueEntry.Next() = 0;
        end;
    end;
}
