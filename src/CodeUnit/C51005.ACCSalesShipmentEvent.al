codeunit 51005 "ACC Sales Shipment Event"
{
    Permissions = TableData "Sales Shipment Header" = rimd;
    TableNo = "Sales Shipment Header";

    trigger OnRun()
    var
        SalesInvoice: Query "ACC Sales Invoice Entry Qry";

        ExternalDocument: Text;
        TaxAuthorityNumber: Text;
        PSInvoiceTxt: Text;
        eInvoiceTxt: Text;
        TmpPSIN: Text;
        TmpEINV: Text;
        ForUpdate: Boolean;

    begin
        Clear(SalesShipment);

        if SalesShipment.Get(Rec."No.") then begin
            ForUpdate := false;
            SalesInvoice.SetFilter(DocumentNo, SalesShipment."No.");
            if SalesInvoice.Open() then begin
                while SalesInvoice.Read() do begin
                    if (SalesInvoice.ShipmentDate <> 0D) AND (SalesInvoice.PostingDate <> 0D) AND (SalesInvoice.ShipmentDate <= SalesInvoice.InvoiceDate) then begin
                        if TmpPSIN <> SalesInvoice.InvoiceNo then begin
                            if TmpPSIN = '' then begin
                                PSInvoiceTxt := SalesInvoice.InvoiceNo;
                            end else begin
                                PSInvoiceTxt := PSInvoiceTxt + '|' + SalesInvoice.InvoiceNo;
                            end;
                            ;
                        end;
                        if TmpEINV <> SalesInvoice.eInvoiceNo then begin
                            if TmpEINV = '' then begin
                                eInvoiceTxt := SalesInvoice.eInvoiceNo;
                                TaxAuthorityNumber := SalesInvoice.eInvoiceCode;
                                ExternalDocument := SalesInvoice.ExternalDocumentNo;
                            end else begin
                                eInvoiceTxt := PSInvoiceTxt + '|' + SalesInvoice.eInvoiceNo;
                                TaxAuthorityNumber := TaxAuthorityNumber + '|' + SalesInvoice.eInvoiceCode;
                                ExternalDocument := ExternalDocument + '|' + SalesInvoice.ExternalDocumentNo;
                            end;
                            ;
                        end;
                        TmpPSIN := SalesInvoice.InvoiceNo;
                        TmpEINV := SalesInvoice.eInvoiceNo;
                    end;
                end;
                SalesInvoice.Close();
            end;
            if SalesShipment."Posted Sales Invoice" <> PSInvoiceTxt then begin
                SalesShipment."Posted Sales Invoice" := PSInvoiceTxt;
                ForUpdate := true;
            end;
            if SalesShipment.eInvoice <> eInvoiceTxt then begin
                SalesShipment.eInvoice := eInvoiceTxt;
                ForUpdate := true;
            end;
            if SalesShipment."Tax authority number" <> TaxAuthorityNumber then begin
                SalesShipment."Tax authority number" := TaxAuthorityNumber;
                ForUpdate := true;
            end;
            if SalesShipment."External Document" <> ExternalDocument then begin
                SalesShipment."External Document" := ExternalDocument;
                ForUpdate := true;
            end;
            if ForUpdate = true then begin
                SalesShipment.Modify();
            end;
        end;
    end;

    var
        SalesShipment: Record "Sales Shipment Header";
}
