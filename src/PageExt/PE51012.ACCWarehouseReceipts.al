pageextension 51012 "ACC Warehouse Receipts" extends "Warehouse Receipts"
{
    actions
    {
        addlast(processing)
        {
            group(Report)
            {
                action(ACCWhseReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhập kho (Unpost)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataWhseReceipt();
                    end;
                }
            }
        }
    }

    local procedure GetDataWhseReceipt()
    var
        Field: Record "Warehouse Receipt Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC WH Receipt Unpost Report";
        WRNo: Text;
        ParametersText: Text;
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);
        WRNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No."));
        ParametersText := StrSubstNo('%1%2%3', '<?xml version="1.0" standalone="yes"?><ReportParameters name="ACC WH Receipt Unpost Report" id="51016"><Options><Field name="WhseNo">', WRNo, '</Field></Options><DataItems><DataItem name="WhseReceipt">VERSION(1) SORTING(Field51001)</DataItem></DataItems></ReportParameters>');
        //Phương thức dùng để lấy thông tin tham số Parameters XML.
        //Test := FieldReport.RunRequestPage();
        //Message(StrSubstNo('%1\%2', WRNo, Test));
        FieldReport.Execute(ParametersText); // Sales AS PDF
    end;
}
