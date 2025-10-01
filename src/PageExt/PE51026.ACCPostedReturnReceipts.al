pageextension 51026 "ACC Posted Return Receipts" extends "Posted Return Receipts"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            group(Report)
            {
                action(ACCReturnReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhận hàng';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataReturnReceipt();
                    end;
                }
            }
        }
    }
    local procedure GetDataReturnReceipt()
    var
        Field: Record "Return Receipt Header";
        FieldRec: Record "Item Ledger Entry";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Return Receipt Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Document No.");
        FieldRec.SetFilter("Document No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
