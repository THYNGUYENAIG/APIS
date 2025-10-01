page 51036 "ACC Sales Reason Card"
{
    ApplicationArea = All;
    Caption = 'ACC Sales Reason Card';
    PageType = StandardDialog;
    SourceTable = "Sales Header";
    //DelayedInsert = false;
    //DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    Editable = false;
                }
                field("ACC Reason Code"; Rec."ACC Reason Code")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ReasonCode: Record "ACC Sales Reason";
                    begin
                        ReasonCode.Reset();
                        ReasonCode.SetRange(Type, "ACC Sales Reason Type"::Delete);
                        if Page.RunModal(Page::"ACC Sales Reason", ReasonCode) = Action::LookupOK then begin
                            Text := ReasonCode.Code;
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    var
                    begin
                        if Rec."ACC Reason Code" = '' then begin
                            Error(StrSubstNo('Select Reason code again.'));
                        end;
                    end;
                }
                field("ACC Reason Comment"; Rec."ACC Reason Comment")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OK)
            {
                ApplicationArea = All;
                Caption = 'Delete Record';
                Image = Delete;
                InFooterBar = true;

                trigger OnAction()
                begin
                    if Rec."ACC Reason Code" = '' then begin
                        Message('Please enter a reason code for deletion.');
                        exit;
                    end;
                    CurrPage.Close();
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Image = Cancel;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Rec."ACC Reason Code" := '';
                    Rec."ACC Reason Comment" := '';
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        Rec.SetRange("No.", SalesOrder_);
    end;

    procedure SetSalesOrder(SalesOrder: Text)
    var
    begin
        SalesOrder_ := SalesOrder;
    end;

    var
        SalesOrder_: Text;
}
