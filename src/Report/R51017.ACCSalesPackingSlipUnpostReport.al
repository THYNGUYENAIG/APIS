report 51017 "ACC Packing Slip Unpost Report"
{
    Caption = 'APIS Phiếu xuất kho nháp - R51017';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51017.ACCSalesPackingSlipUnpostReport.rdl';
    dataset
    {
        dataitem(WhseShipment; "ACC Whse. Shipment Unposted")
        {
            column(CodeIndex; "Code Index")
            {
            }
            column(CompanyAddress; "Company Address")
            {
            }
            column(CompanyFax; "Company Fax")
            {
            }
            column(CompanyMobile; "Company Mobile")
            {
            }
            column(CompanyName; "Company Name")
            {
            }
            column(DeliveryAddress; "Delivery Address")
            {
            }
            column(DeliveryMobile; "Delivery Mobile")
            {
            }
            column(DeliveryNote; "Delivery Note")
            {
            }
            column(DeliveryPerson; "Delivery Person")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(InvoiceAddress; "Invoice Address")
            {
            }
            column(ItemName; "Item Name")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(LocationName; "Location Name")
            {
            }
            column(LotNo; "Lot No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(ProductionDate; "Production Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(RegistrationNo; "Registration No")
            {
            }
            column(SellerNo; "Seller No")
            {
            }
            column(SellerName; "Seller Name")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(UnitCode; "Unit Code")
            {
            }
            column(WSBarCode; "WS Bar Code")
            {
            }
            column(WSNo; "WS No.")
            {
            }
            column(ImageQRCode; ImageQRCode) { }

            trigger OnAfterGetRecord()
            var
            begin
                GenerateHeaderQRCode();
                GenerateImageQRCode();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(WhseNo; WhseNo)
                    {
                        ApplicationArea = All;
                        //TableRelation = "Warehouse Shipment Header"."No.";
                        Caption = 'No.';
                        //ShowMandatory = true;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    local procedure GenerateHeaderQRCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeString: Text;
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        BarcodeString := WhseShipment."Source No.";
        WhseShipment."WS Bar Code" := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
    end;

    local procedure GenerateImageQRCode()
    var
        Instr: InStream;
        OutStr: OutStream;
        TempBlob: Codeunit "Temp Blob";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeImageProvider2D: Interface "Barcode Image Provider 2D";

        BarcodeString: Text;
    begin
        BarcodeImageProvider2D := Enum::"Barcode Image Provider 2D"::Dynamics2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        BarcodeString := StrSubstNo('(91)%1(17)%2(10)%3', WhseShipment."Item No.", Format(WhseShipment."Expiration Date", 0, '<Year><Month,2><Day,2>'), WhseShipment."Lot No.");

        TempBlob := BarcodeImageProvider2D.EncodeImage(BarcodeString, BarcodeSymbology2D);
        TempBlob.CreateInStream(Instr);
        WhseShipment.ImageQRCode.CreateOutStream(OutStr);
        CopyStream(OutStr, Instr);
    end;

    local procedure GenerateInterQRCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeString: Text;
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        //BarcodeString := StrSubstNo('(91)%1(17)%2(10)%3', WhseReceipt."Item No.", Format(WhseReceipt."Expiration Date", 0, '<Year><Month,2><Day,2>'), WhseReceipt."Lot No.");
        //WhseReceipt.LineQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
    end;

    local procedure GenerateInterBarCode()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := WhseShipment."Source No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        WhseShipment."WS Bar Code" := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

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

    trigger OnPreReport()
    var
        RecLTrackingSpecification: Record "Tracking Specification" temporary;
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhseShipmentUpdate: Record "Warehouse Shipment Header";
        WhseShipmentLine: Record "Warehouse Shipment Line";
        TransportUnit: Record "BLACC VAT Import/Export Info";
        SalesOrder: Record "Sales Header";
        SalesLine: Record "Sales Line";

        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";

        ReturnHeader: Record "Purchase Header";
        ReturnLine: Record "Purchase Line";

        ShipToAddres: Record "Ship-to Address";
        CompanyInfo: Record "Company Information";
        InventTable: Record Item;
        LocationTable: Record Location;
        LotInformation: Record "Lot No. Information";
        TrackingSpecification: Record "Tracking Specification";
        ReservationEntry: Record "Reservation Entry";

        Delimiter: Text;
        LotNo: Text;
        LotPart: List of [Text];
    begin
        Clear(WhseShipmentUpdate);
        WhseShipmentUpdate.SetFilter("No.", WhseNo);
        if WhseShipmentUpdate.FindSet() then
            repeat
                WhseShipmentUpdate."Printed No." := WhseShipmentUpdate."Printed No." + 1;
                WhseShipmentUpdate.Modify();
            until WhseShipmentUpdate.Next() = 0;

        CompanyInfo.Get();
        WhseShipmentHeader.SetFilter("No.", WhseNo);
        if WhseShipmentHeader.FindSet() then
            repeat
                WhseShipment."WS No." := WhseShipmentHeader."No.";
                WhseShipment."Posting Date" := WhseShipmentHeader."Posting Date";
                WhseShipment."Company Name" := CompanyInfo.Name;
                WhseShipment."Company Address" := CompanyInfo.Address + ' ' + CompanyInfo."Address 2";
                WhseShipment."Company Mobile" := CompanyInfo."Phone No.";
                WhseShipment."Company Fax" := CompanyInfo."Fax No.";
                WhseShipmentLine.SetRange("No.", WhseShipmentHeader."No.");
                if WhseShipmentLine.FindSet() then
                    repeat
                        WhseShipment."Source No." := WhseShipmentLine."Source No.";
                        WhseShipment."Line No." := WhseShipmentLine."Line No.";
                        WhseShipment."Item No." := WhseShipmentLine."Item No.";
                        if InventTable.Get(WhseShipmentLine."Item No.") then
                            WhseShipment."Item Name" := InventTable.Description;
                        WhseShipment."Unit Code" := WhseShipmentLine."Unit of Measure Code";

                        if LocationTable.Get(WhseShipmentLine."Location Code") then begin
                            WhseShipment."Location Name" := LocationTable.Name;
                            WhseShipment."Location Manager" := LocationTable.Contact;
                        end;

                        if WhseShipmentLine."Source Document" = Enum::"Warehouse Activity Source Document"::"Sales Order" then begin
                            if SalesOrder.Get(Enum::"Sales Document Type"::Order, WhseShipmentLine."Source No.") then begin
                                WhseShipment."Seller No" := SalesOrder."Sell-to Customer No.";
                                WhseShipment."Seller Name" := SalesOrder."Sell-to Customer Name";
                                WhseShipment."Registration No" := SalesOrder."VAT Registration No.";
                                WhseShipment."Invoice Address" := SalesOrder."Bill-to Address" + ' ' + SalesOrder."Bill-to Address 2";
                                WhseShipment."Delivery Address" := SalesOrder."Ship-to Address" + ' ' + SalesOrder."Ship-to Address 2";
                                WhseShipment."Delivery Note" := SalesOrder."BLACC Delivery Note";

                                if ShipToAddres.Get(SalesOrder."Sell-to Customer No.", SalesOrder."Ship-to Code") then begin
                                    WhseShipment."Delivery Person" := ShipToAddres.Contact;
                                    WhseShipment."Delivery Mobile" := ShipToAddres."Phone No.";
                                end;
                            end;
                            if SalesLine.Get(Enum::"Sales Document Type"::Order, WhseShipmentLine."Source No.", WhseShipmentLine."Source Line No.") then begin
                                Clear(RecLTrackingSpecification);
                                CalTrackingFromSalesLine(RecLTrackingSpecification, SalesLine);
                                RecLTrackingSpecification.Reset();
                                if RecLTrackingSpecification.FindSet() then begin
                                    repeat
                                        WhseShipment."Code Index" := WhseShipment."Code Index" + 1;
                                        WhseShipment.Quantity := RecLTrackingSpecification."Quantity (Base)";
                                        WhseShipment."Lot No." := RecLTrackingSpecification."Lot No.";
                                        WhseShipment."Expiration Date" := RecLTrackingSpecification."Expiration Date";
                                        RecLTrackingSpecification.CalcShelfLife();
                                        RecLTrackingSpecification.CalcRemainingShelfLife();
                                        if LotInformation.Get(RecLTrackingSpecification."Item No.", '', RecLTrackingSpecification."Lot No.") then begin
                                            if LotInformation."BLACC Manufacturing Date" <> 0D then begin
                                                WhseShipment."Production Date" := LotInformation."BLACC Manufacturing Date";
                                            end else begin
                                                WhseShipment."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                            end;
                                        end;
                                        WhseShipment.insert();
                                    until RecLTrackingSpecification.Next() = 0;
                                end;
                            end;
                        end;

                        if WhseShipmentLine."Source Document" = Enum::"Warehouse Activity Source Document"::"Outbound Transfer" then begin
                            if TransferHeader.Get(WhseShipmentLine."Source No.") then begin
                                WhseShipment."Seller No" := TransferHeader."Transfer-to Code";
                                WhseShipment."Seller Name" := TransferHeader."Transfer-to Name";

                                if TransportUnit.Get(TransferHeader."BLACC Import/Export Info") then
                                    WhseShipment."Delivery Note" := TransportUnit.Name;
                            end;
                            if TransferLine.Get(WhseShipmentLine."Source No.", WhseShipmentLine."Source Line No.") then begin
                                Clear(RecLTrackingSpecification);
                                CalTrackingFromTransferLine(RecLTrackingSpecification, TransferLine);
                                RecLTrackingSpecification.Reset();
                                if RecLTrackingSpecification.FindSet() then begin
                                    repeat
                                        WhseShipment."Code Index" := WhseShipment."Code Index" + 1;
                                        WhseShipment.Quantity := RecLTrackingSpecification."Quantity (Base)";
                                        WhseShipment."Lot No." := RecLTrackingSpecification."Lot No.";
                                        WhseShipment."Expiration Date" := RecLTrackingSpecification."Expiration Date";
                                        RecLTrackingSpecification.CalcShelfLife();
                                        RecLTrackingSpecification.CalcRemainingShelfLife();
                                        if LotInformation.Get(RecLTrackingSpecification."Lot No.") then begin
                                            if LotInformation."BLACC Manufacturing Date" <> 0D then begin
                                                WhseShipment."Production Date" := LotInformation."BLACC Manufacturing Date";
                                            end else begin
                                                WhseShipment."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                            end;
                                        end;
                                        WhseShipment.insert();
                                    until RecLTrackingSpecification.Next() = 0;
                                end;
                            end;
                        end;

                        if WhseShipmentLine."Source Document" = Enum::"Warehouse Activity Source Document"::"Purchase Return Order" then begin
                            if ReturnHeader.Get(Enum::"Purchase Document Type"::"Return Order", WhseShipmentLine."Source No.") then begin
                                WhseShipment."Seller No" := ReturnHeader."Sell-to Customer No.";
                                //WhseShipment."Seller Name" := ReturnHeader."Sell-to Customer Name";
                                WhseShipment."Registration No" := ReturnHeader."VAT Registration No.";
                                //WhseShipment."Invoice Address" := ReturnHeader."Bill-to Address" + ' ' + SalesOrder."Bill-to Address 2";
                                WhseShipment."Delivery Address" := ReturnHeader."Ship-to Address" + ' ' + ReturnHeader."Ship-to Address 2";
                                //WhseShipment."Delivery Note" := ReturnHeader."BLACC Delivery Note";

                                if ShipToAddres.Get(ReturnHeader."Sell-to Customer No.", ReturnHeader."Ship-to Code") then begin
                                    WhseShipment."Delivery Person" := ShipToAddres.Contact;
                                    WhseShipment."Delivery Mobile" := ShipToAddres."Phone No.";
                                end;
                            end;
                            if ReturnLine.Get(Enum::"Purchase Document Type"::"Return Order", WhseShipmentLine."Source No.", WhseShipmentLine."Source Line No.") then begin
                                Clear(RecLTrackingSpecification);
                                CalTrackingFromReturnLine(RecLTrackingSpecification, ReturnLine);
                                RecLTrackingSpecification.Reset();
                                if RecLTrackingSpecification.FindSet() then begin
                                    repeat
                                        WhseShipment."Code Index" := WhseShipment."Code Index" + 1;
                                        WhseShipment.Quantity := RecLTrackingSpecification."Quantity (Base)";
                                        WhseShipment."Lot No." := RecLTrackingSpecification."Lot No.";
                                        WhseShipment."Expiration Date" := RecLTrackingSpecification."Expiration Date";
                                        RecLTrackingSpecification.CalcShelfLife();
                                        RecLTrackingSpecification.CalcRemainingShelfLife();
                                        WhseShipment."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                        if LotInformation.Get(RecLTrackingSpecification."Lot No.") then begin
                                            if LotInformation."BLACC Manufacturing Date" <> 0D then begin
                                                WhseShipment."Production Date" := LotInformation."BLACC Manufacturing Date";
                                            end else begin
                                                WhseShipment."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                            end;
                                        end;
                                        WhseShipment.insert();
                                    until RecLTrackingSpecification.Next() = 0;
                                end;
                            end;
                        end;
                    until WhseShipmentLine.Next() = 0;
            until WhseShipmentHeader.Next() = 0;
    end;

    var
        WhseNo: Text;
        //LotInfo: Text;
        EncodeTextQRCode: Text;
        EncodeTextBarCode: Text;

}
