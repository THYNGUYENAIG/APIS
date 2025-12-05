codeunit 51020 "ACC Document Modify"
{
    Permissions = tabledata "G/L Entry" = rm,
                  tabledata "VAT Entry" = rm,
                  tabledata "Value Entry" = rm,
                  tabledata "Cust. Ledger Entry" = rm,
                  tabledata "Item Ledger Entry" = rm,
                  tabledata "Sales Invoice Header" = rm,
                  tabledata "Sales Invoice Line" = rm,
                  tabledata "Sales Cr.Memo Header" = rm,
                  tabledata "Sales Cr.Memo Line" = rm,
                  tabledata "Purch. Inv. Header" = rm,
                  tabledata "Vendor Ledger Entry" = rm;
    trigger OnRun()
    begin

    end;

    procedure ChangeDoc(Type: Enum "ACC Type Change Document"; FieldChange: Enum "ACC Field Change Document"; DocumentNo: Text; PostingDate: Date; NewValue: Text)
    var
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        SalesInvoice: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesMemos: Record "Sales Cr.Memo Header";
        SalesCreditMemos: Record "Sales Cr.Memo Line";
        ValueItemLedgerEntry: Query "ACC Value Item Ledger Entries";
        PurchInvHeader: Record "Purch. Inv. Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        case Type of
            Type::"Posted Purchase Invoice":
                case FieldChange of
                    FieldChange::"Vendor Invoice No.":
                        begin
                            //Purch. Inv. Header
                            PurchInvHeader.Reset();
                            if PurchInvHeader.Get(DocumentNo) then begin
                                PurchInvHeader."Vendor Invoice No." := UpperCase(NewValue);
                                PurchInvHeader.Modify();
                            end;
                            //G/L Entry
                            GLEntry.Reset();
                            GLEntry.SetRange("Document No.", DocumentNo);
                            GLEntry.SetRange("Posting Date", PostingDate);
                            GLEntry.ModifyAll("External Document No.", UpperCase(NewValue));
                            //VAT Entry
                            VATEntry.Reset();
                            VATEntry.SetRange("Document No.", DocumentNo);
                            VATEntry.SetRange("Posting Date", PostingDate);
                            VATEntry.ModifyAll("External Document No.", UpperCase(NewValue));

                            //Vendor Ledger Entry
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetRange("Document No.", DocumentNo);
                            VendorLedgerEntry.SetRange("Posting Date", PostingDate);
                            VendorLedgerEntry.ModifyAll("External Document No.", UpperCase(NewValue));

                            //Value Entry
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Document No.", DocumentNo);
                            ValueEntry.SetRange("Posting Date", PostingDate);
                            ValueEntry.ModifyAll("External Document No.", UpperCase(NewValue));
                        end;
                end;
        end;
    end;
}
