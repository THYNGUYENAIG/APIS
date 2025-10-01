pageextension 52027 "ACC Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ACCChangeDocument)
            {
                ApplicationArea = All;
                Caption = 'Change External Document';
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    eInvoice: Page "ACC External Document Change";
                //Field: Record "Sales Invoice Header";
                //SelectionFilterManagement: Codeunit SelectionFilterManagement;
                //RecRef: RecordRef;
                //DocumentNo: Text;
                //PostingDate: Date;
                begin
                    //CurrPage.SetSelectionFilter(Field);
                    //RecRef.GetTable(Field);
                    //DocumentNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No."));
                    //Evaluate(PostingDate, SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Posting Date")));
                    //eInvoice.SetInvoiceValue(DocumentNo, PostingDate);
                    eInvoice.SetInvoiceValue(Rec."No.", Rec."Posting Date");
                    eInvoice.Run();
                end;
            }
        }
    }
}