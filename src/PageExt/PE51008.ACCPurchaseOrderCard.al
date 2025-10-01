pageextension 51008 "ACC Purchase Order Card" extends "Purchase Order"
{
    layout
    {
        addafter("BLTEC BPO No.")
        {
            field("ACC Original Document"; Rec."ACC Original Document")
            {
                ApplicationArea = ALL;
            }
        }
        addafter(PurchaseDocCheckFactbox)
        {
            part(ACCICF_Factbox; "ACC Item Cert FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchLines;
                SubPageLink = "No." = field("No.");
            }
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Purchase Header"),
                              "No." = field("No.");
            }
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            group(Report)
            {
                action(ACCContractUS)
                {
                    ApplicationArea = All;
                    Caption = 'Contract';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" = 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractUS();
                    end;
                }

                action(ACCContractVN)
                {
                    ApplicationArea = All;
                    Caption = 'Đơn đặt hàng';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" <> 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractVN();
                    end;
                }

                action(ACCContractNoVN)
                {
                    ApplicationArea = All;
                    Caption = 'Đơn đặt hàng (Không HĐNT)';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" <> 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractNoVN();
                    end;
                }

                action(ACCContractGIV)
                {
                    ApplicationArea = All;
                    Caption = 'Đơn đặt hàng GIV';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" <> 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractGIV();
                    end;
                }
            }
        }
    }
    local procedure GetDataContractUS()
    var
        Field: Record "Purchase Header";
        FieldRec: Record "Purchase Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Purch Contract US Report";
        ACSFieldReport: Report "ACS Purch Contract US Report";
        CompanyId: Text;
    begin
        CompanyId := CompanyName;

        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));

        if CompanyId = 'ACS' then begin
            ACSFieldReport.SetTableView(FieldRec);
            ACSFieldReport.Run();
        end else begin
            FieldReport.SetTableView(FieldRec);
            FieldReport.Run();
        end;
    end;

    local procedure GetDataContractVN()
    var
        Field: Record "Purchase Header";
        FieldRec: Record "Purchase Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Purch Contract VN Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    local procedure GetDataContractNoVN()
    var
        Field: Record "Purchase Header";
        FieldRec: Record "Purchase Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC PO No Contract VN Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    local procedure GetDataContractGIV()
    var
        Field: Record "Purchase Header";
        FieldRec: Record "Purchase Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC PO Contract GIV VN Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("No.");
        FieldRec.SetFilter("No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;
}
