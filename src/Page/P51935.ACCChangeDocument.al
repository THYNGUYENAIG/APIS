page 51935 "ACC Change Document"
{
    ApplicationArea = All;
    Caption = 'Document Change';
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

                field(Type; Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Editable = false;
                }
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

                field(FieldChange; FieldChange)
                {
                    ApplicationArea = All;
                    Caption = 'Field Change';
                    trigger OnValidate()
                    begin
                        LoadOldValue();
                    end;
                }

                field(OldValue; OldValue)
                {
                    ApplicationArea = All;
                    Caption = 'Old Value';
                    Editable = false;
                }
                field(NewValue; NewValue)
                {
                    ApplicationArea = All;
                    Caption = 'New Value';
                    Editable = true;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        case FieldChange of
                            FieldChange::"Vendor Invoice No.":
                                begin
                                    if StrLen(NewValue) > 35 then begin
                                        Error('"Vendor Invoice No." must be less than 35');
                                    end;
                                end;
                        end;
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
                    ExternalDoc: Codeunit "ACC Document Modify";
                begin
                    if NewValue <> '' then begin
                        ExternalDoc.ChangeDoc(Type, FieldChange, DocumentNo, PostingDate, NewValue);
                        CurrPage.Close();
                    end
                    else
                        Error('New values is empty');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadOldValue();
    end;

    local procedure LoadOldValue()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        case Type of
            Type::"Posted Purchase Invoice":
                begin
                    if PurchInvHeader.Get(DocumentNo) then begin
                        case FieldChange of
                            FieldChange::"Vendor Invoice No.":
                                OldValue := PurchInvHeader."Vendor Invoice No.";
                        end;
                    end;
                end;
        end;
    end;

    procedure SetDocument(_Type: Enum "ACC Type Change Document"; _DocumentNo: Text; _PostingDate: Date)
    var
    begin
        DocumentNo := _DocumentNo;
        PostingDate := _PostingDate;
        Type := _Type;
    end;

    var
        DocumentNo: Text;
        PostingDate: Date;
        OldValue, NewValue : Text[100];
        FieldChange: Enum "ACC Field Change Document";
        Type: Enum "ACC Type Change Document";

}
