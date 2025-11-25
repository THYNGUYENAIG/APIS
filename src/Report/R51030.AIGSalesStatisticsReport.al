report 51030 "AIG Sales Statistics Report"
{
    ApplicationArea = All;
    Caption = 'AIG Sales Statistics Report';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51030.AIGSalesStatisticsReport.rdl';
    dataset
    {
        dataitem(RecTemp; "AIG Sales Statistics Temp")
        {
            column(Amount; Amount)
            {
            }
            column(AmountLCY; "Amount (LCY)")
            {
            }
            column(BUCode; "BU Code")
            {
            }
            column(BUName; "BU Name")
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(BranchName; "Branch Name")
            {
            }
            column(ChargeAmount; "Charge Amount")
            {
            }
            column(CostAmount; "Cost Amount")
            {
            }
            column(CostAmountAdjust; "Cost Amount Adjust.")
            {
            }
            column(CostCenter; "Cost Center")
            {
            }
            column(CostCenterName; "Cost Center Name")
            {
            }
            column(CreditNote; "Credit Note")
            {
            }
            column(CustomerAccount; "Customer Account")
            {
            }
            column(CustomerGroup; "Customer Group")
            {
            }
            column(CustomerGroupName; "Customer Group Name")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(Description; Description)
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(ExchangeRate; "Exchange Rate")
            {
            }
            column(InvoiceAccount; "Invoice Account")
            {
            }
            column(InvoiceDate; "Invoice Date")
            {
            }
            column(InvoiceName; "Invoice Name")
            {
            }
            column(InvoiceNo; "Invoice No.")
            {
            }
            column(ItemLedgerEntryNo; "Item Ledger Entry No.")
            {
            }
            column(ItemNumber; "Item Number")
            {
            }
            column(ItemSalesTaxGroup; "Item Sales Tax Group")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(OrigInvoiceDate; "Orig Invoice Date")
            {
            }
            column(OrigInvoiceNo; "Orig Invoice No.")
            {
            }
            column(OrigeInvoiceNo; "Orig eInvoice No.")
            {
            }
            column(PackingSlip; "Packing Slip")
            {
            }
            column(PhysicalDate; "Physical Date")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(SalesDistrict; "Sales District")
            {
            }
            column(SalesOrder; "Sales Order")
            {
            }
            column(SalesTaker; "Sales Taker")
            {
            }
            column(SalesTakerName; "Sales Taker Name")
            {
            }
            column(SalesTaxAmount; "Sales Tax Amount")
            {
            }
            column(SearchName; "Search Name")
            {
            }
            column(Unit; Unit)
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(VAT; "VAT %")
            {
            }
            column(VATProdPostingGroup; "VAT Prod. Posting Group")
            {
            }
            column(VendorNo; "Vendor No.")
            {
            }
            column(Warehouse; Warehouse)
            {
            }
            column(eInvoiceSeries; "eInvoice Series")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(FromPostingDate; FromPostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Posting Date';
                    }
                    field(ToPostingDate; ToPostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Posting Date';
                    }
                    field(FromeInvoiceDate; FromeInvoiceDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From eInvoice Date';
                    }
                    field(ToeInvoiceDate; ToeInvoiceDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To eInvoice Date';
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoice';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            DocumentPage: Page "Posted Sales Invoices";
                        begin
                            Clear(Text);
                            Clear(DocumentNo);
                            DocumentPage.LookupMode(true);
                            if DocumentPage.RunModal() = Action::LookupOK then begin
                                Text += DocumentPage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(InvoiceAccount; InvoiceAccount)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoice Account';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            CustomerPage: Page "Customer List";
                        begin
                            Clear(Text);
                            Clear(InvoiceAccount);
                            CustomerPage.LookupMode(true);
                            if CustomerPage.RunModal() = Action::LookupOK then begin
                                Text += CustomerPage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(InvoiceName; InvoiceName)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoice Name';
                    }
                    field(eInvoiceNo; eInvoiceNo)
                    {
                        ApplicationArea = All;
                        Caption = 'eInvoice No';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            eInvoicePage: Page "BLTI eInvoices Registers";
                        begin
                            Clear(Text);
                            Clear(eInvoiceNo);
                            eInvoicePage.LookupMode(true);
                            if eInvoicePage.RunModal() = Action::LookupOK then begin
                                Text += eInvoicePage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(OrigeInvoiceNo; OrigeInvoiceNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Orig eInvoice No';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            eInvoicePage: Page "BLTI eInvoices Registers";
                        begin
                            Clear(Text);
                            Clear(OrigeInvoiceNo);
                            eInvoicePage.LookupMode(true);
                            if eInvoicePage.RunModal() = Action::LookupOK then begin
                                Text += eInvoicePage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(SalesOrder; SalesOrder)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            SalesPage: Page "Sales Order List";
                        begin
                            Clear(Text);
                            Clear(SalesOrder);
                            SalesPage.LookupMode(true);
                            if SalesPage.RunModal() = Action::LookupOK then begin
                                Text += SalesPage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            CustomerPage: Page "Customer List";
                        begin
                            Clear(Text);
                            Clear(CustomerNo);
                            CustomerPage.LookupMode(true);
                            if CustomerPage.RunModal() = Action::LookupOK then begin
                                Text += CustomerPage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(CustomerName; CustomerName)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Name';
                    }
                    field(CustomerGroupName; CustomerGroupName)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Group Name';
                    }
                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemPage: Page "Item List";
                        begin
                            Clear(Text);
                            Clear(ItemNo);
                            ItemPage.LookupMode(true);
                            if ItemPage.RunModal() = Action::LookupOK then begin
                                Text += ItemPage.GetSelection();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                    field(SearchName; SearchName)
                    {
                        ApplicationArea = All;
                        Caption = 'Search Name';
                    }
                    field(Description; Description)
                    {
                        ApplicationArea = All;
                        Caption = 'Description';
                    }
                    field(VATProdPostingGroup; VATProdPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'VAT Prod. Posting Group';
                        TableRelation = "VAT Product Posting Group".Code;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnPreReport()
    var
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := Today - 13;
        ToDate := Today;
        CostValueEntry(FromDate, ToDate);
        GetData();
    end;

    local procedure GetData()
    var
    begin
        GetSalesInvoice();
        GetServiceInvoice();
        GetServiceCrMemos();
    end;

    local procedure GetSalesInvoice()
    var
        CostValueEntry: Record "AIG Cost Value Entry";
        CalcValueEntry: Record "AIG Cost Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";

        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemosHeader: Record "Sales Cr.Memo Header";
        SalesCrMemosLine: Record "Sales Cr.Memo Line";

        eInvoiceHeader: Record "Sales Invoice Header";
        Salesperson: Record "Salesperson/Purchaser";
        CustTable: Record Customer;
        CustGroup: Record "BLACC Customer Group";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
        InsertLine: Boolean;
    begin
        CostValueEntry.Reset();
        CostValueEntry.SetFilter("Document Type", '2|4');
        if (FromPostingDate <> 0D) AND (ToPostingDate <> 0D) then CostValueEntry.SetRange("Posting Date", FromPostingDate, ToPostingDate);
        if DocumentNo <> '' then CostValueEntry.SetFilter("Document No.", DocumentNo);
        if CostValueEntry.FindSet() then
            repeat
                if not RecTemp.Get(CostValueEntry."Document No.", CostValueEntry."Line No.", CostValueEntry."Posting Date") then begin
                    RecTemp.Init();
                    RecTemp."Document Type" := CostValueEntry."Document Type";
                    RecTemp."Document No." := CostValueEntry."Document No.";
                    RecTemp."Line No." := CostValueEntry."Line No.";
                    RecTemp."Posting Date" := CostValueEntry."Posting Date";
                    RecTemp."Item Ledger Entry No." := CostValueEntry."Item Ledger Entry No.";
                    RecTemp."From Date" := FromPostingDate;
                    RecTemp."To Date" := ToPostingDate;
                    CalcValueEntry.Reset();
                    CalcValueEntry.SetRange("Document No.", CostValueEntry."Document No.");
                    CalcValueEntry.SetRange("Line No.", CostValueEntry."Line No.");
                    CalcValueEntry.SetRange("Posting Date", CostValueEntry."Posting Date");
                    CalcValueEntry.CalcSums("AIG Cost Amount", "AIG Cost Amount Adjustment");
                    RecTemp."Cost Amount" := -CalcValueEntry."AIG Cost Amount";
                    RecTemp."Cost Amount Adjust." := -CalcValueEntry."AIG Cost Amount Adjustment";

                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Entry No.", CostValueEntry."Item Ledger Entry No.");
                    if ItemLedgerEntry.FindFirst() then begin
                        RecTemp.Warehouse := ItemLedgerEntry."Location Code";
                        RecTemp."Packing Slip" := ItemLedgerEntry."Document No.";
                        RecTemp."Physical Date" := ItemLedgerEntry."Posting Date";
                    end;
                    if CostValueEntry."Document Type" = "Item Ledger Document Type"::"Sales Invoice" then begin
                        SalesInvoiceHeader.Reset();
                        SalesInvoiceHeader.SetRange("No.", CostValueEntry."Document No.");
                        if InvoiceAccount <> '' then SalesInvoiceHeader.SetFilter("Bill-to Customer No.", InvoiceAccount);
                        if InvoiceName <> '' then SalesInvoiceHeader.SetFilter("Bill-to Name", InvoiceName);
                        if CustomerNo <> '' then SalesInvoiceHeader.SetFilter("Sell-to Customer No.", CustomerNo);
                        if CustomerName <> '' then SalesInvoiceHeader.SetFilter("Sell-to Customer Name", CustomerName);
                        if (FromeInvoiceDate <> 0D) AND (ToeInvoiceDate <> 0D) then SalesInvoiceHeader.SetRange("Posting Date", FromeInvoiceDate, ToeInvoiceDate);
                        if eInvoiceNo <> '' then SalesInvoiceHeader.SetFilter("External Document No.", eInvoiceNo);
                        if SalesInvoiceHeader.FindSet() then
                            repeat
                                InsertLine := false;
                                RecTemp."Invoice Date" := SalesInvoiceHeader."Posting Date";
                                RecTemp."Customer Account" := SalesInvoiceHeader."Sell-to Customer No.";
                                RecTemp."Customer Name" := SalesInvoiceHeader."Sell-to Customer Name";
                                RecTemp."Invoice Account" := SalesInvoiceHeader."Bill-to Customer No.";
                                RecTemp."Invoice Name" := SalesInvoiceHeader."Bill-to Name";
                                RecTemp."Sales Taker" := SalesInvoiceHeader."Salesperson Code";
                                RecTemp."Sales District" := SalesInvoiceHeader."Sell-to City";
                                if Salesperson.Get(SalesInvoiceHeader."Salesperson Code") then
                                    RecTemp."Sales Taker Name" := Salesperson.Name;
                                if CustTable.Get(SalesInvoiceHeader."Sell-to Customer No.") then begin
                                    RecTemp."Customer Group" := CustTable."BLACC Customer Group";
                                    if CustGroup.Get(CustTable."BLACC Customer Group") then RecTemp."Customer Group Name" := CustGroup.Description;
                                end;
                                if SalesInvoiceHeader."Currency Factor" <> 0 then
                                    RecTemp."Exchange Rate" := 1 / SalesInvoiceHeader."Currency Factor"
                                else
                                    RecTemp."Exchange Rate" := 1;

                                if SalesInvoiceHeader."BLTI Original eInvoice No." <> '' then begin
                                    eInvoiceHeader.Reset();
                                    eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesInvoiceHeader."BLTI Original eInvoice No.");
                                    if eInvoiceHeader.FindFirst() then begin
                                        RecTemp."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                                        RecTemp."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                                        RecTemp."Sales Order" := eInvoiceHeader."Order No.";
                                        RecTemp."Orig Invoice No." := eInvoiceHeader."No.";
                                    end;
                                end;
                                SalesInvoiceLine.Reset();
                                SalesInvoiceLine.SetRange("Document No.", CostValueEntry."Document No.");
                                SalesInvoiceLine.SetRange("Line No.", CostValueEntry."Line No.");
                                SalesInvoiceLine.SetRange("Posting Date", CostValueEntry."Posting Date");
                                if ItemNo <> '' then SalesInvoiceLine.SetFilter("No.", ItemNo);
                                if SearchName <> '' then SalesInvoiceLine.SetFilter("BLTEC Item Name", SearchName);
                                if Description <> '' then SalesInvoiceLine.SetFilter(Description, Description);
                                if SalesOrder <> '' then SalesInvoiceLine.SetFilter("Order No.", SalesOrder);
                                if VATProdPostingGroup <> '' then SalesInvoiceLine.SetRange("VAT Prod. Posting Group", VATProdPostingGroup);
                                if SalesInvoiceLine.FindSet() then
                                    repeat
                                        InsertLine := true;
                                        RecTemp."Sales Order" := SalesInvoiceLine."Order No.";
                                        RecTemp."Invoice No." := SalesInvoiceLine."BLTI eInvoice No.";
                                        RecTemp."Item Number" := SalesInvoiceLine."No.";
                                        RecTemp.Description := SalesInvoiceLine."BLTEC Item Name";
                                        RecTemp."Search Name" := SalesInvoiceLine.Description;
                                        RecTemp.Unit := SalesInvoiceLine."Unit of Measure Code";
                                        RecTemp."Unit Price" := SalesInvoiceLine."Unit Price";
                                        RecTemp."Sales Tax Amount" := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount";
                                        RecTemp."Charge Amount" := SalesInvoiceLine."BLACC CommissionExpenseAmount";
                                        RecTemp."Item Sales Tax Group" := SalesInvoiceLine."Tax Group Code";
                                        RecTemp."VAT %" := SalesInvoiceLine."VAT %";
                                        RecTemp."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";

                                        RecTemp.Quantity := SalesInvoiceLine.Quantity;
                                        RecTemp.Amount := SalesInvoiceLine."Line Amount";
                                        RecTemp."Amount (LCY)" := SalesInvoiceLine."Line Amount" * RecTemp."Exchange Rate";

                                        DimArray := GetAllDimensionCodeValue(SalesInvoiceLine."Dimension Set ID");
                                        RecTemp."Branch Code" := DimArray.Get(1);
                                        DimValue.Reset();
                                        DimValue.SetRange("Dimension Code", 'BRANCH');
                                        DimValue.SetRange(Code, RecTemp."Branch Code");
                                        if DimValue.FindFirst() then RecTemp."Branch Name" := DimValue.Name;
                                        RecTemp."BU Code" := DimArray.Get(2);
                                        DimValue.Reset();
                                        DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                                        DimValue.SetRange(Code, RecTemp."BU Code");
                                        if DimValue.FindFirst() then RecTemp."BU Name" := DimValue.Name;
                                        RecTemp."Cost Center" := DimArray.Get(3);
                                        DimValue.Reset();
                                        DimValue.SetRange("Dimension Code", 'COSTCENTER');
                                        DimValue.SetRange(Code, RecTemp."Cost Center");
                                        if DimValue.FindFirst() then RecTemp."Cost Center Name" := DimValue.Name;
                                        RecTemp.Insert();
                                    until SalesInvoiceLine.Next() = 0;
                                if InsertLine = false then
                                    RecTemp.Insert();
                            until SalesInvoiceHeader.Next() = 0;
                    end;
                    if CostValueEntry."Document Type" = "Item Ledger Document Type"::"Sales Credit Memo" then begin
                        SalesCrMemosHeader.Reset();
                        SalesCrMemosHeader.SetRange("No.", CostValueEntry."Document No.");
                        if InvoiceAccount <> '' then SalesCrMemosHeader.SetFilter("Bill-to Customer No.", InvoiceAccount);
                        if InvoiceName <> '' then SalesCrMemosHeader.SetFilter("Bill-to Name", InvoiceName);
                        if CustomerNo <> '' then SalesCrMemosHeader.SetFilter("Sell-to Customer No.", CustomerNo);
                        if CustomerName <> '' then SalesCrMemosHeader.SetFilter("Sell-to Customer Name", CustomerName);
                        if (FromeInvoiceDate <> 0D) AND (ToeInvoiceDate <> 0D) then SalesCrMemosHeader.SetRange("Posting Date", FromeInvoiceDate, ToeInvoiceDate);
                        if eInvoiceNo <> '' then SalesCrMemosHeader.SetFilter("External Document No.", eInvoiceNo);
                        if SalesCrMemosHeader.FindSet() then
                            repeat
                                InsertLine := false;
                                RecTemp."Invoice Date" := SalesCrMemosHeader."Posting Date";
                                RecTemp."Customer Account" := SalesCrMemosHeader."Sell-to Customer No.";
                                RecTemp."Customer Name" := SalesCrMemosHeader."Sell-to Customer Name";
                                RecTemp."Invoice Account" := SalesCrMemosHeader."Bill-to Customer No.";
                                RecTemp."Invoice Name" := SalesCrMemosHeader."Bill-to Name";
                                RecTemp."Sales Taker" := SalesCrMemosHeader."Salesperson Code";
                                RecTemp."Sales District" := SalesCrMemosHeader."Sell-to City";
                                if Salesperson.Get(SalesCrMemosHeader."Salesperson Code") then
                                    RecTemp."Sales Taker Name" := Salesperson.Name;
                                if CustTable.Get(SalesCrMemosHeader."Sell-to Customer No.") then begin
                                    RecTemp."Customer Group" := CustTable."BLACC Customer Group";
                                    if CustGroup.Get(CustTable."BLACC Customer Group") then RecTemp."Customer Group Name" := CustGroup.Description;
                                end;
                                if SalesCrMemosHeader."Currency Factor" <> 0 then
                                    RecTemp."Exchange Rate" := 1 / SalesCrMemosHeader."Currency Factor"
                                else
                                    RecTemp."Exchange Rate" := 1;

                                if SalesCrMemosHeader."BLTI Original eInvoice No." <> '' then begin
                                    eInvoiceHeader.Reset();
                                    eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesCrMemosHeader."BLTI Original eInvoice No.");
                                    if eInvoiceHeader.FindFirst() then begin
                                        RecTemp."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                                        RecTemp."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                                        RecTemp."Sales Order" := eInvoiceHeader."Order No.";
                                        RecTemp."Orig Invoice No." := eInvoiceHeader."No.";
                                    end;
                                end;
                                SalesCrMemosLine.Reset();
                                SalesCrMemosLine.SetRange("Document No.", CostValueEntry."Document No.");
                                SalesCrMemosLine.SetRange("Line No.", CostValueEntry."Line No.");
                                SalesCrMemosLine.SetRange("Posting Date", CostValueEntry."Posting Date");
                                if ItemNo <> '' then SalesCrMemosLine.SetFilter("No.", ItemNo);
                                if SearchName <> '' then SalesCrMemosLine.SetFilter("BLTEC Item Name", SearchName);
                                if Description <> '' then SalesCrMemosLine.SetFilter(Description, Description);
                                if SalesOrder <> '' then SalesCrMemosLine.SetFilter("Order No.", SalesOrder);
                                if VATProdPostingGroup <> '' then SalesCrMemosLine.SetRange("VAT Prod. Posting Group", VATProdPostingGroup);
                                if SalesCrMemosLine.FindSet() then
                                    repeat
                                        InsertLine := true;
                                        RecTemp."Sales Order" := SalesCrMemosLine."Order No.";
                                        RecTemp."Invoice No." := SalesCrMemosLine."BLTI eInvoice No.";
                                        RecTemp."Item Number" := SalesCrMemosLine."No.";
                                        RecTemp.Description := SalesCrMemosLine."BLTEC Item Name";
                                        RecTemp."Search Name" := SalesCrMemosLine.Description;
                                        RecTemp.Unit := SalesCrMemosLine."Unit of Measure Code";
                                        RecTemp."Unit Price" := SalesCrMemosLine."Unit Price";

                                        RecTemp."Item Sales Tax Group" := SalesCrMemosLine."Tax Group Code";
                                        RecTemp."VAT %" := SalesCrMemosLine."VAT %";
                                        RecTemp."VAT Prod. Posting Group" := SalesCrMemosLine."VAT Prod. Posting Group";

                                        RecTemp.Quantity := -SalesCrMemosLine.Quantity;
                                        RecTemp.Amount := -SalesCrMemosLine."Line Amount";
                                        RecTemp."Amount (LCY)" := -(SalesCrMemosLine."Line Amount" * RecTemp."Exchange Rate");
                                        RecTemp."Sales Tax Amount" := -(SalesCrMemosLine."Amount Including VAT" - SalesCrMemosLine."VAT Base Amount");
                                        RecTemp."Charge Amount" := -SalesCrMemosLine."BLACC CommissionExpenseAmount";

                                        DimArray := GetAllDimensionCodeValue(SalesCrMemosLine."Dimension Set ID");
                                        RecTemp."Branch Code" := DimArray.Get(1);
                                        DimValue.Reset();
                                        DimValue.SetRange("Dimension Code", 'BRANCH');
                                        DimValue.SetRange(Code, RecTemp."Branch Code");
                                        if DimValue.FindFirst() then RecTemp."Branch Name" := DimValue.Name;
                                        RecTemp."BU Code" := DimArray.Get(2);
                                        DimValue.Reset();
                                        DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                                        DimValue.SetRange(Code, RecTemp."BU Code");
                                        if DimValue.FindFirst() then RecTemp."BU Name" := DimValue.Name;
                                        RecTemp."Cost Center" := DimArray.Get(3);
                                        DimValue.Reset();
                                        DimValue.SetRange("Dimension Code", 'COSTCENTER');
                                        DimValue.SetRange(Code, RecTemp."Cost Center");
                                        if DimValue.FindFirst() then RecTemp."Cost Center Name" := DimValue.Name;
                                        RecTemp.Insert();
                                    until SalesCrMemosLine.Next() = 0;
                                if InsertLine = false then
                                    RecTemp.Insert();
                            until SalesCrMemosHeader.Next() = 0;
                    end;
                end;
            until CostValueEntry.Next() = 0;
    end;

    local procedure GetServiceInvoice()
    var
        SalesInvoice: Query "AIG Sales Invoice Qry";
        eInvoiceHeader: Record "Sales Invoice Header";
        Salesperson: Record "Salesperson/Purchaser";
        CustTable: Record Customer;
        CustGroup: Record "BLACC Customer Group";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
    begin
        if (FromPostingDate <> 0D) AND (ToPostingDate <> 0D) then SalesInvoice.SetRange(PostingDate, FromPostingDate, ToPostingDate);
        if DocumentNo <> '' then SalesInvoice.SetFilter(No, DocumentNo);
        if InvoiceAccount <> '' then SalesInvoice.SetFilter(BilltoCustomerNo, InvoiceAccount);
        if InvoiceName <> '' then SalesInvoice.SetFilter(BilltoName, InvoiceName);
        if CustomerNo <> '' then SalesInvoice.SetFilter(SelltoCustomerNo, CustomerNo);
        if CustomerName <> '' then SalesInvoice.SetFilter(SelltoCustomerName, CustomerName);
        if (FromeInvoiceDate <> 0D) AND (ToeInvoiceDate <> 0D) then SalesInvoice.SetRange(PostingDate, FromeInvoiceDate, ToeInvoiceDate);
        if eInvoiceNo <> '' then SalesInvoice.SetFilter(ExternalDocumentNo, eInvoiceNo);
        if ItemNo <> '' then SalesInvoice.SetFilter(ItemNo, ItemNo);
        if SearchName <> '' then SalesInvoice.SetFilter(ItemName, SearchName);
        if Description <> '' then SalesInvoice.SetFilter(SearchName, Description);
        if SalesOrder <> '' then SalesInvoice.SetFilter(SalesNo, SalesOrder);
        if VATProdPostingGroup <> '' then SalesInvoice.SetRange(VATProdPostingGroup, VATProdPostingGroup);
        if SalesInvoice.Open() then
            while SalesInvoice.Read() do begin
                RecTemp.Init();
                RecTemp."Document Type" := "Item Ledger Document Type"::"Sales Invoice";
                RecTemp."Document No." := SalesInvoice.No;
                RecTemp."Posting Date" := SalesInvoice.PostingDate;
                RecTemp."Sales Taker" := SalesInvoice.SalespersonCode;
                RecTemp."Sales District" := SalesInvoice.SelltoCity;
                if Salesperson.Get(SalesInvoice.SalespersonCode) then
                    RecTemp."Sales Taker Name" := Salesperson.Name;

                RecTemp."Customer Account" := SalesInvoice.SelltoCustomerNo;
                if CustTable.Get(SalesInvoice.SelltoCustomerNo) then begin
                    RecTemp."Customer Group" := CustTable."BLACC Customer Group";
                    RecTemp."Customer Name" := CustTable.Name;
                    if CustGroup.Get(CustTable."BLACC Customer Group") then RecTemp."Customer Group Name" := CustGroup.Description;
                end;
                RecTemp."Invoice Account" := SalesInvoice.BilltoCustomerNo;
                RecTemp."Invoice Name" := SalesInvoice.BilltoName;
                RecTemp."Invoice Date" := SalesInvoice.PostingDate;
                RecTemp."Invoice No." := SalesInvoice.BLTIeInvoiceNo;

                if SalesInvoice.BLTIOriginaleInvoiceNo = '' then begin
                    eInvoiceHeader.Reset();
                    eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesInvoice.BLTIOriginaleInvoiceNo);
                    if eInvoiceHeader.FindFirst() then begin
                        RecTemp."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                        RecTemp."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                        RecTemp."Sales Order" := eInvoiceHeader."Order No.";
                        RecTemp."Orig Invoice No." := eInvoiceHeader."No.";
                    end;
                end;
                RecTemp."Sales Order" := SalesInvoice.SalesNo;
                RecTemp."Line No." := SalesInvoice.LineNo;
                RecTemp."Item Number" := SalesInvoice.ItemNo;
                RecTemp.Description := SalesInvoice.ItemName;
                RecTemp."Search Name" := SalesInvoice.SearchName;
                RecTemp.Unit := SalesInvoice.UnitCode;

                DimArray := GetAllDimensionCodeValue(SalesInvoice.DimensionSetID);
                RecTemp."Branch Code" := DimArray.Get(1);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BRANCH');
                DimValue.SetRange(Code, RecTemp."Branch Code");
                if DimValue.FindFirst() then RecTemp."Branch Name" := DimValue.Name;
                RecTemp."BU Code" := DimArray.Get(2);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                DimValue.SetRange(Code, RecTemp."BU Code");
                if DimValue.FindFirst() then RecTemp."BU Name" := DimValue.Name;
                RecTemp."Cost Center" := DimArray.Get(3);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'COSTCENTER');
                DimValue.SetRange(Code, RecTemp."Cost Center");
                if DimValue.FindFirst() then RecTemp."Cost Center Name" := DimValue.Name;

                RecTemp.Quantity := SalesInvoice.Quantity;
                RecTemp."Unit Price" := SalesInvoice.UnitPrice;
                RecTemp.Amount := SalesInvoice.LineAmount;
                RecTemp."Sales Tax Amount" := SalesInvoice.AmountIncludingVAT - SalesInvoice.VATBaseAmount;
                RecTemp."Item Sales Tax Group" := SalesInvoice.ItemSalesTaxGroup;
                RecTemp."VAT %" := SalesInvoice.VATPercent;
                RecTemp."VAT Prod. Posting Group" := SalesInvoice.VATProdPostingGroup;
                RecTemp."Exchange Rate" := 1;
                RecTemp."Amount (LCY)" := SalesInvoice.LineAmount;
                if SalesInvoice.ItemNo = '333110' then begin
                    if CopyStr(SalesInvoice.VATProdPostingGroup, 1, 2) = 'F-' then begin
                        RecTemp."Unit Price" := 0;
                        RecTemp.Amount := 0;
                        RecTemp."Amount (LCY)" := 0;
                        RecTemp.Insert();
                    end;

                end;
                if CopyStr(SalesInvoice.ItemNo, 1, 3) = '511' then
                    RecTemp.Insert();
                if CopyStr(SalesInvoice.ItemNo, 1, 3) = '515' then
                    RecTemp.Insert();
                if CopyStr(SalesInvoice.ItemNo, 1, 4) = '6428' then
                    RecTemp.Insert();
            end;
        SalesInvoice.Close();
    end;

    local procedure GetServiceCrMemos()
    var
        SalesCrMemos: Query "AIG Sales CrMemos Qry";
        eInvoiceHeader: Record "Sales Invoice Header";
        Salesperson: Record "Salesperson/Purchaser";
        CustTable: Record Customer;
        CustGroup: Record "BLACC Customer Group";
        DimValue: Record "Dimension Value";
        DimArray: List of [Text];
    begin

        if (FromPostingDate <> 0D) AND (ToPostingDate <> 0D) then SalesCrMemos.SetRange(PostingDate, FromPostingDate, ToPostingDate);
        if DocumentNo <> '' then SalesCrMemos.SetFilter(No, DocumentNo);
        if InvoiceAccount <> '' then SalesCrMemos.SetFilter(BilltoCustomerNo, InvoiceAccount);
        if InvoiceName <> '' then SalesCrMemos.SetFilter(BilltoName, InvoiceName);
        if CustomerNo <> '' then SalesCrMemos.SetFilter(SelltoCustomerNo, CustomerNo);
        if CustomerName <> '' then SalesCrMemos.SetFilter(SelltoCustomerName, CustomerName);
        if (FromeInvoiceDate <> 0D) AND (ToeInvoiceDate <> 0D) then SalesCrMemos.SetRange(PostingDate, FromeInvoiceDate, ToeInvoiceDate);
        if eInvoiceNo <> '' then SalesCrMemos.SetFilter(ExternalDocumentNo, eInvoiceNo);
        if ItemNo <> '' then SalesCrMemos.SetFilter(ItemNo, ItemNo);
        if SearchName <> '' then SalesCrMemos.SetFilter(ItemName, SearchName);
        if Description <> '' then SalesCrMemos.SetFilter(SearchName, Description);
        if SalesOrder <> '' then SalesCrMemos.SetFilter(SalesNo, SalesOrder);
        if VATProdPostingGroup <> '' then SalesCrMemos.SetRange(VATProdPostingGroup, VATProdPostingGroup);
        if SalesCrMemos.Open() then begin
            while SalesCrMemos.Read() do begin
                RecTemp.Init();
                RecTemp."Document Type" := "Item Ledger Document Type"::"Sales Credit Memo";
                RecTemp."Document No." := SalesCrMemos.No;
                RecTemp."Posting Date" := SalesCrMemos.PostingDate;
                RecTemp."Sales Taker" := SalesCrMemos.SalespersonCode;
                RecTemp."Sales District" := SalesCrMemos.SelltoCity;
                if Salesperson.Get(SalesCrMemos.SalespersonCode) then
                    RecTemp."Sales Taker Name" := Salesperson.Name;

                RecTemp."Customer Account" := SalesCrMemos.SelltoCustomerNo;
                if CustTable.Get(SalesCrMemos.SelltoCustomerNo) then begin
                    RecTemp."Customer Group" := CustTable."BLACC Customer Group";
                    RecTemp."Customer Name" := CustTable.Name;
                    if CustGroup.Get(CustTable."BLACC Customer Group") then RecTemp."Customer Group Name" := CustGroup.Description;
                end;
                RecTemp."Invoice Account" := SalesCrMemos.BilltoCustomerNo;
                RecTemp."Invoice Name" := SalesCrMemos.BilltoName;

                RecTemp."Invoice Date" := SalesCrMemos.PostingDate;
                RecTemp."Invoice No." := SalesCrMemos.BLTIeInvoiceNo;

                if SalesCrMemos.BLTIOriginaleInvoiceNo = '' then begin
                    eInvoiceHeader.Reset();
                    eInvoiceHeader.SetRange("BLTI eInvoice No.", SalesCrMemos.BLTIOriginaleInvoiceNo);
                    if eInvoiceHeader.FindFirst() then begin
                        RecTemp."Orig eInvoice No." := eInvoiceHeader."BLTI eInvoice No.";
                        RecTemp."Orig Invoice Date" := eInvoiceHeader."Posting Date";
                        RecTemp."Sales Order" := eInvoiceHeader."Order No.";
                        RecTemp."Orig Invoice No." := eInvoiceHeader."No.";
                    end;
                end;
                RecTemp."Sales Order" := SalesCrMemos.SalesNo;
                RecTemp."Line No." := SalesCrMemos.LineNo;
                RecTemp."Item Number" := SalesCrMemos.ItemNo;
                RecTemp.Description := SalesCrMemos.ItemName;
                RecTemp."Search Name" := SalesCrMemos.SearchName;
                RecTemp.Unit := SalesCrMemos.UnitCode;

                DimArray := GetAllDimensionCodeValue(SalesCrMemos.DimensionSetID);
                RecTemp."Branch Code" := DimArray.Get(1);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BRANCH');
                DimValue.SetRange(Code, RecTemp."Branch Code");
                if DimValue.FindFirst() then RecTemp."Branch Name" := DimValue.Name;
                RecTemp."BU Code" := DimArray.Get(2);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                DimValue.SetRange(Code, RecTemp."BU Code");
                if DimValue.FindFirst() then RecTemp."BU Name" := DimValue.Name;
                RecTemp."Cost Center" := DimArray.Get(3);
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", 'COSTCENTER');
                DimValue.SetRange(Code, RecTemp."Cost Center");
                if DimValue.FindFirst() then RecTemp."Cost Center Name" := DimValue.Name;

                RecTemp.Quantity := -SalesCrMemos.Quantity;
                RecTemp."Unit Price" := SalesCrMemos.UnitPrice;
                RecTemp.Amount := -SalesCrMemos.LineAmount;
                RecTemp."Sales Tax Amount" := -(SalesCrMemos.AmountIncludingVAT - SalesCrMemos.VATBaseAmount);
                RecTemp."Item Sales Tax Group" := SalesCrMemos.ItemSalesTaxGroup;
                RecTemp."VAT %" := SalesCrMemos.VATPercent;
                RecTemp."VAT Prod. Posting Group" := SalesCrMemos.VATProdPostingGroup;
                RecTemp."Exchange Rate" := 1;
                RecTemp."Amount (LCY)" := -SalesCrMemos.LineAmount;
                if SalesCrMemos.ItemNo = '333110' then begin
                    if CopyStr(SalesCrMemos.VATProdPostingGroup, 1, 2) = 'F-' then begin
                        RecTemp."Unit Price" := 0;
                        RecTemp.Amount := 0;
                        RecTemp."Amount (LCY)" := 0;
                        RecTemp.Insert();
                    end;

                end;
                if CopyStr(SalesCrMemos.ItemNo, 1, 3) = '511' then
                    RecTemp.Insert();
                if CopyStr(SalesCrMemos.ItemNo, 1, 3) = '515' then
                    RecTemp.Insert();
                if CopyStr(SalesCrMemos.ItemNo, 1, 4) = '6428' then
                    RecTemp.Insert();
            end;
            SalesCrMemos.Close();
        end;
    end;

    procedure GetAllDimensionCodeValue(iviDimId: Integer) ovlstDimSet: List of [Text]
    var
        recDSE: Record "Dimension Set Entry";
        tBranch: Text;
        tBusinessUnit: Text;
        tCostCenter: Text;
        tEmployee: Text;
        tExpeseType: Text;
        tDivision: Text;
        tProdCategory: Text;
        tCustomer: Text;
    begin
        recDSE.SetRange("Dimension Set ID", iviDimId);
        if recDSE.FindSet() then begin
            repeat
                case recDSE."Dimension Code" of
                    'BRANCH':
                        tBranch := recDSE."Dimension Value Code";
                    'BUSINESSUNIT':
                        tBusinessUnit := recDSE."Dimension Value Code";
                    'COSTCENTER':
                        tCostCenter := recDSE."Dimension Value Code";
                    'EMPLOYEE':
                        tEmployee := recDSE."Dimension Value Code";
                    'EXPENSETYPE':
                        tExpeseType := recDSE."Dimension Value Code";
                    'DIVISION':
                        tDivision := recDSE."Dimension Value Code";
                    'PRODCATEGORY':
                        tProdCategory := recDSE."Dimension Value Code";
                    'CUSTOMER':
                        tCustomer := recDSE."Dimension Value Code";
                end;
            until recDSE.Next() < 1;
        end;

        ovlstDimSet.Add(tBranch);
        ovlstDimSet.Add(tBusinessUnit);
        ovlstDimSet.Add(tCostCenter);
        ovlstDimSet.Add(tEmployee);
        ovlstDimSet.Add(tExpeseType);
        ovlstDimSet.Add(tDivision);
        ovlstDimSet.Add(tProdCategory);
        ovlstDimSet.Add(tCustomer);

        exit(ovlstDimSet);
    end;

    local procedure CostValueEntry(FromDate: Date; ToDate: Date)
    var
        CostValueQuery: Query "AIG Cost Value Entry";
        CostValueEntry: Record "AIG Cost Value Entry";
    begin
        CostValueQuery.SetRange(PostingDate, FromDate, ToDate);
        CostValueQuery.SetRange(Adjustment, false);
        if CostValueQuery.Open() then begin
            while CostValueQuery.Read() do begin
                if not CostValueEntry.Get(CostValueQuery.DocumentNo, CostValueQuery.DocumentLineNo, CostValueQuery.ItemLedgerEntryNo, CostValueQuery.PostingDate) then begin
                    CostValueEntry.Init();
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Invoice" then CostValueEntry."Table No." := 113;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Credit Memo" then CostValueEntry."Table No." := 115;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Invoice" then CostValueEntry."Table No." := 123;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Credit Memo" then CostValueEntry."Table No." := 125;
                    CostValueEntry."Document Type" := CostValueQuery.DocumentType;
                    CostValueEntry."Document No." := CostValueQuery.DocumentNo;
                    CostValueEntry."Line No." := CostValueQuery.DocumentLineNo;
                    CostValueEntry."Item Ledger Entry No." := CostValueQuery.ItemLedgerEntryNo;
                    CostValueEntry."Posting Date" := CostValueQuery.PostingDate;
                    CostValueEntry."AIG Cost Amount" := CostValueQuery.CostAmountActual;
                    CostValueEntry.Insert();
                end;
            end;
            CostValueQuery.Close();
        end;

        CostValueQuery.SetRange(PostingDate, FromDate, ToDate);
        CostValueQuery.SetRange(Adjustment, true);
        if CostValueQuery.Open() then begin
            while CostValueQuery.Read() do begin
                if CostValueEntry.Get(CostValueQuery.DocumentNo, CostValueQuery.DocumentLineNo, CostValueQuery.ItemLedgerEntryNo, CostValueQuery.PostingDate) then begin
                    if CostValueEntry."AIG Cost Amount Adjustment" <> CostValueQuery.CostAmountActual then begin
                        CostValueEntry."AIG Cost Amount Adjustment" := CostValueQuery.CostAmountActual;
                        CostValueEntry.Modify();
                    end;
                end else begin
                    CostValueEntry.Init();
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Invoice" then CostValueEntry."Table No." := 113;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Sales Credit Memo" then CostValueEntry."Table No." := 115;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Invoice" then CostValueEntry."Table No." := 123;
                    if CostValueQuery.DocumentType = "Item Ledger Document Type"::"Purchase Credit Memo" then CostValueEntry."Table No." := 125;
                    CostValueEntry."Document Type" := CostValueQuery.DocumentType;
                    CostValueEntry."Document No." := CostValueQuery.DocumentNo;
                    CostValueEntry."Line No." := CostValueQuery.DocumentLineNo;
                    CostValueEntry."Item Ledger Entry No." := CostValueQuery.ItemLedgerEntryNo;
                    CostValueEntry."Posting Date" := CostValueQuery.PostingDate;
                    CostValueEntry."AIG Cost Amount Adjustment" := CostValueQuery.CostAmountActual;
                    CostValueEntry.Insert();
                end;
            end;
            CostValueQuery.Close();
        end;
    end;

    var
        DocumentNo: Text;
        InvoiceAccount: Text;
        InvoiceName: Text;
        eInvoiceNo: Text;
        FromeInvoiceDate: Date;
        ToeInvoiceDate: Date;
        OrigeInvoiceNo: Text;
        SalesOrder: Text;
        CustomerNo: Text;
        CustomerName: Text;
        CustomerGroupName: Text;
        ItemNo: Text;
        SearchName: Text;
        Description: Text;
        FromPostingDate: Date;
        ToPostingDate: Date;
        VATProdPostingGroup: Text;
}
