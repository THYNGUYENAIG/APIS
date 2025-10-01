pageextension 51007 "ACC Posted Purch. Receipt Card" extends "Posted Purchase Receipt"
{
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            group(Report)
            {
                action(ACCProductReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhập kho';
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
        Field: Record "Purch. Rcpt. Header";
        FieldRec: Record "Item Ledger Entry";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Product Receipt Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Document No.");
        FieldRec.SetFilter("Document No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
