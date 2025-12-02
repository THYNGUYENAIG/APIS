pageextension 52034 "ACC Posted Purch. Invoices Ext" extends "Posted Purchase Invoices"
{
    actions
    {
        addlast(processing)
        {
            action(ACCChangeDocument)
            {
                ApplicationArea = All;
                Caption = 'Change Document';
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ChangeDocumentVisible;
                trigger OnAction();
                var
                    ChangeDocument: Page "ACC Change Document";
                begin
                    ChangeDocument.SetDocument(Enum::"ACC Type Change Document"::"Posted Purchase Invoice", Rec."No.", Rec."Posting Date");
                    ChangeDocument.Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        ChangeDocumentVisible := UserId() = 'APPLICATION 1'
    end;

    var
        ChangeDocumentVisible: Boolean;

}