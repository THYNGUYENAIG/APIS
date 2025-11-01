pageextension 51002 "ACC Purchase Orders" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field(ACC_WS_No; arrCellText[1])
            {
                ApplicationArea = All;
                Caption = 'WR No';
            }

            field(ACC_PSS_No; arrCellText[2])
            {
                ApplicationArea = All;
                Caption = 'PPR No';
            }

            field(ACC_PSI_No; arrCellText[3])
            {
                ApplicationArea = All;
                Caption = 'PPI No';
            }
        }
        addafter("Attached Documents List")
        {
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
                action(ACCContractUSAsPDF)
                {
                    ApplicationArea = All;
                    Caption = 'Contract As PDF';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Rec."VAT Bus. Posting Group" = 'OVERSEA';
                    Enabled = Rec.Status = "Purchase Document Status"::Released;
                    trigger OnAction();
                    begin
                        GetDataContractUSAsPDF();
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

    local procedure GetDataContractUSAsPDF()
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
            Report.SaveAs(Report::"ACC Purch Contract US Report", '', ReportFormat::Pdf, OStream, RecRef);
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

    trigger OnAfterGetRecord()
    begin
        arrCellText[1] := '';
        arrCellText[2] := '';
        arrCellText[3] := '';

        recWRL.Reset();
        recWRL.SetRange("Source Document", "Warehouse Activity Source Document"::"Sales Order");
        recWRL.SetRange("Source No.", Rec."No.");
        if recWRL.FindSet() then
            repeat
                if StrPos(arrCellText[1], StrSubstNo('%1', recWRL."No.")) = 0 then begin
                    cuACCGP.AddString(arrCellText[1], recWRL."No.", ' | ');
                end;
            until recWRL.Next() < 1;

        recPRL.Reset();
        recPRL.SetRange("Order No.", Rec."No.");
        if recPRL.FindSet() then
            repeat
                if StrPos(arrCellText[2], StrSubstNo('%1', recPRL."Document No.")) = 0 then begin
                    cuACCGP.AddString(arrCellText[2], recPRL."Document No.", ' | ');
                end;
            until recPRL.Next() < 1;

        recPIH.Reset();
        recPIH.SetRange("Order No.", Rec."No.");
        if recPIH.FindSet() then
            repeat
                if StrPos(arrCellText[3], StrSubstNo('%1', recPIH."No.")) = 0 then begin
                    cuACCGP.AddString(arrCellText[3], recPIH."No.", ' | ');
                end;
            until recPIH.Next() < 1;
    end;

    //Global
    var
        arrCellText: array[5] of Text;
        recWRL: Record "Warehouse Receipt Line";
        recPRL: Record "Purch. Rcpt. Line";
        recPIH: Record "Purch. Inv. Header";
        cuACCGP: Codeunit "ACC General Process";
}
