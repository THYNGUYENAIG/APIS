report 52006 "ACC PO Statistics Report"
{
    Caption = 'ACC Purchase Order Statistics Report - R52006';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52006_ACCPOStatisticsRpt.rdl';

    dataset
    {
        //Posted Purchase Invoice + Posted Purchase Credit Memo
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
            begin
                qACCVE.SetRange(Posting_Date_Filter, dsF, dsT);
                qACCVE.SetRange(Item_Ledger_Entry_Type_Filter, "Item Ledger Entry Type"::Purchase);
                if tsVendNo <> '' then qACCVE.SetRange(Source_No_Filter, tsVendNo);
                qACCVE.SetRange(Item_Charge_No_Filter, '');
                qACCVE.SetFilter(Document_Type_Filter, '%1 | %2', "Item Ledger Document Type"::"Purchase Invoice", "Item Ledger Document Type"::"Purchase Credit Memo");
                // qACCVE.SetRange(Document_No_Filter, 'PPI-00000040');
                if qACCVE.Open() then begin
                    while qACCVE.Read() do begin
                        ACCPOLTmp.Reset();
                        ACCPOLTmp.SetRange(No, qACCVE.Document_No);
                        ACCPOLTmp.SetRange("Item No", qACCVE.Item_No);
                        ACCPOLTmp.SetRange("Line No", qACCVE.Document_Line_No);
                        if ACCPOLTmp.FindFirst() then begin
                            case qACCVE.Document_Type of
                                "Item Ledger Document Type"::"Purchase Invoice":
                                    ModData(0, qACCVE);
                                "Item Ledger Document Type"::"Purchase Credit Memo":
                                    ModData(1, qACCVE);
                            end;
                        end else begin
                            case qACCVE.Document_Type of
                                "Item Ledger Document Type"::"Purchase Invoice":
                                    InitData(0, qACCVE);
                                "Item Ledger Document Type"::"Purchase Credit Memo":
                                    InitData(1, qACCVE);
                            end;
                        end;

                    end;
                    qACCVE.Close();
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);
            end;
        }

        //Main
        dataitem(ACCPOLTmp; "ACC PO Line Tmp")
        {
            UseTemporary = true;
            DataItemTableView = sorting(No, "Item No", "Line No");

            column(No; "No") { }
            column(Vend_No; "Buy-from Vendor No") { }
            column(Vend_Name; "Buy-from Vendor Name") { }
            column(Order_No; "Order No") { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Decl_No; "Declaration No") { }
            column(Currency_Code; "Currency Code") { }
            column(Document_Date; "Document Date") { }
            column(Posting_Date; "Posting Date") { }
            column(Due_Date; "Due Date") { }
            column(Exch_Rate; "Exch Rate") { }
            column(Item_No; "Item No") { }
            column(Item_Desc; Description) { }
            column(UOM; UOM) { }
            column(Qty; Quantity) { }
            column(Price; "Unit Price") { }
            column(Line_Amount; "Line Amount") { }
            column(Line_Amount_LCY; "Line Amount (LCY)") { }
            column(VAT_Amount; "Line VAT Amount") { }
            column(VAT_Amount_LCY; "Line VAT Amount (LCY)") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Vendor_Posting_Group; "Vendor Posting Group") { }
            column(Pay_to_Vendor_No; "Pay-to Vendor No") { }
            column(Vendor_Group; "Vendor Group") { }
            column(Vendor_Invoice_No; "Vendor Invoice No") { }
            column(Receive_No; "Receive No") { }
            column(Purchase_Code; "Purchase Code") { }
            column(Branch; Branch) { }
            column(Branch_Name; "Branch Name") { }
            column(Location_Code; "Location Code") { }
            column(Purchase_Code_Name; tfPurchCodeName) { }
            column(Add_Charge_Currency; "Add Charge Currency") { }
            column(Add_Charge; "Add Charge") { }
            column(Add_Charge_LCY; "Add Charge (LCY)") { }
            column(Fee_Currency; "Fee Currency") { }
            column(Fee; Fee) { }
            column(Fee_LCY; "Fee (LCY)") { }
            column(Freight_Currency; "Freight Currency") { }
            column(Freight; Freight) { }
            column(Freight_LCY; "Freight (LCY)") { }
            column(Import_Tax_Currency; "Import Tax Currency") { }
            column(Import_Tax; "Import Tax") { }
            column(Import_Tax_LCY; "Import Tax (LCY)") { }
            column(Sercharge_Currency; "Sercharge Currency") { }
            column(Sercharge; Sercharge) { }
            column(Sercharge_LCY; "Sercharge (LCY)") { }
            column(Transport_Currency; "Transport Currency") { }
            column(Transport; Transport) { }
            column(Transport_LCY; "Transport (LCY)") { }
            column(Dumping_Tax_Currency; "Dumping Tax Currency") { }
            column(Dumping_Tax; "Dumping Tax") { }
            column(Dumping_Tax_LCY; "Dumping Tax (LCY)") { }
            column(InsCharge_Currency; "InsCharge Currency") { }
            column(InsCharge; InsCharge) { }
            column(InsCharge_LCY; "InsCharge (LCY)") { }
            column(IscSurcharge_Currency; "Isc Surcharge Currency") { }
            column(IscSurcharge; "Isc Surcharge") { }
            column(IscSurcharge_LCY; "Isc Surcharge (LCY)") { }
            column(Lss_Currency; "Lss Currency") { }
            column(Lss; Lss) { }
            column(Lss_LCY; "Lss (LCY)") { }
            column(Vat_Currency; "Vat Currency") { }
            column(Vat; Vat) { }
            column(Vat_LCY; "Vat (LCY)") { }
            column(Security_Tax_Currency; "Security Tax Currency") { }
            column(Security_Tax; "Security Tax") { }
            column(Security_Tax_LCY; "Security Tax (LCY)") { }
            column(Total; Total) { }

            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }

            trigger OnAfterGetRecord()
            begin
                tfPurchCodeName := '';
                recSP.Reset();
                recSP.SetRange(Code, ACCPOLTmp."Purchase Code");
                if recSP.FindFirst() then tfPurchCodeName := recSP.Name;
            end;
        }
    }

    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(dsF; dsF)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date From';

                        trigger OnValidate();
                        begin
                            dsT := CalcDate('<CM>', dsF);
                        end;
                    }

                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date To';
                    }

                    field(tsVendNo; tsVendNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Vendor."No.";
                        Caption = 'Vendor No.';
                        // Enabled = bEdit;
                        // ShowMandatory = true;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsF := DMY2Date(5, 10, 2022);
            // dsT := DMY2Date(5, 10, 2022);
            // dsF := DMY2Date(3, 5, 2024);
            // dsT := DMY2Date(3, 5, 2024);
        end;
    }

    #region - ACC Func
    local procedure InitData(iviType: Integer; ivqACCVE: Query "ACC Value Entry Query")
    var
        recPIH: Record "Purch. Inv. Header";
        recPCMH: Record "Purch. Cr. Memo Hdr.";
        recPIL: Record "Purch. Inv. Line";
        recPCML: Record "Purch. Cr. Memo Line";
        recI: Record Item;
        recV: Record Vendor;
        lstDim: List of [Text];
        tInv: Text;
        tItemChargeNo: Text;
        // recBLTECIE: Record "BLTEC Import Entry";
        tCurrency: Text;
        decExchRateCharge: Decimal;
        lstInv: List of [Text];
        recPL: Record "Purchase Line";
    begin
        recI.Reset();
        recI.Get(ivqACCVE.Item_No);

        ACCPOLTmp.Init();

        ACCPOLTmp.No := ivqACCVE.Document_No;
        ACCPOLTmp."Item No" := ivqACCVE.Item_No;
        ACCPOLTmp."Line No" := ivqACCVE.Document_Line_No;
        ACCPOLTmp.Description := recI.Description;
        ACCPOLTmp."Posting Date" := ivqACCVE.Posting_Date;

        if recI.Type = "Item Type"::Service then begin
            ACCPOLTmp.Quantity := 0;
        end else begin
            ACCPOLTmp.Quantity := ivqACCVE.InvQtySum;
        end;

        ACCPOLTmp."Line Amount (LCY)" := ivqACCVE.CostAmtActSum;

        InitCharge();
        case iviType of
            0:
                begin
                    recPIH.Reset();
                    recPIH.SetRange("No.", ivqACCVE.Document_No);
                    if recPIH.FindFirst() then begin
                        recV.Reset();
                        recV.Get(recPIH."Buy-from Vendor No.");

                        ACCPOLTmp."Vendor Posting Group" := recV."Vendor Posting Group";
                        ACCPOLTmp."Vendor Group" := recV."BLACC Vendor Group";
                        ACCPOLTmp."Buy-from Vendor No" := recPIH."Buy-from Vendor No.";
                        ACCPOLTmp."Buy-from Vendor Name" := recPIH."Buy-from Vendor Name";
                        ACCPOLTmp."Pay-to Vendor No" := recPIH."Pay-to Vendor No.";
                        // ACCPOLTmp."Order No" := recPIH."Order No.";
                        ACCPOLTmp."Shipment Method Code" := recPIH."Shipment Method Code";
                        ACCPOLTmp."Payment Terms Code" := recPIH."Payment Terms Code";
                        ACCPOLTmp."Vendor Invoice No" := recPIH."Vendor Invoice No.";
                        ACCPOLTmp."Purchase Code" := recPIH."Purchaser Code";
                        ACCPOLTmp."Currency Code" := recPIH."Currency Code";
                        ACCPOLTmp."Document Date" := recPIH."Document Date";
                        ACCPOLTmp."Due Date" := recPIH."Due Date";
                        if recPIH."Currency Factor" <> 0 then ACCPOLTmp."Exch Rate" := 1 / recPIH."Currency Factor" else ACCPOLTmp."Exch Rate" := 1;
                    end;

                    recPIL.Reset();
                    recPIL.SetRange("Document No.", ivqACCVE.Document_No);
                    recPIL.SetRange("Line No.", ivqACCVE.Document_Line_No);
                    recPIL.SetRange("No.", ivqACCVE.Item_No);
                    recPIL.SetRange(Type, "Purchase Line Type"::Item);
                    if recPIL.FindFirst() then begin
                        if recI.Type = "Item Type"::Service then begin
                            ACCPOLTmp.Description := recPIL.Description;
                        end;

                        lstDim := cuACCGP.GetAllDimensionCodeValue(recPIL."Dimension Set ID");

                        ACCPOLTmp."Order No" := recPIL."Order No.";
                        ACCPOLTmp."Order Line No" := recPIL."Order Line No.";
                        ACCPOLTmp.Branch := lstDim.Get(1);
                        ACCPOLTmp."Item Category Code" := lstDim.Get(7);
                        ACCPOLTmp.UOM := recPIL."Unit of Measure Code";
                        ACCPOLTmp."Location Code" := recPIL."Location Code";
                        ACCPOLTmp."Unit Price" := recPIL."Direct Unit Cost";
                        ACCPOLTmp."Item Category Code" := cuACCGP.GetDimensionCodeValue(recPIL."Dimension Set ID", 'BUSINESSUNIT');
                        ACCPOLTmp."Line Amount" := recPIL."Line Amount";
                        ACCPOLTmp."Line Amount Include VAT" := recPIL."Amount Including VAT";
                        ACCPOLTmp."Line VAT Amount" := recPIL."Amount Including VAT" - recPIL."Line Amount";
                        ACCPOLTmp."Line VAT Amount (LCY)" := ACCPOLTmp."Line VAT Amount" * ACCPOLTmp."Exch Rate";

                        recILE.Reset();
                        recILE.SetRange("Entry No.", ivqACCVE.Item_Ledger_Entry_No);
                        if recILE.FindFirst() then begin
                            ACCPOLTmp."Declaration No" := recILE."BLTEC Customs Declaration No.";
                            decfVatLCY := SetVATAmount(ivqACCVE.InvQtySum, recPIL."Order No.", recPIL."Order Line No.", recILE."BLTEC Customs Declaration No.");
                            /*
                            recPRH.Reset();
                            recPRH.SetRange("No.", recILE."Document No.");
                            if recPRH.FindFirst() then begin
                                // BLTEC Customs Declaration
                                recBLTECCD.Reset();
                                recBLTECCD.SetRange("BLTEC Customs Declaration No.", recILE."BLTEC Customs Declaration No.");
                                if recBLTECCD.FindFirst() then begin
                                    recBLTECCDL.Reset();
                                    recBLTECCDL.SetRange("Document No.", recBLTECCD."Document No.");
                                    recBLTECCDL.SetRange("Source Document No.", recPRH."Order No.");
                                    recBLTECCDL.SetRange("Source Document Line No.", recILE."Document Line No.");
                                    if recBLTECCDL.FindFirst() then begin
                                        tfVatCurrency := recBLTECCDL."Currency Code";
                                        decfVatLCY := recBLTECCDL."BLTEC VAT Amount (VND)";
                                        if tfVatCurrency <> '' then
                                            decfVat := cuACCGP.Divider(decfVatLCY, ACCPOLTmp."Exch Rate")
                                    end;
                                end;
                            end;
                            */
                        end;

                        // recPL.Reset();
                        // recPL.SetRange("Document No.", recPIL."Order No.");
                        // recPL.SetRange("Line No.", recPIL."Order Line No.");
                        // recPL.SetRange("No.", recPIL."No.");
                        // recPL.SetRange(Type, "Purchase Line Type"::Item);
                        // recPL.SetFilter("BLTEC Customs Declaration No.", '<>%1', '');
                        // if recPL.FindFirst() then begin
                        //     ACCPOLTmp."Declaration No" := recPL."BLTEC Customs Declaration No.";
                        //     // BLTEC Customs Declaration
                        //     recBLTECCD.Reset();
                        //     recBLTECCD.SetRange("BLTEC Customs Declaration No.", recPL."BLTEC Customs Declaration No.");
                        //     if recBLTECCD.FindFirst() then begin
                        //         recBLTECCDL.Reset();
                        //         recBLTECCDL.SetRange("Document No.", recBLTECCD."Document No.");
                        //         recBLTECCDL.SetRange("Source Document No.", recPL."Document No.");
                        //         recBLTECCDL.SetRange("Source Document Line No.", recPL."Line No.");
                        //         if recBLTECCDL.FindFirst() then begin
                        //             tfVatCurrency := recBLTECCDL."Currency Code";
                        //             // decfVatLCY := recBLTECCDL."BLTEC VAT Import Goods";
                        //             decfVatLCY := recBLTECCDL."BLTEC VAT Amount (VND)";
                        //             if tfVatCurrency <> '' then
                        //                 decfVat := cuACCGP.Divider(decfVatLCY, ACCPOLTmp."Exch Rate")
                        //             else
                        //                 decfVat := recGLE.Amount;
                        //         end;
                        //     end;
                        // end;

                        recVE.Reset();
                        recVE.SetRange("Item Ledger Entry No.", ivqACCVE.Item_Ledger_Entry_No);
                        recVE.SetRange("Item No.", ivqACCVE.Item_No);
                        recVE.SetRange("Document Type", "Item Ledger Document Type"::"Purchase Receipt");
                        if recVE.FindFirst() then ACCPOLTmp."Receive No" := recVE."Document No.";
                    end;

                    recVE.Reset();
                    recVE.SetRange("Item Ledger Entry No.", ivqACCVE.Item_Ledger_Entry_No);
                    recVE.SetRange("Item No.", ivqACCVE.Item_No);
                    recVE.SetFilter("Item Charge No.", '<> %1', '');
                    if recVE.FindSet() then begin
                        repeat
                            tItemChargeNo := recVE."Item Charge No.";

                            tCurrency := '';
                            decExchRateCharge := 0;
                            recPIH.Reset();
                            recPIH.SetRange("No.", recVE."Document No.");
                            if recPIH.FindFirst() then begin
                                tCurrency := recPIH."Currency Code";
                                decExchRateCharge := cuACCGP.Divider(1, recPIH."Currency Factor");
                            end;

                            SetCharge(tItemChargeNo, tCurrency, decExchRateCharge);
                        until recVE.Next() < 1;
                    end;
                end;
            1:
                begin
                    recPCMH.Reset();
                    recPCMH.SetRange("No.", ivqACCVE.Document_No);
                    if recPCMH.FindFirst() then begin
                        recV.Reset();
                        recV.Get(recPCMH."Buy-from Vendor No.");

                        ACCPOLTmp."Vendor Posting Group" := recV."Vendor Posting Group";
                        ACCPOLTmp."Vendor Group" := recV."BLACC Vendor Group";
                        ACCPOLTmp."Buy-from Vendor No" := recPCMH."Buy-from Vendor No.";
                        ACCPOLTmp."Buy-from Vendor Name" := recPCMH."Buy-from Vendor Name";
                        ACCPOLTmp."Pay-to Vendor No" := recPCMH."Pay-to Vendor No.";
                        // ACCPOLTmp."Order No" := recPCMH."Return Order No.";
                        ACCPOLTmp."Shipment Method Code" := recPCMH."Shipment Method Code";
                        ACCPOLTmp."Payment Terms Code" := recPCMH."Payment Terms Code";
                        ACCPOLTmp."Purchase Code" := recPCMH."Purchaser Code";
                        ACCPOLTmp."Currency Code" := recPCMH."Currency Code";
                        ACCPOLTmp."Document Date" := recPCMH."Document Date";
                        ACCPOLTmp."Due Date" := recPCMH."Due Date";
                        if recPCMH."Currency Factor" <> 0 then ACCPOLTmp."Exch Rate" := 1 / recPCMH."Currency Factor" else ACCPOLTmp."Exch Rate" := 1;
                        ACCPOLTmp."Vendor Invoice No" := recPCMH."Vendor Cr. Memo No.";
                    end;

                    recPCML.Reset();
                    recPCML.SetRange("Document No.", ivqACCVE.Document_No);
                    recPCML.SetRange("Line No.", ivqACCVE.Document_Line_No);
                    recPCML.SetRange("No.", ivqACCVE.Item_No);
                    if recPCML.FindFirst() then begin
                        if recI.Type = "Item Type"::Service then begin
                            ACCPOLTmp.Description := recPCML.Description;
                        end;

                        lstDim := cuACCGP.GetAllDimensionCodeValue(recPCML."Dimension Set ID");

                        ACCPOLTmp.Branch := lstDim.Get(1);
                        ACCPOLTmp."Item Category Code" := lstDim.Get(7);
                        ACCPOLTmp.UOM := recPCML."Unit of Measure Code";
                        ACCPOLTmp."Location Code" := recPCML."Location Code";
                        ACCPOLTmp."Unit Price" := recPCML."Direct Unit Cost";
                        ACCPOLTmp."Item Category Code" := cuACCGP.GetDimensionCodeValue(recPCML."Dimension Set ID", 'BUSINESSUNIT');
                        ACCPOLTmp."Line Amount" := -recPCML."Line Amount";
                        ACCPOLTmp."Line Amount Include VAT" := -recPCML."Amount Including VAT";
                        ACCPOLTmp."Line VAT Amount" := -recPCML."Amount Including VAT" + recPCML."Line Amount";
                        ACCPOLTmp."Line VAT Amount (LCY)" := ACCPOLTmp."Line VAT Amount" * ACCPOLTmp."Exch Rate";
                        ACCPOLTmp."Order No" := recPCML."Order No.";

                        recPWSL.Reset();
                        recPWSL.SetRange("Source No.", recPCML."Order No.");
                        recPWSL.SetRange("Item No.", recPCML."No.");
                        recPWSL.SetRange("Source Line No.", recPCML."Order Line No.");
                        if recPWSL.FindFirst() then ACCPOLTmp."Receive No" := recPWSL."No.";
                    end;

                    recVE.Reset();
                    recVE.SetRange("Item Ledger Entry No.", ivqACCVE.Item_Ledger_Entry_No);
                    recVE.SetRange("Item No.", ivqACCVE.Item_No);
                    recVE.SetFilter("Item Charge No.", '<> %1', '');
                    if recVE.FindSet() then begin
                        repeat
                            tItemChargeNo := recVE."Item Charge No.";

                            tCurrency := '';
                            decExchRateCharge := 0;
                            recPCMH.Reset();
                            recPCMH.SetRange("No.", recVE."Document No.");
                            if recPCMH.FindFirst() then begin
                                tCurrency := recPCMH."Currency Code";
                                decExchRateCharge := cuACCGP.Divider(1, recPCMH."Currency Factor");
                            end;

                            SetCharge(tItemChargeNo, tCurrency, decExchRateCharge);
                        until recVE.Next() < 1;
                    end;
                end;
        end;

        ACCPOLTmp."Add Charge Currency" := tfAddChargeCurrency;
        ACCPOLTmp."Add Charge" := decfAddCharge;
        ACCPOLTmp."Add Charge (LCY)" := decfAddChargeLCY;
        ACCPOLTmp."Fee Currency" := tfFeeCurrency;
        ACCPOLTmp."Fee" := decfFee;
        ACCPOLTmp."Fee (LCY)" := decfFeeLCY;
        ACCPOLTmp."Freight Currency" := tfFreightCurrency;
        ACCPOLTmp."Freight" := decfFreight;
        ACCPOLTmp."Freight (LCY)" := decfFreightLCY;
        ACCPOLTmp."Import Tax Currency" := tfImportTaxCurrency;
        ACCPOLTmp."Import Tax" := decfImportTax;
        ACCPOLTmp."Import Tax (LCY)" := decfImportTaxLCY;
        ACCPOLTmp."SerCharge Currency" := tfSerChargeCurrency;
        ACCPOLTmp."SerCharge" := decfSerCharge;
        ACCPOLTmp."SerCharge (LCY)" := decfSerChargeLCY;
        ACCPOLTmp."Transport Currency" := tfTransportCurrency;
        ACCPOLTmp."Transport" := decfTransport;
        ACCPOLTmp."Transport (LCY)" := decfTransportLCY;
        ACCPOLTmp."Dumping Tax Currency" := tfDumpingTaxCurrency;
        ACCPOLTmp."Dumping Tax" := decfDumpingTax;
        ACCPOLTmp."Dumping Tax (LCY)" := decfDumpingTaxLCY;
        ACCPOLTmp."InsCharge Currency" := tfInsChargeCurrency;
        ACCPOLTmp."InsCharge" := decfInsCharge;
        ACCPOLTmp."InsCharge (LCY)" := decfInsChargeLCY;
        ACCPOLTmp."Isc SurCharge Currency" := tfIscSurChargeCurrency;
        ACCPOLTmp."Isc SurCharge" := decfIscSurCharge;
        ACCPOLTmp."Isc SurCharge (LCY)" := decfIscSurChargeLCY;
        ACCPOLTmp."Lss Currency" := tfLssCurrency;
        ACCPOLTmp."Lss" := decfLss;
        ACCPOLTmp."Lss (LCY)" := decfLssLCY;
        ACCPOLTmp."Vat Currency" := tfVatCurrency;
        ACCPOLTmp."Vat" := decfVat;
        ACCPOLTmp."Vat (LCY)" := decfVatLCY;
        ACCPOLTmp."Security Tax Currency" := tfSecurityTaxCurrency;
        ACCPOLTmp."Security Tax" := decfSecurityTax;
        ACCPOLTmp."Security Tax (LCY)" := decfSecurityTaxLCY;

        ACCPOLTmp.Total := decfFeeLCY + decfFreightLCY + decfImportTaxLCY + decfSerChargeLCY + decfTransportLCY
                        + decfDumpingTaxLCY + decfInsChargeLCY + decfIscSurChargeLCY + decfLssLCY + decfAddChargeLCY;

        ACCPOLTmp.Insert();
    end;

    local procedure ModData(iviType: Integer; ivqACCVE: Query "ACC Value Entry Query")
    var
        recPIH: Record "Purch. Inv. Header";
        recPCMH: Record "Purch. Cr. Memo Hdr.";
        recI: Record Item;
        tItemChargeNo: Text;
        tCurrency: Text;
        decExchRateCharge: Decimal;
    begin
        recI.Reset();
        recI.Get(ivqACCVE.Item_No);

        if recI.Type = "Item Type"::Service then begin
            ACCPOLTmp.Quantity := 0;
        end else begin
            ACCPOLTmp.Quantity += ivqACCVE.InvQtySum;
        end;

        ACCPOLTmp."Line Amount (LCY)" += ivqACCVE.CostAmtActSum;

        InitCharge();
        case iviType of
            0:
                begin
                    recVE.Reset();
                    recVE.SetRange("Item Ledger Entry No.", ivqACCVE.Item_Ledger_Entry_No);
                    recVE.SetRange("Item No.", ivqACCVE.Item_No);
                    recVE.SetFilter("Item Charge No.", '<> %1', '');
                    if recVE.FindSet() then begin
                        repeat
                            tItemChargeNo := recVE."Item Charge No.";

                            tCurrency := '';
                            decExchRateCharge := 0;
                            recPIH.Reset();
                            recPIH.SetRange("No.", recVE."Document No.");
                            if recPIH.FindFirst() then begin
                                tCurrency := recPIH."Currency Code";
                                decExchRateCharge := cuACCGP.Divider(1, recPIH."Currency Factor");
                            end;

                            SetCharge(tItemChargeNo, tCurrency, decExchRateCharge);
                        until recVE.Next() < 1;
                    end;
                end;
            1:
                begin
                    recVE.Reset();
                    recVE.SetRange("Item Ledger Entry No.", ivqACCVE.Item_Ledger_Entry_No);
                    recVE.SetRange("Item No.", ivqACCVE.Item_No);
                    recVE.SetFilter("Item Charge No.", '<> %1', '');
                    if recVE.FindSet() then begin
                        repeat
                            tItemChargeNo := recVE."Item Charge No.";

                            tCurrency := '';
                            decExchRateCharge := 0;
                            recPCMH.Reset();
                            recPCMH.SetRange("No.", recVE."Document No.");
                            if recPCMH.FindFirst() then begin
                                tCurrency := recPCMH."Currency Code";
                                decExchRateCharge := cuACCGP.Divider(1, recPCMH."Currency Factor");
                            end;

                            SetCharge(tItemChargeNo, tCurrency, decExchRateCharge);
                        until recVE.Next() < 1;
                    end;
                end;
        end;

        decfVatLCY := SetVATAmount(ACCPOLTmp.Quantity, ACCPOLTmp."Order No", ACCPOLTmp."Order Line No", ACCPOLTmp."Declaration No");

        ACCPOLTmp."Add Charge" += decfAddCharge;
        ACCPOLTmp."Add Charge (LCY)" += decfAddChargeLCY;
        ACCPOLTmp."Fee" += decfFee;
        ACCPOLTmp."Fee (LCY)" += decfFeeLCY;
        ACCPOLTmp."Freight" += decfFreight;
        ACCPOLTmp."Freight (LCY)" += decfFreightLCY;
        ACCPOLTmp."Import Tax" += decfImportTax;
        ACCPOLTmp."Import Tax (LCY)" += decfImportTaxLCY;
        ACCPOLTmp."SerCharge" += decfSerCharge;
        ACCPOLTmp."SerCharge (LCY)" += decfSerChargeLCY;
        ACCPOLTmp."Transport" += decfTransport;
        ACCPOLTmp."Transport (LCY)" += decfTransportLCY;
        ACCPOLTmp."Dumping Tax" += decfDumpingTax;
        ACCPOLTmp."Dumping Tax (LCY)" += decfDumpingTaxLCY;
        ACCPOLTmp."InsCharge" += decfInsCharge;
        ACCPOLTmp."InsCharge (LCY)" += decfInsChargeLCY;
        ACCPOLTmp."Isc SurCharge" += decfIscSurCharge;
        ACCPOLTmp."Isc SurCharge (LCY)" += decfIscSurChargeLCY;
        ACCPOLTmp."Lss" += decfLss;
        ACCPOLTmp."Lss (LCY)" += decfLssLCY;
        ACCPOLTmp."Vat" += decfVat;
        ACCPOLTmp."Vat (LCY)" := decfVatLCY;
        ACCPOLTmp."Security Tax" += decfSecurityTax;
        ACCPOLTmp."Security Tax (LCY)" += decfSecurityTaxLCY;

        ACCPOLTmp.Total += decfFeeLCY + decfFreightLCY + decfImportTaxLCY + decfSerChargeLCY + decfTransportLCY
                        + decfDumpingTaxLCY + decfInsChargeLCY + decfIscSurChargeLCY + decfLssLCY + decfAddChargeLCY;

        ACCPOLTmp.Modify();
    end;

    local procedure InitCharge()
    begin
        tfAddChargeCurrency := '';
        decfAddCharge := 0;
        decfAddChargeLCY := 0;
        tfFeeCurrency := '';
        decfFee := 0;
        decfFeeLCY := 0;
        tfFreightCurrency := '';
        decfFreight := 0;
        decfFreightLCY := 0;
        tfImportTaxCurrency := '';
        decfImportTax := 0;
        decfImportTaxLCY := 0;
        tfSerChargeCurrency := '';
        decfSerCharge := 0;
        decfSerChargeLCY := 0;
        tfTransportCurrency := '';
        decfTransport := 0;
        decfTransportLCY := 0;
        tfDumpingTaxCurrency := '';
        decfDumpingTax := 0;
        decfDumpingTaxLCY := 0;
        tfInsChargeCurrency := '';
        decfInsCharge := 0;
        decfInsChargeLCY := 0;
        tfIscSurChargeCurrency := '';
        decfIscSurCharge := 0;
        decfIscSurChargeLCY := 0;
        tfLssCurrency := '';
        decfLss := 0;
        decfLssLCY := 0;
        tfVatCurrency := '';
        decfVat := 0;
        decfVatLCY := 0;
        tfSecurityTaxCurrency := '';
        decfSecurityTaxLCY := 0;
        decfSecurityTax := 0;
        decfTotal := 0;
    end;

    local procedure SetCharge(ivtItemChargeNo: Text; ivtCurrency: Text; ivdecExchRate: Decimal)
    begin
        case ivtItemChargeNo of
            'ADDCHARGE':
                begin
                    tfAddChargeCurrency := ivtCurrency;
                    decfAddChargeLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfAddCharge += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfAddCharge += recVE."Cost Amount (Actual)";
                end;
            'FEE':
                begin
                    tfFeeCurrency := ivtCurrency;
                    decfFeeLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfFee += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfFee += recVE."Cost Amount (Actual)";
                end;
            'FREIGHT':
                begin
                    tfFreightCurrency := ivtCurrency;
                    decfFreightLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfFreight += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfFreight += recVE."Cost Amount (Actual)";
                end;
            'IMPORT_TAX':
                begin
                    tfImportTaxCurrency := ivtCurrency;
                    decfImportTaxLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfImportTax += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfImportTax += recVE."Cost Amount (Actual)";
                end;
            'SERCHARGE':
                begin
                    tfSerChargeCurrency := ivtCurrency;
                    decfSerChargeLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfSerCharge += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfSerCharge += recVE."Cost Amount (Actual)";
                end;
            'TRANSPORT':
                begin
                    tfTransportCurrency := ivtCurrency;
                    decfTransportLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfTransport += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfTransport += recVE."Cost Amount (Actual)";
                end;
            'THUEPHAGIA':
                begin
                    tfDumpingTaxCurrency := ivtCurrency;
                    decfDumpingTaxLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfDumpingTax += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfDumpingTax += recVE."Cost Amount (Actual)";
                end;
            'INSCHARGE':
                begin
                    tfInsChargeCurrency := ivtCurrency;
                    decfInsChargeLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfInsCharge += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfInsCharge += recVE."Cost Amount (Actual)";
                end;
            'ISCSURCHAR':
                begin
                    tfIscSurChargeCurrency := ivtCurrency;
                    decfIscSurChargeLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfIscSurCharge += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfIscSurCharge += recVE."Cost Amount (Actual)";
                end;
            'LSS':
                begin
                    tfLssCurrency := ivtCurrency;
                    decfLssLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfLss += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfLss += recVE."Cost Amount (Actual)";
                end;
            // 'VAT':
            //     begin
            //         tfVatCurrency := ivtCurrency;
            //         decfVatLCY += recVE."Cost Amount (Actual)";
            //         if ivtCurrency <> '' then
            //             decfVat += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
            //         else
            //             decfVat += recVE."Cost Amount (Actual)";
            //     end;
            'TUVE_TAX':
                begin
                    tfSecurityTaxCurrency := ivtCurrency;
                    decfSecurityTaxLCY += recVE."Cost Amount (Actual)";
                    if ivtCurrency <> '' then
                        decfSecurityTax += cuACCGP.Divider(recVE."Cost Amount (Actual)", ivdecExchRate)
                    else
                        decfSecurityTax += recVE."Cost Amount (Actual)";
                end;
        end;
    end;
    #endregion
    local procedure SetVATAmount(Quantity: Decimal; DocumentNo: Code[20]; DocumentLine: Integer; CustomsDeclarationNo: Code[35]): Decimal
    var
        VATLedgerEntry: Query "ACC Import VAT Ledger Entry";
        VATCustomsEntry: Query "ACC Customs VAT Entry";
        CustomsLine: Record "BLTEC Customs Decl. Line";
        CustomsVATAmount: Decimal;
        Rate01: Decimal;
        Rate02: Decimal;
    begin
        if Quantity = 0 then
            exit(0);
        VATCustomsEntry.SetRange(CustomsDeclarationNo, CustomsDeclarationNo);
        if VATCustomsEntry.Open() then begin
            while VATCustomsEntry.Read() do begin
                CustomsVATAmount := VATCustomsEntry.VATAmountVND;
            end;
            VATCustomsEntry.Close();
        end;
        if CustomsVATAmount = 0 then
            exit(0);
        CustomsLine.Reset();
        CustomsLine.SetRange("Source Document No.", DocumentNo);
        CustomsLine.SetRange("Source Document Line No.", DocumentLine);
        if CustomsLine.FindFirst() then begin
            Rate01 := CustomsLine."BLTEC VAT Amount (VND)" / CustomsVATAmount;
            Rate02 := (Quantity * CustomsLine."Direct Unit Cost (LCY)") / CustomsLine."Line Amount (LCY)";
        end;

        VATLedgerEntry.SetFilter(ExternalDocumentNo, StrSubstNo('*%1', CustomsDeclarationNo));
        if VATLedgerEntry.Open() then begin
            while VATLedgerEntry.Read() do begin
                exit(VATLedgerEntry.Amount * Rate01 * Rate02);
            end;
            VATLedgerEntry.Close();
        end;
        exit(0);
    end;
    //Global
    var
        dsF: Date;
        dsT: Date;
        tsVendNo: Text;
        qACCVE: Query "ACC Value Entry Query";
        cuACCGP: Codeunit "ACC General Process";
        tfPurchCodeName: Text;
        recSP: Record "Salesperson/Purchaser";
        recVE: Record "Value Entry";
        tfAddChargeCurrency: Text;
        decfAddCharge: Decimal;
        decfAddChargeLCY: Decimal;
        tfFeeCurrency: Text;
        decfFee: Decimal;
        decfFeeLCY: Decimal;
        tfFreightCurrency: Text;
        decfFreight: Decimal;
        decfFreightLCY: Decimal;
        tfImportTaxCurrency: Text;
        decfImportTax: Decimal;
        decfImportTaxLCY: Decimal;
        tfSerChargeCurrency: Text;
        decfSerCharge: Decimal;
        decfSerChargeLCY: Decimal;
        tfTransportCurrency: Text;
        decfTransport: Decimal;
        decfTransportLCY: Decimal;
        tfDumpingTaxCurrency: Text;
        decfDumpingTax: Decimal;
        decfDumpingTaxLCY: Decimal;
        tfInsChargeCurrency: Text;
        decfInsCharge: Decimal;
        decfInsChargeLCY: Decimal;
        tfIscSurChargeCurrency: Text;
        decfIscSurCharge: Decimal;
        decfIscSurChargeLCY: Decimal;
        tfLssCurrency: Text;
        decfLss: Decimal;
        decfLssLCY: Decimal;
        tfVatCurrency: Text;
        decfVat: Decimal;
        decfVatLCY: Decimal;
        tfSecurityTaxCurrency: Text;
        decfSecurityTaxLCY: Decimal;
        decfSecurityTax: Decimal;
        decfTotal: Decimal;
        // recGLE: Record "G/L Entry";
        recBLTECCD: Record "BLTEC Customs Declaration";
        recBLTECCDL: Record "BLTEC Customs Decl. Line";
        // recPHA: Record "Purchase Header Archive";
        recPWSL: Record "Posted Whse. Shipment Line";
        recILE: Record "Item Ledger Entry";
        recPRH: Record "Purch. Rcpt. Header";
}