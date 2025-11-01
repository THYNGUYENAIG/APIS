query 51908 "ACC Purch Invoice Entry Qry"
{
    Caption = 'APIS Purch Invoice Entry Qry';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(DocumentNo);

    elements
    {
        dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
        {
            column(Count)
            {
                Method = Count;
            }
            column(DocumentNo; "No.")
            {
                Caption = 'PPR No.';
            }
            column(ReceiptDate; "Posting Date") { }
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                //DataItemTableFilter = Quantity = filter('>0');
                DataItemLink = "Document No." = PurchRcptHeader."No.";
                column(PostingDate; "Posting Date") { }
                column(LocationCode; "Location Code") { }
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
                dataitem(ValueEntry; "Value Entry")
                {
                    DataItemTableFilter = "Document Type" = filter('Purchase Invoice'), "Item Charge No." = filter('');
                    DataItemLink = "Item Ledger Entry No." = ItemLedgerEntry."Entry No.";
                    dataitem(PurchInvHeader; "Purch. Inv. Header")
                    {
                        DataItemLink = "No." = ValueEntry."Document No.";
                        column(InvoiceNo; "No.")
                        {
                            Caption = 'PPI No.';
                        }
                        column(InvoiceDate; "Posting Date")
                        {
                            Caption = 'Invoice Date';
                        }
                        column(VendorInvoiceNo; "Vendor Invoice No.")
                        {
                            Caption = 'Vendor Invoice No';
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
