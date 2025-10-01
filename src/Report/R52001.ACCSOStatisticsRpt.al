report 52001 "ACC SO Statistics Report"
{
    Caption = 'ACC Sales Order Statistics Report - R52001';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52001_ACCSOStatisticsRpt.rdl';

    dataset
    {
        //Posted Sales Invoice + Posted Sales Credit Memo
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
                recSIL: Record "Sales Invoice Line";
                recSCML: Record "Sales Cr.Memo Line";
            begin
                qACCVE.SetRange(Posting_Date_Filter, dsF, dsT);
                qACCVE.SetRange(Item_Ledger_Entry_Type_Filter, "Item Ledger Entry Type"::Sale);
                if tsCustNo <> '' then qACCVE.SetRange(Source_No_Filter, tsCustNo);
                qACCVE.SetRange(Item_Charge_No_Filter, '');
                qACCVE.SetRange(Adjustment_Filter, false);
                qACCVE.SetFilter(Document_Type_Filter, '%1 | %2', "Item Ledger Document Type"::"Sales Invoice", "Item Ledger Document Type"::"Sales Credit Memo");
                // qACCVE.SetRange(Document_No_Filter, 'PSCM-00000005');
                if qACCVE.Open() then begin
                    while qACCVE.Read() do begin
                        ACCSOLTmp.Reset();
                        ACCSOLTmp.SetRange(No, qACCVE.Document_No);
                        ACCSOLTmp.SetRange("Item No", qACCVE.Item_No);
                        ACCSOLTmp.SetRange("Line No", qACCVE.Document_Line_No);
                        if ACCSOLTmp.FindFirst() then begin
                            case qACCVE.Document_Type of
                                "Item Ledger Document Type"::"Sales Invoice":
                                    ModData(0, qACCVE, 0);
                                "Item Ledger Document Type"::"Sales Credit Memo":
                                    ModData(1, qACCVE, 0);
                            end;
                        end else begin
                            case qACCVE.Document_Type of
                                "Item Ledger Document Type"::"Sales Invoice":
                                    InitData(0, qACCVE, 0);
                                "Item Ledger Document Type"::"Sales Credit Memo":
                                    InitData(1, qACCVE, 0);
                            end;
                        end;
                    end;
                    qACCVE.Close();
                end;

                clear(qACCVE);
                qACCVE.SetRange(Posting_Date_Filter, dsF, dsT);
                qACCVE.SetRange(Item_Ledger_Entry_Type_Filter, "Item Ledger Entry Type"::Sale);
                qACCVE.SetRange(Adjustment_Filter, false);
                if tsCustNo <> '' then qACCVE.SetRange(Source_No_Filter, tsCustNo);
                qACCVE.SetFilter(Item_Charge_No_Filter, '<> %1', '');
                qACCVE.SetFilter(Document_Type_Filter, '%1 | %2', "Item Ledger Document Type"::"Sales Invoice", "Item Ledger Document Type"::"Sales Credit Memo");
                // qACCVE.SetRange(Document_No_Filter, 'PSC2405-0002');
                if qACCVE.Open() then begin
                    while qACCVE.Read() do begin
                        ACCSOLTmp.Reset();
                        ACCSOLTmp.SetRange(No, qACCVE.Document_No);
                        ACCSOLTmp.SetRange("Item No", qACCVE.Item_No);
                        ACCSOLTmp.SetRange("Line No", qACCVE.Document_Line_No);
                        if ACCSOLTmp.FindFirst() then begin
                            case qACCVE.Document_Type of
                                "Item Ledger Document Type"::"Sales Invoice":
                                    ModData(0, qACCVE, qACCVE.SalesAmtSum);
                                "Item Ledger Document Type"::"Sales Credit Memo":
                                    ModData(1, qACCVE, qACCVE.SalesAmtSum);
                            end;
                        end else begin
                            case qACCVE.Document_Type of
                                "Item Ledger Document Type"::"Sales Invoice":
                                    InitData(0, qACCVE, qACCVE.SalesAmtSum);
                                "Item Ledger Document Type"::"Sales Credit Memo":
                                    InitData(1, qACCVE, qACCVE.SalesAmtSum);
                            end;
                        end;
                    end;
                    qACCVE.Close();
                end;

                recSIL.Reset();
                recSIL.SetRange("Posting Date", dsF, dsT);
                recSIL.SetRange(Type, "Sales Line Type"::"G/L Account");
                // recSIL.SetRange("Document No.", 'PSI-00005550');
                if tsCustNo <> '' then recSIL.SetRange("Sell-to Customer No.", tsCustNo);
                if recSIL.FindSet() then
                    repeat
                        ACCSOLTmp.Reset();
                        ACCSOLTmp.SetRange(No, recSIL."Document No.");
                        ACCSOLTmp.SetRange("Item No", recSIL."No.");
                        ACCSOLTmp.SetRange("Line No", recSIL."Line No.");
                        if ACCSOLTmp.IsEmpty then InitDataGLSI(recSIL);
                    until recSIL.Next() < 1;

                recSCML.Reset();
                recSCML.SetRange("Posting Date", dsF, dsT);
                recSCML.SetRange(Type, "Sales Line Type"::"G/L Account");
                if tsCustNo <> '' then recSCML.SetRange("Sell-to Customer No.", tsCustNo);
                if recSCML.FindSet() then
                    repeat
                        ACCSOLTmp.Reset();
                        ACCSOLTmp.SetRange(No, recSCML."Document No.");
                        ACCSOLTmp.SetRange("Item No", recSCML."No.");
                        ACCSOLTmp.SetRange("Line No", recSCML."Line No.");
                        if ACCSOLTmp.IsEmpty then InitDataGLSCM(recSCML);
                    until recSCML.Next() < 1;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);
            end;
        }

        //Main
        dataitem(ACCSOLTmp; "ACC SO Line Tmp")
        {
            UseTemporary = true;
            DataItemTableView = sorting(No, "Item No", "Line No");
            column(No; No) { }
            column(Item_No; "Item No") { }
            column(Line_No; "Line No") { }
            column(Description; Description) { }
            column(Posting_Date; "Posting Date") { }
            column(Sell_To_Cust_No; "Sell-to Customer No") { }
            column(Sell_To_Cust_Name; "Sell-to Customer Name") { }
            column(Quantity; Quantity) { }
            column(UOM; UOM) { }
            column(Unit_Price; "Unit Price") { }
            column(SalesPerson_Code; "SalesPerson Code") { }
            column(SalesPerson_Name; "SalesPerson Name") { }
            column(Sales_District; "Sales District") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Item_Category_Name; "Item Category Name") { }
            column(Cost_Center_Code; "Cost Center Code") { }
            column(Cost_Center_Name; "Cost Center Name") { }
            column(Vendor_No; "Vendor No") { }
            column(EI_Invoice_No; "EI Invoice No") { }
            column(VAT_Perc; "VAT Perc") { }
            column(Line_Amount; "Line Amount") { }
            column(Line_Amount_Include_VAT; "Line Amount Include VAT") { }
            column(Line_VAT_Amount; "Line VAT Amount") { }
            column(Line_Cost_Amount; "Line Cost Amount") { }
            column(LineCostAmountAdjust; "Line Cost Amount Adjust") { }
            column(Line_GM1_Amount; "Line GM1 Amount") { }
            column(Line_GM2_Amount; "Line GM2 Amount") { }
            column(Exch_Rate; "Exch Rate") { }
            column(PS_No; "PS No") { }
            column(Sales_Order; "Sales Order") { }
            column(Branch; "Branch") { }
            column(Branch_Name; "Branch Name") { }
            column(Credit_Note; "Credit Note") { }
            column(Customer_Group_Name; "Customer Group Name") { }
            column(Bill_to_Customer_No; "Bill-to Customer No") { }
            column(Bill_to_Customer_Name; "Bill-to Customer Name") { }
            column(Search_Name; "Search Name") { }
            column(Item_Sales_Tax_Group; "Item Sales Tax Group") { }
            column(Shipment_Date; "Shipment Date") { }
            column(Location_Code; "Location Code") { }
            column(Orig_Posting_Date; "Orig Posting Date") { }
            column(Orig_No; "Orig No") { }
            column(Orig_EI_Invoice_No; "Orig EI Invoice No") { }
            column(CommissionExpenseAmount; "Commission Expense Amount") { }

            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }
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

                        trigger OnValidate();
                        begin
                            dsT := CalcDate('<CM>', dsF);
                        end;
                    }

                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date To';
                    }

                    field(tsCustNo; tsCustNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
                        Caption = 'Customer No.';
                        // Enabled = bEdit;
                        // ShowMandatory = true;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsF := DMY2Date(1, 1, 2025);
            // dsT := DMY2Date(5, 10, 2022);
        end;
    }

    #region - ACC Func
    local procedure InitDataGLSCM(ivrecSCML: Record "Sales Cr.Memo Line")
    var
        recSP: Record "Salesperson/Purchaser";
        recSIH: Record "Sales Invoice Header";
        recSCMH: Record "Sales Cr.Memo Header";
        recC: Record Customer;
        recDV: Record "Dimension Value";
        lstDim: List of [Text];
        tSP: Text;
        tSellCust: Text;
        decExchRate: Decimal;
        tBillCust: Text;
    begin
        tSP := '';
        tSellCust := '';
        tBillCust := '';
        decExchRate := 1;

        ACCSOLTmp.Init();

        ACCSOLTmp.No := ivrecSCML."Document No.";
        ACCSOLTmp."Item No" := ivrecSCML."No.";
        ACCSOLTmp."Line No" := ivrecSCML."Line No.";
        ACCSOLTmp."Posting Date" := ivrecSCML."Posting Date";
        ACCSOLTmp."Search Name" := ivrecSCML.Description;
        ACCSOLTmp.Description := ivrecSCML."BLTEC Item Name";

        lstDim := cuACCGP.GetAllDimensionCodeValue(ivrecSCML."Dimension Set ID");

        ACCSOLTmp.Branch := lstDim.Get(1);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'BRANCH');
        recDV.SetRange(Code, ACCSOLTmp.Branch);
        if recDV.FindFirst() then ACCSOLTmp."Branch Name" := recDV.Name;

        ACCSOLTmp."Item Category Code" := lstDim.Get(2);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'BUSINESSUNIT');
        recDV.SetRange(Code, ACCSOLTmp."Item Category Code");
        if recDV.FindFirst() then ACCSOLTmp."Item Category Name" := recDV.Name;

        ACCSOLTmp."Cost Center Code" := lstDim.Get(3);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'COSTCENTER');
        recDV.SetRange(Code, ACCSOLTmp."Cost Center Code");
        if recDV.FindFirst() then ACCSOLTmp."Cost Center Name" := recDV.Name;

        ACCSOLTmp.Quantity := -ivrecSCML.Quantity;
        ACCSOLTmp."Line Amount" := -ivrecSCML."Line Amount";
        // ACCSOLTmp."Line Cost Amount" := -ivrecSCML."Line Amount";
        ACCSOLTmp."Line Cost Amount" := 0;
        ACCSOLTmp."Credit Note" := true;

        recSCMH.Reset();
        recSCMH.SetRange("No.", ivrecSCML."Document No.");
        if recSCMH.FindFirst() then begin
            tSellCust := recSCMH."Sell-to Customer No.";
            tSP := recSCMH."Salesperson Code";
            ACCSOLTmp."SalesPerson Code" := tSP;
            ACCSOLTmp."Sell-to Customer No" := recSCMH."Sell-to Customer No.";
            ACCSOLTmp."Sell-to Customer Name" := recSCMH."Sell-to Customer Name";
            tBillCust := recSCMH."Bill-to Customer No.";

            if recSCMH."Currency Factor" <> 0 then decExchRate := 1 / recSCMH."Currency Factor";

            if recSCMH."BLTI Original eInvoice No." <> '' then begin
                recSIH.Reset();
                recSIH.SetRange("BLTI eInvoice No.", recSCMH."BLTI Original eInvoice No.");
                if recSIH.FindFirst() then begin
                    ACCSOLTmp."Orig Posting Date" := recSIH."Posting Date";
                    ACCSOLTmp."Orig No" := recSIH."No.";
                    ACCSOLTmp."Sales Order" := recSIH."Order No.";
                    ACCSOLTmp."Orig EI Invoice No" := recSIH."BLTI eInvoice No.";
                end;
            end;
        end;

        ACCSOLTmp."EI Invoice No" := ivrecSCML."BLTI eInvoice No.";
        ACCSOLTmp.UOM := ivrecSCML."Unit of Measure Code";
        ACCSOLTmp."Unit Price" := ivrecSCML."Unit Price";

        ACCSOLTmp."Item Sales Tax Group" := ivrecSCML."VAT Prod. Posting Group";
        ACCSOLTmp."VAT Perc" := ivrecSCML."VAT %";
        ACCSOLTmp."Line Amount Include VAT" := ivrecSCML."Amount Including VAT";
        ACCSOLTmp."Line VAT Amount" := ivrecSCML."Amount Including VAT" - ivrecSCML."VAT Base Amount";
        ACCSOLTmp."Location Code" := ivrecSCML."Location Code";
        ACCSOLTmp."Commission Expense Amount" := -ivrecSCML."BLACC CommissionExpenseAmount";
        // ACCSOLTmp."Line GM1 Amount" := ivrecSCML."BLACC GM1";
        // ACCSOLTmp."Line GM2 Amount" := ivrecSCML."BLACC GM2";
        ACCSOLTmp."Line GM1 Amount" := ACCSOLTmp."Line Amount" - ACCSOLTmp."Line Cost Amount" - ACCSOLTmp."Line Cost Amount Adjust";
        ACCSOLTmp."Line GM2 Amount" := ACCSOLTmp."Line GM1 Amount" - ACCSOLTmp."Commission Expense Amount";

        recC.Reset();
        recC.SetRange("No.", tSellCust);
        if recC.FindFirst() then ACCSOLTmp."Sales District" := recC.City;

        recSP.Reset();
        recSP.SetRange(Code, tSP);
        if recSP.FindFirst() then ACCSOLTmp."SalesPerson Name" := recSP.Name;

        recC.Reset();
        recC.SetRange("No.", tBillCust);
        if recC.FindFirst() then begin
            ACCSOLTmp."Bill-to Customer No" := tBillCust;
            ACCSOLTmp."Bill-to Customer Name" := recC.Name;

            recBLACCCG.Reset();
            recBLACCCG.SetRange(Code, recC."BLACC Customer Group");
            if recBLACCCG.FindFirst() then ACCSOLTmp."Customer Group Name" := recBLACCCG.Description;
        end;

        ACCSOLTmp."Exch Rate" := decExchRate;
        ACCSOLTmp.Insert();
    end;

    local procedure InitDataGLSI(ivrecSIL: Record "Sales Invoice Line")
    var
        recSP: Record "Salesperson/Purchaser";
        recSIH: Record "Sales Invoice Header";
        recC: Record Customer;
        recDV: Record "Dimension Value";
        // recI: Record Item;
        lstDim: List of [Text];
        tSP: Text;
        tSellCust: Text;
        decExchRate: Decimal;
        tBillCust: Text;
        recIC: Record "Item Charge";
    begin
        tSP := '';
        tVAT := '';
        tSellCust := '';
        tBillCust := '';
        decExchRate := 1;

        ACCSOLTmp.Init();

        ACCSOLTmp.No := ivrecSIL."Document No.";
        ACCSOLTmp."Item No" := ivrecSIL."No.";
        ACCSOLTmp."Line No" := ivrecSIL."Line No.";
        ACCSOLTmp."Posting Date" := ivrecSIL."Posting Date";
        ACCSOLTmp."Search Name" := ivrecSIL.Description;
        ACCSOLTmp.Description := ivrecSIL."BLTEC Item Name";

        lstDim := cuACCGP.GetAllDimensionCodeValue(ivrecSIL."Dimension Set ID");

        ACCSOLTmp.Branch := lstDim.Get(1);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'BRANCH');
        recDV.SetRange(Code, ACCSOLTmp.Branch);
        if recDV.FindFirst() then ACCSOLTmp."Branch Name" := recDV.Name;

        ACCSOLTmp."Item Category Code" := lstDim.Get(2);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'BUSINESSUNIT');
        recDV.SetRange(Code, ACCSOLTmp."Item Category Code");
        if recDV.FindFirst() then ACCSOLTmp."Item Category Name" := recDV.Name;

        ACCSOLTmp."Cost Center Code" := lstDim.Get(3);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'COSTCENTER');
        recDV.SetRange(Code, ACCSOLTmp."Cost Center Code");
        if recDV.FindFirst() then ACCSOLTmp."Cost Center Name" := recDV.Name;

        ACCSOLTmp.Quantity := ivrecSIL.Quantity;
        ACCSOLTmp."Line Amount" := ivrecSIL."Line Amount";
        // ACCSOLTmp."Line Cost Amount" := ivrecSIL."Line Amount";
        ACCSOLTmp."Line Cost Amount" := 0;

        ACCSOLTmp."Credit Note" := false;

        recSIH.Reset();
        recSIH.SetRange("No.", ivrecSIL."Document No.");
        if recSIH.FindFirst() then begin
            tSellCust := recSIH."Sell-to Customer No.";
            tSP := recSIH."Salesperson Code";
            ACCSOLTmp."SalesPerson Code" := tSP;
            ACCSOLTmp."Sell-to Customer No" := recSIH."Sell-to Customer No.";
            ACCSOLTmp."Sell-to Customer Name" := recSIH."Sell-to Customer Name";
            tBillCust := recSIH."Bill-to Customer No.";

            if recSIH."Currency Factor" <> 0 then decExchRate := 1 / recSIH."Currency Factor";
        end;

        if ivrecSIL."Order No." <> '' then ACCSOLTmp."Sales Order" := ivrecSIL."Order No." else ACCSOLTmp."Sales Order" := recSIH."Order No.";
        ACCSOLTmp."EI Invoice No" := ivrecSIL."BLTI eInvoice No.";
        ACCSOLTmp.Description := ivrecSIL."BLTEC Item Name";
        ACCSOLTmp.UOM := ivrecSIL."Unit of Measure Code";
        ACCSOLTmp."Unit Price" := ivrecSIL."Unit Price";
        ACCSOLTmp."Item Sales Tax Group" := ivrecSIL."VAT Prod. Posting Group";
        ACCSOLTmp."VAT Perc" := ivrecSIL."VAT %";
        ACCSOLTmp."Line Amount Include VAT" := ivrecSIL."Amount Including VAT";
        ACCSOLTmp."Line VAT Amount" := ivrecSIL."Amount Including VAT" - ivrecSIL."VAT Base Amount";
        ACCSOLTmp."Location Code" := ivrecSIL."Location Code";
        ACCSOLTmp."Commission Expense Amount" := ivrecSIL."BLACC CommissionExpenseAmount";
        // ACCSOLTmp."Line GM1 Amount" := ivrecSIL."BLACC GM1";
        // ACCSOLTmp."Line GM2 Amount" := ivrecSIL."BLACC GM2";

        recC.Reset();
        recC.SetRange("No.", tSellCust);
        if recC.FindFirst() then ACCSOLTmp."Sales District" := recC.City;

        recSP.Reset();
        recSP.SetRange(Code, tSP);
        if recSP.FindFirst() then ACCSOLTmp."SalesPerson Name" := recSP.Name;

        recC.Reset();
        recC.SetRange("No.", tBillCust);
        if recC.FindFirst() then begin
            ACCSOLTmp."Bill-to Customer No" := tBillCust;
            ACCSOLTmp."Bill-to Customer Name" := recC.Name;

            recBLACCCG.Reset();
            recBLACCCG.SetRange(Code, recC."BLACC Customer Group");
            if recBLACCCG.FindFirst() then ACCSOLTmp."Customer Group Name" := recBLACCCG.Description;
        end;

        ACCSOLTmp."Exch Rate" := decExchRate;

        tVAT := ACCSOLTmp."Item Sales Tax Group";
        if tVAT.StartsWith('F-') then begin
            ACCSOLTmp."Unit Price" := 0;
            ACCSOLTmp."Line Amount" := 0;
            ACCSOLTmp."Line Cost Amount" := 0;
        end;

        ACCSOLTmp."Line GM1 Amount" := ACCSOLTmp."Line Amount" - ACCSOLTmp."Line Cost Amount" - ACCSOLTmp."Line Cost Amount Adjust";
        ACCSOLTmp."Line GM2 Amount" := ACCSOLTmp."Line GM1 Amount" - ACCSOLTmp."Commission Expense Amount";

        ACCSOLTmp.Insert();
    end;

    local procedure InitData(iviType: Integer; ivqACCVE: Query "ACC Value Entry Query"; ivdecCharge: Decimal)
    var
        recSP: Record "Salesperson/Purchaser";
        recSIH: Record "Sales Invoice Header";
        recSIL: Record "Sales Invoice Line";
        recSCMH: Record "Sales Cr.Memo Header";
        recSCML: Record "Sales Cr.Memo Line";
        recRRL: Record "Return Receipt Line";
        recSH_SRO: Record "Sales Header";
        recC: Record Customer;
        recDV: Record "Dimension Value";
        recI: Record Item;
        lstDim: List of [Text];
        tSP: Text;
        tSellCust: Text;
        decExchRate: Decimal;
        tBillCust: Text;
        recIC: Record "Item Charge";
        recSSH: Record "Sales Shipment Header";
        recVE: Record "Value Entry";
    begin
        tSP := '';
        tVAT := '';
        tSellCust := '';
        tBillCust := '';
        decExchRate := 1;

        recI.Reset();
        recI.Get(ivqACCVE.Item_No);

        ACCSOLTmp.Init();

        ACCSOLTmp.No := ivqACCVE.Document_No;
        ACCSOLTmp."Item No" := ivqACCVE.Item_No;
        ACCSOLTmp."Line No" := ivqACCVE.Document_Line_No;
        ACCSOLTmp."Posting Date" := ivqACCVE.Posting_Date;
        ACCSOLTmp."Search Name" := recI."Search Description";
        ACCSOLTmp.Description := recI.Description;

        lstDim := cuACCGP.GetAllDimensionCodeValue(ivqACCVE.Dimension_Set_ID);

        ACCSOLTmp.Branch := lstDim.Get(1);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'BRANCH');
        recDV.SetRange(Code, ACCSOLTmp.Branch);
        if recDV.FindFirst() then ACCSOLTmp."Branch Name" := recDV.Name;

        ACCSOLTmp."Item Category Code" := lstDim.Get(2);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'BUSINESSUNIT');
        recDV.SetRange(Code, ACCSOLTmp."Item Category Code");
        if recDV.FindFirst() then ACCSOLTmp."Item Category Name" := recDV.Name;

        ACCSOLTmp."Cost Center Code" := lstDim.Get(3);
        recDV.Reset();
        recDV.SetRange("Dimension Code", 'COSTCENTER');
        recDV.SetRange(Code, ACCSOLTmp."Cost Center Code");
        if recDV.FindFirst() then ACCSOLTmp."Cost Center Name" := recDV.Name;

        recILE.Reset();
        recILE.SetRange("Entry No.", ivqACCVE.Item_Ledger_Entry_No);
        if recILE.FindFirst() then begin
            ACCSOLTmp."PS No" := recILE."Document No.";
            ACCSOLTmp."Shipment Date" := recILE."Posting Date";
        end;

        ACCSOLTmp.Quantity := -ivqACCVE.InvQtySum;

        ACCSOLTmp."Line Amount" := ivqACCVE.SalesAmtSum;
        ACCSOLTmp."Line Cost Amount" := -ivqACCVE.CostAmtActSum;

        if ivdecCharge = 0 then begin
            recVE.Reset();
            recVE.SetRange("Document Type", "Item Ledger Document Type"::" ");
            recVE.SetRange("Item Ledger Entry No.", ivqACCVE.Item_Ledger_Entry_No);
            recVE.SetRange("Item Charge No.", '');
            if recVE.FindFirst() then begin
                recVE.CalcSums(recVE."Cost Amount (Actual)");
                ACCSOLTmp."Line Cost Amount" += -recVE."Cost Amount (Actual)";
            end;
        end;

        case iviType of
            0:
                begin
                    ACCSOLTmp."Credit Note" := false;

                    recSIH.Reset();
                    recSIH.SetRange("No.", ivqACCVE.Document_No);
                    if recSIH.FindFirst() then begin
                        tSellCust := recSIH."Sell-to Customer No.";
                        tSP := recSIH."Salesperson Code";
                        ACCSOLTmp."SalesPerson Code" := tSP;
                        ACCSOLTmp."Sell-to Customer No" := recSIH."Sell-to Customer No.";
                        ACCSOLTmp."Sell-to Customer Name" := recSIH."Sell-to Customer Name";
                        tBillCust := recSIH."Bill-to Customer No.";

                        if recSIH."Currency Factor" <> 0 then decExchRate := 1 / recSIH."Currency Factor";
                    end;

                    recSIL.Reset();
                    recSIL.SetRange("Document No.", ivqACCVE.Document_No);
                    recSIL.SetRange("Line No.", ivqACCVE.Document_Line_No);
                    recSIL.SetRange("No.", ivqACCVE.Item_No);
                    if recSIL.FindFirst() then begin
                        if recSIL."Order No." <> '' then ACCSOLTmp."Sales Order" := recSIL."Order No." else ACCSOLTmp."Sales Order" := recSIH."Order No.";
                        ACCSOLTmp."EI Invoice No" := recSIL."BLTI eInvoice No.";
                        ACCSOLTmp.Description := recSIL."BLTEC Item Name";
                        if recSIL.Type = "Sales Line Type"::"Charge (Item)" then begin
                            recIC.Reset();
                            recIC.Get(recSIL."No.");
                            ACCSOLTmp."Search Name" := recIC."Search Description";
                            ACCSOLTmp.Description := recIC.Description;
                        end;

                        ACCSOLTmp.UOM := recSIL."Unit of Measure Code";

                        if ivdecCharge = 0 then
                            ACCSOLTmp."Unit Price" := recSIL."Unit Price"
                        else
                            ACCSOLTmp."Unit Price" := 0;

                        ACCSOLTmp."Item Sales Tax Group" := recSIL."VAT Prod. Posting Group";
                        ACCSOLTmp."VAT Perc" := recSIL."VAT %";
                        ACCSOLTmp."Line Amount Include VAT" := recSIL."Amount Including VAT";
                        ACCSOLTmp."Line VAT Amount" := recSIL."Amount Including VAT" - recSIL."VAT Base Amount";
                        ACCSOLTmp."Location Code" := recSIL."Location Code";
                        // ACCSOLTmp."Line GM1 Amount" := recSIL."BLACC GM1";
                        // ACCSOLTmp."Line GM2 Amount" := recSIL."BLACC GM2";
                        ACCSOLTmp."Commission Expense Amount" := recSIL."BLACC CommissionExpenseAmount";
                    end;
                end;
            1:
                begin
                    ACCSOLTmp."Credit Note" := true;

                    recSCMH.Reset();
                    recSCMH.SetRange("No.", ivqACCVE.Document_No);
                    if recSCMH.FindFirst() then begin
                        tSellCust := recSCMH."Sell-to Customer No.";
                        tSP := recSCMH."Salesperson Code";
                        ACCSOLTmp."SalesPerson Code" := tSP;
                        ACCSOLTmp."Sell-to Customer No" := recSCMH."Sell-to Customer No.";
                        ACCSOLTmp."Sell-to Customer Name" := recSCMH."Sell-to Customer Name";
                        tBillCust := recSCMH."Bill-to Customer No.";

                        if recSCMH."Currency Factor" <> 0 then decExchRate := 1 / recSCMH."Currency Factor";

                        if recSCMH."BLTI Original eInvoice No." <> '' then begin
                            recSIH.Reset();
                            recSIH.SetRange("BLTI eInvoice No.", recSCMH."BLTI Original eInvoice No.");
                            if recSIH.FindFirst() then begin
                                ACCSOLTmp."Orig Posting Date" := recSIH."Posting Date";
                                ACCSOLTmp."Orig No" := recSIH."No.";
                                ACCSOLTmp."Sales Order" := recSIH."Order No.";
                                ACCSOLTmp."Orig EI Invoice No" := recSIH."BLTI eInvoice No.";

                                // recSIL.Reset();
                                // recSIL.SetRange("Document No.", recSIH."No.");
                                // recSIL.SetRange("Line No.", ivqACCVE.Document_Line_No);
                                // recSIL.SetRange("No.", ivqACCVE.Item_No);
                                // if recSIL.FindFirst() then ACCSOLTmp."Orig EI Invoice No" := recSIL."BLTI eInvoice No.";
                            end;
                        end;
                    end;

                    recSCML.Reset();
                    recSCML.SetRange("Document No.", ivqACCVE.Document_No);
                    recSCML.SetRange("Line No.", ivqACCVE.Document_Line_No);
                    recSCML.SetRange("No.", ivqACCVE.Item_No);
                    if recSCML.FindFirst() then begin
                        ACCSOLTmp."EI Invoice No" := recSCML."BLTI eInvoice No.";

                        if recSCML.Type = "Sales Line Type"::"Charge (Item)" then begin
                            recIC.Reset();
                            recIC.Get(recSCML."No.");
                            ACCSOLTmp."Search Name" := recIC."Search Description";
                            ACCSOLTmp.Description := recIC.Description;
                        end;

                        ACCSOLTmp.UOM := recSCML."Unit of Measure Code";

                        if ivdecCharge = 0 then
                            ACCSOLTmp."Unit Price" := recSCML."Unit Price"
                        else
                            ACCSOLTmp."Unit Price" := 0;

                        ACCSOLTmp."Item Sales Tax Group" := recSCML."VAT Prod. Posting Group";
                        ACCSOLTmp."VAT Perc" := recSCML."VAT %";
                        ACCSOLTmp."Line Amount Include VAT" := recSCML."Amount Including VAT";
                        ACCSOLTmp."Line VAT Amount" := -(recSCML."Amount Including VAT" - recSCML."VAT Base Amount");
                        ACCSOLTmp."Location Code" := recSCML."Location Code";
                        // ACCSOLTmp."Line GM1 Amount" := recSCML."BLACC GM1";
                        // ACCSOLTmp."Line GM2 Amount" := recSCML."BLACC GM2";
                        ACCSOLTmp."Commission Expense Amount" := -recSCML."BLACC CommissionExpenseAmount";
                    end;
                end;
        end;

        recC.Reset();
        recC.SetRange("No.", tSellCust);
        if recC.FindFirst() then ACCSOLTmp."Sales District" := recC.City;

        recSP.Reset();
        recSP.SetRange(Code, tSP);
        if recSP.FindFirst() then ACCSOLTmp."SalesPerson Name" := recSP.Name;

        recC.Reset();
        recC.SetRange("No.", tBillCust);
        if recC.FindFirst() then begin
            ACCSOLTmp."Bill-to Customer No" := tBillCust;
            ACCSOLTmp."Bill-to Customer Name" := recC.Name;

            recBLACCCG.Reset();
            recBLACCCG.SetRange(Code, recC."BLACC Customer Group");
            if recBLACCCG.FindFirst() then ACCSOLTmp."Customer Group Name" := recBLACCCG.Description;
        end;

        ACCSOLTmp."Exch Rate" := decExchRate;
        ACCSOLTmp."Vendor No" := recI."Vendor No.";

        tVAT := ACCSOLTmp."Item Sales Tax Group";
        if tVAT.StartsWith('F-') then begin
            ACCSOLTmp."Unit Price" := 0;
            ACCSOLTmp."Line Amount" := 0;
            ACCSOLTmp."Line Cost Amount" := 0;
        end;

        ACCSOLTmp."Line Cost Amount Adjust" := -GetCostAdjust(ivqACCVE.Document_No, ivqACCVE.Item_No, ivqACCVE.Document_Line_No);
        ACCSOLTmp."Line GM1 Amount" := ACCSOLTmp."Line Amount" - ACCSOLTmp."Line Cost Amount" - ACCSOLTmp."Line Cost Amount Adjust";
        ACCSOLTmp."Line GM2 Amount" := ACCSOLTmp."Line GM1 Amount" - ACCSOLTmp."Commission Expense Amount";

        ACCSOLTmp.Insert();
    end;

    local procedure ModData(iviType: Integer; ivqACCVE: Query "ACC Value Entry Query"; ivdecCharge: Decimal)
    var
    begin
        tVAT := '';
        if ivdecCharge = 0 then
            ACCSOLTmp.Quantity += -ivqACCVE.InvQtySum;

        // ACCSOLTmp."Line Amount" += ivqACCVE.SalesAmtSum;
        // ACCSOLTmp."Line Cost Amount" += -ivqACCVE.CostAmtActSum;

        tVAT := ACCSOLTmp."Item Sales Tax Group";
        if not tVAT.StartsWith('F-') then begin
            ACCSOLTmp."Line Amount" += ivqACCVE.SalesAmtSum;
            ACCSOLTmp."Line Cost Amount" += -ivqACCVE.CostAmtActSum;
        end;

        ACCSOLTmp."Line GM1 Amount" := ACCSOLTmp."Line Amount" - ACCSOLTmp."Line Cost Amount" - ACCSOLTmp."Line Cost Amount Adjust";
        ACCSOLTmp."Line GM2 Amount" := ACCSOLTmp."Line GM1 Amount" - ACCSOLTmp."Commission Expense Amount";

        ACCSOLTmp.Modify();
    end;

    local procedure GetCostAdjust(ivtDoc: Text; ivtItem: Text; iviLine: Integer): Decimal
    var
        recVE: Record "Value Entry";
    begin
        recVE.SetRange("Document No.", ivtDoc);
        recVE.SetRange("Item No.", ivtItem);
        recVE.SetRange("Document Line No.", iviLine);
        recVE.SetRange(Adjustment, true);
        if recVE.FindFirst() then begin
            recVE.CalcSums("Cost Amount (Actual)");
            exit(recVE."Cost Amount (Actual)");
        end;
        exit(0);
    end;
    #endregion

    //Global
    var
        dsF: Date;
        dsT: Date;
        tsCustNo: Text;
        cuACCGP: Codeunit "ACC General Process";
        qACCVE: Query "ACC Value Entry Query";
        recILE: Record "Item Ledger Entry";
        recBLACCCG: Record "BLACC Customer Group";
        tVAT: Text;
}