codeunit 51006 "ACC Purch Receipt Event"
{
    Permissions = TableData "Purch. Rcpt. Header" = rimd;
    TableNo = "Purch. Rcpt. Header";

    trigger OnRun()
    var
        PurchInvoice: Query "ACC Purch Invoice Entry Qry";

        PSInvoiceTxt: Text;
        eInvoiceTxt: Text;
        TmpPSIN: Text;
        TmpEINV: Text;
        TmpDate: Date;
        ForUpdate: Boolean;
    begin
        Clear(PurchReceipt);

        if PurchReceipt.Get(Rec."No.") then begin
            ForUpdate := false;
            PurchInvoice.SetFilter(DocumentNo, PurchReceipt."No.");
            if PurchInvoice.Open() then begin
                while PurchInvoice.Read() do begin
                    if TmpPSIN <> PurchInvoice.InvoiceNo then begin
                        if TmpPSIN = '' then begin
                            PSInvoiceTxt := PurchInvoice.InvoiceNo;
                        end else begin
                            if StrLen(PSInvoiceTxt + '|' + PurchInvoice.InvoiceNo) < 500 then
                                PSInvoiceTxt := PSInvoiceTxt + '|' + PurchInvoice.InvoiceNo;
                        end;
                        ;
                    end;
                    if TmpEINV <> PurchInvoice.VendorInvoiceNo then begin
                        if TmpEINV = '' then begin
                            eInvoiceTxt := PurchInvoice.VendorInvoiceNo;
                        end else begin
                            if StrLen(eInvoiceTxt + '|' + PurchInvoice.VendorInvoiceNo) < 500 then
                                eInvoiceTxt := eInvoiceTxt + '|' + PurchInvoice.VendorInvoiceNo;
                        end;
                        ;
                    end;
                    TmpPSIN := PurchInvoice.InvoiceNo;
                    TmpEINV := PurchInvoice.VendorInvoiceNo;
                    TmpDate := PurchInvoice.InvoiceDate;
                end;
                PurchInvoice.Close();
            end;
            if PurchReceipt."Posted Purchase Invoice" <> PSInvoiceTxt then begin
                PurchReceipt."Posted Purchase Invoice" := PSInvoiceTxt;
                ForUpdate := true;
            end;
            if PurchReceipt."Vendor Invoice No." <> eInvoiceTxt then begin
                PurchReceipt."Vendor Invoice No." := eInvoiceTxt;
                ForUpdate := true;
            end;
            if PurchReceipt."Invoice Date" <> TmpDate then begin
                PurchReceipt."Invoice Date" := TmpDate;
                ForUpdate := true;
            end;

            if ForUpdate = true then begin
                PurchReceipt.Modify();
            end;
        end;
    end;

    var
        PurchReceipt: Record "Purch. Rcpt. Header";
}