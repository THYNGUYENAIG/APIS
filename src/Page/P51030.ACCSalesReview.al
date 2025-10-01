page 51030 "ACC Sales Review"
{
    ApplicationArea = All;
    Caption = 'ACC Sales Review';
    PageType = List;
    SourceTable = "ACC Sales Review";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                //field(Status; Rec.Status) { }
                field("Requested Date"; Rec."Requested Date") { }
                field("Sales Order"; Rec."Sales Order") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Line No."; Rec."Line No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Sales Quantity"; Rec."Sales Quantity") { }
                field(Quantity; Rec.Quantity) { }
                field("Location Code"; Rec."Location Code") { }
                field("Lot No."; Rec."Lot No.") { }
                field("Manufacturing Date"; Rec."Manufacturing Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("Close Date"; CloseDate) { }
                field("Remain 1p3 Shelf Life"; Remain1p3ShelfLife) { }
                field("Remain 2p3 Shelf Life"; Remain2p3ShelfLife) { }
            }
        }
    }

    procedure CalTrackingFromSalesLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pSalesLine: Record "Sales Line")
    var
        RecLItem: Record Item;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ItemTrckingLines: Page "Item Tracking Lines";
    begin
        if pSalesLine.Type <> pSalesLine.Type::Item then
            exit;
        if pSalesLine."No." = '' then
            exit;

        RecLItem.SetLoadFields("Item Tracking Code");
        RecLItem.Get(pSalesLine."No.");
        if RecLItem."Item Tracking Code" = '' then
            exit;

        Clear(SalesLineReserve);
        SalesLineReserve.InitFromSalesLine(pTrackingSpecification, pSalesLine);
        ItemTrckingLines.SetSourceSpec(pTrackingSpecification, pSalesLine."Shipment Date");
        ItemTrckingLines.GetTrackingSpec(pTrackingSpecification);
    end;

    trigger OnAfterGetRecord()
    var
        _2p3ShelfLife: Date;
        _1p3ShelfLife: Date;
        _1p2ShelfLife: Date;
    begin
        if Rec."Manufacturing Date" <> 0D then begin
            _2p3ShelfLife := Rec."Manufacturing Date" + ROUND((Rec."Expiration Date" - Rec."Manufacturing Date") * 1 / 3, 1);
            //_1p2ShelfLife := Rec."Manufacturing Date" + ROUND((Rec."Expiration Date" - Rec."Manufacturing Date") * 1 / 2, 1);
            _1p3ShelfLife := Rec."Manufacturing Date" + ROUND((Rec."Expiration Date" - Rec."Manufacturing Date") * 2 / 3, 1);
            if _2p3ShelfLife > Today() then begin
                Remain2p3ShelfLife := _2p3ShelfLife;
            end else begin
                Remain2p3ShelfLife := 0D;
            end;

            if (_2p3ShelfLife <= Today()) AND (_1p3ShelfLife >= Today()) then begin
                Remain1p3ShelfLife := _1p3ShelfLife;
            end else begin
                Remain1p3ShelfLife := 0D;
            end;

            if _1p3ShelfLife < Today() then begin
                CloseDate := Rec."Expiration Date";
            end else begin
                CloseDate := 0D;
            end;
        end else begin
            Remain2p3ShelfLife := 0D;
            Remain1p3ShelfLife := 0D;
            CloseDate := 0D;
        end;

        /*
        if _1p2ShelfLife > Today() then begin
            Remain1p2ShelfLife := _1p2ShelfLife;
        end else begin
            Remain1p2ShelfLife := 0D;
        end;
        */
    end;

    trigger OnOpenPage()
    var
        RecLTrackingSpecification: Record "Tracking Specification" temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ShipmentHeader: Record "Warehouse Shipment Header";
        ShipmentLine: Record "Warehouse Shipment Line";
        LotInformation: Record "Lot No. Information";
        TrackingSpecification: Record "Tracking Specification";
        LotInsert: Boolean;
        ToDate: Date;
    begin
        ToDate := CalcDate('+13D', Today);
        LotInsert := true;
        Rec.Reset();
        Rec.DeleteAll();

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", "Sales Document Type"::Order);
        if SalesOrderList <> '' then begin
            SalesHeader.SetFilter("No.", SalesOrderList);
        end else begin
            SalesHeader.SetRange("Requested Delivery Date", Today, ToDate);
            SalesHeader.SetRange(Status, "Sales Document Status"::Released);
        end;
        if SalesHeader.FindSet() then
            repeat
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then begin
                    repeat
                        Rec.Init();
                        Rec."Sales Order" := SalesLine."Document No.";
                        Rec."Line No." := SalesLine."Line No.";
                        Rec."Item No." := SalesLine."No.";
                        Rec."Location Code" := SalesLine."Location Code";
                        Rec."Sales Quantity" := SalesLine.Quantity;
                        /*
                        ShipmentLine.Reset();
                        ShipmentLine.SetRange("Source No.", SalesLine."Document No.");
                        ShipmentLine.SetRange("Source Line No.", SalesLine."Line No.");
                        if ShipmentLine.FindFirst() then begin
                            if ShipmentHeader.Get(SalesLine."Document No.") then begin
                                Rec.Status := Format(ShipmentHeader."Document Status");
                            end;
                        end;
                        */
                        Clear(RecLTrackingSpecification);
                        CalTrackingFromSalesLine(RecLTrackingSpecification, SalesLine);
                        RecLTrackingSpecification.Reset();
                        if RecLTrackingSpecification.FindSet() then begin
                            repeat
                                Rec.Quantity := RecLTrackingSpecification."Qty. to Handle (Base)";
                                Rec."Lot No." := RecLTrackingSpecification."Lot No.";
                                Rec."Expiration Date" := RecLTrackingSpecification."Expiration Date";
                                if LotInformation.Get(RecLTrackingSpecification."Item No.", '', RecLTrackingSpecification."Lot No.") then begin
                                    if LotInformation."BLACC Manufacturing Date" <> 0D then begin
                                        Rec."Manufacturing Date" := LotInformation."BLACC Manufacturing Date";
                                    end else begin
                                        Rec."Manufacturing Date" := Today();
                                    end;
                                end;
                                LotInsert := false;
                                Rec.insert();
                            until RecLTrackingSpecification.Next() = 0;

                        end;
                        if LotInsert then begin
                            Rec.Quantity := SalesLine.Quantity;
                            Rec.Insert();
                        end;

                    until SalesLine.Next() = 0;
                end;
            until SalesHeader.Next() = 0;
        if SalesOrderList = '' then
            Rec.SetFilter("Lot No.", '<>%1', '');
    end;

    procedure TestMerge(_SalesOrderList: Text)
    var
    begin
        SalesOrderList := _SalesOrderList;
    end;

    var
        SalesOrderList: Text;
        CloseDate: Date;
        Remain1p3ShelfLife: Date;
        Remain2p3ShelfLife: Date;
}
