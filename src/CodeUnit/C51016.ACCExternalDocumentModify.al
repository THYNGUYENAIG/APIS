codeunit 51016 "ACC External Document Modify"
{
    Permissions = tabledata "G/L Entry" = rm,
                  tabledata "VAT Entry" = rm,
                  tabledata "Value Entry" = rm,
                  tabledata "Cust. Ledger Entry" = rm,
                  tabledata "Item Ledger Entry" = rm,
                  tabledata "Sales Invoice Header" = rm,
                  tabledata "Sales Invoice Line" = rm,
                  tabledata "Sales Cr.Memo Header" = rm,
                  tabledata "Sales Cr.Memo Line" = rm;
    trigger OnRun()
    begin

    end;

    procedure ChangeDoc(DocumentNo: Text; PostingDate: Date; ExternalDocNo: Text)
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
    begin
        GLEntry.Reset();
        GLEntry.SetRange("Document No.", DocumentNo);
        GLEntry.SetRange("Posting Date", PostingDate);
        if GLEntry.FindSet() then begin
            repeat
                GLEntry."External Document No." := ExternalDocNo;
                GLEntry.Modify();
            until GLEntry.Next() = 0;
        end;

        VATEntry.Reset();
        VATEntry.SetRange("Document No.", DocumentNo);
        VATEntry.SetRange("Posting Date", PostingDate);
        if VATEntry.FindSet() then begin
            repeat
                VATEntry."External Document No." := ExternalDocNo;
                VATEntry.Modify();
            until VATEntry.Next() = 0;
        end;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        CustLedgerEntry.SetRange("Posting Date", PostingDate);
        if CustLedgerEntry.FindSet() then begin
            repeat
                CustLedgerEntry."External Document No." := ExternalDocNo;
                CustLedgerEntry.Modify();
            until CustLedgerEntry.Next() = 0;
        end;

        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Posting Date", PostingDate);
        if ValueEntry.FindSet() then begin
            repeat
                ValueEntry."External Document No." := ExternalDocNo;
                ValueEntry.Modify();
            until ValueEntry.Next() = 0;
        end;

        SalesInvoice.Reset();
        SalesInvoice.SetRange("No.", DocumentNo);
        SalesInvoice.SetRange("Posting Date", PostingDate);
        if SalesInvoice.FindFirst() then begin
            SalesInvoice."External Document No." := ExternalDocNo;
            SalesInvoice.Modify();
        end;

        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        SalesInvoiceLine.SetRange("Posting Date", PostingDate);
        if SalesInvoiceLine.FindLast() then begin
            ValueItemLedgerEntry.SetRange(Value_Entry_Doc_No, SalesInvoiceLine."Document No.");
            ValueItemLedgerEntry.SetRange(Value_Entry_Doc_Type, Enum::"Item Ledger Document Type"::"Sales Invoice");
            ValueItemLedgerEntry.SetRange(Value_Entry_Doc_Line_No, SalesInvoiceLine."Line No.");
            ValueItemLedgerEntry.SetRange(Item_Ledg_Document_Type, Enum::"Item Ledger Document Type"::"Sales Shipment");
            ValueItemLedgerEntry.Open();
            while ValueItemLedgerEntry.Read() do begin
                if ItemLedgerEntry.Get(ValueItemLedgerEntry.Item_Ledger_Entry_No_) then begin
                    ItemLedgerEntry."External Document No." := ExternalDocNo;
                    ItemLedgerEntry.Modify();
                end;
            end;
        end;

        SalesMemos.Reset();
        SalesMemos.SetRange("No.", DocumentNo);
        SalesMemos.SetRange("Posting Date", PostingDate);
        if SalesMemos.FindFirst() then begin
            SalesMemos."External Document No." := ExternalDocNo;
            SalesMemos.Modify();
        end;

        SalesCreditMemos.Reset();
        SalesCreditMemos.SetRange("Document No.", DocumentNo);
        SalesCreditMemos.SetRange("Posting Date", PostingDate);
        if SalesCreditMemos.FindLast() then begin
            ValueItemLedgerEntry.SetRange(Value_Entry_Doc_No, SalesCreditMemos."Document No.");
            ValueItemLedgerEntry.SetRange(Value_Entry_Doc_Type, Enum::"Item Ledger Document Type"::"Sales Invoice");
            ValueItemLedgerEntry.SetRange(Value_Entry_Doc_Line_No, SalesCreditMemos."Line No.");
            ValueItemLedgerEntry.SetRange(Item_Ledg_Document_Type, Enum::"Item Ledger Document Type"::"Sales Shipment");
            ValueItemLedgerEntry.Open();
            while ValueItemLedgerEntry.Read() do begin
                if ItemLedgerEntry.Get(ValueItemLedgerEntry.Item_Ledger_Entry_No_) then begin
                    ItemLedgerEntry."External Document No." := ExternalDocNo;
                    ItemLedgerEntry.Modify();
                end;
            end;
        end;
    end;
}
