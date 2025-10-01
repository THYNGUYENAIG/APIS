report 51007 "ACC Purch Contract VN Report"
{
    ApplicationArea = All;
    Caption = 'ACC Purchase Contract VN Report - R51007';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51007.ACCPurchContractVNReport.rdl';
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
            column(BuyToVATRegistration; VendTable."VAT Registration No.") { }
            column(BuyFromVNAddress; VendTable."BLACC VN Address") { }
            column(BuyToPhone; VendTable."Phone No.") { }
            column(BuyToFax; VendTable."Fax No.") { }
            column(BuyToBankName; VendBankAccount.Name) { }
            column(BuyToBankAccount; VendBankAccount."Bank Account No.") { }
            column(BuyToContactName; VendContact.Name) { }
            column(BuyToContactMobile; VendContact."Phone No.") { }
            column(PaytoVendorNo; "Pay-to Vendor No.") { }
            column(PaytoName; "Pay-to Name") { }
            column(PaytoAddress; "Pay-to Address") { }
            column(PaytoCountryRegionCode; "Pay-to Country/Region Code") { }
            column(PaymentTermsCode; "Payment Terms Code") { }
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
            column(DeliveryAddress; DeliveryAddress) { }
            column(PurchaserName; PurchaserName) { }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ItemNo; "No.") { }
                column(Description; Description) { }
                column(UnitofMeasureCode; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(UnitCost; "Direct Unit Cost") { }
                column(UnitCostLCY; "Unit Cost (LCY)") { }
                column(LineAmount; "Line Amount") { }
                column(LocationCode; "Location Code") { }
                column(VAT; "VAT %") { }
                column(CountryName; CountryTable.Name) { }
                column(ETDRequestDate; "BLTEC ETD Request Date") { }
                trigger OnAfterGetRecord()
                begin
                    GetDataTable();
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
    begin
        if CompanyInfo.Get() then begin
            CompanyInfo.CalcFields(Picture);
        end;
        if VendTable.Get(PurchaseHeader."Buy-from Vendor No.") then begin
        end;
        if Purchaser.Get(PurchaseHeader."Purchaser Code") then begin
        end;
        if VendBankAccount.Get(PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."BLTEC Vendor Bank Account") then begin
        end;
        if VendContact.Get(PurchaseHeader."Buy-from Contact No.") then begin
        end;

        if PurchaseHeader."Ship-to Address" <> '' then begin
            DeliveryAddress := PurchaseHeader."Ship-to Address";
        end;

        if ItemTable.Get(PurchaseLine."No.") then begin
            if CountryTable.Get(ItemTable."Country/Region of Origin Code") then begin
            end;
        end;

        PurchaserName := 'Trần Thị Huyền Châu';
    end;

    var
        CompanyInfo: Record "Company Information";
        VendTable: Record Vendor;
        VendBankAccount: Record "Vendor Bank Account";
        Purchaser: Record "Salesperson/Purchaser";
        VendContact: Record Contact;
        ItemTable: Record Item;
        CountryTable: Record "Country/Region";
        DeliveryAddress: Text;
        PurchaserName: Text;
}
