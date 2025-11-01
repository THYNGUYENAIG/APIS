page 52029 "ACC WH Shipment Det. (Sales)"
{
    ApplicationArea = All;
    Caption = 'APIS Warehouse Shipment Details (Sales) - P52029';
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
                field("Sales Order"; Rec."Sales Order")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Delivery Address"; Rec."Delivery Address")
                {
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                }
                field("Delivery Note"; Rec."Delivery Note")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Source Document"; Rec."Source Document")
                {
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                }
                field("Packing Group"; Rec."Packing Group")
                {
                }
                field("Quantity (Packing)"; Rec."Quantity (Packing)")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                    ToolTip = 'Specifies the value of the Payment Term Code field.', Comment = '%';
                }
                field("Payment Term Name"; Rec."Payment Term Name")
                {
                    ToolTip = 'Specifies the value of the Payment Term Name field.', Comment = '%';
                }
                field("Purchase Name"; Rec."Purchase Name")
                {
                    ToolTip = 'Specifies the value of the Purchase Name field.', Comment = '%';
                }
                field("Ecus - Item Name"; Rec."Ecus - Item Name")
                {
                    ToolTip = 'Specifies the value of the Ecus - Item Name field.', Comment = '%';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.', Comment = '%';
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    ToolTip = 'Specifies the value of the Agreement No. field.', Comment = '%';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field.', Comment = '%';
                }
                field("Salesperson Name"; Rec."Salesperson Name")
                {
                    ToolTip = 'Specifies the value of the Salesperson Name field.', Comment = '%';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the BU Code field.', Comment = '%';
                }
                field("Bill to Customer No."; Rec."Bill to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill to Customer No. field.', Comment = '%';
                }
                field("Bill to Customer Name"; Rec."Bill to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Bill to Customer Name field.', Comment = '%';
                }
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

        recPT: Record "Payment Terms";
        recSP: Record "Salesperson/Purchaser";
        recC: Record Customer;
    begin
        WhseShipment.SetFilter(LocationCode, BCHelper.GetWhseByCurUserId());
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
                recPT.Reset();
                if recPT.Get(WhseShipment.PaymentTermsCode) then Rec."Payment Term Name" := recPT.Description;

                Rec."Salesperson Code" := WhseShipment.SalespersonCode;
                recSP.Reset();
                if recSP.Get(WhseShipment.SalespersonCode) then Rec."Salesperson Name" := recSP.Name;

                SalesOrder.Reset();
                SalesOrder.SetRange("No.", WhseShipment.SourceNo);
                if SalesOrder.FindFirst() then begin
                    Rec."Bill to Customer No." := SalesOrder."Bill-to Customer No.";
                    recC.Reset();
                    recC.SetRange("No.", SalesOrder."Bill-to Customer No.");
                    if recC.FindFirst() then begin
                        Rec."Bill to Customer Name" := recC.Name + ' ' + recC."Name 2";
                    end;

                    Rec."Responsibility Center" := SalesOrder."Responsibility Center";
                end;

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

    var
}
