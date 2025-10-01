page 51023 "AHH Sales Statistics"
{
    ApplicationArea = All;
    Caption = 'AHH Sales Statistics - P51023';
    PageType = List;
    SourceTable = "AHH Sales Statistics";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("External Document No."; ExternalDocumentNo) { }
                field("VAT Bus. Posting Group"; VATBus) { }
                field("VAT Prod. Posting Group"; VATProd) { }
                field("Sales No."; Rec."Sales No.") { }
                field("Document No."; Rec."Document No.") { }
                field("Line No."; Rec."Line No.") { }
                field("eInvoice No."; Rec."eInvoice No.") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("BU Code"; Rec."BU Code") { }
                field(Salesperson; Rec.Salesperson) { }
                field("Salesperson Name"; Rec."Salesperson Name") { }
                field(UnitId; Rec.UnitId) { }
                field(Quantity; Rec.Quantity) { }
                field("Unit Price"; Rec."Unit Price") { }
                field(Amount; Rec.Amount) { }
                field(VATAmount; VATAmount) { }
                field("Cost Amount"; Rec."Cost Amount") { }
                field(GM1; Rec.GM1) { }
                field("Charge Amount"; Rec."Charge Amount") { }
                field(GM2; Rec.GM2) { }
                field("Commission Entry No."; Rec."Commission Entry No.") { }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ACCAction)
            {
                Caption = 'Action';

                action(ACCLastMonth)
                {
                    ApplicationArea = All;
                    Caption = 'Last Month';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        CalcLastMonth();
                    end;
                }
                action(ACCThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'This Month';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        CalcThisMonth();
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if Rec."Sales Return" then begin
            SalesCrMemoLine.Reset();
            SalesCrMemoLine.SetRange("Document No.", Rec."Document No.");
            SalesCrMemoLine.SetRange("Order No.", Rec."Sales No.");
            SalesCrMemoLine.SetRange("Order Line No.", Rec."Line No.");
            if SalesCrMemoLine.FindFirst() then begin
                VATAmount := SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine."VAT Base Amount";
                VATBus := SalesCrMemoLine."VAT Bus. Posting Group";
                VATProd := SalesCrMemoLine."VAT Prod. Posting Group";
            end;
            SalesCrMemoHeader.Reset();
            SalesCrMemoHeader.SetRange("No.", Rec."Document No.");
            if SalesCrMemoHeader.FindFirst() then
                ExternalDocumentNo := SalesCrMemoHeader."External Document No.";
        end else begin
            SalesInvoiceLine.Reset();
            SalesInvoiceLine.SetRange("Document No.", Rec."Document No.");
            SalesInvoiceLine.SetRange("Order No.", Rec."Sales No.");
            SalesInvoiceLine.SetRange("Order Line No.", Rec."Line No.");
            if SalesInvoiceLine.FindFirst() then begin
                VATAmount := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount";
                VATBus := SalesInvoiceLine."VAT Bus. Posting Group";
                VATProd := SalesInvoiceLine."VAT Prod. Posting Group";
            end;
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", Rec."Document No.");
            if SalesInvoiceHeader.FindFirst() then
                ExternalDocumentNo := SalesInvoiceHeader."External Document No.";
        end;
    end;

    var
        VATAmount: Decimal;
        ExternalDocumentNo: Code[35];
        VATBus: Code[20];
        VATProd: Code[20];

    local procedure CalcLastMonth()
    var
        ItemTable: Record Item;
        SalesHeader: Record "Sales Invoice Header";
        MemosHeader: Record "Sales Cr.Memo Header";
        SalesLine: Record "Sales Invoice Line";
        MemosLine: Record "Sales Cr.Memo Line";
        Customers: Record "AHH Customer";
        CommPrice: Record "AHH Commission Price";
        SalesStat: Record "AHH Sales Statistics";
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today());
        FromDate := CalcDate('-1M', FromDate);
        ToDate := CalcDate('CM', FromDate);
        SalesStat.Reset();
        SalesStat.SetRange("Posting Date", FromDate, ToDate);
        if SalesStat.FindSet() then
            SalesStat.DeleteAll(true);

        Customers.Reset();
        if Customers.FindSet() then begin
            repeat
                SalesLine.Reset();
                SalesLine.SetRange("Sell-to Customer No.", Customers."Customer No.");
                SalesLine.SetRange("Posting Date", FromDate, ToDate);
                SalesLine.SetRange(Type, "Sales Line Type"::Item);
                SalesLine.SetFilter("No.", '<>%1', 'SERVICE-511');
                //SalesLine.SetFilter("BLTI eInvoice No.", '<>%1', '');
                if SalesLine.FindSet() then begin
                    repeat
                        SalesStat.Init();
                        SalesStat."Sales No." := SalesLine."Order No.";
                        SalesStat."Document No." := SalesLine."Document No.";
                        SalesStat."Line No." := SalesLine."Line No.";
                        SalesStat."eInvoice No." := SalesLine."BLTI eInvoice No.";
                        SalesStat."Customer No." := SalesLine."Sell-to Customer No.";
                        SalesStat."Item No." := SalesLine."No.";
                        SalesStat."Posting Date" := SalesLine."Posting Date";
                        SalesStat."BU Code" := SalesLine."Shortcut Dimension 2 Code";
                        SalesHeader.Reset();
                        SalesHeader.SetRange("No.", SalesLine."Document No.");
                        if SalesHeader.FindFirst() then
                            SalesStat.Salesperson := SalesHeader."Salesperson Code";
                        SalesStat.Quantity := SalesLine.Quantity;
                        SalesStat."Unit Price" := SalesLine."Unit Price";
                        SalesStat.Amount := SalesLine."Line Amount";
                        ItemTable.Reset();
                        //ItemTable.SetAutoCalcFields("Unit Cost");
                        if ItemTable.Get(SalesLine."No.") then begin
                            //ItemTable.CalcFields("Unit Cost");
                            if ItemTable."Unit Cost" <> 0 then begin
                                SalesStat."Cost Price" := ItemTable."Unit Cost";
                                SalesStat."Cost Amount" := ItemTable."Unit Cost" * SalesLine.Quantity;
                            end else begin
                                SalesStat."Cost Price" := ItemTable."Last Direct Cost";
                                SalesStat."Cost Amount" := ItemTable."Last Direct Cost" * SalesLine.Quantity;
                            end;
                        end;
                        SalesStat.GM1 := SalesLine.Amount - SalesStat."Cost Amount";
                        CommPrice.Reset();
                        CommPrice.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
                        CommPrice.SetRange("Item No.", SalesLine."No.");
                        CommPrice.SetRange(State, "AHH Price State"::Released);
                        CommPrice.SetFilter("From Date", '..%1', SalesLine."Posting Date");
                        CommPrice.SetFilter("To Date", '%1..', SalesLine."Posting Date");
                        if CommPrice.FindFirst() then begin
                            SalesStat."Commission Entry No." := CommPrice."Entry No.";
                            SalesStat."Commission Price" := CommPrice.Price;
                            SalesStat."Charge Amount" := CommPrice.Price * SalesLine.Quantity;
                        end;
                        SalesStat.GM2 := SalesStat.GM1 - SalesStat."Charge Amount";
                        SalesStat.Insert();
                    until SalesLine.Next() = 0;
                end;

                MemosLine.Reset();
                MemosLine.SetRange("Sell-to Customer No.", Customers."Customer No.");
                MemosLine.SetRange("Posting Date", FromDate, ToDate);
                MemosLine.SetRange(Type, "Sales Line Type"::Item);
                MemosLine.SetFilter("No.", '<>%1', 'SERVICE-511');
                //MemosLine.SetFilter("BLTI eInvoice No.", '<>%1', '');
                if MemosLine.FindSet() then begin
                    repeat
                        SalesStat.Init();
                        SalesStat."Sales No." := MemosLine."Order No.";
                        SalesStat."Document No." := MemosLine."Document No.";
                        SalesStat."Line No." := MemosLine."Line No.";
                        SalesStat."eInvoice No." := MemosLine."BLTI eInvoice No.";
                        SalesStat."Customer No." := MemosLine."Sell-to Customer No.";
                        SalesStat."Item No." := MemosLine."No.";
                        SalesStat."Posting Date" := MemosLine."Posting Date";
                        SalesStat."BU Code" := MemosLine."Shortcut Dimension 2 Code";
                        MemosHeader.Reset();
                        MemosHeader.SetRange("No.", MemosLine."Document No.");
                        if MemosHeader.FindFirst() then
                            SalesStat.Salesperson := MemosHeader."Salesperson Code";
                        SalesStat.Quantity := MemosLine.Quantity * -1;
                        SalesStat."Unit Price" := MemosLine."Unit Price";
                        SalesStat.Amount := MemosLine."Line Amount" * -1;
                        ItemTable.Reset();
                        //ItemTable.SetAutoCalcFields("Unit Cost");
                        if ItemTable.Get(MemosLine."No.") then begin
                            //ItemTable.CalcFields("Unit Cost");
                            if ItemTable."Unit Cost" <> 0 then begin
                                SalesStat."Cost Price" := ItemTable."Unit Cost";
                                SalesStat."Cost Amount" := ItemTable."Unit Cost" * MemosLine.Quantity * -1;
                            end else begin
                                SalesStat."Cost Price" := ItemTable."Last Direct Cost";
                                SalesStat."Cost Amount" := ItemTable."Last Direct Cost" * MemosLine.Quantity * -1;
                            end;
                        end;
                        SalesStat.GM1 := SalesStat.Amount - SalesStat."Cost Amount";
                        CommPrice.Reset();
                        CommPrice.SetRange("Customer No.", MemosLine."Sell-to Customer No.");
                        CommPrice.SetRange("Item No.", MemosLine."No.");
                        CommPrice.SetRange(State, "AHH Price State"::Released);
                        CommPrice.SetFilter("From Date", '..%1', MemosLine."Posting Date");
                        CommPrice.SetFilter("To Date", '%1..', MemosLine."Posting Date");
                        if CommPrice.FindFirst() then begin
                            SalesStat."Commission Entry No." := CommPrice."Entry No.";
                            SalesStat."Commission Price" := CommPrice.Price;
                            SalesStat."Charge Amount" := CommPrice.Price * MemosLine.Quantity * -1;
                        end;
                        SalesStat.GM2 := SalesStat.GM1 - SalesStat."Charge Amount";
                        SalesStat."Sales Return" := true;
                        SalesStat.Insert();
                    until MemosLine.Next() = 0;
                end;
            until Customers.Next() = 0;
        end;

    end;

    local procedure CalcThisMonth()
    var
        ItemTable: Record Item;
        SalesHeader: Record "Sales Invoice Header";
        MemosHeader: Record "Sales Cr.Memo Header";
        SalesLine: Record "Sales Invoice Line";
        MemosLine: Record "Sales Cr.Memo Line";
        Customers: Record "AHH Customer";
        CommPrice: Record "AHH Commission Price";
        SalesStat: Record "AHH Sales Statistics";
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today());
        ToDate := CalcDate('CM', FromDate);

        SalesStat.Reset();
        SalesStat.SetRange("Posting Date", FromDate, ToDate);
        if SalesStat.FindSet() then
            SalesStat.DeleteAll(true);

        Customers.Reset();
        if Customers.FindSet() then begin
            repeat
                SalesLine.Reset();
                SalesLine.SetRange("Sell-to Customer No.", Customers."Customer No.");
                SalesLine.SetRange("Posting Date", FromDate, ToDate);
                SalesLine.SetRange(Type, "Sales Line Type"::Item);
                SalesLine.SetFilter("No.", '<>%1', 'SERVICE-511');
                //SalesLine.SetFilter("BLTI eInvoice No.", '<>%1', '');
                if SalesLine.FindSet() then begin
                    repeat
                        SalesStat.Init();
                        SalesStat."Sales No." := SalesLine."Order No.";
                        SalesStat."Document No." := SalesLine."Document No.";
                        SalesStat."Line No." := SalesLine."Line No.";
                        SalesStat."eInvoice No." := SalesLine."BLTI eInvoice No.";
                        SalesStat."Customer No." := SalesLine."Sell-to Customer No.";
                        SalesStat."Item No." := SalesLine."No.";
                        SalesStat."Posting Date" := SalesLine."Posting Date";
                        SalesStat."BU Code" := SalesLine."Shortcut Dimension 2 Code";
                        SalesHeader.Reset();
                        SalesHeader.SetRange("No.", SalesLine."Document No.");
                        if SalesHeader.FindFirst() then
                            SalesStat.Salesperson := SalesHeader."Salesperson Code";
                        SalesStat.Quantity := SalesLine.Quantity;
                        SalesStat."Unit Price" := SalesLine."Unit Price";
                        SalesStat.Amount := SalesLine."Line Amount";
                        ItemTable.Reset();
                        //ItemTable.SetAutoCalcFields("Unit Cost");
                        if ItemTable.Get(SalesLine."No.") then begin
                            //ItemTable.CalcFields("Unit Cost");
                            if ItemTable."Unit Cost" <> 0 then begin
                                SalesStat."Cost Price" := ItemTable."Unit Cost";
                                SalesStat."Cost Amount" := ItemTable."Unit Cost" * SalesLine.Quantity;
                            end else begin
                                SalesStat."Cost Price" := ItemTable."Last Direct Cost";
                                SalesStat."Cost Amount" := ItemTable."Last Direct Cost" * SalesLine.Quantity;
                            end;
                        end;
                        SalesStat.GM1 := SalesLine.Amount - SalesStat."Cost Amount";
                        CommPrice.Reset();
                        CommPrice.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
                        CommPrice.SetRange("Item No.", SalesLine."No.");
                        CommPrice.SetRange(State, "AHH Price State"::Released);
                        CommPrice.SetFilter("From Date", '..%1', SalesLine."Posting Date");
                        CommPrice.SetFilter("To Date", '%1..', SalesLine."Posting Date");
                        if CommPrice.FindFirst() then begin
                            SalesStat."Commission Entry No." := CommPrice."Entry No.";
                            SalesStat."Commission Price" := CommPrice.Price;
                            SalesStat."Charge Amount" := CommPrice.Price * SalesLine.Quantity;
                        end;
                        SalesStat.GM2 := SalesStat.GM1 - SalesStat."Charge Amount";
                        SalesStat.Insert();
                    until SalesLine.Next() = 0;
                end;

                MemosLine.Reset();
                MemosLine.SetRange("Sell-to Customer No.", Customers."Customer No.");
                MemosLine.SetRange("Posting Date", FromDate, ToDate);
                MemosLine.SetRange(Type, "Sales Line Type"::Item);
                MemosLine.SetFilter("No.", '<>%1', 'SERVICE-511');
                //MemosLine.SetFilter("BLTI eInvoice No.", '<>%1', '');
                if MemosLine.FindSet() then begin
                    repeat
                        SalesStat.Init();
                        SalesStat."Sales No." := MemosLine."Order No.";
                        SalesStat."Document No." := MemosLine."Document No.";
                        SalesStat."Line No." := MemosLine."Line No.";
                        SalesStat."eInvoice No." := MemosLine."BLTI eInvoice No.";
                        SalesStat."Customer No." := MemosLine."Sell-to Customer No.";
                        SalesStat."Item No." := MemosLine."No.";
                        SalesStat."Posting Date" := MemosLine."Posting Date";
                        SalesStat."BU Code" := MemosLine."Shortcut Dimension 2 Code";
                        MemosHeader.Reset();
                        MemosHeader.SetRange("No.", MemosLine."Document No.");
                        if MemosHeader.FindFirst() then
                            SalesStat.Salesperson := MemosHeader."Salesperson Code";
                        SalesStat.Quantity := MemosLine.Quantity * -1;
                        SalesStat."Unit Price" := MemosLine."Unit Price";
                        SalesStat.Amount := MemosLine."Line Amount" * -1;
                        ItemTable.Reset();
                        //ItemTable.SetAutoCalcFields("Unit Cost");
                        if ItemTable.Get(MemosLine."No.") then begin
                            //ItemTable.CalcFields("Unit Cost");
                            if ItemTable."Unit Cost" <> 0 then begin
                                SalesStat."Cost Price" := ItemTable."Unit Cost";
                                SalesStat."Cost Amount" := ItemTable."Unit Cost" * MemosLine.Quantity * -1;
                            end else begin
                                SalesStat."Cost Price" := ItemTable."Last Direct Cost";
                                SalesStat."Cost Amount" := ItemTable."Last Direct Cost" * MemosLine.Quantity * -1;
                            end;
                        end;
                        SalesStat.GM1 := SalesStat.Amount - SalesStat."Cost Amount";
                        CommPrice.Reset();
                        CommPrice.SetRange("Customer No.", MemosLine."Sell-to Customer No.");
                        CommPrice.SetRange("Item No.", MemosLine."No.");
                        CommPrice.SetRange(State, "AHH Price State"::Released);
                        CommPrice.SetFilter("From Date", '..%1', MemosLine."Posting Date");
                        CommPrice.SetFilter("To Date", '%1..', MemosLine."Posting Date");
                        if CommPrice.FindFirst() then begin
                            SalesStat."Commission Entry No." := CommPrice."Entry No.";
                            SalesStat."Commission Price" := CommPrice.Price;
                            SalesStat."Charge Amount" := CommPrice.Price * MemosLine.Quantity * -1;
                        end;
                        SalesStat.GM2 := SalesStat.GM1 - SalesStat."Charge Amount";
                        SalesStat."Sales Return" := true;
                        SalesStat.Insert();
                    until MemosLine.Next() = 0;
                end;
            until Customers.Next() = 0;
        end;

    end;
}
