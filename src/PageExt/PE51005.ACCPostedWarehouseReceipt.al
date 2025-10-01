pageextension 51005 "ACC Posted Warehouse Receipt" extends "Posted Whse. Receipt List"
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
        PurchReceipt: Query "ACC Purch. Whse. Receipt Qry";
        Field: Record "Posted Whse. Receipt Header";
        FieldRec: Record "Item Ledger Entry";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Product Receipt Report";

    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        PurchReceipt.SetRange(No, SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        if PurchReceipt.Open() then begin
            if PurchReceipt.Read() then begin
                FieldRec.SetCurrentKey("Document No.");
                FieldRec.SetFilter("Document No.", PurchReceipt.PostedSourceNo);
                FieldRec.SetFilter("Posting Date", Format(PurchReceipt.PostingDate));
                FieldReport.SetTableView(FieldRec);
                FieldReport.Run();
            end;
            PurchReceipt.Close();
        end;
    end;
}
