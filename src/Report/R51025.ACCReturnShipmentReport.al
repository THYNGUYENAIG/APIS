report 51025 "ACC Return Shipment Report"
{
    Caption = 'APIS Return Shipment Report - R51025';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51025.ACCReturnShipmentReport.rdl';
    dataset
    {
        dataitem(SalesShipmentHeader; "Return Shipment Header")
        {
            RequestFilterFields = "No.";
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress02; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyFax; CompanyInfo."Fax No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(DocBarCode; EncodeTextBarCode) { }
            column(DocumentNo; "No.") { }
            column(OrderNo; "Return Order No.") { }
            column(PostingDate; "Posting Date") { }
            column(SellToCustomerName; "Buy-from Vendor Name") { }
            column(SellToCustomerNo; "Buy-from Vendor No.") { }
            column(BillToAddress; "Buy-from Address") { }
            column(BillToAddress02; "Buy-from Address 2") { }
            column(BillToCity; "Buy-from City") { }
            column(ShipToAddress; "Ship-to Address") { }
            column(ShipToAddress02; "Ship-to Address 2") { }
            column(ShipToCity; "Ship-to City") { }
            column(VATRegistrationNo; CustTable."VAT Registration No.") { }
            column(eInvoiceNo; eInvoiceNo) { }
            column(POSAReference; POSAReference) { }
            column(CACertificate; CACertificate) { }
            column(COCertificate; COCertificate) { }
            column(DeliveryNote; DeliveryNote) { }
            column(ContactName; ContactName) { }
            column(ContactPhone; ContactPhone) { }
            dataitem(SalesShipmentLine; "Return Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = filter('Item'));
                column(ItemNo; "No.") { }
                column(ItemName; ItemTable."BLTEC Item Name") { }
                column(UnitofMeasureCode; "Unit of Measure Code") { }
                column(LocationCode; "Location Code") { }
                column(LocationName; Location.Name) { }
                column(LocationContactName; Location.Contact) { }
                column(WhseOrderPinterName; WhseOrderPinterName) { }
                column(WhseKeeperName; WhseKeeperName) { }
                dataitem(ItemEntryRelation; "Item Entry Relation")
                {
                    DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                    DataItemTableView = where("Source Type" = const(6651));
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Item Entry No.");
                        DataItemTableView = where(Quantity = filter('<>0'));
                        column(LotNo; LotInfo) { }
                        column(Quantity; Quantity) { }
                        column(ExpirationDate; "Expiration Date") { }
                        column(ManufactureDate; LotTable."BLACC Manufacturing Date") { }
                        trigger OnAfterGetRecord()
                        begin
                            GenerateInterBarCode();
                            GetDataTable();
                        end;
                    }
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
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

    local procedure GenerateInterBarCode()
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := SalesShipmentHeader."Return Order No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodeTextBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    local procedure GetDataTable()
    var
        EInvoiceTbl: Query "ACC Sales Invoice Entry Qry";
        WhseStaff: Record "ACC Whse. Staff Shipment";
        SalesInvoiceLine: Record "Sales Invoice Line";
        ShipToAddres: Record "Ship-to Address";
        Delimiter: Text;
        LotNo: Text;
        LotPart: List of [Text];
        UserId: Text;
    begin
        if CompanyInfo.Get() then begin
        end;
        if CustTable.Get(SalesShipmentHeader."Sell-to Customer No.") then begin
        end;

        if ShipToAddres.Get(SalesShipmentHeader."Sell-to Customer No.", SalesShipmentHeader."Ship-to Code") then begin
            ContactName := ShipToAddres.Contact;
            ContactPhone := ShipToAddres."Phone No.";
        end else begin
            ContactName := SalesShipmentHeader."Ship-to Contact";
            ContactPhone := SalesShipmentHeader."Ship-to Phone No.";
        end;

        if Location.Get(SalesShipmentLine."Location Code") then begin
            LocationName := Location.Name;
        end;

        EInvoiceTbl.SetRange(DocumentNo, SalesShipmentHeader."No.");
        if EInvoiceTbl.Open() then begin
            while EInvoiceTbl.Read() do begin
                eInvoiceNo := EInvoiceTbl.eInvoiceNo;
                EInvoiceTbl.Close();
                break;
            end;
        end;
        if ItemTable.Get(SalesShipmentLine."No.") then begin
        end;
        //LotTable.SetAutoCalcFields("BLACC Expiration Date");
        if LotTable.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            //LotTable.CalcShelfLife();
            //LotTable.CalcManufacturingDate();
            LotNo := LotTable."Lot No.";
            Delimiter := '*';
            LotPart := LotNo.Split(Delimiter);
            if LotPart.Count() >= 2 then begin
                LotInfo := LotPart.Get(1);
            end else begin
                LotInfo := LotNo;
            end;
        end;
        UserId := UserId();
        WhseStaff.SetRange("Location Code", SalesShipmentLine."Location Code");
        //WhseStaff.SetRange("User ID", UserId);
        WhseStaff.SetRange("Active Print ", true);
        WhseStaff.SetAutoCalcFields("Whse. Keeper Name");
        WhseStaff.SetAutoCalcFields("Whse. Order Printer Name");
        if WhseStaff.FindFirst() then begin
            WhseOrderPinterName := WhseStaff."Whse. Order Printer Name";
            WhseKeeperName := WhseStaff."Whse. Keeper Name";
        end;
    end;

    var
        EncodeTextBarCode: Text;
        CompanyInfo: Record "Company Information";
        CustTable: Record Customer;
        ItemTable: Record Item;
        LotTable: Record "Lot No. Information";
        LotInfo: Text;
        Location: Record Location;
        LocationName: Text;
        ContactName: Text;
        ContactPhone: Text;
        eInvoiceNo: Text;
        POSAReference: Text;
        CACertificate: Text;
        COCertificate: Text;
        DeliveryNote: Text;
        ManufactureDate: Date;
        WhseOrderPinterName: Text;
        WhseKeeperName: Text;

}
