report 51031 "ACC Purch Contract US Report 1"
{
    ApplicationArea = All;
    Caption = 'APIS Purchase Contract US Report - R51031 (Normal)';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51031.ACCPurchContractUSReport.rdl';
    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No; "No.") { }
            column(BuyFromVendorNo; "Buy-from Vendor No.") { }
            column(BuyFromVendorName; "Buy-from Vendor Name") { }
            column(BuyFromAddress; "Buy-from Address") { }
            column(BuyFromAddress02; "Buy-from Address 2") { }
            column(BuyFromCity; "Buy-from City") { }
            column(VNAddress; VendTable."BLACC VN Address") { }
            column(BuyToVATRegistration; VendTable."VAT Registration No.") { }
            column(BuyToPhone; VendTable."Phone No.") { }
            column(BuyToFax; VendTable."Fax No.") { }
            column(VendorReference; "BLTEC Contract No.") { }
            column(Incoterms; Incoterms) { }
            column(ShipmentMode; "Transport Method") { }
            column(ShipmentTerm; ShipmentTerm) { }
            column(PortOfDischarge; PortOfDischarge) { }
            column(BuyToContactName; VendContact.Name) { }
            column(BuyToContactMobile; VendContact."Phone No.") { }
            column(BuyToBeneficiaryName; VendBankAccount."BLACC Beneficiary") { } // Chưa xác định
            column(BuyToBeneficiaryAddress; VendBankAccount."BLACC Beneficiary Address") { } // Chưa xác định
            column(BuyToBankName; VendBankAccount.Name) { }
            column(BuyToBankAccount; VendBankAccount."Bank Account No.") { }
            column(BuyToIBAN; VendBankAccount.IBAN) { }
            column(BuyToBankAddress; VendBankAccount.Address) { }
            column(BuyToBankAddress02; VendBankAccount."Address 2") { }
            column(BuyToBankCity; VendBankAccount.City) { }
            column(BuyToBankSwiftCode; VendBankAccount."SWIFT Code") { }
            column(BuyToBankACNo; BuyToBankACNo) { }
            column(BuyToACNo; VendBankAccount."SWIFT Code") { }
            column(PaytoVendorNo; "Pay-to Vendor No.") { }
            column(PaytoName; "Pay-to Name") { }
            column(PaytoAddress; "Pay-to Address") { }
            column(PaytoCountryRegionCode; "Pay-to Country/Region Code") { }
            column(ShipToName; "Ship-to Name") { }
            column(ShipToAddress; "Ship-to Address" + "Ship-to Address 2") { }
            column(ShipToPhoneNo; "Ship-to Phone No.") { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(PaymentTermsName; PaymentTerm.Description) { }
            column(PostingDate; "Posting Date") { }
            column(DocumentDate; "Document Date") { }
            column(OrderDate; "Order Date") { }
            column(CurrencyCode; "Currency Code") { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress02; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyFax; CompanyInfo."Fax No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyVATRegistration; CompanyInfo."VAT Registration No.") { }
            column(CompanyBankName; CompanyInfo."Bank Name") { }
            column(CompanyBankAccount; CompanyInfo."Bank Account No.") { }
            column(CompanyContactName; Purchaser.Name) { }
            column(CompanyContactMobile; Purchaser."Phone No.") { }
            column(CompanyBillNameUSD; CompanyBillNameUSD) { }
            column(CompanyBillAddressUSD; CompanyBillAddressUSD) { }
            column(CompanyBusinessNameUSD; CompanyBusinessNameUSD) { }
            column(CompanyBusinessAddressUSD; CompanyBusinessAddressUSD) { }
            column(LineAmountInWords; LineAmountInWords) { }
            column(OtherTermsAndConditions; OtherTermsAndConditions) { }
            column(DocumentsAndProductAgeRequired; DocumentsAndProductAgeRequired) { }
            column(OtherInformation; OtherInformation) { }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ItemNo; "No.") { }
                column(Description; Description) { }
                column(ItemPurchName; ItemTable."BLACC Purchase Name") { }
                column(ItemCustomerNo; ItemTable."BLACC Item Customer No.") { }
                column(UnitofMeasureCode; UnitofMeasureCode) { }
                column(Quantity; Quantity) { }
                column(UnitCost; "Direct Unit Cost") { }
                column(UnitCostLCY; "Unit Cost (LCY)") { }
                column(LineAmount; "Line Amount") { }
                column(LocationCode; "Location Code") { }
                column(VAT; "VAT %") { }
                column(ETDDate; "BLTEC ETD Request Date") { }
                column(ShelfLifeDescription; ShelfLifeDescription) { }
                column(Tolerance; Tolerance) { }
                column(ETDRequestDate; "BLTEC ETD Request Date") { }
                trigger OnAfterGetRecord()
                begin
                    GetDataTable();
                    AmountInWords();
                end;
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

    local procedure GetDataTable()
    var
        DocContract: Record "ACC Contract Document";
        ItemVoucher: Query "ACC Product Doc. Req. Query";
        AreaTable: Record "Area";
        EntryPoint: Record "Entry/Exit Point";
        OverReceipt: Record "Over-Receipt Code";
        CompanyAddress: Record "BLACC Company Address";
        TransactionType: Record "Transaction Type";
        ShelfLife: Record "BLACC Shelf Life Setup";
        UnitTable: Record "Unit of Measure";
        ItemDocument: Text;
        PartialShipment: Text;
    begin
        if PurchaseHeader."Transaction Type" = '' then begin
            PartialShipment := 'not allowed';
        end else begin
            if TransactionType.Get(PurchaseHeader."Transaction Type") then begin
                PartialShipment := TransactionType.Description;
            end;
        end;

        ShipmentTerm := PurchaseHeader."Shipment Method Code";
        if AreaTable.Get(PurchaseHeader."Area") then begin
            ShipmentTerm := ShipmentTerm + ' - ' + AreaTable.Text;
        end;

        if EntryPoint.Get(PurchaseHeader."Entry Point") then begin
            PortOfDischarge := EntryPoint.Description;
        end;

        if OverReceipt.Get(PurchaseLine."Over-Receipt Code") then begin
            Tolerance := OverReceipt."Over-Receipt Tolerance %";
        end;

        if CompanyInfo.Get() then begin
            CompanyInfo.CalcFields(Picture);
        end;
        if CompanyAddress.Get('ENGLISH', 'INVCONT') then begin
            CompanyBillNameUSD := CompanyAddress.Name;
            CompanyBillAddressUSD := CompanyAddress.Address + CompanyAddress."Ship-to Address 2";
        end else begin
            CompanyBillNameUSD := 'ASIA CHEMICAL CORPORATION';
            CompanyBillAddressUSD := 'Lot K 4B, Le Minh Xuan Industrial Zone, Road No.4, Le Minh Xuan Commune, Binh Chanh Dist., Ho Chi Minh City, Vietnam';
        end;
        if DocContract.Get(PurchaseHeader."ACC Original Document") then begin
            CompanyBusinessNameUSD := DocContract."Doc Name";
            CompanyBusinessAddressUSD := DocContract."Doc Address";
        end else begin
            if CompanyAddress.Get('ENGLISH', 'BUSCONT') then begin
                CompanyBusinessNameUSD := CompanyAddress.Name;
                CompanyBusinessAddressUSD := CompanyAddress.Address + CompanyAddress."Ship-to Address 2";
            end else begin
                CompanyBusinessNameUSD := 'ASIA CHEMICAL CORPORATION';
                CompanyBusinessAddressUSD := 'AIG Tower, 3rd floor, Lot TH-1B, Street No.7, South Commercial Area, Tan Thuan Export Processing Zone, Tan Thuan Dong Ward, Dist. 7, Ho Chi Minh City, Vietnam';
            end;
        end;

        OtherTermsAndConditions := '1/ Please email full set of shipping documents directly to ' + CompanyBusinessNameUSD + ' within 03 days after shipment date. Fax: ' + CompanyInfo."Phone No." + '<br>2/ Quality as agreed specifications.<br>3/ Best before date must be showed on each bag of the goods and certificate of analysis.<br>4/ Maximum one production code / lot number per item unless otherwise agreed by the buyer.<br>5/ Request to apply 14 free demurrage days for the shipment at destination port.';
        OtherInformation := '1/ Shipper:<br>2/ Tran-shipment: allowed.<br>3/ Partial shipment: ' + PartialShipment + '.<br>4/ Port of loading:<br>5/ Shipping mark:<br>&nbsp;&nbsp;&nbsp;- Name of manufacture.<br>&nbsp;&nbsp;&nbsp;- Name of Commodity and Standard.<br>&nbsp;&nbsp;&nbsp;- Net weight Gross weight.<br>&nbsp;&nbsp;&nbsp;- Batch number, manufactured date, Expiry date.<br>&nbsp;&nbsp;&nbsp;- Country of Origin.<br>Attention : The actual shipping volume should be closely controlled to match figures in shipping documents (invoice, packing list, etc…)';

        ItemVoucher.SetRange(DocumentNo, PurchaseHeader."No.");
        if ItemVoucher.Open() then begin
            while ItemVoucher.Read() do begin
                if ItemVoucher.VoucherDescription <> '' then begin
                    ItemDocument := ItemDocument + '- ' + ItemVoucher.VoucherDescription + '<br>';
                end;
            end;
            ItemVoucher.Close();
        end;
        DocumentsAndProductAgeRequired := ItemDocument + '<br>- Goods must not exceed following months old at time of dispatch from product date:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;+ 1 month if Shelf-life less than 12 months<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;+ 2 months if Shelf-life of 12 months<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;+ 3 months if Shelf-life longer than 12 months';

        if VendTable.Get(PurchaseHeader."Buy-from Vendor No.") then begin
        end;
        if VendContact.Get(PurchaseHeader."Buy-from Contact No.") then begin
        end;
        if PaymentTerm.Get(PurchaseHeader."Payment Terms Code") then begin
        end;
        if VendBankAccount.Get(PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."BLTEC Vendor Bank Account") then begin
            if VendBankAccount.IBAN <> '' then begin
                BuyToBankACNo := VendBankAccount.IBAN;
            end else begin
                BuyToBankACNo := VendBankAccount."Bank Account No.";
            end;

        end;
        if Purchaser.Get(PurchaseHeader."Purchaser Code") then begin
        end;
        if ItemTable.Get(PurchaseLine."No.") then begin
            if ShelfLife.Get(ItemTable."BLACC Shelf Life") then begin
                ShelfLifeDescription := ShelfLife.Description;
            end;
        end;
        if PurchaseHeader."BLTEC Incoterms" = '' then begin
            Incoterms := '2020';
        end else begin
            Incoterms := PurchaseHeader."BLTEC Incoterms";
        end;

        if UnitTable.Get(PurchaseLine."Unit of Measure Code") then begin
            UnitofMeasureCode := UpperCase(UnitTable."BLACC English Name");
        end;
    end;

    local procedure AmountInWords()
    var
        BCHelper: Codeunit "BC Helper";
        AmountInWords: Codeunit "BLT AmountInWords";
        PurchLine: Record "Purchase Line";
        PurchAmount: Decimal;
        PurchAmountLCY: Decimal;
        AmountLetter: Text;
        AmountENLetter: Text;
        EquivalentENLetter: Text;
    begin

        PurchLine.SetFilter("Document No.", PurchaseHeader."No.");
        PurchLine.SetFilter("Document Type", 'Order');
        if PurchLine.FindSet() then begin
            PurchAmount := 0;
            repeat
                PurchAmount := PurchAmount + PurchLine."Line Amount";
                PurchAmountLCY := PurchAmountLCY + PurchaseLine.Amount;
            until PurchLine.Next() = 0;
        end;
        //LineAmountInWords := Text.LowerCase(;BCHelper.AmountInWordsInUSFormat(PurchAmount, 'USD'));
        AmountInWords.AmountInWordsForReport(PurchAmount, PurchLine."Currency Code", PurchAmount, AmountLetter, AmountENLetter, EquivalentENLetter);
        LineAmountInWords := EquivalentENLetter;
    end;

    var
        LineAmountInWords: Text;
        CompanyInfo: Record "Company Information";
        VendBankAccount: Record "Vendor Bank Account";
        VendTable: Record Vendor;
        Purchaser: Record "Salesperson/Purchaser";
        VendContact: Record Contact;
        PaymentTerm: Record "Payment Terms";
        ItemTable: Record Item;
        OtherTermsAndConditions: Text;
        DocumentsAndProductAgeRequired: Text;
        OtherInformation: Text;
        BuyToBankACNo: Text;
        ShipmentTerm: Text;
        PortOfDischarge: Text;
        Tolerance: Decimal;
        Incoterms: Text;
        CompanyBillNameUSD: Text;
        CompanyBillAddressUSD: Text;
        CompanyBusinessNameUSD: Text;
        CompanyBusinessAddressUSD: Text;
        ShelfLifeDescription: Text;
        UnitofMeasureCode: Text;
}
