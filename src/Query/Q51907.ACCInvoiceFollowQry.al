query 51907 "ACC Logistics Follow Qry"
{
    Caption = 'ACC Logistics Follow - Q51907';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(DocumentNo);
    
    elements
    {
        dataitem(eInvoiceRegister; "BLTI eInvoice Register")
        {
            column(Count)
            {
                Method = Count;
            }
            column(ReservationCode; "eInvoice ReservationCode") { }
            dataitem(SalesInvoiceHeader; "Sales Invoice Header")
            {
                DataItemLink = "BLTI Draft eInvoice No." = eInvoiceRegister."No.",
                               "BLTI eInvoice No." = eInvoiceRegister."eInvoice No.";
                SqlJoinType = FullOuterJoin;
                column(InvoiceNo; "No.")
                {
                    Caption = 'PSI No.';
                }
                column(InvoiceDate; "Posting Date")
                {
                    Caption = 'Invoice Date';
                }
                column(eInvoiceNo; "BLTI eInvoice No.") { }
                dataitem(ValueEntry; "Value Entry")
                {
                    DataItemTableFilter = "Document Type" = filter('Sales Invoice');
                    DataItemLink = "Document No." = SalesInvoiceHeader."No.";
                    dataitem(ItemLedgerEntry; "Item Ledger Entry")
                    {
                        DataItemLink = "Entry No." = ValueEntry."Item Ledger Entry No.";

                        column(PostingDate; "Posting Date") { }
                        column(LocationCode; "Location Code") { }
                        dataitem(SalesShipmentHeader; "Sales Shipment Header")
                        {
                            DataItemLink = "No." = ItemLedgerEntry."Document No.";

                            column(DocumentNo; "No.")
                            {
                                Caption = 'PSS No.';
                            }
                            column(ShipmentDate; "Posting Date")
                            {
                                Caption = 'Shipment Date';
                            }
                            column(OrderNo; "Order No.") { }
                            column(OrderDate; "Order Date") { }
                            column(BillToCustomerNo; "Bill-to Customer No.") { }
                            column(BillToName; "Bill-to Name") { }
                            column(AgreementNo; "BLACC Agreement No.") { }
                            column(SalesPoolCode; "BLACC Sales Pool Code") { }
                            column(SalesQuotationNo; "BLACC Sales Quotation No.") { }
                            column(InvoiceNote; "BLACC Invoice Note") { }
                            column(DeliveryNote; "BLACC Delivery Note") { }
                            column(Note; "BLACC Note") { }
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
