page 51991 "ACC BU Inventory Onhand"
{
    ApplicationArea = All;
    Caption = 'APIS BU Inventory Onhand';
    PageType = List;
    SourceTable = "ACC BU Inentory Onhand";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    Permissions = tabledata "No. Series Line" = rm;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Site No."; Rec."Site No.")
                {
                }
                field("Business Unit"; Rec."Business Unit")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(Suggest; Rec.Suggest) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCSuggest)
            {
                ApplicationArea = All;
                Image = Suggest;
                Caption = 'Suggest';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Onhand: Record "ACC BU Inentory Onhand";
                begin
                    if not Confirm('Do you want to Suggest select lines?', true) then
                        exit;
                    CurrPage.SetSelectionFilter(Onhand);
                    Onhand.SetAutoCalcFields(Quantity);
                    if Onhand.FindSet() then begin
                        repeat
                            Onhand.SuggestPlanningEntry(Onhand."Item No.", Onhand."Site No.", Onhand."Business Unit", Onhand.Quantity);
                        until Onhand.Next() = 0;
                    end;
                end;
            }
            action(ACCOpen)
            {
                ApplicationArea = All;
                Image = Open;
                Caption = 'Open';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PlanningEntry: Page "ACC BU Planning Entry";
                begin
                    PlanningEntry.PageRelease(true);
                    PlanningEntry.Run();
                end;
            }
            action(ACCRefresh)
            {
                ApplicationArea = All;
                Image = Refresh;
                Caption = 'Refresh';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                begin
                    InventoryEntry();
                    TransactionEntry();
                    BusinessUnitEntry();
                    OnhandEntry();
                end;
            }
        }
    }


    trigger OnOpenPage()
    var
    begin

    end;

    local procedure OnhandEntry()
    var
        OnhandQuery: Query "ACC BU Inventory Onhand";
        OnhandRecord: Record "ACC BU Inentory Onhand";
    begin
        OnhandRecord.Reset();
        OnhandRecord.DeleteAll();

        if OnhandQuery.Open() then begin
            while OnhandQuery.Read() do begin
                OnhandRecord.Init();
                OnhandRecord."Item No." := OnhandQuery.ItemNo;
                OnhandRecord."Business Unit" := OnhandQuery.BusinessUnit;
                OnhandRecord."Site No." := OnhandQuery.Site;
                OnhandRecord.Insert();
            end;
            OnhandQuery.Close();
        end;
        Rec.FilterGroup(2);
        Rec.SetFilter(Quantity, '<>0');
        Rec.FilterGroup(0);
    end;

    local procedure BusinessUnitEntry()
    var
        TransactionEntry: Query "AIG Transaction Entry";
        BUInventoryEntry: Record "ACC BU Inventory Entry";
        ItemList: List of [Text];
    begin
        DeleteBuzUnitEntry();
        //ItemList := AdjustmentEntry();
        if TransactionEntry.Open() then begin
            while TransactionEntry.Read() do begin
                BUInventoryEntry.Init();
                BUInventoryEntry."Entry Type" := TransactionEntry.EntryType;
                BUInventoryEntry."Document Type" := TransactionEntry.DocumentType;
                BUInventoryEntry."Order No." := TransactionEntry.OrderNo;
                BUInventoryEntry."Item No." := TransactionEntry.ItemNo;
                BUInventoryEntry.Site := TransactionEntry.Site;
                BUInventoryEntry."Business Unit" := TransactionEntry.BusinessUnit;
                BUInventoryEntry.Quantity := TransactionEntry.Quantity;
                //if ItemList.Contains(TransactionEntry.ItemNo) then
                //    BUInventoryEntry.Adjustment := true;
                BUInventoryEntry.Insert();
            end;
            TransactionEntry.Close();
        end;
    end;

    local procedure DeleteBuzUnitEntry()
    var
        BUInventoryEntry: Record "ACC BU Inventory Entry";
        PlanningEntry: Record "ACC BU Planning Entry";
    begin
        BUInventoryEntry.Reset();
        BUInventoryEntry.SetFilter("Document Type", '<>22&<>23');
        if BUInventoryEntry.FindSet() then
            repeat
                BUInventoryEntry.Delete();
            until BUInventoryEntry.Next() = 0;
        PlanningEntry.Reset();
        PlanningEntry.SetRange(Released, false);
        if PlanningEntry.FindSet() then
            repeat
                PlanningEntry.Delete();
            until PlanningEntry.Next() = 0;
    end;

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

    local procedure InventoryEntry()
    var
        InventoryEntry: Record "AIG Inventory Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotInformation: Record "Lot No. Information";
        ShipmentLine: Record "Sales Shipment Line";
        ReceiptLine: Record "Purch. Rcpt. Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferReceiptLine: Record "Transfer Receipt Line";
    Begin
        InventoryEntry.Reset();
        InventoryEntry.DeleteAll();
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Entry No.");
        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
        ItemLedgerEntry.SetFilter("Remaining Quantity", '<>0');
        ItemLedgerEntry.SetFilter("Location Code", GetTransitFilter());
        if ItemLedgerEntry.FindSet() then begin
            repeat
                InventoryEntry.Init();
                InventoryEntry."Entry No." := ItemLedgerEntry."Entry No.";
                InventoryEntry."Posting Date" := ItemLedgerEntry."Posting Date";
                InventoryEntry."Entry Type" := ItemLedgerEntry."Entry Type";
                InventoryEntry."External Document No." := ItemLedgerEntry."External Document No.";
                InventoryEntry."Document Type" := ItemLedgerEntry."Document Type";
                InventoryEntry."Document No." := ItemLedgerEntry."Document No.";
                InventoryEntry."Document Line No." := ItemLedgerEntry."Document Line No.";
                InventoryEntry."Item No." := ItemLedgerEntry."Item No.";
                InventoryEntry."Lot No." := ItemLedgerEntry."Lot No.";
                InventoryEntry.Site := CopyStr(ItemLedgerEntry."Location Code", 1, 2);
                InventoryEntry."Business Unit" := ItemLedgerEntry."Global Dimension 2 Code";
                InventoryEntry."Location Code" := ItemLedgerEntry."Location Code";
                InventoryEntry.Quantity := ItemLedgerEntry.Quantity;
                InventoryEntry."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";
                if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Purchase Receipt" then begin
                    if ReceiptLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                        InventoryEntry."Order No." := ReceiptLine."Order No.";
                        InventoryEntry."Line No." := ReceiptLine."Order Line No.";
                    end;
                end;
                if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Sales Shipment" then begin
                    if ShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                        InventoryEntry."Order No." := ShipmentLine."Order No.";
                        InventoryEntry."Line No." := ShipmentLine."Order Line No.";
                    end;
                end;
                if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Transfer Shipment" then begin
                    if TransferShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                        InventoryEntry."Order No." := TransferShipmentLine."Transfer Order No.";
                        InventoryEntry."Line No." := TransferShipmentLine."Trans. Order Line No.";
                    end;
                end;
                if ItemLedgerEntry."Document Type" = "Item Ledger Document Type"::"Transfer Receipt" then begin
                    if TransferReceiptLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                        InventoryEntry."Order No." := TransferReceiptLine."Transfer Order No.";
                    end;
                end;
                if LotInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
                    InventoryEntry."Lot Blocked" := LotInformation.Blocked;
                end;
                InventoryEntry.Insert();
            until ItemLedgerEntry.Next() = 0;
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
