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
                action(ACCContractUSAsPDF_Normal)
                {
                    ApplicationArea = All;
                    Caption = 'Contract As PDF (Normal)';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" = 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractUSAsPDF(0);
                    end;
                }
                action(ACCContractUSAsPDF_Givaudan)
                {
                    ApplicationArea = All;
                    Caption = 'Contract As PDF (Givaudan, Symrise)';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" = 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractUSAsPDF(1);
                    end;
                }
                action(ACCContractUSAsPDF_FIRMENICH)
                {
                    ApplicationArea = All;
                    Caption = 'Contract As PDF (FIRMENICH)';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" = 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractUSAsPDF(2);
                    end;
                }
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

    local procedure GetDataContractUSAsPDF(Layout: Option Normal,Givaudan,FIRMENICH)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;

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
        TempBlob.CreateOutStream(OStream);

        if CompanyId = 'ACS' then begin
            Report.SaveAs(Report::"ACS Purch Contract US Report", '', ReportFormat::Pdf, OStream, RecRef);
            FileManagement.BLOBExport(TempBlob, 'Purchase Order_' + Rec."No." + '_' + Format(CurrentDateTime, 0, '<Year4><Day,2><Month,2><Hours24><Minutes,2><Seconds,2>') + '.pdf', true);
        end else begin
            case Layout of
                Layout::Normal:
                    Report.SaveAs(Report::"ACC Purch Contract US Report 1", '', ReportFormat::Pdf, OStream, RecRef);
                Layout::Givaudan:
                    Report.SaveAs(Report::"ACC Purch Contract US Report", '', ReportFormat::Pdf, OStream, RecRef);
                Layout::FIRMENICH:
                    Report.SaveAs(Report::"ACC Purch Contract US Report 3", '', ReportFormat::Pdf, OStream, RecRef);
            end;
            FileManagement.BLOBExport(TempBlob, 'Purchase Order_' + Rec."No." + '_' + Format(CurrentDateTime, 0, '<Year4><Day,2><Month,2><Hours24><Minutes,2><Seconds,2>') + '.pdf', true);
        end;
    end;

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
