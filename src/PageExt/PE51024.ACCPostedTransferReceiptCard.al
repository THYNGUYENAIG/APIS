pageextension 51024 "ACC Transfer Receipt Card" extends "Posted Transfer Receipt"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            group(Report)
            {
                action(ACCTransferReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhận hàng';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataTransferReceipt();
                    end;
                }
                action(ACCTOReceiptMerge)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhận hàng (TO)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataTOReceiptMerge();
                    end;
                }
            }
        }
    }
    local procedure GetDataTransferReceipt()
    var
        Field: Record "Transfer Receipt Header";
        FieldRec: Record "Transfer Receipt Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Transfer Receipt Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    local procedure GetDataTOReceiptMerge()
    var
        Field: Record "Transfer Receipt Header";
        FieldRec: Record "Transfer Receipt Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC TO Receipt Merge Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("Transfer Order No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Transfer Order No.")));
        FieldRec.SetFilter("Transfer Order Date", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Transfer Order Date")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
