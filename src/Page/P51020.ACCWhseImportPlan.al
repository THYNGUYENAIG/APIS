page 51020 "ACC Whse. Import Plan"
{
    ApplicationArea = All;
    Caption = 'Kế hoạch nhập hàng (Kho) - P51020';
    PageType = List;
    SourceTable = "ACC Import Plan Table";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableView = where("Process Status" = filter(<> 15));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Process Status"; Rec."Process Status") { }
                field("Source Document No."; Rec."Source Document No.") { }
                field("Source Line No."; Rec."Source Line No.") { }
                field("Purchase Status"; Rec."Purchase Status") { }
                field("Warehouse Receipt"; Rec."Warehouse Receipt") { }
                field("Posted Warehouse Receipt"; Rec."Posted Warehouse Receipt") { }
                field("Receipt Date"; Rec."Receipt Date") { }
                field("Posted Whse. Rcpt. Quatity"; Rec."Posted Whse. Rcpt. Quatity") { }
                field("Posted Purchase Receipt"; Rec."Posted Purchase Receipt") { }
                field("Vendor Account"; Rec."Vendor Account") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Item Group"; Rec."Item Group New") { }
                field("Purchase Item Number"; Rec."Purchase Item Number") { }
                field("Purchase Item Name"; Rec."Purchase Item Name") { }
                field("Purchase Quantity"; Rec."Purchase Quantity") { }
                field("Declaration No."; Rec."Declaration No.") { }
                field("Imported Available Date"; Rec."Imported Available Date")
                {
                    Editable = false;
                }
                field("Purchase Location Code"; Rec."Purchase Location Code") { }
                field("Actual Location Code"; Rec."Actual Location Code") { }
                field("Actual Received Quantity"; Rec."Actual Received Quantity") { }
                field("Delivery Date"; Rec."Delivery Date") { }
                field("Delivery Time"; Rec."Delivery Time") { }
                field("Transport Code"; Rec."Transport Code") { }
                field("Transport Name"; Rec."Transport Name") { }
                field("Whse. Reason"; Rec."Whse. Reason") { }
                field(Note; Rec.Note) { }
                field("Whse. Note"; Rec."Whse. Note") { }
                field("BUS GROUP"; Rec."BUS GROUP") { }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ACCAction)
            {
                Caption = 'Action';
                action(ACCWhseReceipt)
                {
                    ApplicationArea = All;
                    Caption = 'Phiếu nhập kho (Unpost)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        GetDataWhseReceipt();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-1D', TODAY);
        ToDate := CalcDate('+3D', TODAY);
        Rec.SetRange("Delivery Date", FromDate, ToDate);
    end;

    local procedure GetDataWhseReceipt()
    var
        Field: Record "ACC Import Plan Table";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
        FieldReport: Report "ACC Import Plan Unpost Report";
        WRNo: Text;
        PurchNo: Text;
        LineNo: Text;
        ItemLineNo: Text;
        ParametersText: Text;
    begin
        CurrPage.SetSelectionFilter(Field);
        RecRef.GetTable(Field);
        PurchNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Source Document No."));
        LineNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Source Line No."));
        ItemLineNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Line No."));
        ParametersText := StrSubstNo('%1%2%3%4%5%6%7', '<?xml version="1.0" standalone="yes"?><ReportParameters name="ACC Import Plan Unpost Report" id="51023"><Options><Field name="PurchNo">', PurchNo, '</Field><Field name="LineNo">', LineNo, '</Field><Field name="ItemLineNo">', ItemLineNo, '</Field></Options><DataItems><DataItem name="ImportPlan">VERSION(1) SORTING(Field51001)</DataItem></DataItems></ReportParameters>');
        //WRNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No."));
        //ParametersText := StrSubstNo('%1%2%3', '<?xml version="1.0" standalone="yes"?><ReportParameters name="ACC WH Receipt Unpost Report" id="51016"><Options><Field name="WhseNo">', WRNo, '</Field></Options><DataItems><DataItem name="WhseReceipt">VERSION(1) SORTING(Field51001)</DataItem></DataItems></ReportParameters>');
        //Phương thức dùng để lấy thông tin tham số Parameters XML.
        //WRNo := FieldReport.RunRequestPage();
        //Message(WRNo);
        FieldReport.Execute(ParametersText); // Sales AS PDF
    end;
}
