report 51016 "ACC WH Receipt Unpost Report"
{
    Caption = 'ACC Phiếu nhập kho nháp - R51016';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51016.ACCWhseReceiptUnpostReport.rdl';

    dataset
    {
        dataitem("WhseReceipt"; "ACC Whse. Receipt Unposted")
        {
            //RequestFilterFields = "WR No.";
            column(WRNo; "WR No.") { }
            column(SourceNo; "Source No.") { }
            column(BuyerName; "Buyer Name") { }
            column(WRBarCode; WRBarCode) { }
            column(LocationName; "Location Name") { }
            column(LocationManager; "Location Manager") { }
            column(PostingDate; "Posting Date") { }
            column(ItemNo; "Item No.") { }
            column(ItemName; "Item Name") { }
            column(LineNo; "Line No.") { }
            column(LotNo; "Lot No.") { }
            column(ProductionDate; "Production Date") { }
            column(ExpirationDate; "Expiration Date") { }
            column(Quantity; Quantity) { }
            column(LineQRCode; LineQRCode) { }
            column(ImageQRCode; ImageQRCode) { }
            column(UnitCode; "Unit Code") { }
            column(InvoiceNo; "Invoice No.") { }
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
                        //TableRelation = "Warehouse Receipt Header"."No.";
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

    local procedure GenerateInterQRCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeString: Text;
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        BarcodeString := StrSubstNo('(91)%1(17)%2(10)%3', WhseReceipt."Item No.", Format(WhseReceipt."Expiration Date", 0, '<Year><Month,2><Day,2>'), 'DFN2410128349');
        WhseReceipt.LineQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
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
        BarcodeString := StrSubstNo('(91)%1(17)%2(10)%3', WhseReceipt."Item No.", Format(WhseReceipt."Expiration Date", 0, '<Year><Month,2><Day,2>'), WhseReceipt."Lot No.");

        TempBlob := BarcodeImageProvider2D.EncodeImage(BarcodeString, BarcodeSymbology2D);
        TempBlob.CreateInStream(Instr);
        WhseReceipt.ImageQRCode.CreateOutStream(OutStr);
        CopyStream(OutStr, Instr);
    end;

    local procedure GenerateHeaderQRCode()
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeString: Text;
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        BarcodeString := WhseReceipt."WR No.";
        WhseReceipt.WRBarCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
    end;

    local procedure GenerateInterBarCode()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := WhseReceipt."WR No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        WhseReceipt.WRBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure CalTrackingFromPurchaseLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pPurchaseLine: Record "Purchase Line")
    var
        RecLItem: Record Item;
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ItemTrckingLines: Page "Item Tracking Lines";
    begin
        if pPurchaseLine.Type <> pPurchaseLine.Type::Item then
            exit;
        if pPurchaseLine."No." = '' then
            exit;

        RecLItem.SetLoadFields("Item Tracking Code");
        RecLItem.Get(pPurchaseLine."No.");
        if RecLItem."Item Tracking Code" = '' then
            exit;

        Clear(PurchLineReserve);
        PurchLineReserve.InitFromPurchLine(pTrackingSpecification, pPurchaseLine);
        ItemTrckingLines.SetSourceSpec(pTrackingSpecification, pPurchaseLine."Order Date");
        ItemTrckingLines.GetTrackingSpec(pTrackingSpecification);
    end;

    procedure CalTrackingFromTransferLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pTransferLine: Record "Transfer Line")
    var
        RecLItem: Record Item;
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        ItemTrckingLines: Page "Item Tracking Lines";
        ReceiptDate: Date;
    begin
        if pTransferLine."Item No." = '' then
            exit;

        RecLItem.SetLoadFields("Item Tracking Code");
        RecLItem.Get(pTransferLine."Item No.");
        if RecLItem."Item Tracking Code" = '' then
            exit;

        Clear(TransferLineReserve);
        TransferLineReserve.InitFromTransLine(pTrackingSpecification, pTransferLine, ReceiptDate, "Transfer Direction"::Inbound);
        ItemTrckingLines.SetSourceSpec(pTrackingSpecification, pTransferLine."Receipt Date");
        ItemTrckingLines.GetTrackingSpec(pTrackingSpecification);
    end;

    procedure CalTrackingFromSalesReturnLine(var pTrackingSpecification: Record "Tracking Specification" temporary; pSalesLine: Record "Sales Line")
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

    procedure CalTrackingFromWarehouseReceiptLine(_WhseReceiptLine: Record "Warehouse Receipt Line"; var _TrackingSpecification: Record "Tracking Specification" temporary)
    var
        Item: Record Item;
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        TransferLine: Record "Transfer Line";
        Direction: Enum "Transfer Direction";
    begin
        _WhseReceiptLine.TestField("No.");
        _WhseReceiptLine.TestField("Qty. (Base)");

        Item.Get(_WhseReceiptLine."Item No.");
        Item.TestField("Item Tracking Code");

        case _WhseReceiptLine."Source Type" of
            Database::"Purchase Line":
                if PurchaseLine.Get(_WhseReceiptLine."Source Subtype", _WhseReceiptLine."Source No.", _WhseReceiptLine."Source Line No.") then
                    CalTrackingFromPurchaseLine(_TrackingSpecification, PurchaseLine);
            Database::"Sales Line":
                if SalesLine.Get(_WhseReceiptLine."Source Subtype", _WhseReceiptLine."Source No.", _WhseReceiptLine."Source Line No.") then
                    CalTrackingFromSalesReturnLine(_TrackingSpecification, SalesLine);
            Database::"Transfer Line":
                begin
                    Direction := Direction::Inbound;
                    if TransferLine.Get(_WhseReceiptLine."Source No.", _WhseReceiptLine."Source Line No.") then
                        CalTrackingFromTransferLine(_TrackingSpecification, TransferLine);
                end
        end;

    end;

    trigger OnPreReport()
    var
        RecLTrackingSpecification: Record "Tracking Specification" temporary;
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptUpdate: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        PurchOrder: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";

        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        ImportInfo: Record "BLACC VAT Import/Export Info";

        ReturnHeader: Record "Sales Header";
        ReturnLine: Record "Sales Line";

        InventTable: Record Item;
        LocationTable: Record Location;
        LotInformation: Record "Lot No. Information";
        TrackingSpecification: Record "Tracking Specification";
        ReservationEntry: Record "Reservation Entry";
        IdxCode: Integer;
    begin
        IdxCode := 0;
        Clear(WhseReceiptUpdate);
        WhseReceiptUpdate.SetFilter("No.", WhseNo);
        if WhseReceiptUpdate.FindSet() then
            repeat
                WhseReceiptUpdate."Printed No." := WhseReceiptUpdate."Printed No." + 1;
                WhseReceiptUpdate.Modify();
            until WhseReceiptUpdate.Next() = 0;

        WhseReceiptHeader.SetFilter("No.", WhseNo);
        if WhseReceiptHeader.FindSet() then
            repeat
                WhseReceipt."WR No." := WhseReceiptHeader."No.";
                WhseReceipt."Posting Date" := WhseReceiptHeader."Posting Date";
                WhseReceiptLine.SetRange("No.", WhseReceiptHeader."No.");
                if WhseReceiptLine.FindSet() then
                    repeat
                        WhseReceipt."Source No." := WhseReceiptLine."Source No.";
                        WhseReceipt."Line No." := WhseReceiptLine."Line No.";
                        WhseReceipt."Invoice No." := WhseReceiptLine."BLACC Invoice No.";
                        WhseReceipt."Item No." := WhseReceiptLine."Item No.";
                        if InventTable.Get(WhseReceiptLine."Item No.") then
                            WhseReceipt."Item Name" := InventTable."BLTEC Item Name";
                        WhseReceipt."Unit Code" := WhseReceiptLine."Unit of Measure Code";

                        if LocationTable.Get(WhseReceiptLine."Location Code") then begin
                            WhseReceipt."Location Name" := LocationTable.Name;
                            WhseReceipt."Location Manager" := LocationTable.Contact;
                        end;
                        // <Purchase Order Receipt>
                        if WhseReceiptLine."Source Document" = Enum::"Warehouse Activity Source Document"::"Purchase Order" then begin
                            if PurchOrder.get(Enum::"Purchase Document Type"::Order, WhseReceiptLine."Source No.") then
                                WhseReceipt."Buyer Name" := PurchOrder."Buy-from Vendor Name";
                        end;
                        // <Inbound Transfer>
                        if WhseReceiptLine."Source Document" = Enum::"Warehouse Activity Source Document"::"Inbound Transfer" then begin
                            if TransferHeader.get(WhseReceiptLine."Source No.") then begin
                                WhseReceipt."Buyer Name" := TransferHeader."Transfer-from Name";
                                if ImportInfo.Get(TransferHeader."BLACC Import/Export Info") then
                                    WhseReceipt."Transport Name" := ImportInfo.Name;
                            end;
                        end;
                        // <Sales Return>
                        if WhseReceiptLine."Source Document" = Enum::"Warehouse Activity Source Document"::"Sales Return Order" then begin
                            if ReturnHeader.get(Enum::"Sales Document Type"::"Return Order", WhseReceiptLine."Source No.") then
                                WhseReceipt."Buyer Name" := ReturnHeader."Sell-to Customer Name";
                        end;
                        Clear(RecLTrackingSpecification);
                        CalTrackingFromWarehouseReceiptLine(WhseReceiptLine, RecLTrackingSpecification);
                        RecLTrackingSpecification.Reset();
                        if RecLTrackingSpecification.FindSet() then begin
                            repeat
                                WhseReceipt.Quantity := RecLTrackingSpecification."Quantity (Base)";
                                WhseReceipt."Lot No." := RecLTrackingSpecification."Lot No.";
                                WhseReceipt."Expiration Date" := RecLTrackingSpecification."Expiration Date";

                                if LotInformation.Get(RecLTrackingSpecification."Item No.", '', RecLTrackingSpecification."Lot No.") then begin
                                    if LotInformation."BLACC Manufacturing Date" <> 0D then begin
                                        WhseReceipt."Production Date" := LotInformation."BLACC Manufacturing Date";
                                    end else begin
                                        WhseReceipt."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                    end;
                                end else begin
                                    WhseReceipt."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                end;
                                if RecLTrackingSpecification."Qty. to Handle (Base)" <> 0 then begin
                                    IdxCode := IdxCode + 1;
                                    WhseReceipt."Code Index" := IdxCode;
                                    WhseReceipt.insert();
                                end;
                            until RecLTrackingSpecification.Next() = 0;
                        end;
                    until WhseReceiptLine.Next() = 0;
            until WhseReceiptHeader.Next() = 0;
    end;

    var
        WhseNo: Text;
        EncodeTextQRCode: Text;
        EncodeTextBarCode: Text;



}
