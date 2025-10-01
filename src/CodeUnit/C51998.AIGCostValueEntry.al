codeunit 51998 "AIG Cost Value Entry"
{
    TableNo = "AIG Cost Value Entry";

    trigger OnRun()
    begin

    end;

    procedure CostValueEntry()
    var
        CostValueQuery: Query "AIG Cost Value Entry";
        CostValueEntry: Record "AIG Cost Value Entry";

        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today);
        FromDate := CalcDate('-2M', FromDate);
        ToDate := CalcDate('CM', Today);

        CostValueQuery.SetRange(PostingDate, FromDate, ToDate);
        CostValueQuery.SetRange(Adjustment, false);
        if CostValueQuery.Open() then begin
            while CostValueQuery.Read() do begin
                if not CostValueEntry.Get(CostValueQuery.DocumentNo, CostValueQuery.DocumentLineNo, CostValueQuery.ItemLedgerEntryNo, CostValueQuery.PostingDate) then begin
                    CostValueEntry.Init();
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
}
