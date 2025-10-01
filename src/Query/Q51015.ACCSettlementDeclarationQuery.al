query 51015 "ACC Settle Declaration Query"
{
    Caption = 'ACC Settlement Declaration Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(ImportEntry; "BLTEC Import Entry")
        {
            column(Count) { Method = Count; }
            column(DeclarationNo; "BLTEC Customs Declaration No.") { }
            column(DeclarationDate; "Customs Declaration Date") { }

            dataitem(PurchInvLine; "Purch. Inv. Line")
            {
                DataItemTableFilter = "VAT Bus. Posting Group" = filter('OVERSEA'),
                                      Type = filter("Purchase Line Type"::Item);
                DataItemLink = "Order No." = ImportEntry."Purchase Order No.",
                               "Order Line No." = ImportEntry."Line No.";

                column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }

                dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
                {
                    DataItemLink = "Document No." = PurchInvLine."Document No.",
                                    "Posting Date" = PurchInvLine."Posting Date";
                    //column(DocumentNo; "Document No.") { }
                    //column(DueDate; "Due Date") { }
                    //column(PostingDate; "Posting Date") { }
                    column(VendorNo; "Vendor No.") { }
                    column(VendorName; "Vendor Name") { }
                    //column(Description; Description) { }
                    //column(ExternalDocumentNo; "External Document No.") { }
                    column(PaymentReference; "Payment Reference") { }
                    column(PaymentMethodCode; "Payment Method Code") { }
                    //column(Amount; Amount) { }
                    //column(AmountLCY; "Amount (LCY)") { }
                    //column(RemainingAmount; "Remaining Amount") { }
                    //column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
                    column(CurrencyCode; "Currency Code") { }
                    dataitem(DetailedVendorLedgEntry; "Detailed Vendor Ledg. Entry")
                    {
                        DataItemTableFilter = "Entry Type" = filter(> "Detailed CV Ledger Entry Type"::"Initial Entry");
                        DataItemLink = "Vendor Ledger Entry No." = VendorLedgerEntry."Entry No.";
                        column(EntryType; "Entry Type") { }
                        column(Amount; Amount) { }
                        column(AmountLCY; "Amount (LCY)") { }
                        column(EntryNo; "Entry No.") { }
                        dataitem(SettleLedgerEntry; "Vendor Ledger Entry")
                        {
                            DataItemLink = "Document No." = DetailedVendorLedgEntry."Document No.";
                            column(DocumentNo; "Document No.") { }
                            column(DocumentType; "Document Type") { }
                            column(ExternalDocumentNo; "External Document No.") { }
                            column(Description; Description) { }
                            column(DueDate; "Due Date") { }
                            column(PostingDate; "Posting Date") { }
                            column(RecipientBankAccount; "Recipient Bank Account") { }
                            column(BalAccountNo; "Bal. Account No.") { }
                        }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
