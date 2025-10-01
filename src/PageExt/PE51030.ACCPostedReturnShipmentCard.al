pageextension 51030 "ACC Return Shipment Card" extends "Posted Return Shipment"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            group(Report)
            {
                Caption = 'Report';
                action(ACCReturnShipment)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu xuất kho (Return)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataFromPageControlField();
                    end;
                }
            }
        }
    }

    local procedure GetDataFromPageControlField()
    var
        Field: Record "Return Shipment Header";
        FieldRec: Record "Return Shipment Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Return Shipment Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
