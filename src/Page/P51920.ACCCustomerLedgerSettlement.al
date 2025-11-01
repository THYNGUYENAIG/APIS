page 51920 "ACC Cust. Ledger Settlement"
{
    ApplicationArea = All;
    Caption = 'APIS Customer Settlement';
    PageType = List;
    SourceTable = "ACC Cust. Ledger Settlement";
    UsageCategory = ReportsAndAnalysis;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer Account"; Rec."Customer Account") { }
                field("Customer Name"; Rec."Customer Name") { }
                field(Invoice; Rec.Invoice) { }
                field("Invoice No."; Rec."Invoice No.") { }
                field(Voucher; Rec.Voucher) { }
                field("Offset Voucher"; Rec."Offset Voucher") { }
                field(Description; Rec.Description) { }
                field("Document Date"; Rec."Document Date") { }
                field("Date"; Rec."Date") { }
                field("Due Date"; Rec."Due Date") { }
                field("Date Of Settlement"; Rec."Date Of Settlement") { }
                field("Settled Currency"; Rec."Settled Currency") { }
                field("Amount Settled"; Rec."Amount Settled") { }
                field("Currency Code"; Rec."Currency Code") { }
                field(Site; Rec.Site) { }
                field(BU; Rec.BU) { }
                field("Statistics Group Name"; Rec."Statistics Group Name") { }
                field("Modified At"; Rec."Modified At") { }
                field("Ledger Entry No."; Rec."Ledger Entry No.") { }
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
                var
                begin
                    ResetSettlement();
                    CustOpenBalance();
                    CustSettlement();
                end;
            }

            action(ACCReset)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Reset All';
                trigger OnAction()
                var
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                end;
            }
        }
    }

    local procedure ResetSettlement()
    var
        ACCCustSettle: Record "ACC Cust. Ledger Settlement";
    begin
        ACCCustSettle.Reset();
        ACCCustSettle.SetRange(Reset, true);
        if ACCCustSettle.FindSet() then
            repeat
                ACCCustSettle.Delete();
            until ACCCustSettle.Next() = 0;
    end;

    local procedure CustOpenBalance()
    var
        CustTable: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        OffsetLedgerEntry: Record "Cust. Ledger Entry";
        DetailedLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        CustSettleInsert: Query "ACC Cust Settle Insert Qry";
        OpenDate: Date;
        FromDate: DateTime;
        ToDate: DateTime;
    begin
        OpenDate := 20250531D;
        FromDate := CreateDateTime(OpenDate, 000000T);
        ToDate := CreateDateTime(OpenDate, 235959T);

        CustSettleInsert.SetRange(ModifiedAt, FromDate, ToDate);
        CustSettleInsert.SetRange(LedgerEntryNo, 0);
        if CustSettleInsert.Open() then begin
            while CustSettleInsert.Read() do begin
            end;
        end;

        CustLedgerEntry.SetRange("Posting Date", OpenDate);
        CustLedgerEntry.SetFilter("Document No.", 'OPC*');
        CustLedgerEntry.SetAutoCalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
        if CustLedgerEntry.FindSet() then begin
            repeat
                if CustLedgerEntry."Amount (LCY)" <> CustLedgerEntry."Remaining Amt. (LCY)" then begin
                    if not Rec.Get(CustLedgerEntry."Entry No.") then begin
                        Rec.Init();
                        Rec."Ledger Entry No." := CustLedgerEntry."Entry No.";
                        Rec.Description := CustLedgerEntry.Description;
                        Rec."Document Date" := CustLedgerEntry."Document Date";
                        Rec.Date := CustLedgerEntry."Posting Date";
                        Rec."Due Date" := CustLedgerEntry."Due Date";
                        Rec."Invoice No." := CustLedgerEntry."External Document No.";
                        Rec.Invoice := CustLedgerEntry."BLTI eInvoice No.";
                        Rec."Customer Account" := CustLedgerEntry."Customer No.";
                        Rec."Customer Name" := CustLedgerEntry."Customer Name";
                        Rec."Offset Voucher" := CustLedgerEntry."Document No.";
                        Rec."Settled Currency" := CustLedgerEntry."Amount (LCY)";
                        Rec."Currency Code" := CustLedgerEntry."Currency Code";
                        Rec.Site := CustLedgerEntry."Global Dimension 1 Code";
                        Rec.BU := CustLedgerEntry."Global Dimension 2 Code";
                        if CustTable.Get(CustLedgerEntry."Customer No.") then
                            Rec."Statistics Group" := CustTable."Statistics Group";
                        Rec."Modified At" := CustLedgerEntry.SystemModifiedAt;
                        DetailedLedgerEntry.Reset();
                        DetailedLedgerEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        DetailedLedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                        if DetailedLedgerEntry.FindSet() then begin
                            repeat
                                Rec."Detailed Ledger Entry No." := DetailedLedgerEntry."Entry No.";
                                Rec."Date Of Settlement" := DetailedLedgerEntry."Posting Date";
                                Rec.Voucher := DetailedLedgerEntry."Document No.";
                                Rec."Amount Settled" := DetailedLedgerEntry."Amount (LCY)";
                                if OffsetLedgerEntry.Get(DetailedLedgerEntry."Applied Cust. Ledger Entry No.") then
                                    Rec.Description := OffsetLedgerEntry.Description;
                                if CustLedgerEntry."Amount (LCY)" <> CustLedgerEntry."Remaining Amt. (LCY)" then begin
                                    if CustLedgerEntry."Remaining Amt. (LCY)" > 0 then
                                        Rec.Reset := true;
                                    Rec.Insert();
                                end;
                            until DetailedLedgerEntry.Next() = 0;
                        end;
                    end;
                end;
            until CustLedgerEntry.Next() = 0;
        end;
    end;

    local procedure CustSettlement()
    var
        CustSettle: Record "ACC Cust. Ledger Settlement";
        CustTable: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        OffsetLedgerEntry: Record "Cust. Ledger Entry";
        DetailedLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        CustSettleInsert: Query "ACC Cust Settle Insert Qry";
        ValidDate: Date;
        FromDate: DateTime;
        ToDate: DateTime;
    begin
        ValidDate := CalcDate('-CM', Today);
        ValidDate := CalcDate('-3M', ValidDate);
        FromDate := CreateDateTime(ValidDate, 000000T);
        ValidDate := CalcDate('CM', Today);
        ToDate := CreateDateTime(ValidDate, 000000T);

        CustSettleInsert.SetRange(ModifiedAt, FromDate, ToDate);
        CustSettleInsert.SetRange(LedgerEntryNo, 0);
        if CustSettleInsert.Open() then begin
            while CustSettleInsert.Read() do begin
                CustLedgerEntry.SetRange("Entry No.", CustSettleInsert.CustEntryNo);
                CustLedgerEntry.SetAutoCalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                if CustLedgerEntry.FindFirst() then begin
                    Rec.Init();
                    Rec."Ledger Entry No." := CustLedgerEntry."Entry No.";
                    Rec."Document Date" := CustLedgerEntry."Document Date";
                    Rec.Date := CustLedgerEntry."Posting Date";
                    Rec."Due Date" := CustLedgerEntry."Due Date";
                    Rec."Invoice No." := CustLedgerEntry."External Document No.";
                    Rec.Invoice := CustLedgerEntry."BLTI eInvoice No.";
                    Rec."Customer Account" := CustLedgerEntry."Customer No.";
                    Rec."Customer Name" := CustLedgerEntry."Customer Name";
                    Rec."Offset Voucher" := CustLedgerEntry."Document No.";
                    Rec."Settled Currency" := CustLedgerEntry."Amount (LCY)";
                    Rec."Currency Code" := CustLedgerEntry."Currency Code";
                    Rec.Site := CustLedgerEntry."Global Dimension 1 Code";
                    Rec.BU := CustLedgerEntry."Global Dimension 2 Code";
                    if CustTable.Get(CustLedgerEntry."Customer No.") then
                        Rec."Statistics Group" := CustTable."Statistics Group";
                    Rec."Modified At" := CustLedgerEntry.SystemModifiedAt;
                    DetailedLedgerEntry.Reset();
                    DetailedLedgerEntry.SetCurrentKey("Document No.");
                    DetailedLedgerEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                    DetailedLedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                    if DetailedLedgerEntry.FindSet() then begin
                        repeat
                            if not CustSettle.Get(DetailedLedgerEntry."Entry No.") then begin
                                Rec."Detailed Ledger Entry No." := DetailedLedgerEntry."Entry No.";
                                Rec."Date Of Settlement" := DetailedLedgerEntry."Posting Date";
                                Rec.Voucher := DetailedLedgerEntry."Document No.";
                                Rec."Amount Settled" := DetailedLedgerEntry."Amount (LCY)";
                                if OffsetLedgerEntry.Get(DetailedLedgerEntry."Applied Cust. Ledger Entry No.") then
                                    Rec.Description := OffsetLedgerEntry.Description;
                                if CustLedgerEntry."Amount (LCY)" <> CustLedgerEntry."Remaining Amt. (LCY)" then begin
                                    if CustLedgerEntry."Remaining Amt. (LCY)" > 0 then
                                        Rec.Reset := true;
                                    Rec.Insert();
                                end;
                            end;
                        until DetailedLedgerEntry.Next() = 0;
                    end;
                end;
            end;
            CustSettleInsert.Close();
        end;
    end;

    trigger OnOpenPage()
    var
    begin
        //CustOpenBalance();
        //CustSettlement();
    end;
}
