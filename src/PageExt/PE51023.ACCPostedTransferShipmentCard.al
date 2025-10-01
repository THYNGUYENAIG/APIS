pageextension 51023 "ACC Transfer Shipment Card" extends "Posted Transfer Shipment"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            group(Report)
            {
                action(ACCTransferOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu xuất điều chuyển';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataTransferShipment();
                    end;
                }
            }
        }
    }
    local procedure GetDataTransferShipment()
    var
        Field: Record "Transfer Shipment Header";
        FieldRec: Record "Transfer Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Transfer Order Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
