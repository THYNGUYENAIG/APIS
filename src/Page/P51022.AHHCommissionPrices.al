page 51022 "AHH Commission Prices"
{
    ApplicationArea = All;
    Caption = 'AHH Commission Prices - P51022';
    PageType = List;
    SourceTable = "AHH Commission Price";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("From Date"; Rec."From Date") { }
                field("To Date"; Rec."To Date") { }
                field(Unit; Rec.Unit) { }
                field(Price; Rec.Price) { }
                field(State; Rec.State) { }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ACCAction)
            {
                Caption = 'Action';

                action(ACCOpen)
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        ComOpen();
                    end;
                }
                action(ACCReleased)
                {
                    ApplicationArea = All;
                    Caption = 'Released';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        ComReleased();
                    end;
                }
            }
        }
    }
    local procedure ComOpen()
    var
        Field: Record "AHH Commission Price";
        FieldRec: Record "AHH Commission Price";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Entry No.");
        FieldRec.SetFilter("Entry No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Entry No.")));
        if FieldRec.FindSet() then begin
            repeat
                if FieldRec.State <> "AHH Price State"::Open then begin
                    FieldRec.State := "AHH Price State"::Open;
                    FieldRec.Modify();
                end;
            until FieldRec.Next() = 0;
        end;
    end;

    local procedure ComReleased()
    var
        Field: Record "AHH Commission Price";
        FieldRec: Record "AHH Commission Price";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Entry No.");
        FieldRec.SetFilter("Entry No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Entry No.")));
        if FieldRec.FindSet() then begin
            repeat
                if FieldRec.State <> "AHH Price State"::Released then begin
                    FieldRec.State := "AHH Price State"::Released;
                    FieldRec.Modify();
                end;
            until FieldRec.Next() = 0;
        end;
    end;
}
