page 51024 "ACC Sales Shipment Details"
{
    ApplicationArea = All;
    Caption = 'APIS Sales Shipment Details - P51024';
    PageType = List;
    SourceTable = "ACC Whse Shipment Details";
    UsageCategory = ReportsAndAnalysis;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code") { }
                field("Sales Order"; Rec."Sales Order") { }
                field("Payment Term Name"; Rec."Payment Term Name") { }
                field("Bill to Customer No."; Rec."Bill to Customer No.") { }
                field("Bill to Customer Name"; Rec."Bill to Customer Name") { }
                field("Salesperson Code"; Rec."Salesperson Code") { }
                field("Salesperson Name"; Rec."Salesperson Name") { }
                field("Responsibility Center"; Rec."Responsibility Center") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Delivery Address"; Rec."Delivery Address") { }
                field("Delivery Date"; Rec."Delivery Date") { }
                field("Delivery Note"; Rec."Delivery Note") { }
                field(Status; Rec.Status) { }
                field("Source Document"; Rec."Source Document") { }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Quantity (Base)"; Rec."Quantity (Base)") { }
                field("Packing Group"; Rec."Packing Group") { }
                field("Quantity (Packing)"; Rec."Quantity (Packing)") { }
                field("Lot No."; Rec."Lot No.") { }
                field("Manufacturing Date"; Rec."Manufacturing Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
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

    procedure CalTrackingFromTransferLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pTransferLine: Record "Transfer Line")
    var
        RecLItem: Record Item;
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        ItemTrckingLines: Page "Item Tracking Lines";
        ShipmentDate: Date;
    begin

        if pTransferLine."Item No." = '' then
            exit;

        RecLItem.SetLoadFields("Item Tracking Code");
        RecLItem.Get(pTransferLine."Item No.");
        if RecLItem."Item Tracking Code" = '' then
            exit;

        Clear(TransferLineReserve);
        TransferLineReserve.InitFromTransLine(pTrackingSpecification, pTransferLine, ShipmentDate, "Transfer Direction"::Outbound);
        ItemTrckingLines.SetSourceSpec(pTrackingSpecification, pTransferLine."Shipment Date");
        ItemTrckingLines.GetTrackingSpec(pTrackingSpecification);
    end;

    procedure CalTrackingFromReturnLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pPurchLine: Record "Purchase Line")
    var
        RecLItem: Record Item;
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ItemTrckingLines: Page "Item Tracking Lines";
    begin
        if pPurchLine.Type <> pPurchLine.Type::Item then
            exit;
        if pPurchLine."No." = '' then
            exit;

        RecLItem.SetLoadFields("Item Tracking Code");
        RecLItem.Get(pPurchLine."No.");
        if RecLItem."Item Tracking Code" = '' then
            exit;

        Clear(PurchLineReserve);
        PurchLineReserve.InitFromPurchLine(pTrackingSpecification, pPurchLine);
        ItemTrckingLines.SetSourceSpec(pTrackingSpecification, pPurchLine."Order Date");
        ItemTrckingLines.GetTrackingSpec(pTrackingSpecification);
    end;

    trigger OnOpenPage()
    var
        BCHelper: Codeunit "BC Helper";
        WhseShipment: Query "ACC Whse. Shipment Entry Qry";
        LotInforTabl: Record "Lot No. Information";

        RecLTrackingSpecification: Record "Tracking Specification" temporary;
        SalesOrder: Record "Sales Header";
        SalesLine: Record "Sales Line";

        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";

        ReturnHeader: Record "Purchase Header";
        ReturnLine: Record "Purchase Line";
        ForInsert: Boolean;
    begin
        WhseShipment.SetFilter(BUCode, BCHelper.GetSalesByCurUserId());
        if WhseShipment.Open() then begin
            while WhseShipment.Read() do begin
                ForInsert := true;
                Rec.Init();
                Rec."Sales Order" := WhseShipment.SalesNo;
                Rec."Line No." := WhseShipment.SourceLineNo;
                Rec."Customer No." := WhseShipment.CustomerNo;
                Rec."Customer Name" := WhseShipment.CustomerName;
                Rec."Delivery Address" := WhseShipment.ShiptoAddress + ' ' + WhseShipment.ShiptoAddress2;
                Rec."Delivery Note" := WhseShipment.DeliveryNote;
                Rec."Delivery Date" := WhseShipment.DeliveryDate;
                Rec.Status := WhseShipment.Status;
                Rec."Source Document" := WhseShipment.SourceDocument;
                Rec."Whse. Shipment No." := WhseShipment.No;
                Rec."Item No." := WhseShipment.ItemNo;
                Rec."Item Name" := WhseShipment.Description;
                Rec."Packing Group" := WhseShipment.PackingGroup;
                Rec."Location Code" := WhseShipment.LocationCode;
                Rec."Payment Term Code" := WhseShipment.PaymentTermsCode;
                Rec."Salesperson Code" := WhseShipment.SalespersonCode;
                if SalesLine.Get(WhseShipment.SourceDocument, WhseShipment.SourceNo, WhseShipment.SourceLineNo) then begin
                    Clear(RecLTrackingSpecification);
                    CalTrackingFromSalesLine(RecLTrackingSpecification, SalesLine);
                    RecLTrackingSpecification.Reset();
                    if RecLTrackingSpecification.FindSet() then begin
                        repeat
                            ForInsert := false;
                            Rec."Quantity (Base)" := RecLTrackingSpecification."Quantity (Base)";
                            if WhseShipment.GrossWeight <> 0 then begin
                                Rec."Quantity (Packing)" := RecLTrackingSpecification."Quantity (Base)" / WhseShipment.GrossWeight;
                            end else begin
                                Rec."Quantity (Packing)" := RecLTrackingSpecification."Quantity (Base)";
                            end;
                            Rec."Lot No." := RecLTrackingSpecification."Lot No.";
                            Rec."Expiration Date" := RecLTrackingSpecification."Expiration Date";
                            RecLTrackingSpecification.CalcShelfLife();
                            RecLTrackingSpecification.CalcRemainingShelfLife();
                            Rec."Manufacturing Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                            /*
                            if LotInforTabl.Get(RecLTrackingSpecification."Lot No.") then begin
                                if LotInforTabl."BLACC Manufacturing Date" <> 0D then begin
                                    Rec."Manufacturing Date" := LotInforTabl."BLACC Manufacturing Date";
                                end else begin
                                    Rec."Manufacturing Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                end;
                            end;
                            */
                            Rec.Insert();
                        until RecLTrackingSpecification.Next() = 0;
                    end;
                end;
                if ForInsert then
                    Rec.Insert();
            end;
            WhseShipment.Close();
        end;
    end;
}
