query 52011 "ACC Sales Agreement"
{
    Caption = 'APIS Sales Agreement Statistic - Q52011';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    UsageCategory = Lists;

    elements
    {
        dataitem(SH; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = filter("Sales Document Type"::"BLACC Agreement");

            column(No; "No.") { }
            column(SelltoCustomerNo; "Sell-to Customer No.") { }
            column(SelltoCustomerName; "Sell-to Customer Name") { }
            column(SelltoAddress; "Sell-to Address") { }
            column(SelltoAddress2; "Sell-to Address 2") { }
            column(SelltoPostCode; "Sell-to Post Code") { }
            column(SelltoCity; "Sell-to City") { }
            column(SelltoCountryRegionCode; "Sell-to Country/Region Code") { }
            column(SelltoContactNo; "Sell-to Contact No.") { }
            column(SelltoPhoneNo; "Sell-to Phone No.") { }
            column(SelltoEMail; "Sell-to E-Mail") { }
            column(SelltoContact; "Sell-to Contact") { }
            column(DocumentDate; "Document Date") { }
            column(DueDate; "Due Date") { }
            column(OrderDate; "Order Date") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(YourReference; "Your Reference") { }
            column(SalespersonCode; "Salesperson Code") { }
            column(BLACCSalespersonName; "BLACC Salesperson Name") { }
            column(CampaignNo; "Campaign No.") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(AssignedUserID; "Assigned User ID") { }
            column(Status; Status) { }
            column(BLACCSalesPoolCode; "BLACC Sales Pool Code") { }
            column(BLACCSelltoSalesPoolCode; "BLACC Sell-to Sales Pool Code") { }
            column(BLACCSalesQuotationNo; "BLACC Sales Quotation No.") { }
            column(BLACCTolerance; "BLACC Tolerance %") { }
            // column(WorkDescription; "Work Description") { }
            column(BLACCAgreementStartDate; "BLACC Agreement StartDate") { }
            column(BLACCAgreementEndDate; "BLACC Agreement EndDate") { }
            column(BLACCContractDeliveryDate; "BLACC Contract Delivery Date") { }
            column(BLACCContractReturnDate; "BLACC Contract Return Date") { }
            column(BLACCOwnerGroup; "BLACC Owner Group") { }
            column(BLACCCustomerGroup; "BLACC Customer Group") { }
            column(BLACCSAType; "BLACC SA Type") { }
            column(BLACCPrincipalSA; "BLACC Principal SA") { }
            column(BLACCNotPassCheckMinPrice; "BLACC Not Pass Check MinPrice") { }
            column(BLACCGroupCreditLimit; "BLACC Group Credit Limit") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(BLACCNote; "BLACC Note") { }
            column(BLACCDeliveryNote; "BLACC Delivery Note") { }
            column(BLACCInvoiceNote; "BLACC Invoice Note") { }
            column(CurrencyCode; "Currency Code") { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(PaymentMethodCode; "Payment Method Code") { }
            // column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            // column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }

            //Filter
            // filter(Location_Code_Filter; "Location Code") { }

            dataitem(SL; "Sales Line")
            {
                DataItemLink = "Document No." = SH."No.";
                SqlJoinType = LeftOuterJoin;

                column("Type"; "Type") { }
                column(No_SL; "No.") { }
                column(LocationCode; "Location Code") { }
                column(ItemReferenceNo; "Item Reference No.") { }
                column(VATProdPostingGroup; "VAT Prod. Posting Group") { }
                column(Description; Description) { }
                column(BLTECItemName; "BLTEC Item Name") { }
                column(Quantity; Quantity) { Method = Sum; }
                column(UnitofMeasureCode; "Unit of Measure Code") { }
                column(UnitPrice; "Unit Price") { }
                column(BLACCCheckedMinPrice; "BLACC Checked Min Price") { }
                column(LineDiscount; "Line Discount %") { }
                column(LineAmount; "Line Amount") { }
                column(QtytoShip; "Qty. to Ship") { }
                column(QuantityShipped; "Quantity Shipped") { }
                column(QuantityInvoiced; "Quantity Invoiced") { }
                column(BLACCSOReleasedQuantity; "BLACC SO Released Quantity") { }
                column(BLACCSOOutstandingQuantity; "BLACC SO Outstanding Quantity") { }
                column(ShipmentDate; "Shipment Date") { }
                // column(DimensionSetID; "Dimension Set ID") { }
                column(ShortcutDimension1Code_SL; "Shortcut Dimension 1 Code") { Caption = 'Branch Code'; }
                column(ShortcutDimension2Code_SL; "Shortcut Dimension 2 Code") { Caption = 'BU Code'; }
                column(BLACCMaxTolerance; "BLACC Max Tolerance %") { }
                column(BLACCStockCoverPeriod; "BLACC Stock Cover Period") { }
                column(BLACCAgreementStartDate_SL; "BLACC Agreement StartDate") { }
                column(BLACCAgreementEndDate_SL; "BLACC Agreement EndDate") { }
                column(BLACCMaxQuantity; "BLACC Max Quantity") { }
                column(BLACCMinTolerance; "BLACC Min Tolerance %") { }
                column(BLACCMinQuantity; "BLACC Min Quantity") { }
                column(BLACCBSOQuantity; "BLACC BSO Quantity") { }
                column(BLACCMOQ; "BLACC MOQ") { }
                column(LineNo; "Line No.") { }
                column(PurchasingCode; "Purchasing Code") { }
                column(BLACCDirectShipment; "BLACC Direct Shipment") { }

                // column(Quantity; Quantity) { Method = Sum; }
            }
        }
    }
}
