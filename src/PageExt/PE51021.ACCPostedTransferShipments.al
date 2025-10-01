pageextension 51021 "ACC Posted Transfer Shipments" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Transfer-to Code")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related transfer order.';
            }
        }
    }
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
