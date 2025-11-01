query 51906 "ACC Sales Invoice Entry Qry"
{
    Caption = 'ACC Sales Invoice Entry Qry';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(DocumentNo);

    elements
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            column(Count)
            {
                Method = Count;
            }
            column(DocumentNo; "No.")
            {
                Caption = 'PSS No.';
            }
            column(ShipmentDate; "Shipment Date") { }
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemLink = "Document No." = SalesShipmentHeader."No.";
                SqlJoinType = InnerJoin;
                column(PostingDate; "Posting Date") { }
                column(LocationCode; "Location Code") { }
                dataitem(ValueEntry; "Value Entry")
                {
                    DataItemTableFilter = "Document Type" = filter('Sales Invoice');
                    DataItemLink = "Item Ledger Entry No." = ItemLedgerEntry."Entry No.";
                    SqlJoinType = InnerJoin;
                    dataitem(SalesInvoiceHeader; "Sales Invoice Header")
                    {
                        DataItemLink = "No." = ValueEntry."Document No.";
                        SqlJoinType = InnerJoin;
                        column(InvoiceNo; "No.")
                        {
                            Caption = 'PSI No.';
                        }
                        column(InvoiceDate; "Posting Date")
                        {
                            Caption = 'Invoice Date';
                        }
                        column(ExternalDocumentNo; "External Document No.") { }
                        column(eInvoiceNo; "BLTI eInvoice No.") { }
                        dataitem(eInvoiceRegister; "BLTI eInvoice Register")
                        {
                            DataItemLink = "No." = SalesInvoiceHeader."BLTI Draft eInvoice No.",
                                       "eInvoice No." = SalesInvoiceHeader."BLTI eInvoice No.";
                            SqlJoinType = InnerJoin;
                            column(ReservationCode; "eInvoice ReservationCode") { }
                            column(eInvoiceCode; "eInvoice Code") { }
                            column(eInvNo; "No.") { }
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
