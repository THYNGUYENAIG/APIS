report 51023 "ACC Import Plan Unpost Report"
{
    Caption = 'APIS Phiếu nhập kho nháp - R51023';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51023.ACCImportPlanUnpostReport.rdl';

    dataset
    {
        dataitem(ImportPlan; "ACC Import Plan Unposted")
        {
            //RequestFilterFields = "WR No.";
            column(WRNo; "WR No.")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(BuyerName; "Buyer Name")
            {
            }
            column(WRBarCode; WRBarCode)
            {
            }
            column(LocationName; "Location Name")
            {
            }
            column(LocationManager; "Location Manager")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(ItemName; "Item Name")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(LotNo; "Lot No.")
            {
            }
            column(ProductionDate; "Production Date")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(LineQRCode; LineQRCode)
            {
            }
            column(UnitCode; "Unit Code")
            {
            }
            column(ContainerNo; "Container No.") { }
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
                    field(PurchNo; PurchNo)
                    {
                        ApplicationArea = All;
                        //TableRelation = "Warehouse Receipt Header"."No.";
                        Caption = 'Purchase No.';
                        //ShowMandatory = true;
                    }

                    field(LineNo; LineNo)
                    {
                        ApplicationArea = All;
                        //TableRelation = "Warehouse Receipt Header"."No.";
                        Caption = 'Line No.';
                        //ShowMandatory = true;
                    }
                    field(ItemLineNo; ItemLineNo)
                    {
                        ApplicationArea = All;
                        //TableRelation = "Warehouse Receipt Header"."No.";
                        Caption = 'Line No.';
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
        BarcodeString := StrSubstNo('(91)%1(17)%2(10)%3', ImportPlan."Item No.", Format(ImportPlan."Expiration Date", 0, '<Year><Month,2><Day,2>'), ImportPlan."Lot No.");
        ImportPlan.LineQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
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
        BarcodeString := StrSubstNo('(91)%1(17)%2(10)%3', ImportPlan."Item No.", Format(ImportPlan."Expiration Date", 0, '<Year><Month,2><Day,2>'), ImportPlan."Lot No.");

        TempBlob := BarcodeImageProvider2D.EncodeImage(BarcodeString, BarcodeSymbology2D);
        TempBlob.CreateInStream(Instr);
        ImportPlan.ImageQRCode.CreateOutStream(OutStr);
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
        BarcodeString := ImportPlan."WR No.";
        ImportPlan.WRBarCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
    end;

    local procedure GenerateInterBarCode()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := ImportPlan."WR No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        //ImportPlan.WRBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
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
        /*
Database::"Sales Line":
    if SalesLine.Get(_WhseReceiptLine."Source Subtype", _WhseReceiptLine."Source No.", _WhseReceiptLine."Source Line No.") then
        CalTrackingFromSalesReturnLine(_TrackingSpecification, SalesLine);
Database::"Transfer Line":
    begin
        Direction := Direction::Inbound;
        if TransferLine.Get(_WhseReceiptLine."Source No.", _WhseReceiptLine."Source Line No.") then
            CalTrackingFromTransferLine(_TrackingSpecification, TransferLine);
    end
    */
        end;

    end;

    trigger OnPreReport()
    var
        RecLTrackingSpecification: Record "Tracking Specification" temporary;
        ImportPlanTable: Record "ACC Import Plan Table";
        WhseImportPlan: Record "Warehouse Receipt Line";
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        PurchOrder: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        InventTable: Record Item;
        LocationTable: Record Location;
        LotInformation: Record "Lot No. Information";
        TrackingSpecification: Record "Tracking Specification";
        ReservationEntry: Record "Reservation Entry";
        IdxCode: Integer;
    begin
        IdxCode := 0;
        ImportPlanTable.SetFilter("Source Document No.", PurchNo);
        ImportPlanTable.SetFilter("Source Line No.", Format(LineNo));
        ImportPlanTable.SetFilter("Line No.", Format(ItemLineNo));
        if ImportPlanTable.FindSet() then
            repeat
                WhseImportPlan.SetFilter("Source No.", PurchNo);
                WhseImportPlan.SetFilter("Source Line No.", Format(LineNo));
                //WhseImportPlan.SetFilter("Source Document", 'Purchase Order');
                if WhseImportPlan.FindSet() then
                    repeat
                        WhseReceiptHeader.SetFilter("No.", WhseImportPlan."No.");
                        if WhseReceiptHeader.FindSet() then
                            repeat
                                ImportPlan."WR No." := WhseReceiptHeader."No.";
                                ImportPlan."Posting Date" := WhseReceiptHeader."Posting Date";
                                WhseReceiptLine.SetRange("No.", WhseReceiptHeader."No.");
                                WhseReceiptLine.SetRange("Source No.", WhseImportPlan."Source No.");
                                WhseReceiptLine.SetRange("Source Line No.", WhseImportPlan."Source Line No.");
                                if WhseReceiptLine.FindSet() then
                                    repeat
                                        ImportPlan."Source No." := WhseReceiptLine."Source No.";
                                        ImportPlan."Line No." := WhseReceiptLine."Line No.";
                                        if LocationTable.Get(WhseReceiptLine."Location Code") then begin
                                            ImportPlan."Location Name" := LocationTable.Name;
                                            ImportPlan."Location Manager" := LocationTable.Contact;
                                        end;
                                        if PurchOrder.get(Enum::"Purchase Document Type"::Order, WhseReceiptLine."Source No.") then
                                            ImportPlan."Buyer Name" := PurchOrder."Buy-from Vendor Name";
                                        ImportPlan."Item No." := WhseReceiptLine."Item No.";
                                        if InventTable.Get(WhseReceiptLine."Item No.") then
                                            ImportPlan."Item Name" := InventTable."BLTEC Item Name";
                                        //ImportPlan."Item Name" := WhseReceiptLine.Description + WhseReceiptLine."Item No.";
                                        ImportPlan."Unit Code" := WhseReceiptLine."Unit of Measure Code";
                                        ImportPlan.Quantity := ImportPlanTable."Actual Received Quantity";
                                        ImportPlan."Container No." := ImportPlanTable."Container No.";
                                        if PurchOrderLine.Get(Enum::"Purchase Document Type"::Order, WhseImportPlan."Source No.", WhseImportPlan."Source Line No.") then begin
                                            Clear(RecLTrackingSpecification);
                                            CalTrackingFromPurchaseLine(RecLTrackingSpecification, PurchOrderLine);
                                            RecLTrackingSpecification.Reset();
                                            if RecLTrackingSpecification.FindSet() then begin
                                                repeat
                                                    ImportPlan."Lot No." := RecLTrackingSpecification."Lot No.";
                                                    ImportPlan."Expiration Date" := RecLTrackingSpecification."Expiration Date";
                                                    if LotInformation.Get(RecLTrackingSpecification."Item No.", '', RecLTrackingSpecification."Lot No.") then
                                                        ImportPlan."Production Date" := RecLTrackingSpecification."BLACC Manufacturing Date";
                                                    if RecLTrackingSpecification."Qty. to Handle (Base)" <> 0 then begin
                                                        IdxCode := IdxCode + 1;
                                                        ImportPlan."Code Index" := IdxCode;
                                                        ImportPlan.insert();
                                                    end;
                                                until RecLTrackingSpecification.Next() = 0;
                                            end;
                                        end;
                                    until WhseReceiptLine.Next() = 0;
                            until WhseReceiptHeader.Next() = 0;
                    until WhseImportPlan.Next() = 0;
            until ImportPlanTable.Next() = 0;
    end;

    var
        //WhseNo: Text;
        PurchNo: Text;
        LineNo: Integer;
        ItemLineNo: Integer;
        EncodeTextQRCode: Text;
        EncodeTextBarCode: Text;

}
