page 51995 "ACC Transaction Entry"
{
    ApplicationArea = All;
    Caption = 'APIS Transaction Entry';
    PageType = List;
    SourceTable = "AIG Transaction Entry";
    UsageCategory = Administration;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Entry Type"; Rec."Entry Type") { }
                field("Document Type"; Rec."Document Type") { }
                field("Document No."; Rec."Document No.") { }
                field("Document Line No."; Rec."Document Line No.") { }
                field("Order No."; Rec."Order No.") { }
                field("Line No."; Rec."Line No.") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Item No."; Rec."Item No.") { }
                field(Site; Rec.Site) { }
                field("Business Unit"; Rec."Business Unit") { }
                field("Location Code"; Rec."Location Code") { }
                field("Lot No."; Rec."Lot No.") { }
                field(Quantity; Rec.Quantity) { }
                field("Remaining Quantity"; Rec."Remaining Quantity") { }
                field("Lot Blocked"; Rec."Lot Blocked") { }
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
                Image = Refresh;
                Caption = 'Refresh';
                trigger OnAction()
                begin
                    TransactionEntry();
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
    local procedure TransactionEntry()
    var
        InventoryEntry: Query "AIG Inventory Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TransactionEntry: Record "AIG Transaction Entry";
        LotInformation: Record "Lot No. Information";
        ShipmentLine: Record "Sales Shipment Line";
        ReceiptLine: Record "Purch. Rcpt. Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferReceiptLine: Record "Transfer Receipt Line";
    Begin
        TransactionEntry.Reset();
        TransactionEntry.DeleteAll();
        if InventoryEntry.Open() then begin
            while InventoryEntry.Read() do begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Item No.", InventoryEntry.ItemNo);
                ItemLedgerEntry.SetRange("Lot No.", InventoryEntry.LotNo);
                ItemLedgerEntry.SetFilter("Location Code", GetTransitFilter());
                if ItemLedgerEntry.FindSet() then begin
                    repeat
                        TransactionEntry.Init();
                        TransactionEntry."Entry No." := ItemLedgerEntry."Entry No.";
                        TransactionEntry."Posting Date" := ItemLedgerEntry."Posting Date";
                        TransactionEntry."Entry Type" := ItemLedgerEntry."Entry Type";
                        TransactionEntry."External Document No." := ItemLedgerEntry."External Document No.";
                        TransactionEntry."Document Type" := ItemLedgerEntry."Document Type";
                        TransactionEntry."Document No." := ItemLedgerEntry."Document No.";
                        TransactionEntry."Document Line No." := ItemLedgerEntry."Document Line No.";
                        TransactionEntry."Item No." := ItemLedgerEntry."Item No.";
                        TransactionEntry."Lot No." := ItemLedgerEntry."Lot No.";
                        TransactionEntry.Site := CopyStr(ItemLedgerEntry."Location Code", 1, 2);
                        TransactionEntry."Business Unit" := ItemLedgerEntry."Global Dimension 2 Code";
                        TransactionEntry."Location Code" := ItemLedgerEntry."Location Code";
                        TransactionEntry.Quantity := ItemLedgerEntry.Quantity;
                        TransactionEntry."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";
                        if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Purchase Receipt" then begin
                            if ReceiptLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                                TransactionEntry."Order No." := ReceiptLine."Order No.";
                                TransactionEntry."Line No." := ReceiptLine."Order Line No.";
                            end;
                        end;
                        if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Sales Shipment" then begin
                            if ShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                                TransactionEntry."Order No." := ShipmentLine."Order No.";
                                TransactionEntry."Line No." := ShipmentLine."Order Line No.";
                            end;
                        end;
                        if LotInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
                            TransactionEntry."Lot Blocked" := LotInformation.Blocked;
                        end;
                        if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Transfer Shipment" then begin
                            if TransferShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                                TransactionEntry."Order No." := TransferShipmentLine."Transfer Order No.";
                                TransactionEntry."Line No." := TransferShipmentLine."Trans. Order Line No.";
                            end;
                        end;
                        if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Transfer Receipt" then begin
                            if TransferReceiptLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                                TransactionEntry."Order No." := TransferReceiptLine."Transfer Order No.";
                            end;
                        end;
                        TransactionEntry.Insert();
                    until ItemLedgerEntry.Next() = 0;
                end;
            end;
            InventoryEntry.Close();
        end;
    end;
  
    local procedure GetTransitFilter(): Text
    var
        LocationTable: Record Location;
        LocationFilter: Text;
    begin
        LocationTable.Reset();
        LocationTable.SetRange("Use As In-Transit", true);
        if LocationTable.FindSet() then begin
            repeat
                if LocationFilter = '' then begin
                    LocationFilter := StrSubstNo('<>%1', LocationTable.Code);
                end else begin
                    LocationFilter += StrSubstNo('&<>%1', LocationTable.Code);
                end;
            until LocationTable.Next() = 0;
        end;
        exit(LocationFilter);
    end;
}
