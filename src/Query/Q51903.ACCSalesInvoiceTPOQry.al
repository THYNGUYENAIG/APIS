query 51903 "ACC Sales Invoice TPO Qry"
{
    Caption = 'ACC Sales Invoice TPO Qry';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(TruckNumber);
    
    elements
    {
        dataitem(TransportInformation; "BLACC Transport Information")
        {
            DataItemTableFilter = "BLACC Source Document" = filter("Warehouse Activity Source Document"::"Sales Order");
            column(Count)
            {
                Method = Count;
            }
            column(TruckNumber; "Truck Number") { }
            dataitem(SalesShipmentLine; "Sales Shipment Line")
            {
                DataItemLink = "Order No." = TransportInformation."BLACC Posted Source No.",
                               "Order Line No." = TransportInformation."BLACC Source Line No.";
                column(DocumentNo; "Document No.") { }
                column(LocationCode; "Location Code") { }
                column(ShipmentDate; "Shipment Date") { }
                dataitem(SalesInvoiceLine; "Sales Invoice Line")
                {
                    DataItemTableFilter = Quantity = filter('>0');
                    DataItemLink = "Order No." = SalesShipmentLine."Order No.",
                                   "Order Line No." = SalesShipmentLine."Order Line No.";
                    column(PostingDate; "Posting Date") { }
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
    }

    trigger OnBeforeOpen()
    begin

    end;
}
