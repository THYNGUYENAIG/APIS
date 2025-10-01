page 51918 "ACC External Document Change"
{
    ApplicationArea = All;
    Caption = 'External Document Change';
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Option)
            {
                Caption = 'Options';
                field("Document No."; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;
                }
                field("Posting Date"; PostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field("Select eInvoice"; SelecteInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Select eInvoice';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        eInvoiceList: Page "BLTI eInvoices Registers";
                    begin
                        Clear(Text);
                        Clear(SelecteInvoice);
                        eInvoiceList.LookupMode(true);
                        if eInvoiceList.RunModal() = Action::LookupOK then begin
                            Text += eInvoiceList.GetSelection();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCConsolidate)
            {
                ApplicationArea = All;
                Image = Change;
                Caption = 'Change';
                trigger OnAction()
                var
                    ExternalDoc: Codeunit "ACC External Document Modify";
                begin
                    ExternalDoc.ChangeDoc(DocumentNo, PostingDate, SelecteInvoice);
                    CurrPage.Close();
                end;
            }
        }
    }

    procedure SetInvoiceValue(_DocumentNo: Text; _PostingDate: Date)
    var
    begin
        DocumentNo := _DocumentNo;
        PostingDate := _PostingDate;
    end;

    var
        SelecteInvoice: Text;
        DocumentNo: Text;
        PostingDate: Date;
}
