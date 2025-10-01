pageextension 51918 "ACC Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Salesperson Name"; Rec."Salesperson Name") { ApplicationArea = All; }
            field("External Document No."; Rec."External Document No.") { ApplicationArea = All; }
            field("BLTI Original eInvoice No."; Rec."BLTI Original eInvoice No.") { ApplicationArea = All; }
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
                begin
                    eInvoice.SetInvoiceValue(Rec."No.", Rec."Posting Date");
                    eInvoice.Run();
                end;
            }
        }
    }
}
