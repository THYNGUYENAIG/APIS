page 52900 "Administrative Tools"
{
    Caption = 'Administrative Tools - P52900';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ACC Transfer Line";
    Permissions = tabledata "Item Ledger Entry" = RM;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Parm)
            {
                field(iType; iType)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Visible = bVisible;
                }
                field(iTable; iTable)
                {
                    ApplicationArea = All;
                    Caption = 'Table No';
                    Visible = bVisible;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ResetAccSourceNo)
            {
                ApplicationArea = All;
                Caption = 'Reset Data Customize field';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = bVisible;

                trigger OnAction()
                var
                begin
                    case iTable of
                        Database::"Item Ledger Entry":
                            begin
                                recILE.Reset();
                                case iType of
                                    0:
                                        begin
                                            recILE.ModifyAll("ACC Order No.", '');
                                            recILE.ModifyAll("ACC EInvoice No", '');
                                            recILE.ModifyAll("ACC Invoice No", '');
                                            if recILE.FindSet() then
                                                repeat
                                                    recILE."ACC Order No." := '';
                                                    recILE."ACC EInvoice No" := '';
                                                    recILE."ACC Invoice No" := '';
                                                    recILE.Modify();
                                                until recILE.Next() < 1;
                                        end;
                                    1:
                                        begin
                                            recILE.ModifyAll("ACC Order No.", '');
                                        end;
                                    2:
                                        begin
                                            recILE.ModifyAll("ACC EInvoice No", '');
                                        end;
                                    3:
                                        begin
                                            recILE.ModifyAll("ACC Invoice No", '');
                                        end;
                                end;
                            end;
                    end;

                    Message('Done');
                end;
            }
            action("Calculate Item Inventory")
            {
                ApplicationArea = All;
                Caption = 'Calculate Item Inventory';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = bVisible;

                trigger OnAction()
                var
                    pDialog: Page "ACC Inventory Dialog";
                    cuACCCI: Codeunit "ACC Calculate Inventory";
                    dT: Date;
                begin
                    if pDialog.RunModal() = Action::OK then begin
                        dT := pDialog.GetPostingDate();

                        if dT <> 0D then begin
                            cuACCCI.CalculateItemInventoryByMonth(dT);
                        end;
                    end;

                    Message('Done');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        bVisible := false;
        if UserId = 'APPLICATION' then begin
            bVisible := true;
        end;
    end;

    var
        recILE: Record "Item Ledger Entry";
        iType: Integer;
        iTable: Integer;
        bVisible: Boolean;
}