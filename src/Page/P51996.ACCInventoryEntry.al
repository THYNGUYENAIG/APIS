page 51996 "ACC Inventory Entry"
{
    ApplicationArea = All;
    Caption = 'ACC Inventory Entry';
    PageType = List;
    SourceTable = "AIG Inventory Entry";
    UsageCategory = Administration;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Lot No."; Rec."Lot No.") { }
                field(Quantity; Rec.Quantity) { }
                field("Remaining Quantity"; Rec."Remaining Quantity") { }
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
                    InventoryEntry();
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
                InventoryEntry."Item No." := ItemLedgerEntry."Item No.";
                InventoryEntry."Lot No." := ItemLedgerEntry."Lot No.";
                InventoryEntry.Quantity := ItemLedgerEntry.Quantity;
                InventoryEntry."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";
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
