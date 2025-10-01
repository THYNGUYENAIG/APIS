pageextension 51001 "ACC Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addlast(Control1)
        {
            field(Order_No; Rec."Order No.")
            {
                ApplicationArea = All;
                Caption = 'Order No.';
                Editable = false;
            }
            field("Posted Purchase Invoice"; Rec."Posted Purchase Invoice")
            {
                ApplicationArea = All;
                Caption = 'Posted Purchase Invoice';
                Editable = false;
            }
            field("Invoice Date"; Rec."Invoice Date")
            {
                ApplicationArea = All;
                Caption = 'Invoice Date';
                Editable = false;
            }
            field("Purchase Quantity"; Rec."Purchase Quantity")
            {
                ApplicationArea = All;
                Caption = 'Purchase Quantity';
            }
        }
        addafter("Location Code")
        {
            field("ACC Location"; Rec."ACC Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ACC Location Code field.', Comment = '%';
            }
        }
        modify("Location Code")
        {
            Visible = false;
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ACCUpdate)
            {
                ApplicationArea = All;
                Caption = 'Get eInvoice';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    PurchReceiptCU: Codeunit "ACC Purch Receipt Event";
                    ReceiptHeader: Record "Purch. Rcpt. Header";
                    FromDate: Date;
                    ToDate: Date;
                begin
                    FromDate := CalcDate('-3D', TODAY);
                    ToDate := Today();
                    Clear(ReceiptHeader);
                    ReceiptHeader.SetRange("Posting Date", FromDate, ToDate);
                    if ReceiptHeader.FindSet() then begin
                        repeat
                            PurchReceiptCU.Run(ReceiptHeader);
                        until ReceiptHeader.Next() = 0;
                    end;
                end;
            }
            group(Report)
            {
                action(ACCProductReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhập kho';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataFromPageControlField();
                    end;
                }
                action(ACCOrderReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhập kho (gộp PO)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetPOFromPageControlField();
                    end;
                }
            }
        }
    }

    local procedure GetDataFromPageControlField()
    var
        Field: Record "Purch. Rcpt. Header";
        FieldRec: Record "Item Ledger Entry";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Product Receipt Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Document No.");
        FieldRec.SetFilter("Document No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No.")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    local procedure GetPOFromPageControlField()
    var
        Field: Record "Purch. Rcpt. Header";
        FieldRec: Record "Purch. Rcpt. Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Order Receipt Report";
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);

        FieldRec.SetCurrentKey("Order No.");
        FieldRec.SetFilter("Order No.", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Order No.")));
        FieldRec.SetFilter("Posting Date", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Posting Date")));
        FieldReport.SetTableView(FieldRec);
        FieldReport.Run();
    end;

    trigger OnOpenPage()
    var
        PurchReceiptCU: Codeunit "ACC Purch Receipt Event";
        ReceiptHeader: Record "Purch. Rcpt. Header";
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-3D', TODAY);
        ToDate := Today();
        Clear(ReceiptHeader);
        ReceiptHeader.SetRange("Posting Date", FromDate, ToDate);
        if ReceiptHeader.FindSet() then begin
            repeat
                PurchReceiptCU.Run(ReceiptHeader);
            until ReceiptHeader.Next() = 0;
        end;
    end;
}
