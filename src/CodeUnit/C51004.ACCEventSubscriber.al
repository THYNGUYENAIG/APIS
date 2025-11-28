codeunit 51004 "ACC Event Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"BLACC Transport Information", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyTransportInfo(var Rec: Record "BLACC Transport Information")
    var
        ShipmentLine: Record "Sales Shipment Line";
        SalesShipment: Record "Sales Shipment Header";
        TransportInfo: Record "BLACC Transport Information";
        TruckNumberTxt: Text;
        TruckNumberTmp: Text;
    begin
        /*
        if Rec."Truck Number" <> '' then begin
            if Rec."BLACC Source Document" = Enum::"Warehouse Activity Source Document"::"Sales Order" then begin
                TransportInfo.SetRange("BLACC Source No.", Rec."BLACC Source No.");
                TransportInfo.SetRange("BLACC Source Line No.", Rec."BLACC Source Line No.");
                TransportInfo.SetRange("BLACC Source Document", Rec."BLACC Source Document");
                if TransportInfo.FindSet() then
                    repeat
                        if TruckNumberTxt <> '' then begin
                            TruckNumberTxt := TransportInfo."Truck Number";
                        end else begin
                            if TruckNumberTmp <> TransportInfo."Truck Number" then
                                TruckNumberTxt := '|' + TransportInfo."Truck Number";
                        end;
                        TruckNumberTmp := TransportInfo."Truck Number";
                    until TransportInfo.Next() = 0;
                ShipmentLine.SetRange("Order No.", Rec."BLACC Source No.");
                ShipmentLine.SetRange("Order Line No.", Rec."BLACC Source Line No.");
                if ShipmentLine.FindFirst() then begin
                    SalesShipment.SetCurrentKey("No.");
                    if SalesShipment.Get(ShipmentLine."Document No.") then begin
                        SalesShipment."Truck Number" := TruckNumberTxt;
                        SalesShipment.Modify();
                    end;
                end;
            end;
        end;
        */
    end;

    [EventSubscriber(ObjectType::Table, Database::"BLACC Transport Information", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteTransportInfo(var Rec: Record "BLACC Transport Information")
    var
        ShipmentLine: Record "Sales Shipment Line";
        SalesShipment: Record "Sales Shipment Header";
        TransportInfo: Record "BLACC Transport Information";
        TruckNumberTxt: Text;
        TruckNumberTmp: Text;
    begin
        /*
        if Rec."Truck Number" <> '' then begin
            if Rec."BLACC Source Document" = Enum::"Warehouse Activity Source Document"::"Sales Order" then begin
                TransportInfo.SetRange("BLACC Source No.", Rec."BLACC Source No.");
                TransportInfo.SetRange("BLACC Source Line No.", Rec."BLACC Source Line No.");
                TransportInfo.SetRange("BLACC Source Document", Rec."BLACC Source Document");
                if TransportInfo.FindSet() then
                    repeat
                        if TruckNumberTxt <> '' then begin
                            TruckNumberTxt := TransportInfo."Truck Number";
                        end else begin
                            if TruckNumberTmp <> TransportInfo."Truck Number" then
                                TruckNumberTxt := '|' + TransportInfo."Truck Number";
                        end;
                        TruckNumberTmp := TransportInfo."Truck Number";
                    until TransportInfo.Next() = 0;
                ShipmentLine.SetRange("Order No.", Rec."BLACC Source No.");
                ShipmentLine.SetRange("Order Line No.", Rec."BLACC Source Line No.");
                if ShipmentLine.FindFirst() then begin
                    SalesShipment.SetCurrentKey("No.");
                    if SalesShipment.Get(ShipmentLine."Document No.") then begin
                        SalesShipment."Truck Number" := TruckNumberTxt;
                        SalesShipment.Modify();
                    end;
                end;
            end;
        end;
        */
    end;

    [EventSubscriber(ObjectType::Table, Database::"BLTEC Import Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertImportEntry(var Rec: Record "BLTEC Import Entry")
    var
        PurchLine: Record "Purchase Line";
        ImportPlan: Record "ACC Import Plan Table";
        CustomsDelc: Record "BLTEC Customs Declaration";
        ContainerType: Record "BLTEC Container Type";
        PurchserTable: Record "Salesperson/Purchaser";
        Item: Record Item;
        ItemCertificate: Record "BLACC Item Certificate";
    begin
        if PurchLine.Get(Enum::"Purchase Document Type"::Order, Rec."Purchase Order No.", Rec."Line No.") then begin
            if Rec."BLTEC Customs Declaration No." <> '' then begin
                ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                if ImportPlan.FindSet() then begin
                    repeat
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

                        if (Rec."Actual ETA Date" <> 0D) AND (ImportPlan."Actual Arrival Date" = 0D) then begin
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
                        end;
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
                    ImportPlan."Location Code" := Rec."Location Code";
                    ImportPlan."Copy Docs Date" := Rec."BLACC Copy Docs Date";
                    if Rec."Actual ETA Date" <> 0D then begin
                        ImportPlan."Actual Arrival Date" := Rec."Actual ETA Date";
                        if ImportPlan."Copy Docs Date" > ImportPlan."Actual Arrival Date" then begin
                            ImportPlan."Imported Available Date" := ImportPlan."Copy Docs Date" + 2;
                            ImportPlan."Import Reason" := Enum::"ACC Import Reason Type"::"Waiting for Documents";
                        end else begin
                            ImportPlan."Imported Available Date" := ImportPlan."Actual Arrival Date" + 2;
                        end;
                    end;
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

                    ImportPlan.Insert();
                end;
            end else begin
                ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                if ImportPlan.FindSet() then begin
                    repeat
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
                    ImportPlan."Branch Code" := Rec."Shortcut Dimension 1 Code";
                    ImportPlan."Location Code" := Rec."Location Code";
                    ImportPlan."Actual Location Code" := Rec."Location Code";
                    ImportPlan."Actual Received Quantity" := Rec.Quantity;
                    if (Rec."ETD Supplier Date" <> 0D) OR (Rec."On Board Date" <> 0D) then begin
                        ImportPlan."Imported Available Date" := Rec."Delivery Date";
                    end else begin
                        ImportPlan."Imported Available Date" := 0D;
                    end;
                    ImportPlan.Insert();
                end;
            end;
        end;

        ItemCertificate.Reset();
        ItemCertificate.SetCurrentKey("Expiration Date");
        ItemCertificate.SetAscending("Expiration Date", false);
        ItemCertificate.SetRange("Item No.", Rec."Item No.");
        ItemCertificate.SetRange("Quality Group", "ACC Quality Group"::CBCL);
        ItemCertificate.SetRange(Outdated, false);
        if ItemCertificate.FindFirst() then begin
            Rec."Registration No." := ItemCertificate."No.";
            Rec."Registration Date" := ItemCertificate."Published Date";
            Rec."Reg. Expire Date" := ItemCertificate."Expiration Date";
            Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"BLTEC Import Entry", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyImportEntry(var Rec: Record "BLTEC Import Entry"; var xRec: Record "BLTEC Import Entry")
    var
        PurchLine: Record "Purchase Line";
        ImportPlan: Record "ACC Import Plan Table";
        CustomsDelc: Record "BLTEC Customs Declaration";
        ContainerType: Record "BLTEC Container Type";
        PurchserTable: Record "Salesperson/Purchaser";
        PersonInCharge: Record "Salesperson/Purchaser";
        ServiceUnit: Record "BLTEC Service Unit";
        Item: Record Item;

        WhseReqstKey: Record "Warehouse Request";
        PurchHeader: Record "Purchase Header";
    begin
        if PurchLine.Get(Enum::"Purchase Document Type"::Order, Rec."Purchase Order No.", Rec."Line No.") then begin
            if Rec."BLTEC Customs Declaration No." <> '' then begin
                if (Rec."Process Status" = "BLTEC Import Process Status"::Finished) OR (Rec."Process Status" = "BLTEC Import Process Status"::Cancel) then
                    exit;
                ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                if ImportPlan.FindSet() then begin
                    repeat
                        if ImportPlan."Declaration No." <> Rec."BLTEC Customs Declaration No." then begin
                            ImportPlan."Declaration No." := Rec."BLTEC Customs Declaration No.";
                            ImportPlan."Declaration Date" := Rec."Customs Declaration Date";
                            ImportPlan."Bill No." := Rec."BL No.";
                            ImportPlan."Location Code" := Rec."Location Code";
                            ImportPlan.Quantity := Rec.Quantity;
                            ImportPlan.Modify();
                        end;
                        CustomsDelc.SetRange("BLTEC Customs Declaration No.", Rec."BLTEC Customs Declaration No.");
                        if CustomsDelc.FindFirst() then begin
                            if ImportPlan."Document No." <> CustomsDelc."Document No." then begin
                                ImportPlan."Document No." := CustomsDelc."Document No.";
                                ImportPlan."Bill No." := CustomsDelc."BL No.";
                                ImportPlan.Modify();
                            end;
                            if ContainerType.Get(CustomsDelc."BLTEC Container Type") then begin
                                if ImportPlan."Cont. Type" <> ContainerType."BLTEC Code" then begin
                                    ImportPlan."Cont. Type" := ContainerType."BLTEC Code";
                                    ImportPlan."Product Type" := ContainerType."BLTEC Product Type";
                                    ImportPlan."Cont. 20" := ContainerType."BLTEC Cont. 20 Qty";
                                    ImportPlan."Cont. 40" := ContainerType."BLTEC Cont. 40 Qty";
                                    ImportPlan."Cont. 45" := ContainerType."BLTEC Cont. 45 Qty";
                                    ImportPlan."Cont. Quantity" := ContainerType."BLTEC Quantity";
                                    ImportPlan.Modify();
                                end;
                            end;
                        end;
                        if (Rec."BLACC Copy Docs Date" <> 0D) AND (xRec."BLACC Copy Docs Date" <> Rec."BLACC Copy Docs Date") then begin
                            ImportPlan."Copy Docs Date" := Rec."BLACC Copy Docs Date";
                            if ImportPlan."Copy Docs Date" > ImportPlan."Actual Arrival Date" then begin
                                ImportPlan."Imported Available Date" := ImportPlan."Copy Docs Date" + 2;
                                ImportPlan."Import Reason" := Enum::"ACC Import Reason Type"::"Waiting for Documents";
                            end else begin
                                ImportPlan."Imported Available Date" := ImportPlan."Actual Arrival Date" + 2;
                            end;
                            ImportPlan.Modify();
                        end;
                        if (Rec."Actual ETA Date" <> 0D) AND (xRec."Actual ETA Date" <> Rec."Actual ETA Date") then begin
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
                    ImportPlan."Declaration No." := Rec."BLTEC Customs Declaration No.";
                    ImportPlan."Declaration Date" := Rec."Customs Declaration Date";
                    ImportPlan."Bill No." := Rec."BL No.";
                    ImportPlan."Location Code" := Rec."Location Code";
                    ImportPlan."Copy Docs Date" := Rec."BLACC Copy Docs Date";
                    if Rec."Actual ETA Date" <> 0D then begin
                        ImportPlan."Actual Arrival Date" := Rec."Actual ETA Date";
                        if ImportPlan."Copy Docs Date" > ImportPlan."Actual Arrival Date" then begin
                            ImportPlan."Imported Available Date" := ImportPlan."Copy Docs Date" + 2;
                            ImportPlan."Import Reason" := Enum::"ACC Import Reason Type"::"Waiting for Documents";
                        end else begin
                            ImportPlan."Imported Available Date" := ImportPlan."Actual Arrival Date" + 2;
                        end;
                    end;
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
                    ImportPlan.Insert();
                end;
            end else begin
                if PurchLine."Outstanding Quantity" > 0 then begin
                    ImportPlan.SetRange("Source Document No.", Rec."Purchase Order No.");
                    ImportPlan.SetRange("Source Line No.", Rec."Line No.");
                    if ImportPlan.FindSet() then begin
                        repeat
                            if xRec.Quantity <> Rec.Quantity then begin
                                ImportPlan.Quantity := Rec.Quantity;
                                ImportPlan."Actual Received Quantity" := Rec.Quantity;
                                ImportPlan.Modify();
                            end;
                            if xRec."Location Code" <> Rec."Location Code" then begin
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
                            if xRec."Delivery Date" <> Rec."Delivery Date" then begin
                                if (Rec."ETD Supplier Date" <> 0D) OR (Rec."On Board Date" <> 0D) then begin
                                    if ImportPlan."Imported Available Date" <> Rec."Delivery Date" then begin
                                        ImportPlan."Imported Available Date" := Rec."Delivery Date";
                                        ImportPlan.Modify();
                                    end;
                                end else begin
                                    ImportPlan."Imported Available Date" := 0D;
                                    ImportPlan.Modify();
                                end;
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
    end;

    [EventSubscriber(ObjectType::Table, Database::"BLTEC Customs Declaration", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyCustomsDecl(var Rec: Record "BLTEC Customs Declaration")
    var
        ImportPlan: Record "ACC Import Plan Table";
        ContainerType: Record "BLTEC Container Type";
        PurchserTable: Record "Salesperson/Purchaser";
        PersonInCharge: Record "Salesperson/Purchaser";
        ServiceUnit: Record "BLTEC Service Unit";
        ForUpdated: Boolean;
    begin
        if Rec."Declaration Date" = 0D then
            exit;
        if Rec."BLTEC Customs Declaration No." <> '' then begin
            ImportPlan.SetRange("Declaration No.", Rec."BLTEC Customs Declaration No.");
            if ImportPlan.FindSet() then begin
                repeat
                    ForUpdated := false;
                    if ImportPlan."Declaration Date" <> Rec."Declaration Date" then begin
                        ForUpdated := true;
                        ImportPlan."Declaration Date" := Rec."Declaration Date";
                    end;
                    if ImportPlan."Cont. Type" <> Rec."BLTEC Container Type" then begin
                        ForUpdated := true;
                        if ContainerType.Get(Rec."BLTEC Container Type") then begin
                            ImportPlan."Cont. Type" := ContainerType."BLTEC Code";
                            ImportPlan."Product Type" := ContainerType."BLTEC Product Type";
                            ImportPlan."Cont. 20" := ContainerType."BLTEC Cont. 20 Qty";
                            ImportPlan."Cont. 40" := ContainerType."BLTEC Cont. 40 Qty";
                            ImportPlan."Cont. 45" := ContainerType."BLTEC Cont. 45 Qty";
                        end;
                    end;

                    if ImportPlan."Bill No." <> Rec."BL No." then begin
                        ImportPlan."Bill No." := Rec."BL No.";
                    end;
                    if ForUpdated then
                        ImportPlan.Modify();
                until ImportPlan.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"ACC Import Plan Table", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyImportPlan(var Rec: Record "ACC Import Plan Table"; var xRec: Record "ACC Import Plan Table")
    var
        BCHelper: Codeunit "BC Helper";
        PurchDelivery: Query "ACC Delivery Import Plan Qry";
        PurchLocation: Query "ACC Purchase Import Plan Qry";
        WhseLocation: Query "ACC Import Plan Location Qry";

        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        ImportEntry: Record "BLTEC Import Entry";
        WhseReqst: Record "Warehouse Request";
        WhseReqstKey: Record "Warehouse Request";

        LocationCreatedList: List of [Text];
        LocationUpdatedList: List of [Text];

        LocationCreated: Code[20];
        LocationUpdated: Code[20];

        iCreated: Integer;
        i: Integer;
        j: Integer;

        forCreated: Boolean;
        CondFilter: Text;
    begin
        if xRec."Delivery Date" <> Rec."Delivery Date" then begin
            PurchDelivery.SetFilter(SourceDocumentNo, Rec."Source Document No.");
            PurchDelivery.SetFilter(SourceLineNo, Format(Rec."Source Line No."));
            if PurchDelivery.Open() then begin
                while PurchDelivery.Read() do begin
                    if PurchLine.Get(Enum::"Purchase Document Type"::Order, Rec."Source Document No.", Rec."Source Line No.") then begin
                        PurchLine."Expected Receipt Date" := PurchDelivery.DeliveryDate;
                        PurchLine.Modify();
                    end;
                    break;
                end;
            end;
        end;

        if (xRec."Actual Location Code" <> Rec."Actual Location Code") then begin
            if BCHelper.GetLocationImportPlan(Rec."Source Document No.", Rec."Source Line No.") = 1 then begin
                PurchLocation.SetFilter(SourceDocumentNo, Rec."Source Document No.");
                PurchLocation.SetFilter(SourceLineNo, Format(Rec."Source Line No."));
                PurchLocation.SetFilter(ActualLocationCode, '<>%1', '');
                if PurchLocation.Open() then begin
                    while PurchLocation.Read() do begin
                        PurchLine.SetAutoCalcFields("BLACC Status");
                        if PurchLine.Get(Enum::"Purchase Document Type"::Order, Rec."Source Document No.", Rec."Source Line No.") then begin
                            if PurchLine.Quantity = 0 then
                                exit;
                            if PurchLine.Quantity <> PurchLine."Outstanding Quantity" then
                                exit;
                            if CopyStr(PurchLine."Location Code", 1, 1) <> CopyStr(PurchLocation.ActualLocationCode, 1, 1) then begin
                                if PurchLine."BLACC Status" = "Purchase Document Status"::Released then begin
                                    PurchLine."Location Code" := PurchLocation.ActualLocationCode;
                                    //PurchLine.Validate("Location Code", PurchLocation.ActualLocationCode);
                                    PurchLine.Modify();
                                end else begin
                                    Error(StrSubstNo('Anh chị muốn cập nhật khác Site thì qua lại chỉnh PO Line.'));
                                end;
                            end else begin
                                PurchLine."Location Code" := PurchLocation.ActualLocationCode;
                                PurchLine.Modify();
                            end;
                        end;
                    end;
                    PurchLocation.Close();
                end;
            end;

            WhseLocation.SetFilter(SourceDocumentNo, Rec."Source Document No.");
            if WhseLocation.Open() then begin
                while WhseLocation.Read() do begin
                    if not WhseReqstKey.Get("Warehouse Request Type"::Inbound, WhseLocation.ActualLocationCode, 39, 1, Rec."Source Document No.") then begin
                        LocationCreatedList.Add(WhseLocation.ActualLocationCode);
                    end else begin
                        LocationUpdatedList.Add(WhseLocation.ActualLocationCode);
                    end;
                end;
                WhseLocation.Close();
            end;

            if LocationCreatedList.Count() = 0 then
                exit;
            for i := 1 to LocationCreatedList.Count() do begin
                LocationCreated := LocationCreatedList.Get(i);

                if i = 1 then begin
                    if LocationUpdatedList.Count = 0 then begin
                        CondFilter := '<>' + LocationCreated;
                    end else begin
                        CondFilter := '<>' + LocationCreated;
                        for j := 1 to LocationUpdatedList.Count() do begin
                            LocationUpdated := LocationUpdatedList.Get(j);
                            CondFilter := CondFilter + '&<>' + LocationUpdated;
                        end;
                    end;
                end else begin
                    CondFilter := CondFilter + '&<>' + LocationCreated;
                end;

                forCreated := true;
                WhseReqst.Reset();
                WhseReqst.SetRange(Type, "Warehouse Request Type"::Inbound);
                WhseReqst.SetRange("Source Type", 39);
                WhseReqst.SetRange("Source Subtype", 1);
                WhseReqst.SetRange("Source No.", Rec."Source Document No.");
                WhseReqst.SetRange("Completely Handled", false);
                WhseReqst.SetFilter("Location Code", CondFilter);
                if WhseReqst.FindFirst() then begin
                    repeat
                        forCreated := false;
                        if not WhseReqstKey.Get(WhseReqst.Type, LocationCreated, WhseReqst."Source Type", WhseReqst."Source Subtype", WhseReqst."Source No.") then begin
                            if WhseReqstKey.Get(WhseReqst.Type, WhseReqst."Location Code", WhseReqst."Source Type", WhseReqst."Source Subtype", WhseReqst."Source No.") then begin
                                if Rec."BUS GROUP" = 'OVERSEA' then begin
                                    if Rec."Declaration No." <> '' then begin
                                        WhseReqstKey."BLTEC Customs Declaration No." := Rec."Declaration No.";
                                        WhseReqstKey.Modify();
                                    end else begin
                                        ImportEntry.Reset();
                                        ImportEntry.SetRange("Purchase Order No.", Rec."Source Document No.");
                                        ImportEntry.SetRange("Line No.", Rec."Source Line No.");
                                        if ImportEntry.FindFirst() then begin
                                            WhseReqstKey."BLTEC Customs Declaration No." := ImportEntry."BLTEC Customs Declaration No.";
                                            WhseReqstKey.Modify();
                                        end;
                                    end;
                                end;
                                WhseReqstKey.Rename(WhseReqst.Type, LocationCreated, WhseReqst."Source Type", WhseReqst."Source Subtype", WhseReqst."Source No.");
                            end;
                        end;
                    until WhseReqst.Next() = 0;
                end;

                if forCreated = true then begin
                    if not WhseReqstKey.Get("Warehouse Request Type"::Inbound, LocationCreated, 39, 1, Rec."Source Document No.") then begin
                        WhseReqstKey.Reset();
                        WhseReqstKey.Init();
                        WhseReqstKey.Type := "Warehouse Request Type"::Inbound;
                        WhseReqstKey."Location Code" := LocationCreated;
                        WhseReqstKey."Source Type" := 39;
                        WhseReqstKey."Source Subtype" := 1;
                        WhseReqstKey."Source No." := Rec."Source Document No.";
                        WhseReqstKey."Source Document" := "Warehouse Request Source Document"::"Purchase Order";
                        if Rec."BUS GROUP" = 'OVERSEA' then begin
                            if Rec."Declaration No." <> '' then begin
                                WhseReqstKey."BLTEC Customs Declaration No." := Rec."Declaration No.";
                            end else begin
                                ImportEntry.Reset();
                                ImportEntry.SetRange("Purchase Order No.", Rec."Source Document No.");
                                ImportEntry.SetRange("Line No.", Rec."Source Line No.");
                                if ImportEntry.FindFirst() then
                                    WhseReqstKey."BLTEC Customs Declaration No." := ImportEntry."BLTEC Customs Declaration No.";
                            end;
                        end;
                        WhseReqstKey."Destination Type" := "Warehouse Destination Type"::Vendor;
                        if PurchHeader.Get("Purchase Document Type"::Order, Rec."Source Document No.") then begin
                            WhseReqstKey."Shipment Method Code" := PurchHeader."Shipment Method Code";
                            WhseReqstKey."Destination No." := PurchHeader."Buy-from Vendor No.";
                        end;
                        WhseReqstKey."Document Status" := 1;
                        WhseReqstKey.Insert();
                    end;
                end;
            end;
        end;
        WhseReqst.Reset();
        WhseReqst.SetRange(Type, "Warehouse Request Type"::Inbound);
        WhseReqst.SetRange("Source Type", 39);
        WhseReqst.SetRange("Source Subtype", 1);
        WhseReqst.SetRange("Source No.", Rec."Source Document No.");
        WhseReqst.SetRange("Location Code", Rec."Actual Location Code");
        WhseReqst.SetRange("Shipping Advice", "Sales Header Shipping Advice"::Partial);
        WhseReqst.SetRange("Completely Handled", true);
        if WhseReqst.FindFirst() then begin
            if Rec."BUS GROUP" = 'OVERSEA' then begin
                if WhseReqst."BLTEC Customs Declaration No." = '' then begin
                    ImportEntry.Reset();
                    ImportEntry.SetRange("Purchase Order No.", Rec."Source Document No.");
                    ImportEntry.SetRange("Line No.", Rec."Source Line No.");
                    if ImportEntry.FindFirst() then
                        WhseReqst."BLTEC Customs Declaration No." := ImportEntry."BLTEC Customs Declaration No.";
                end;
            end;
            WhseReqst."Completely Handled" := false;
            WhseReqst.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"ACC Import Plan Table", 'OnBeforeDeleteEvent', '', true, true)]
    local procedure OnBeforeDeleteImportPlan(var Rec: Record "ACC Import Plan Table")
    var

    begin
        if Rec."Line No." = 1 then begin
            Error(StrSubstNo('PO gốc không được xóa nhé.'));
            exit;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"ACC Sharepoint Attachment", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteSPAttachment(var Rec: Record "ACC Sharepoint Attachment")
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('ATTACHDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('ATTACHDOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODeleteFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"BLACC CD Certificate Files", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteCDCertificate(var Rec: Record "BLACC CD Certificate Files")
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        /*
        if SharepointConnector.Get('CUSTOMSDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('CUSTOMSDOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODeleteFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.");
        */
    end;

    [EventSubscriber(ObjectType::Table, Database::"BLACC Item Certificate", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteItemCertificate(var Rec: Record "BLACC Item Certificate")
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if Rec."File No." = '' then
            exit;
        if Rec."Is Synchronize" then
            exit;
        if SharepointConnector.Get('ITEMDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('ITEMDOC', 1) then begin
            exit;
        end;
        BCHelper.SPODeleteFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"ACC DMS Library", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteDMSLibrary(var Rec: Record "ACC DMS Library")
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('DMSDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('DMSDOC', 1) then begin
            exit;
        end;
        if Rec."File No" <> '' then
            BCHelper.SPODeleteFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No");
    end;

    [EventSubscriber(ObjectType::Table, Database::"ACC DMS Library", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyDMSLibrary(var Rec: Record "ACC DMS Library"; var xRec: Record "ACC DMS Library")
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
        FieldObject: JsonObject;
        JsonText: Text;
    begin
        if Rec."Out Date" <> xRec."Out Date" then begin
            if SharepointConnector.Get('DMSDOC') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SharepointConnectorLine.Get('DMSDOC', 1) then begin
                exit;
            end;
            Clear(FieldObject);
            FieldObject.Add('Obsolete', Rec."Out Date");
            JsonText := Format(FieldObject);
            BCHelper.UpdateMetadata(OauthenToken, JsonText, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"AIG Transfer Document", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteTransferDocument(var Rec: Record "AIG Transfer Document")
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('TODOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('TODOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODeleteFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertShipmentHeader(var Rec: Record "Warehouse Shipment Line")
    var
        recWS: Record "Warehouse Shipment Header";
        recSH: Record "Sales Header";
        recPH: Record "Purchase Header";
    begin
        if recWS.Get(Rec."No.") then begin
            if recWS."ACC Source No." = '' then begin
                case Rec."Source Document" of
                    "Warehouse Activity Source Document"::"Sales Order":
                        begin
                            recSH.Reset();
                            recSH.SetRange("No.", Rec."Source No.");
                            if recSH.FindFirst() then begin
                                recWS."ACC Source No." := Rec."Source No.";
                                recWS."ACC Requested Delivery Date" := recSH."Requested Delivery Date";
                                recWS."ACC Customer No" := recSH."Sell-to Customer No.";
                                recWS."ACC Customer Name" := recSH."Sell-to Customer Name";
                                recWS."ACC Delivery Address" := recSH."Ship-to Address" + ' ' + recSH."Ship-to Address 2";
                                recWS."ACC Delivery Note" := recSH."BLACC Delivery Note";
                                recWS.Modify();
                            end;
                        end;
                    "Warehouse Activity Source Document"::"Purchase Return Order":
                        begin
                            recPH.Reset();
                            recPH.SetRange("No.", Rec."Source No.");
                            if recPH.FindFirst() then begin
                                recWS."ACC Source No." := Rec."Source No.";
                                recWS."ACC Requested Delivery Date" := recPH."Requested Receipt Date";
                                recWS."ACC Customer No" := recPH."Buy-from Vendor No.";
                                recWS."ACC Customer Name" := recPH."Buy-from Vendor Name";
                                recWS."ACC Delivery Address" := recPH."Ship-to Address" + ' ' + recPH."Ship-to Address 2";
                                recWS.Modify();
                            end;
                        end;
                    else begin
                        recWS."ACC Source No." := Rec."Source No.";
                        recWS.Modify();
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertSalesHeader(var Rec: Record "Sales Header")
    var
        recSalesHeader: Record "Sales Header";
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Quote:
                begin
                    Rec."ACC SQ Created By" := UserId();
                    Rec."ACC SQ Created At" := Rec.SystemCreatedAt;
                end;
            Rec."Document Type"::Order, Rec."Document Type"::Invoice, Rec."Document Type"::"Return Order", Rec."Document Type"::"Credit Memo":
                begin
                    Rec."ACC SO Created By" := UserId();
                    Rec."ACC SO Created At" := Rec.SystemCreatedAt;
                end;
            Rec."Document Type"::"BLACC Agreement":
                begin
                    Rec."ACC SA Created By" := UserId();
                    Rec."ACC SA Created At" := Rec.SystemCreatedAt;
                end;
        end;

        Rec.Modify();
    end;
}
