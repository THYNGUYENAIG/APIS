query 51902 "ACC Sales Invoice SPO Qry"
{
    Caption = 'APIS Sales Invoice SPO Qry';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(DocumentNo);
    
    elements
    {

        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            column(Count)
            {
                Method = Count;
            }
            column(DocumentNo; "Document No.") { }
            column(LocationCode; "Location Code") { }
            column(ShipmentDate; "Shipment Date") { }
            column(InvoiceQuantity; Quantity)
            {
                Method = Sum;
            }
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemTableFilter = Quantity = filter('>0');
                DataItemLink = "Order No." = SalesShipmentLine."Order No.",
                                   "Order Line No." = SalesShipmentLine."Order Line No.";
                column(PostingDate; "Posting Date") { }
                column(ShipmentQuantity; Quantity)
                {
                    Method = Sum;
                }
                dataitem(SalesInvoiceHeader; "Sales Invoice Header")
                {
                    DataItemLink = "No." = SalesInvoiceLine."Document No.";
                    column(eInvoiceNo; "BLTI eInvoice No.") { }
                    //column(eInTransactionId; "BLTI Original eInTransactionId") { }
                    dataitem(eInvoiceRegister; "BLTI eInvoice Register")
                    {
                        DataItemLink = "No." = SalesInvoiceHeader."BLTI Draft eInvoice No.",
                                       "eInvoice No." = SalesInvoiceHeader."BLTI eInvoice No.";
                        column(ReservationCode; "eInvoice ReservationCode") { }
                    }
                }
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
