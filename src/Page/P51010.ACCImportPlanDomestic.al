page 51010 "ACC Domestic Import Plan"
{
    ApplicationArea = All;
    Caption = 'Kế hoạch nhập hàng (Nội địa) - P51010';
    PageType = List;
    SourceTable = "ACC Import Plan Table";
    UsageCategory = Lists;
    InsertAllowed = false;
    SourceTableView = where("Declaration No." = filter(''),
                            "BUS GROUP" = filter('DOMESTIC'),
                            "Process Status" = filter(<> 15));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Process Status"; Rec."Process Status") { }
                field("Contract No."; Rec."Contract No.") { }
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
                action(ACCDeliveryDate)
                {
                    ApplicationArea = All;
                    Caption = 'Get Delivery Date(s)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                    begin
                        ImportDomestic();
                    end;
                }
                action(ACCPurchOrder)
                {
                    ApplicationArea = All;
                    Caption = 'PO Changed';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                    begin
                        ImportPlanUpdate();
                    end;
                }
                action(ACCDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Get Document(s)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                    begin
                        ImportPlanModify();
                    end;
                }
                action(ACCCopy)
                {
                    ApplicationArea = All;
                    Caption = 'Copy';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        ImportPlan: Record "ACC Import Plan Table";
                    begin
                        CurrPage.SetSelectionFilter(ImportPlan);
                        ImportPlan.Next();
                        if ImportPlan.Count = 1 then begin
                            CopyImportPlan(ImportPlan);
                        end else begin
                            Message('Anh / chị đã chọn nhiều dòng.');
                        end;
                    end;
                }

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
        //Rec.SetFilter("Posted Purchase Receipt", '%1', '');
        //Rec.SetRange("Imported Available Date", FromDate, ToDate);
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

    local procedure CopyImportPlan(Rec: Record "ACC Import Plan Table")
    var
        ImportPlan: Record "ACC Import Plan Table";
        ImportRECD: Record "ACC Import Plan Table";
        LineNo: Integer;
    begin
        Clear(ImportPlan);
        Clear(ImportRECD);
        LineNo := 0;
        ImportPlan.Init();
        ImportPlan.Copy(Rec);
        ImportRECD.SetRange("Source Document No.", Rec."Source Document No.");
        ImportRECD.SetRange("Source Line No.", Rec."Source Line No.");
        if ImportRECD.FindSet() then
            repeat
                if LineNo < ImportRECD."Line No." then
                    LineNo := ImportRECD."Line No.";
            until ImportRECD.Next() = 0;
        ImportPlan."Line No." := LineNo + 1;
        ImportPlan."Actual Received Quantity" := 0;
        ImportPlan.Insert();
    end;

    local procedure ImportPlanModify()
    var
        PurchTable: Query "ACC Import Entry Qry";
        Rec: Record "BLTEC Import Entry";
        PurchLine: Record "Purchase Line";
        ImportPlan: Record "ACC Import Plan Table";
        CustomsDelc: Record "BLTEC Customs Declaration";
        ContainerType: Record "BLTEC Container Type";
        PurchserTable: Record "Salesperson/Purchaser";
        Item: Record Item;
        WhseReqstKey: Record "Warehouse Request";
        PurchHeader: Record "Purchase Header";

        RecItem: Record Item;
        RecCusDecl: Record "BLTEC Customs Declaration";
        DELCContainerType: Record "BLTEC Container Type";
        DELCPurchserTable: Record "Salesperson/Purchaser";
        DELCPersonInCharge: Record "Salesperson/Purchaser";
        DELCServiceUnit: Record "BLTEC Service Unit";
        ForUpdated: Boolean;
    begin
        Rec.SetFilter("Process Status", '<>%1', 10);
        if Rec.FindSet() then begin
            repeat
                if PurchLine.Get(Enum::"Purchase Document Type"::Order, Rec."Purchase Order No.", Rec."Line No.") then begin
                    if PurchLine."VAT Bus. Posting Group" = 'OVERSEA' then begin
                        ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                        ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                        if ImportPlan.FindSet() then begin
                            repeat
                                ForUpdated := false;
                                if ImportPlan."Copy Docs Date" <> Rec."BLACC Copy Docs Date" then begin
                                    ImportPlan."Copy Docs Date" := Rec."BLACC Copy Docs Date";
                                    ForUpdated := true;
                                end;
                                if ImportPlan."Declaration No." <> Rec."BLTEC Customs Declaration No." then begin
                                    ImportPlan."Declaration No." := Rec."BLTEC Customs Declaration No.";
                                    ImportPlan."Declaration Date" := Rec."Customs Declaration Date";
                                    ImportPlan."Bill No." := Rec."BL No.";
                                    ImportPlan.Quantity := Rec.Quantity;
                                    ForUpdated := true;
                                end;
                                CustomsDelc.SetRange("BLTEC Customs Declaration No.", Rec."BLTEC Customs Declaration No.");
                                if CustomsDelc.FindFirst() then begin
                                    if ImportPlan."Document No." <> CustomsDelc."Document No." then begin
                                        ImportPlan."Document No." := CustomsDelc."Document No.";
                                        ImportPlan."Bill No." := CustomsDelc."BL No.";
                                        ForUpdated := true;
                                    end;
                                    if ContainerType.Get(CustomsDelc."BLTEC Container Type") then begin
                                        if ImportPlan."Cont. Type" <> ContainerType."BLTEC Code" then begin
                                            ImportPlan."Cont. Type" := ContainerType."BLTEC Code";
                                            ImportPlan."Product Type" := ContainerType."BLTEC Product Type";
                                            ImportPlan."Cont. 20" := ContainerType."BLTEC Cont. 20 Qty";
                                            ImportPlan."Cont. 40" := ContainerType."BLTEC Cont. 40 Qty";
                                            ImportPlan."Cont. 45" := ContainerType."BLTEC Cont. 45 Qty";
                                            ImportPlan."Cont. Quantity" := ContainerType."BLTEC Quantity";
                                            ForUpdated := true;
                                        end;
                                    end;
                                end;
                                if (Rec."Actual ETA Date" <> 0D) AND (ImportPlan."Actual Arrival Date" <> Rec."Actual ETA Date") then begin
                                    ImportPlan."Actual Arrival Date" := Rec."Actual ETA Date";
                                    if ImportPlan."Copy Docs Date" > ImportPlan."Actual Arrival Date" then begin
                                        ImportPlan."Imported Available Date" := ImportPlan."Copy Docs Date" + 2;
                                        ImportPlan."Import Reason" := Enum::"ACC Import Reason Type"::"Waiting for Documents";
                                    end else begin
                                        ImportPlan."Imported Available Date" := ImportPlan."Actual Arrival Date" + 2;
                                    end;
                                    ImportPlan."Storage Date" := ImportPlan."Actual Arrival Date" + ImportPlan."Store lưu bãi" - 1;
                                    if ImportPlan.Combine <> 0 then begin
                                        if ImportPlan."Delivery Date" = 0D then begin
                                            ImportPlan."Full Container Date" := ImportPlan."Actual Arrival Date" + ImportPlan.Combine - 1;
                                            ImportPlan."Empty Container Date" := ImportPlan."Full Container Date";
                                        end else begin
                                            ImportPlan."Empty Container Date" := ImportPlan."Actual Arrival Date" + ImportPlan.Combine - 1;
                                        end;
                                    end else begin
                                        if ImportPlan.DEM <> 0 then
                                            ImportPlan."Full Container Date" := ImportPlan."Actual Arrival Date" + ImportPlan.DEM - 1;
                                    end;
                                    if ImportPlan."Storage Date" > ImportPlan."Full Container Date" then begin
                                        ImportPlan."Port Date" := ImportPlan."Full Container Date";
                                    end else begin
                                        ImportPlan."Port Date" := ImportPlan."Storage Date";
                                    end;
                                    ForUpdated := true;
                                end;
                                if ForUpdated = true then
                                    ImportPlan.Modify();
                            until ImportPlan.Next() = 0;
                        end else begin
                            Clear(ImportPlan);
                            ImportPlan.Init();
                            ImportPlan."Source Document No." := Rec."Purchase Order No.";
                            ImportPlan."Source Line No." := Rec."Line No.";
                            ImportPlan."Line No." := 1;
                            ImportPlan."Vendor Account" := Rec."Vendor No.";
                            ImportPlan."Vendor Name" := Rec."Vendor Name";
                            ImportPlan."Item Number" := Rec."Item No.";
                            ImportPlan."Item Name" := Rec."Item Description";
                            ImportPlan.Quantity := Rec.Quantity;
                            ImportPlan."Declaration No." := Rec."BLTEC Customs Declaration No.";
                            ImportPlan."Declaration Date" := Rec."Customs Declaration Date";
                            ImportPlan."Bill No." := Rec."BL No.";
                            ImportPlan."Copy Docs Date" := Rec."BLACC Copy Docs Date";

                            CustomsDelc.SetRange("BLTEC Customs Declaration No.", Rec."BLTEC Customs Declaration No.");
                            if CustomsDelc.FindFirst() then begin
                                ImportPlan."Document No." := CustomsDelc."Document No.";
                                if ContainerType.Get(CustomsDelc."BLTEC Container Type") then begin
                                    ImportPlan."Cont. Type" := ContainerType."BLTEC Code";
                                    ImportPlan."Product Type" := ContainerType."BLTEC Product Type";
                                    ImportPlan."Cont. 20" := ContainerType."BLTEC Cont. 20 Qty";
                                    ImportPlan."Cont. 40" := ContainerType."BLTEC Cont. 40 Qty";
                                    ImportPlan."Cont. 45" := ContainerType."BLTEC Cont. 45 Qty";
                                    ImportPlan."Cont. Quantity" := ContainerType."BLTEC Quantity";
                                end;
                            end;
                            if Rec."Actual ETA Date" <> 0D then begin
                                ImportPlan."Actual Arrival Date" := Rec."Actual ETA Date";
                                if ImportPlan."Copy Docs Date" > ImportPlan."Actual Arrival Date" then begin
                                    ImportPlan."Imported Available Date" := ImportPlan."Copy Docs Date" + 2;
                                    ImportPlan."Import Reason" := Enum::"ACC Import Reason Type"::"Waiting for Documents";
                                end else begin
                                    ImportPlan."Imported Available Date" := ImportPlan."Actual Arrival Date" + 2;
                                end;
                            end;
                            ImportPlan.Insert();
                        end;
                    end else begin
                        if PurchLine."Outstanding Quantity" > 0 then begin
                            ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                            ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                            if ImportPlan.FindSet() then begin
                                repeat
                                    if ImportPlan."Vendor Account" <> Rec."Vendor No." then begin
                                        ImportPlan."Vendor Account" := Rec."Vendor No.";
                                        ImportPlan."Vendor Name" := Rec."Vendor Name";
                                        ImportPlan.Modify();
                                    end;
                                    if ImportPlan.Quantity <> Rec.Quantity then begin
                                        ImportPlan.Quantity := Rec.Quantity;
                                        ImportPlan."Actual Received Quantity" := Rec.Quantity;
                                        ImportPlan.Modify();
                                    end;
                                    if ImportPlan."Location Code" <> Rec."Location Code" then begin
                                        ImportPlan."Location Code" := Rec."Location Code";
                                        ImportPlan."Actual Location Code" := Rec."Location Code";
                                        ImportPlan.Modify();
                                        if Rec."Location Code" <> '' then begin
                                            if not WhseReqstKey.Get("Warehouse Request Type"::Inbound, Rec."Location Code", 39, 1, Rec."Purchase Order No.") then begin
                                                WhseReqstKey.Reset();
                                                WhseReqstKey.Init();
                                                WhseReqstKey.Type := "Warehouse Request Type"::Inbound;
                                                WhseReqstKey."Location Code" := Rec."Location Code";
                                                WhseReqstKey."Source Type" := 39;
                                                WhseReqstKey."Source Subtype" := 1;
                                                WhseReqstKey."Source No." := Rec."Purchase Order No.";
                                                WhseReqstKey."Source Document" := "Warehouse Request Source Document"::"Purchase Order";
                                                WhseReqstKey."BLTEC Customs Declaration No." := Rec."BLTEC Customs Declaration No.";
                                                WhseReqstKey."Destination Type" := "Warehouse Destination Type"::Vendor;
                                                if PurchHeader.Get("Purchase Document Type"::Order, Rec."Purchase Order No.") then begin
                                                    WhseReqstKey."Shipment Method Code" := PurchHeader."Shipment Method Code";
                                                    WhseReqstKey."Destination No." := PurchHeader."Buy-from Vendor No.";
                                                end;
                                                WhseReqstKey."Document Status" := 1;
                                                WhseReqstKey.Insert();
                                            end;
                                        end;
                                    end;
                                    if (Rec."ETD Supplier Date" <> 0D) OR (Rec."On Board Date" <> 0D) then begin
                                        if ImportPlan."Imported Available Date" <> Rec."Delivery Date" then begin
                                            ImportPlan."Imported Available Date" := Rec."Delivery Date";
                                            ImportPlan.Modify();
                                        end;
                                    end else begin
                                        ImportPlan."Imported Available Date" := 0D;
                                        ImportPlan.Modify();
                                    end;
                                until ImportPlan.Next() = 0;
                            end else begin
                                Clear(ImportPlan);
                                ImportPlan.Init();
                                ImportPlan."Source Document No." := Rec."Purchase Order No.";
                                ImportPlan."Source Line No." := Rec."Line No.";
                                ImportPlan."Line No." := 1;
                                ImportPlan."Vendor Account" := Rec."Vendor No.";
                                ImportPlan."Vendor Name" := Rec."Vendor Name";
                                ImportPlan."Item Number" := Rec."Item No.";
                                ImportPlan."Item Name" := Rec."Item Description";
                                ImportPlan.Quantity := Rec.Quantity;
                                ImportPlan."Location Code" := Rec."Location Code";
                                ImportPlan."Actual Location Code" := Rec."Location Code";
                                ImportPlan."Actual Received Quantity" := Rec.Quantity;
                                if (Rec."ETD Supplier Date" <> 0D) OR (Rec."On Board Date" <> 0D) then begin
                                    ImportPlan."Imported Available Date" := Rec."Delivery Date";
                                end else begin
                                    ImportPlan."Imported Available Date" := 0D;
                                end;
                                ImportPlan.Insert();
                                if Rec."Location Code" <> '' then begin
                                    if not WhseReqstKey.Get("Warehouse Request Type"::Inbound, Rec."Location Code", 39, 1, Rec."Purchase Order No.") then begin
                                        WhseReqstKey.Reset();
                                        WhseReqstKey.Init();
                                        WhseReqstKey.Type := "Warehouse Request Type"::Inbound;
                                        WhseReqstKey."Location Code" := Rec."Location Code";
                                        WhseReqstKey."Source Type" := 39;
                                        WhseReqstKey."Source Subtype" := 1;
                                        WhseReqstKey."Source No." := Rec."Purchase Order No.";
                                        WhseReqstKey."Source Document" := "Warehouse Request Source Document"::"Purchase Order";
                                        WhseReqstKey."BLTEC Customs Declaration No." := Rec."BLTEC Customs Declaration No.";
                                        WhseReqstKey."Destination Type" := "Warehouse Destination Type"::Vendor;
                                        if PurchHeader.Get("Purchase Document Type"::Order, Rec."Purchase Order No.") then begin
                                            WhseReqstKey."Shipment Method Code" := PurchHeader."Shipment Method Code";
                                            WhseReqstKey."Destination No." := PurchHeader."Buy-from Vendor No.";
                                        end;
                                        WhseReqstKey."Document Status" := 1;
                                        WhseReqstKey.Insert();
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            until Rec.Next() = 0;
        end;
    end;

    local procedure ImportPlanUpdate()
    var
        PurchTable: Query "ACC Import Entry Qry";
        Rec: Record "BLTEC Import Entry";
        PurchLine: Record "Purchase Line";
        ImportPlan: Record "ACC Import Plan Table";
        CustomsDelc: Record "BLTEC Customs Declaration";
        ContainerType: Record "BLTEC Container Type";
        PurchserTable: Record "Salesperson/Purchaser";
        Item: Record Item;
        WhseReqstKey: Record "Warehouse Request";
        PurchHeader: Record "Purchase Header";

        RecItem: Record Item;
        RecCusDecl: Record "BLTEC Customs Declaration";
        DELCContainerType: Record "BLTEC Container Type";
        DELCPurchserTable: Record "Salesperson/Purchaser";
        DELCPersonInCharge: Record "Salesperson/Purchaser";
        DELCServiceUnit: Record "BLTEC Service Unit";
        ForUpdated: Boolean;
    begin
        Rec.SetFilter("Process Status", '<>%1', 10);
        if Rec.FindSet() then begin
            repeat
                if PurchLine.Get(Enum::"Purchase Document Type"::Order, Rec."Purchase Order No.", Rec."Line No.") then begin
                    if PurchLine."VAT Bus. Posting Group" = 'OVERSEA' then begin
                    end else begin
                        ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                        ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                        if ImportPlan.FindSet() then begin
                            repeat
                                if ImportPlan."Vendor Account" <> Rec."Vendor No." then begin
                                    ImportPlan."Vendor Account" := Rec."Vendor No.";
                                    ImportPlan."Vendor Name" := Rec."Vendor Name";
                                    ImportPlan.Modify();
                                end;
                            until ImportPlan.Next() = 0;
                        end;
                    end;
                end;
            until Rec.Next() = 0;
        end;
    end;

    local procedure ImportDomestic()
    var
        PurchLine: Record "Purchase Line";
        Item: Record Item;
        ImportPlan: Record "ACC Import Plan Table";
        ImportEntry: Record "BLTEC Import Entry";
    begin
        ImportPlan.SetRange("BUS GROUP", 'DOMESTIC');
        if ImportPlan.FindSet() then begin
            repeat
                if ImportEntry.Get(ImportPlan."Source Document No.", ImportPlan."Source Line No.") then begin
                    if (ImportEntry."ETD Supplier Date" <> 0D) OR (ImportEntry."On Board Date" <> 0D) then begin
                        if ImportPlan."Imported Available Date" <> ImportEntry."Delivery Date" then begin
                            ImportPlan."Imported Available Date" := ImportEntry."Delivery Date";
                            ImportPlan.Modify();
                        end;
                    end else begin
                        ImportPlan."Imported Available Date" := 0D;
                        ImportPlan.Modify();
                    end;
                end;
            until ImportPlan.Next() = 0;
        end;
    end;
}
