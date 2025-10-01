codeunit 51991 "AIG Mult. Whse. Shipments Mgt"
{
    procedure CreateMultipleShipmentsBySalesOrder(SalesNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ShipmentHeader: Record "Warehouse Shipment Header";
        indexLoc: Integer;
        indexTax: Integer;
        LocationList: List of [Text];
        LocationCode: Code[20];
        TaxList: List of [Text];
        TaxGroup: Code[20];
        MsgLabel: Label 'Successfully created %1 warehouse shipment(s) for sales order %2.\';
        MsgText: Text;
    begin
        if not SalesHeader.Get("Sales Document Type"::Order, SalesNo) then
            exit;
        if SalesHeader.Status <> "Sales Document Status"::Released then
            exit;
        LocationList := WarehouseShipmentByLocation(SalesHeader);
        TaxList := WarehouseShipmentByTax(SalesHeader);
        for indexLoc := 1 to LocationList.Count do begin
            LocationCode := LocationList.Get(indexLoc);
            CreateWarehouseRequest(SalesHeader, LocationCode);
            for indexTax := 1 to TaxList.Count do begin
                TaxGroup := TaxList.Get(indexTax);
                if TaxLocation(SalesHeader, LocationCode, TaxGroup) then begin
                    ShipmentHeader := CreateWarehouseShipmentHeader(SalesHeader, LocationCode);
                    CreateWarehouseShipmentLines(SalesHeader, ShipmentHeader, LocationCode, TaxGroup);
                    if MsgText = '' then begin
                        MsgText := StrSubstNo(MsgLabel, ShipmentHeader."No.", SalesHeader."No.");
                    end else
                        MsgText += StrSubstNo(MsgLabel, ShipmentHeader."No.", SalesHeader."No.");

                end;
            end;
        end;
        if MsgText <> '' then
            Message(MsgText);
    end;

    local procedure CreateWarehouseRequest(var SalesHeader: Record "Sales Header"; LocationCode: Code[20])
    var
        SalesLine: Record "Sales Line";
        WhseRequest: Record "Warehouse Request";
        Location: Record Location;
    begin
        if not Location.Get(LocationCode) then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Location Code", LocationCode);
        SalesLine.SetFilter("Outstanding Quantity", '>0');
        if not SalesLine.FindFirst() then
            exit;

        WhseRequest.Reset();
        WhseRequest.SetRange("Source Type", Database::"Sales Line");
        WhseRequest.SetRange("Source No.", SalesHeader."No.");
        WhseRequest.SetRange("Location Code", LocationCode);
        if WhseRequest.FindFirst() then
            WhseRequest.Delete();

        WhseRequest.Init();
        WhseRequest."Source Type" := Database::"Sales Line";
        WhseRequest."Source Subtype" := 1;
        WhseRequest."Source No." := SalesLine."Document No.";
        WhseRequest."Source Document" := "Warehouse Request Source Document"::"Sales Order";
        WhseRequest."Document Status" := WhseRequest."Document Status"::Released;
        WhseRequest.Type := WhseRequest.Type::Outbound;
        WhseRequest."Location Code" := SalesLine."Location Code";
        WhseRequest."Shipment Date" := SalesLine."Shipment Date";
        WhseRequest."Shipping Advice" := "Sales Header Shipping Advice"::Partial;
        WhseRequest."Destination Type" := "Warehouse Destination Type"::Customer;
        WhseRequest."Destination No." := SalesLine."Sell-to Customer No.";
        WhseRequest."External Document No." := SalesLine."BLACC Agreement No.";
        WhseRequest.Insert();
    end;

    local procedure CreateWarehouseShipmentHeader(var SalesHeader: Record "Sales Header"; LocationCode: Code[20]): Record "Warehouse Shipment Header"
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WarehouseSetup: Record "Warehouse Setup";
    begin
        WarehouseSetup.Get();

        WarehouseShipmentHeader.Init();
        WarehouseShipmentHeader."No." := NoSeriesMgt.GetNextNo(WarehouseSetup."Whse. Ship Nos.", WorkDate(), true);
        WarehouseShipmentHeader."Location Code" := LocationCode;
        WarehouseShipmentHeader."Assigned User ID" := UserId;
        WarehouseShipmentHeader."Assignment Date" := Today;
        WarehouseShipmentHeader."Assignment Time" := Time;
        WarehouseShipmentHeader."Posting Date" := SalesHeader."Shipment Date";
        WarehouseShipmentHeader."External Document No." := SalesHeader."External Document No.";
        WarehouseShipmentHeader."Zone Code" := 'SHIP';
        WarehouseShipmentHeader."Bin Code" := 'SHIP';
        WarehouseShipmentHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
        WarehouseShipmentHeader."Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
        WarehouseShipmentHeader."Shipment Method Code" := SalesHeader."Shipment Method Code";
        WarehouseShipmentHeader."No. Series" := WarehouseSetup."Whse. Ship Nos.";
        WarehouseShipmentHeader.Insert(true);
        exit(WarehouseShipmentHeader);
    end;

    local procedure CreateWarehouseShipmentLines(var SalesHeader: Record "Sales Header"; ShipmentHeader: Record "Warehouse Shipment Header"; LocationCode: Code[20]; TaxGroup: Code[20])
    var
        SalesLine: Record "Sales Line";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        LineNo: Integer;
    begin
        // Get the last line number for this shipment
        WarehouseShipmentLine.SetRange("No.", ShipmentHeader."No.");
        if WarehouseShipmentLine.FindLast() then
            LineNo := WarehouseShipmentLine."Line No."
        else
            LineNo := 0;

        // Create shipment lines for this location
        SalesLine.Reset();
        SalesLine.SetCurrentKey("Line No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Location Code", LocationCode);
        SalesLine.SetRange("VAT Prod. Posting Group", TaxGroup);
        SalesLine.SetFilter("Outstanding Quantity", '>0');
        if SalesLine.FindSet() then
            repeat
                LineNo += 10000;
                WarehouseShipmentLine.Init();
                WarehouseShipmentLine."No." := ShipmentHeader."No.";
                WarehouseShipmentLine."Line No." := LineNo;
                WarehouseShipmentLine."Source Type" := Database::"Sales Line";
                WarehouseShipmentLine."Source Subtype" := 1;
                WarehouseShipmentLine."Source No." := SalesLine."Document No.";
                WarehouseShipmentLine."Source Line No." := SalesLine."Line No.";
                WarehouseShipmentLine."Source Document" := WarehouseShipmentLine."Source Document"::"Sales Order";
                WarehouseShipmentLine."Location Code" := SalesLine."Location Code";
                WarehouseShipmentLine."Bin Code" := ShipmentHeader."Bin Code";
                WarehouseShipmentLine."Zone Code" := ShipmentHeader."Zone Code";
                WarehouseShipmentLine."Item No." := SalesLine."No.";
                WarehouseShipmentLine."Variant Code" := SalesLine."Variant Code";
                WarehouseShipmentLine.Description := SalesLine.Description;
                WarehouseShipmentLine."Description 2" := SalesLine."Description 2";
                WarehouseShipmentLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                WarehouseShipmentLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
                WarehouseShipmentLine.Quantity := SalesLine."Outstanding Quantity";
                WarehouseShipmentLine."Qty. (Base)" := SalesLine."Outstanding Qty. (Base)";
                WarehouseShipmentLine."Qty. Outstanding" := SalesLine."Outstanding Quantity";
                WarehouseShipmentLine."Qty. Outstanding (Base)" := SalesLine."Outstanding Qty. (Base)";
                WarehouseShipmentLine."Due Date" := SalesLine."Shipment Date";
                WarehouseShipmentLine."Shipment Date" := SalesLine."Shipment Date";
                WarehouseShipmentLine."Destination No." := SalesLine."Sell-to Customer No.";
                WarehouseShipmentLine."Destination Type" := "Warehouse Destination Type"::Customer;
                WarehouseShipmentLine.Insert();
            until SalesLine.Next() = 0;
    end;

    local procedure WarehouseShipmentByTax(var SalesHeader: Record "Sales Header") TaxList: List of [Text]
    var
        SalesLine: Record "Sales Line";
        VATProdPosting: Code[20];
    begin
        SalesLine.Reset();
        SalesLine.SetCurrentKey("VAT Prod. Posting Group");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                if VATProdPosting <> SalesLine."VAT Prod. Posting Group" then begin
                    TaxList.Add(SalesLine."VAT Prod. Posting Group");
                end;
                VATProdPosting := SalesLine."VAT Prod. Posting Group";
            until SalesLine.Next() = 0;
    end;

    local procedure WarehouseShipmentByLocation(var SalesHeader: Record "Sales Header") LocationList: List of [Text]
    var
        SalesLine: Record "Sales Line";
        LocationCode: Code[20];
    begin
        SalesLine.Reset();
        SalesLine.SetCurrentKey("Location Code");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Location Code", '<>%1', '');
        if SalesLine.FindSet() then
            repeat
                if LocationCode <> SalesLine."Location Code" then begin
                    LocationList.Add(SalesLine."Location Code");
                end;
                LocationCode := SalesLine."Location Code";
            until SalesLine.Next() = 0;
    end;

    local procedure TaxLocation(var SalesHeader: Record "Sales Header"; LocationCode: Code[20]; VATProdPostingGroup: Code[20]): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetCurrentKey("Location Code");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Location Code", LocationCode);
        SalesLine.SetRange("VAT Prod. Posting Group", VATProdPostingGroup);
        SalesLine.SetFilter("Outstanding Quantity", '>0');
        if SalesLine.FindFirst() then
            exit(true);
        exit(false);
    end;
}
