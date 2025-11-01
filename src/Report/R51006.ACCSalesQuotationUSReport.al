report 51006 "ACC Sales Quotation US Report"
{
    ApplicationArea = All;
    Caption = 'APIS Sales Quotation US Report - R51006';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51006.ACCSalesQuotationUSReport.rdl';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = WHERE("Document Type" = FILTER(Quote));
            column(No; "No.") { }
            column(SelltoCustomerNo; "Sell-to Customer No.") { }
            column(SelltoCustomerName; "Sell-to Customer Name") { }
            column(OrderDate; "Order Date") { }
            column(DocumentDate; "Document Date") { }
            column(DueDate; "Due Date") { }
            column(BillToAddress; "Bill-to Address") { }
            column(BillToAddress2; "Bill-to Address 2") { }
            column(BillToCity; "Bill-to City") { }
            column(ShiptoAddress; "Ship-to Address") { }
            column(ShipToAddress02; "Ship-to Address 2") { }
            column(ShipToCity; "Ship-to City") { }
            column(SelltoEMail; "Sell-to E-Mail") { }
            column(SelltoPhoneNo; "Sell-to Phone No.") { }
            column(SalespersonCode; "Salesperson Code") { }
            column(SalespersonName; Salesperson.Name) { }
            column(SalespersonPhone; Salesperson."Phone No.") { }
            column(CustContactName; CustContact.Name) { }
            column(CustContactPhone; CustContact."Phone No.") { }
            column(CustContactFax; CustContact."Fax No.") { }
            column(CustContactEmail; CustContact."E-Mail") { }
            column(RelationContactName; RelationContactName) { }
            column(RelationContactPhone; RelationContactPhone) { }
            column(PaymentDesc; PaymentTerm.Description) { }
            column(PaymentCalc; PaymentTerm."Due Date Calculation") { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress02; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyFax; CompanyInfo."Fax No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyWebsite; CompanyWebsite) { }
            column(CompanyBuzAddress; CompanyBuzAddress) { }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ItemNo; "No.") { }
                column(Description; InventTable."BLTEC Item Name") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Unit_Price; "Unit Price") { }
                column(Line_Amount; "Line Amount") { }
                column(CountryName; CountryRegion.Name) { }
                column(PackingGroup; "BLACC Packing Group") { }
                column(TaxGroup; TaxGroup) { }
                column(MinOrderQty; MinOrderQty) { }
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
        if PaymentTerm.Get(SalesHeader."Payment Terms Code") then begin
        end;
        if CustContact.Get(SalesHeader."Sell-to Contact No.") then begin
        end;
        if InventTable.Get(SalesLine."No.") then begin
            if CountryRegion.Get(InventTable."Country/Region of Origin Code") then begin
            end;
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        InventTable: Record Item;
        CountryRegion: Record "Country/Region";
        PaymentTerm: Record "Payment Terms";
        Salesperson: Record "Salesperson/Purchaser";
        CustContact: Record Contact;
        RelationContactName: Text;
        RelationContactPhone: Text;
        TaxGroup: Text;
        MinOrderQty: Decimal;
        CompanyWebsite: Text;
        CompanyBuzAddress: Text;
}
