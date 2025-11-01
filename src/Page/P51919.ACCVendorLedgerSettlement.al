page 51919 "ACC Vendor Ledger Settlement"
{
    ApplicationArea = All;
    Caption = 'APIS Vendor Settlement';
    PageType = List;
    SourceTable = "ACC Vendor Ledger Settlement";
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
                field("Declaration No."; Rec."Declaration No.") { }
                field("Invoice No."; Rec."Invoice No.") { }
                field("Vendor Posting Group"; Rec."Vendor Posting Group") { }
                field("Vendor Posting Group Name"; Rec."Vendor Posting Group Name") { }
                field("Vendor Account"; Rec."Vendor Account") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Date"; Rec."Date") { }
                field("Due Date"; Rec."Due Date") { }
                field("Offset Document No."; Rec."Offset Document No.") { }
                field("Payment Description"; Rec."Payment Description") { }
                field("Date Of Settlement"; Rec."Date Of Settlement") { }
                field("Original Payment Amount"; Rec."Original Payment Amount") { }
                field("Settled Currency"; Rec."Settled Currency") { }
                field("Amount Settled"; Rec."Amount Settled") { }
                field("Settled Currency (LCY)"; Rec."Settled Currency (LCY)") { }
                field("Amount Settled (LCY)"; Rec."Amount Settled (LCY)") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("Modified At"; Rec."Modified At") { }
                field("Ledger Entry No."; Rec."Ledger Entry No.") { }
                field("Detailed Entry No."; Rec."Detailed Entry No.") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCModify)
            {
                ApplicationArea = All;
                Image = Change;
                Caption = 'Modify';
                trigger OnAction()
                var
                    Settlement: Page "ACC Vendor Settlement Modify";
                begin
                    Settlement.SetInvoiceValue(Rec."Detailed Entry No.", Rec."Ledger Entry No.");
                    Settlement.Run();
                end;
            }
            action(ACCCalc)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Calc';
                trigger OnAction()
                var
                begin
                    ResetSettlement();
                    OpenSettlement();
                    VendSettlement();
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
        VendSettlement: Record "ACC Vendor Ledger Settlement";
    begin
        VendSettlement.Reset();
        VendSettlement.SetRange(Reset, true);
        if VendSettlement.FindSet() then
            repeat
                VendSettlement.Delete();
            until VendSettlement.Next() = 0;
    end;

    local procedure VendSettlement()
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
        PaymLedgerEntry: Record "Vendor Ledger Entry";
        DetailedLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        Loop01LedgerEntry: Record "Detailed Vendor Ledg. Entry";
        Loop02LedgerEntry: Record "Detailed Vendor Ledg. Entry";
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := 20250601D;
        ToDate := Today;
        VendLedgerEntry.SetCurrentKey("Document No.");
        VendLedgerEntry.SetRange("Posting Date", FromDate, ToDate);
        VendLedgerEntry.SetFilter("Vendor Posting Group", 'A02|B01|B02');
        VendLedgerEntry.SetFilter("Document Type", Format("Gen. Journal Document Type"::Invoice));
        VendLedgerEntry.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)");
        if VendLedgerEntry.FindSet() then begin
            repeat
                if not Rec.ChkExist(VendLedgerEntry."Entry No.") then begin
                    Rec.Init();
                    Rec."Ledger Entry No." := VendLedgerEntry."Entry No.";
                    Rec."Invoice No." := VendLedgerEntry."External Document No.";
                    Rec.Description := VendLedgerEntry.Description;
                    Rec.Date := VendLedgerEntry."Posting Date";
                    Rec."Due Date" := VendLedgerEntry."Due Date";
                    Rec."Vendor Account" := VendLedgerEntry."Vendor No.";
                    Rec."Document No." := VendLedgerEntry."Document No.";
                    Rec."Settled Currency" := VendLedgerEntry.Amount;
                    Rec."Settled Currency (LCY)" := VendLedgerEntry."Amount (LCY)";
                    Rec."Currency Code" := VendLedgerEntry."Currency Code";
                    Rec."Vendor Posting Group" := VendLedgerEntry."Vendor Posting Group";
                    if VendLedgerEntry."Remaining Amount" < 0 then
                        Rec.Reset := true;
                    if VendLedgerEntry."Vendor Posting Group" = 'A02' then
                        Rec."Declaration No." := CustomsSettlement(VendLedgerEntry."Document No.", VendLedgerEntry."Posting Date");
                    DetailedLedgerEntry.Reset();
                    DetailedLedgerEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry."Entry No.");
                    DetailedLedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                    DetailedLedgerEntry.SetRange(Unapplied, false);
                    DetailedLedgerEntry.SetFilter("Applied Vend. Ledger Entry No.", '<>%1', VendLedgerEntry."Entry No.");
                    if DetailedLedgerEntry.FindSet() then begin
                        repeat
                            Rec."Detailed Entry No." := DetailedLedgerEntry."Entry No.";
                            Rec."Date Of Settlement" := DetailedLedgerEntry."Posting Date";
                            Rec."Amount Settled" := DetailedLedgerEntry.Amount;
                            Rec."Amount Settled (LCY)" := DetailedLedgerEntry."Amount (LCY)";
                            Rec."Modified At" := DetailedLedgerEntry.SystemModifiedAt;
                            if DetailedLedgerEntry."Vendor Ledger Entry No." <> DetailedLedgerEntry."Applied Vend. Ledger Entry No." then begin
                                if not Rec.Get(DetailedLedgerEntry."Entry No.", VendLedgerEntry."Entry No.") then begin
                                    PaymLedgerEntry.SetAutoCalcFields("Original Amount");
                                    if PaymLedgerEntry.Get(DetailedLedgerEntry."Applied Vend. Ledger Entry No.") then begin
                                        Rec."Original Payment Amount" := PaymLedgerEntry."Original Amount";
                                        Rec."Payment Description" := PaymLedgerEntry.Description;
                                    end;
                                    Rec."Offset Document No." := DetailedLedgerEntry."Document No.";
                                    Rec.Insert();
                                end;
                            end;
                        until DetailedLedgerEntry.Next() = 0;
                    end;

                    DetailedLedgerEntry.Reset();
                    DetailedLedgerEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry."Entry No.");
                    DetailedLedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                    DetailedLedgerEntry.SetRange(Unapplied, false);
                    DetailedLedgerEntry.SetRange("Applied Vend. Ledger Entry No.", VendLedgerEntry."Entry No.");
                    if DetailedLedgerEntry.FindFirst() then begin
                        Loop01LedgerEntry.Reset();
                        Loop01LedgerEntry.SetRange("Applied Vend. Ledger Entry No.", VendLedgerEntry."Entry No.");
                        Loop01LedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                        Loop01LedgerEntry.SetRange(Unapplied, false);
                        Loop01LedgerEntry.SetFilter("Vendor Ledger Entry No.", '<>%1', VendLedgerEntry."Entry No.");
                        if Loop01LedgerEntry.FindSet() then begin
                            repeat
                                Rec."Detailed Entry No." := Loop01LedgerEntry."Entry No.";
                                Rec."Date Of Settlement" := Loop01LedgerEntry."Posting Date";
                                Rec."Amount Settled" := -Loop01LedgerEntry.Amount;
                                Rec."Amount Settled (LCY)" := -Loop01LedgerEntry."Amount (LCY)";
                                Rec."Modified At" := Loop01LedgerEntry.SystemModifiedAt;
                                Loop02LedgerEntry.Reset();
                                Loop02LedgerEntry.SetRange("Vendor Ledger Entry No.", Loop01LedgerEntry."Vendor Ledger Entry No.");
                                Loop02LedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::"Initial Entry");
                                if Loop02LedgerEntry.FindFirst() then begin
                                    if not Rec.Get(DetailedLedgerEntry."Entry No.", Loop02LedgerEntry."Entry No.") then begin
                                        Rec."Detailed Entry No." := Loop02LedgerEntry."Entry No.";
                                        Rec."Offset Document No." := Loop02LedgerEntry."Document No.";
                                        Rec."Modified At" := Loop02LedgerEntry.SystemModifiedAt;
                                        PaymLedgerEntry.SetAutoCalcFields("Original Amount");
                                        if PaymLedgerEntry.Get(Loop02LedgerEntry."Vendor Ledger Entry No.") then begin
                                            Rec."Original Payment Amount" := PaymLedgerEntry."Original Amount";
                                            Rec."Payment Description" := PaymLedgerEntry.Description;
                                        end;
                                        Rec.Insert(true);
                                    end;
                                end;
                            until Loop01LedgerEntry.Next() = 0;
                        end;
                    end;
                end;
            until VendLedgerEntry.Next() = 0;
        end;
    end;

    local procedure OpenSettlement()
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
        PaymLedgerEntry: Record "Vendor Ledger Entry";
        DetailedLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        Loop01LedgerEntry: Record "Detailed Vendor Ledg. Entry";
        Loop02LedgerEntry: Record "Detailed Vendor Ledg. Entry";
        ValidDate: Date;
    begin
        ValidDate := 20250531D;
        VendLedgerEntry.SetCurrentKey("Document No.");
        VendLedgerEntry.SetRange("Posting Date", ValidDate);
        VendLedgerEntry.SetFilter("Vendor Posting Group", 'A02|B01|B02');
        VendLedgerEntry.SetFilter(Amount, '<0');
        VendLedgerEntry.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)");
        if VendLedgerEntry.FindSet() then begin
            repeat
                if not Rec.ChkExist(VendLedgerEntry."Entry No.") then begin
                    Rec.Init();
                    Rec."Ledger Entry No." := VendLedgerEntry."Entry No.";
                    Rec.Description := VendLedgerEntry.Description;
                    Rec.Date := VendLedgerEntry."Posting Date";
                    Rec."Due Date" := VendLedgerEntry."Due Date";
                    Rec."Invoice No." := VendLedgerEntry."External Document No.";
                    Rec."Vendor Account" := VendLedgerEntry."Vendor No.";
                    Rec."Document No." := VendLedgerEntry."Document No.";
                    Rec."Settled Currency" := VendLedgerEntry.Amount;
                    Rec."Settled Currency (LCY)" := VendLedgerEntry."Amount (LCY)";
                    Rec."Currency Code" := VendLedgerEntry."Currency Code";
                    Rec."Vendor Posting Group" := VendLedgerEntry."Vendor Posting Group";
                    if VendLedgerEntry."Remaining Amount" < 0 then
                        Rec.Reset := true;
                    DetailedLedgerEntry.Reset();
                    DetailedLedgerEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry."Entry No.");
                    DetailedLedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                    DetailedLedgerEntry.SetRange(Unapplied, false);
                    DetailedLedgerEntry.SetFilter("Applied Vend. Ledger Entry No.", '<>%1', VendLedgerEntry."Entry No.");
                    if DetailedLedgerEntry.FindSet() then begin
                        repeat
                            Rec."Detailed Entry No." := DetailedLedgerEntry."Entry No.";
                            Rec."Date Of Settlement" := DetailedLedgerEntry."Posting Date";
                            Rec."Amount Settled" := DetailedLedgerEntry.Amount;
                            Rec."Amount Settled (LCY)" := DetailedLedgerEntry."Amount (LCY)";
                            Rec."Modified At" := DetailedLedgerEntry.SystemModifiedAt;
                            if DetailedLedgerEntry."Vendor Ledger Entry No." <> DetailedLedgerEntry."Applied Vend. Ledger Entry No." then begin
                                if not Rec.Get(DetailedLedgerEntry."Entry No.", VendLedgerEntry."Entry No.") then begin
                                    PaymLedgerEntry.SetAutoCalcFields("Original Amount");
                                    if PaymLedgerEntry.Get(DetailedLedgerEntry."Applied Vend. Ledger Entry No.") then begin
                                        Rec."Original Payment Amount" := PaymLedgerEntry."Original Amount";
                                        Rec."Payment Description" := PaymLedgerEntry.Description;
                                    end;
                                    Rec."Offset Document No." := DetailedLedgerEntry."Document No.";
                                    Rec.Insert();
                                end;
                            end;
                        until DetailedLedgerEntry.Next() = 0;
                    end;

                    DetailedLedgerEntry.Reset();
                    DetailedLedgerEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry."Entry No.");
                    DetailedLedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                    DetailedLedgerEntry.SetRange(Unapplied, false);
                    DetailedLedgerEntry.SetRange("Applied Vend. Ledger Entry No.", VendLedgerEntry."Entry No.");
                    if DetailedLedgerEntry.FindFirst() then begin
                        Loop01LedgerEntry.Reset();
                        Loop01LedgerEntry.SetRange("Applied Vend. Ledger Entry No.", VendLedgerEntry."Entry No.");
                        Loop01LedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                        Loop01LedgerEntry.SetRange(Unapplied, false);
                        Loop01LedgerEntry.SetFilter("Vendor Ledger Entry No.", '<>%1', VendLedgerEntry."Entry No.");
                        if Loop01LedgerEntry.FindSet() then begin
                            repeat
                                Rec."Detailed Entry No." := Loop01LedgerEntry."Entry No.";
                                Rec."Date Of Settlement" := Loop01LedgerEntry."Posting Date";
                                Rec."Amount Settled" := -Loop01LedgerEntry.Amount;
                                Rec."Amount Settled (LCY)" := -Loop01LedgerEntry."Amount (LCY)";
                                Rec."Modified At" := Loop01LedgerEntry.SystemModifiedAt;
                                Loop02LedgerEntry.Reset();
                                Loop02LedgerEntry.SetRange("Vendor Ledger Entry No.", Loop01LedgerEntry."Vendor Ledger Entry No.");
                                Loop02LedgerEntry.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::"Initial Entry");
                                if Loop02LedgerEntry.FindFirst() then begin
                                    if not Rec.Get(DetailedLedgerEntry."Entry No.", Loop02LedgerEntry."Entry No.") then begin
                                        Rec."Detailed Entry No." := Loop02LedgerEntry."Entry No.";
                                        Rec."Offset Document No." := Loop02LedgerEntry."Document No.";
                                        Rec."Modified At" := Loop02LedgerEntry.SystemModifiedAt;
                                        PaymLedgerEntry.SetAutoCalcFields("Original Amount");
                                        if PaymLedgerEntry.Get(Loop02LedgerEntry."Vendor Ledger Entry No.") then begin
                                            Rec."Original Payment Amount" := PaymLedgerEntry."Original Amount";
                                            Rec."Payment Description" := PaymLedgerEntry.Description;
                                        end;
                                        Rec.Insert(true);
                                    end;
                                end;
                            until Loop01LedgerEntry.Next() = 0;
                        end;
                    end;
                end;
            until VendLedgerEntry.Next() = 0;
        end;
    end;

    local procedure CustomsSettlement(DocumentNo: Text; PostingDate: Date): Text
    var
        CustomsSettle: Query "ACC Customs Ledger Settle. Qry";
        CustomsNo: Text;
    begin
        CustomsNo := '';
        CustomsSettle.SetRange(DocumentNo, DocumentNo);
        CustomsSettle.SetRange(PostingDate, PostingDate);
        if CustomsSettle.Open() then begin
            while CustomsSettle.Read() do begin
                CustomsNo := CustomsSettle.DeclarationNo;
            end;
            CustomsSettle.Close();
        end;
        exit(CustomsNo);
    end;

}
