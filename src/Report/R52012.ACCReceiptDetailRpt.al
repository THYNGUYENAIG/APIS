report 52012 "ACC Receipt Detail Report"
{
    Caption = 'ACC Receipt Detail Report - R52012';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52012_ACCReceiptDetailRpt.rdl';

    dataset
    {
        //Init Data
        dataitem(int1; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
                recWHRH: Record "Warehouse Receipt Header";
                recWHRL: Record "Warehouse Receipt Line";
                decQty: Decimal;
                decQtyReceived: Decimal;
                recPL: Record "Purchase Line";
                tName: Text;
                tDeclationNo: Text;
                recSL: Record "Sales Line";
                recTFL: Record "Transfer Line";
                recV: Record Vendor;
                recC: Record Customer;
                recPWRH: Record "Posted Whse. Receipt Header";
                recPWRL: Record "Posted Whse. Receipt Line";
                recPRL: Record "Purch. Rcpt. Line";
                // recTRL: Record "Transfer Receipt Line";
                recPRH: Record "Purch. Rcpt. Header";
                recTRH: Record "Transfer Receipt Header";
                recRRH: Record "Return Receipt Header";
                decQtyInvoiced: Decimal;
                tVendorInv: Text;
                bCheckIns: Boolean;
            // recACCIPT: Record "ACC Import Plan Table";
            begin
                iLine := ACCWHRTmp.Count();
                tDeclationNo := '';
                tVendorInv := '';

                recWHRH.Reset();
                recWHRH.SetRange("Posting Date", dsF, dsT);
                if tsLoc <> '' then recWHRH.SetRange("Location Code", tsLoc);
                if recWHRH.FindSet() then
                    repeat
                        decQty := 0;
                        decQtyReceived := 0;
                        decQtyInvoiced := 0;

                        recWHRL.Reset();
                        recWHRL.SetRange("No.", recWHRH."No.");
                        // recWHRL.SetRange("Source No.", '25052392');
                        recWHRL.SetFilter("Source Document", '%1 | %2 | %3'
                                            , "Warehouse Activity Source Document"::"Purchase Order"
                                            , "Warehouse Activity Source Document"::"Sales Return Order"
                                            , "Warehouse Activity Source Document"::"Inbound Transfer");
                        if recWHRL.FindFirst() then begin
                            iLine += 1;
                            ACCWHRTmp.Init();
                            ACCWHRTmp."Entry No" := iLine;
                            ACCWHRTmp."Document No" := recWHRH."No.";
                            ACCWHRTmp."Source No" := recWHRL."Source No.";
                            ACCWHRTmp."Location Code" := recWHRH."Location Code";
                            ACCWHRTmp."Item No" := recWHRL."Item No.";
                            ACCWHRTmp."Item Name" := recWHRL.Description;
                            ACCWHRTmp."Line No" := recWHRL."Source Line No.";

                            recL.Reset();
                            recL.SetRange(Code, recWHRH."Location Code");
                            if recL.FindFirst() then begin
                                ACCWHRTmp."Location Name" := recL.Name;
                            end;

                            ACCWHRTmp.Status := 'In Receiving';
                            ACCWHRTmp."Source Document" := recWHRL."Source Document";
                            ACCWHRTmp."Posting Date" := recWHRH."Posting Date";

                            tName := '';
                            tDeclationNo := '';
                            case recWHRL."Source Document" of
                                "Warehouse Activity Source Document"::"Purchase Order":
                                    begin
                                        recPL.Reset();
                                        recPL.SetRange("Document No.", recWHRL."Source No.");
                                        recPL.SetRange("Line No.", recWHRL."Source Line No.");
                                        recPL.SetRange("Document Type", "Purchase Document Type"::Order);
                                        recPL.SetRange(Type, "Purchase Line Type"::Item);
                                        if recPL.FindFirst() then begin
                                            recPL.CalcSums(Quantity, "Quantity Received", "Quantity Invoiced");
                                            decQty := recPL.Quantity;
                                            decQtyReceived := recPL."Quantity Received";
                                            decQtyInvoiced := recPL."Quantity Invoiced";

                                            recV.Reset();
                                            recV.Get(recPL."Buy-from Vendor No.");
                                            tName := recV.Name;
                                            tDeclationNo := recPL."BLTEC Customs Declaration No.";
                                            ACCWHRTmp."Vendor Invoice" := recPL."BLACC Invoice No.";
                                        end;
                                    end;
                                "Warehouse Activity Source Document"::"Sales Return Order":
                                    begin
                                        recSL.Reset();
                                        recSL.SetRange("Document No.", recWHRL."Source No.");
                                        recSL.SetRange("Line No.", recWHRL."Source Line No.");
                                        recSL.SetRange("Document Type", "Sales Document Type"::"Return Order");
                                        recSL.SetRange(Type, "Sales Line Type"::Item);
                                        if recSL.FindFirst() then begin
                                            recSL.CalcSums(Quantity, "Return Qty. Received", "Quantity Invoiced");
                                            decQty := recSL.Quantity;
                                            decQtyReceived := recSL."Return Qty. Received";
                                            decQtyInvoiced := recSL."Quantity Invoiced";

                                            recC.Reset();
                                            recC.SetRange("No.", recSL."Sell-to Customer No.");
                                            if recC.FindFirst() then begin
                                                tName := recC.Name;
                                            end;
                                        end;
                                    end;
                                "Warehouse Activity Source Document"::"Inbound Transfer":
                                    begin
                                        recTFL.Reset();
                                        recTFL.SetRange("Document No.", recWHRL."Source No.");
                                        if recTFL.FindFirst() then begin
                                            recTFL.CalcSums(Quantity, "Quantity Shipped");
                                            decQty := recTFL.Quantity;
                                            decQtyReceived := recTFL."Quantity Shipped";
                                            recL.Reset();
                                            recL.Get(recTFL."Transfer-from Code");
                                            tName := recL.Name;
                                        end;
                                    end;
                            end;
                            ACCWHRTmp."Name" := tName;
                            ACCWHRTmp."Declaration No" := tDeclationNo;
                            ACCWHRTmp."Quantity Expected" := decQty;
                            ACCWHRTmp."Quantity Received" := decQtyReceived;
                            ACCWHRTmp."Quantity Invoiced" := decQtyInvoiced;
                            ACCWHRTmp."Created Date" := DT2Date(recWHRH.SystemCreatedAt);
                            ACCWHRTmp.Insert();
                        end;
                    until recWHRH.Next() < 1;

                recPWRH.Reset();
                recPWRH.SetRange("Posting Date", dsF, dsT);
                if tsLoc <> '' then recPWRH.SetRange("Location Code", tsLoc);
                if recPWRH.FindSet() then
                    repeat
                        recPWRL.Reset();
                        recPWRL.SetRange("No.", recPWRH."No.");
                        // recPWRL.SetRange("Source No.", '25052392');
                        recPWRL.SetFilter("Source Document", '%1 | %2 | %3'
                                            , "Warehouse Activity Source Document"::"Purchase Order"
                                            , "Warehouse Activity Source Document"::"Sales Return Order"
                                            , "Warehouse Activity Source Document"::"Inbound Transfer");
                        if recPWRL.FindSet() then
                            repeat
                                bCheckIns := false;

                                ACCWHRTmp.Reset();
                                ACCWHRTmp.SetRange("Source No", recPWRL."Source No.");
                                ACCWHRTmp.SetRange("Location Code", recPWRH."Location Code");
                                ACCWHRTmp.SetRange("Item No", recPWRL."Item No.");
                                ACCWHRTmp.SetRange("Line No", recPWRL."Source Line No.");
                                ACCWHRTmp.SetRange("Status", 'In Receiving');
                                if ACCWHRTmp.IsEmpty then bCheckIns := true;

                                if bCheckIns then begin
                                    ACCWHRTmp.Reset();
                                    ACCWHRTmp.SetRange("Source No", recPWRL."Source No.");
                                    ACCWHRTmp.SetRange("Location Code", recPWRH."Location Code");
                                    ACCWHRTmp.SetRange("Item No", recPWRL."Item No.");
                                    ACCWHRTmp.SetRange("Line No", recPWRL."Source Line No.");
                                    ACCWHRTmp.SetRange("Status", 'Received');
                                    if ACCWHRTmp.FindFirst() then begin
                                        decQty := 0;
                                        decQtyReceived := 0;
                                        decQtyInvoiced := 0;
                                        tDeclationNo := '';
                                        tVendorInv := '';

                                        case recPWRL."Source Document" of
                                            "Warehouse Activity Source Document"::"Purchase Order":
                                                begin
                                                    decQtyReceived := recPWRL.Quantity;

                                                    recPL.Reset();
                                                    recPL.SetRange("Document No.", recPWRL."Source No.");
                                                    recPL.SetRange("Line No.", recPWRL."Source Line No.");
                                                    recPL.SetRange("Document Type", "Purchase Document Type"::Order);
                                                    recPL.SetRange(Type, "Purchase Line Type"::Item);
                                                    if recPL.FindFirst() then begin
                                                        recPL.CalcSums("Quantity Invoiced");
                                                        decQtyInvoiced := recPL."Quantity Invoiced";

                                                        tDeclationNo := ACCWHRTmp."Declaration No";
                                                        if not tDeclationNo.Contains(recPL."BLTEC Customs Declaration No.") then cuACCGP.AddString(tDeclationNo, recPL."BLTEC Customs Declaration No.", ',');
                                                        ACCWHRTmp."Declaration No" := tDeclationNo;

                                                        tVendorInv := ACCWHRTmp."Vendor Invoice";
                                                        if not tVendorInv.Contains(recPL."BLACC Invoice No.") then cuACCGP.AddString(tVendorInv, recPL."BLACC Invoice No.", ',');
                                                        ACCWHRTmp."Vendor Invoice" := tVendorInv;
                                                    end;

                                                    // recPRH.Reset();
                                                    // recPRH.SetRange("Order No.", recPWRL."Source No.");
                                                    // if recPRH.FindFirst() then begin
                                                    //     ACCWHRTmp."Created Date" := recPRH."Document Date";
                                                    // end;

                                                    // recPIL.Reset();
                                                    // recPIL.SetRange("Order No.", recPWRL."Source No.");
                                                    // recPIL.SetRange("Order Line No.", recPWRL."Source Line No.");
                                                    // recPIL.SetRange(Type, "Purchase Line Type"::Item);
                                                    // if recPIL.FindFirst() then begin
                                                    //     ACCWHRTmp."Invoice Date" := recPIL."Posting Date";
                                                    // end;
                                                end;
                                            "Warehouse Activity Source Document"::"Sales Return Order":
                                                begin
                                                    decQtyReceived := recPWRL.Quantity;

                                                    // recRRH.Reset();
                                                    // recRRH.SetRange("Return Order No.", recPWRL."Source No.");
                                                    // if recRRH.FindFirst() then begin
                                                    //     tName := recRRH."Sell-to Customer Name";
                                                    //     // ACCWHRTmp."Created Date" := recRRH."Document Date";
                                                    // end;

                                                    recRRL.Reset();
                                                    recRRL.SetRange("Document No.", recPWRL."Posted Source No.");
                                                    recRRL.SetRange("Return Order Line No.", recPWRL."Source Line No.");
                                                    if recRRL.FindFirst() then begin
                                                        recRRL.CalcSums(Quantity, "Quantity Invoiced");
                                                        decQty := recRRL.Quantity;
                                                        decQtyInvoiced := recRRL."Quantity Invoiced";
                                                    end;

                                                    recPRL.Reset();
                                                    recPRL.SetRange("Document No.", recPWRL."Posted Source No.");
                                                    recPRL.SetRange("Order Line No.", recPWRL."Source Line No.");
                                                    recPRL.SetRange(Type, "Purchase Line Type"::Item);
                                                    if recPRL.FindFirst() then begin
                                                        tDeclationNo := ACCWHRTmp."Declaration No";
                                                        if not tDeclationNo.Contains(recPRL."BLTEC Customs Declaration No.") then cuACCGP.AddString(tDeclationNo, recPRL."BLTEC Customs Declaration No.", ',');
                                                        ACCWHRTmp."Declaration No" := tDeclationNo;

                                                        tVendorInv := ACCWHRTmp."Vendor Invoice";
                                                        if not tVendorInv.Contains(recPRL."BLACC Invoice No.") then cuACCGP.AddString(tVendorInv, recPRL."BLACC Invoice No.", ',');
                                                        ACCWHRTmp."Vendor Invoice" := tVendorInv;
                                                    end;
                                                end;
                                            "Warehouse Activity Source Document"::"Inbound Transfer":
                                                begin
                                                    decQty := recPWRL.Quantity;
                                                    decQtyReceived := recPWRL.Quantity;

                                                    // recTRH.Reset();
                                                    // recTRH.SetRange("Transfer Order No.", recPWRL."Source No.");
                                                    // if recTRH.FindFirst() then begin
                                                    //     recL.Reset();
                                                    //     recL.Get(recTRH."Transfer-from Code");
                                                    //     tName := recL.Name;

                                                    //     ACCWHRTmp."Created Date" := recTRH."Transfer Order Date";
                                                    // end;
                                                end;
                                        end;

                                        ACCWHRTmp."Quantity Expected" += decQty;
                                        ACCWHRTmp."Quantity Received" += decQtyReceived;
                                        ACCWHRTmp."Quantity Invoiced" += decQtyInvoiced;
                                        ACCWHRTmp.Modify();
                                    end else begin
                                        decQty := 0;
                                        decQtyReceived := 0;
                                        decQtyInvoiced := 0;
                                        iLine += 1;

                                        ACCWHRTmp.Init();
                                        ACCWHRTmp."Entry No" := iLine;
                                        ACCWHRTmp."Document No" := recPWRH."No.";
                                        ACCWHRTmp."Source No" := recPWRL."Source No.";
                                        ACCWHRTmp."Location Code" := recPWRH."Location Code";
                                        ACCWHRTmp."Item No" := recPWRL."Item No.";
                                        ACCWHRTmp."Item Name" := recPWRL.Description;
                                        ACCWHRTmp."Line No" := recPWRL."Source Line No.";

                                        recL.Reset();
                                        recL.SetRange(Code, recPWRH."Location Code");
                                        if recL.FindFirst() then begin
                                            ACCWHRTmp."Location Name" := recL.Name;
                                        end;

                                        ACCWHRTmp.Status := 'Received';
                                        ACCWHRTmp."Source Document" := recPWRL."Source Document";

                                        // recACCIPT.Reset();
                                        // recACCIPT.SetCurrentKey("Receipt Date");
                                        // recACCIPT.SetAscending("Receipt Date", false);
                                        // recACCIPT.SetRange("Source Document No.", recPWRL."Source No.");
                                        // recACCIPT.SetRange("Source Line No.", recPWRL."Source Line No.");
                                        // if recACCIPT.FindFirst() then ACCWHRTmp."Posting Date" := recACCIPT."Receipt Date";
                                        ACCWHRTmp."Posting Date" := recPWRL."Posting Date";
                                        tName := '';
                                        tDeclationNo := '';
                                        case recPWRL."Source Document" of
                                            "Warehouse Activity Source Document"::"Purchase Order":
                                                begin
                                                    decQtyReceived := recPWRL.Quantity;

                                                    recPL.Reset();
                                                    recPL.SetRange("Document No.", recPWRL."Source No.");
                                                    recPL.SetRange("Line No.", recPWRL."Source Line No.");
                                                    recPL.SetRange("Document Type", "Purchase Document Type"::Order);
                                                    recPL.SetRange(Type, "Purchase Line Type"::Item);
                                                    if recPL.FindFirst() then begin
                                                        recPL.CalcSums(Quantity, "Quantity Invoiced");
                                                        decQty := recPL.Quantity;
                                                        decQtyInvoiced := recPL."Quantity Invoiced";

                                                        recV.Reset();
                                                        recV.Get(recPL."Buy-from Vendor No.");
                                                        tName := recV.Name;
                                                        tDeclationNo := recPL."BLTEC Customs Declaration No.";
                                                        ACCWHRTmp."Vendor Invoice" := recPL."BLACC Invoice No.";
                                                    end;

                                                    // recPRH.Reset();
                                                    // recPRH.SetRange("Order No.", recPWRL."Source No.");
                                                    // if recPRH.FindFirst() then begin
                                                    //     ACCWHRTmp."Created Date" := recPRH."Document Date";
                                                    // end;

                                                    // recPIL.Reset();
                                                    // recPIL.SetRange("Order No.", recPWRL."Source No.");
                                                    // recPIL.SetRange("Order Line No.", recPWRL."Source Line No.");
                                                    // recPIL.SetRange(Type, "Purchase Line Type"::Item);
                                                    // if recPIL.FindFirst() then begin
                                                    //     ACCWHRTmp."Invoice Date" := recPIL."Posting Date";
                                                    // end;
                                                end;
                                            "Warehouse Activity Source Document"::"Sales Return Order":
                                                begin
                                                    decQtyReceived := recPWRL.Quantity;

                                                    recRRH.Reset();
                                                    recRRH.SetRange("Return Order No.", recPWRL."Source No.");
                                                    if recRRH.FindFirst() then begin
                                                        tName := recRRH."Sell-to Customer Name";
                                                        // ACCWHRTmp."Created Date" := recRRH."Document Date";
                                                    end;

                                                    recRRL.Reset();
                                                    recRRL.SetRange("Document No.", recPWRL."Posted Source No.");
                                                    recRRL.SetRange("Return Order Line No.", recPWRL."Source Line No.");
                                                    if recRRL.FindFirst() then begin
                                                        recRRL.CalcSums(Quantity, "Quantity Invoiced");
                                                        decQty := recRRL.Quantity;
                                                        decQtyInvoiced := recRRL."Quantity Invoiced";
                                                    end;

                                                    recPRL.Reset();
                                                    recPRL.SetRange("Document No.", recPWRL."Posted Source No.");
                                                    recPRL.SetRange("Order Line No.", recPWRL."Source Line No.");
                                                    recPRL.SetRange(Type, "Purchase Line Type"::Item);
                                                    if recPRL.FindFirst() then begin
                                                        tDeclationNo := recPRL."BLTEC Customs Declaration No.";
                                                        ACCWHRTmp."Vendor Invoice" := recPRL."BLACC Invoice No.";
                                                    end;
                                                end;
                                            "Warehouse Activity Source Document"::"Inbound Transfer":
                                                begin
                                                    decQty := recPWRL.Quantity;
                                                    decQtyReceived := recPWRL.Quantity;

                                                    recTRH.Reset();
                                                    recTRH.SetRange("Transfer Order No.", recPWRL."Source No.");
                                                    if recTRH.FindFirst() then begin
                                                        recL.Reset();
                                                        recL.Get(recTRH."Transfer-from Code");
                                                        tName := recL.Name;

                                                        // ACCWHRTmp."Created Date" := recTRH."Transfer Order Date";
                                                    end;
                                                end;
                                        end;

                                        ACCWHRTmp."Name" := tName;
                                        ACCWHRTmp."Declaration No" := tDeclationNo;
                                        ACCWHRTmp."Quantity Expected" := decQty;
                                        ACCWHRTmp."Quantity Received" := decQtyReceived;
                                        // ACCWHRTmp."Received Date" := recPWRL.SystemCreatedAt;
                                        ACCWHRTmp."Quantity Invoiced" := decQtyInvoiced;
                                        ACCWHRTmp.Insert();
                                    end;
                                end else begin

                                end;
                            until recPWRL.Next() < 1;
                    until recPWRH.Next() < 1;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 1);
            end;
        }

        //Main
        dataitem(ACCWHRTmp; "ACC WH Receipt Tmp")
        {
            UseTemporary = true;
            DataItemTableView = sorting("Entry No");

            column(CreatedDate; "Created Date") { }
            column(DeclarationNo; "Declaration No") { }
            column(DocumentNo; "Document No") { }
            column(Name; Name) { }
            column(QuantityExpected; "Quantity Expected") { }
            column(QuantityReceived; "Quantity Received") { }
            column(ReceivedDate; "Received Date") { }
            column(SourceDocument; "Source Document") { }
            column(SourceNo; "Source No") { }
            column(Status; Status) { }
            column(InvoiceDate; "Invoice Date") { }
            column(QuantityInvoiced; "Quantity Invoiced") { }
            column(PostingDate; "Posting Date") { }
            column(LocationCode; "Location Code") { }
            column(LocationName; "Location Name") { }
            column(VendorInvoice; "Vendor Invoice") { }
            column(ItemNo; "Item No") { }
            column(ItemName; "Item Name") { }
            column(LineNo; "Line No") { }

            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }
            column(Location_Parm; tsLoc + ' - ' + tsLocName) { }
        }
    }

    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(dsF; dsF)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date From';
                    }
                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date To';
                    }
                    field(tsLoc; tsLoc)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        TableRelation = Location.Code;

                        trigger OnValidate()
                        begin
                            if tsLoc <> '' then begin
                                recL.Reset();
                                recL.SetRange(Code, tsLoc);
                                if recL.FindFirst() then tsLocName := recL.Name;
                            end;
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsT := DMY2Date(27, 11, 2024);
            // tsCustNo := '10-00001-00';
        end;
    }

    #region ACC Func
    local procedure InitData()
    begin

    end;
    #endregion

    //GLobal
    var
        dsF: Date;
        dsT: Date;
        tsLoc: Text;
        tsLocName: Text;
        recL: Record Location;
        recILE: Record "Item Ledger Entry";
        recVE_Inv: Record "Value Entry";
        iLine: Integer;
        recPIL: Record "Purch. Inv. Line";
        recRRL: Record "Return Receipt Line";
        cuACCGP: Codeunit "ACC General Process";
}