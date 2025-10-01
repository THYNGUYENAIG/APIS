report 52005 "ACC Shelf Life As Date Report"
{
    Caption = 'ACC Shelf Life As Date Report - R52005';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52005_ACCShelfLifeAsDateRpt.rdl';

    dataset
    {
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
                qACCILE1: Query "ACC Item Ledger Entry 1 Query";
            begin
                if tsLocation <> '' then
                    qACCILE1.SetFilter(Location_Code_Filter, tsLocation)
                else
                    qACCILE1.SetFilter(Location_Code_Filter, '<> %1', tsLocation);
                if tsItem <> '' then qACCILE1.SetRange(Item_No_Filter, tsItem);
                if tsLot <> '' then qACCILE1.SetRange(Lot_No_Filter, tsLot);
                if (dsFExpire <> 0D) and (dsTExpire <> 0D) then qACCILE1.SetRange(Expiration_Date_Filter, dsFExpire, dsTExpire);
                qACCILE1.Open();
                while qACCILE1.Read() do begin
                    InitData(qACCILE1);
                end;

            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);
            end;
        }
        //Main
        dataitem(ACCSLADTmp; "ACC Shelf Life As Date Tmp")
        {
            UseTemporary = true;
            DataItemTableView = sorting("Location Code", "Item No", "Lot No");

            column(Location_Code; "Location Code") { }
            column(Item_No; "Item No") { }
            column(Lot_No; "Lot No") { }
            column(Description; Description) { }
            column(Manufaturing_Date; "Manufaturing Date") { }
            column(Expiration_Date; "Expiration Date") { }
            column(ReceiptDate; "Receipt Date") { }
            column(InvoicedDate; "Invoiced Date") { }
            column(Physical_Inventory; "Physical Inventory") { }
            column(Physical_Reserved; "Physical Reserved") { }
            column(Available_Physical; "Available Physical") { }
            column(Quality_Quantity; "Quality Quantity") { }
            /*
            column(Ordered; Ordered) { }
            column(Ordered_Reserved; "Ordered Reserved") { }
            */
            column(Total_Available; "Total Available") { }
            column(Location_Name; "Location Name") { }
            column(Remain_1_3; Remain_1_3) { }
            column(Remain_2_3; Remain_2_3) { }
            column(Remain_Near; Remain_Near) { }
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
                    field(tsLocation; tsLocation)
                    {
                        ApplicationArea = All;
                        Caption = 'Location';
                        TableRelation = Location.Code;
                    }
                    field(tsItem; tsItem)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No.';
                        TableRelation = Item."No.";
                    }
                    field(tsLot; tsLot)
                    {
                        ApplicationArea = All;
                        Caption = 'Lot No.';
                        // TableRelation = Item."No.";
                    }
                    field(dsFExpire; dsFExpire)
                    {
                        ApplicationArea = All;
                        Caption = 'Expiration Date From';

                        trigger OnValidate()
                        begin
                            if dsFExpire <> 0D then dsTExpire := DMY2Date(31, 12, Date2DMY(dsFExpire, 3));
                        end;
                    }
                    field(dsTExpire; dsTExpire)
                    {
                        ApplicationArea = All;
                        Caption = 'Expiration Date To';
                    }
                }
            }
        }

        // trigger OnOpenPage()
        // begin
        //     tsItem := '20100100001';
        // end;
    }

    #region - ACC Func
    local procedure InitData(ivqACCILE1: Query "ACC Item Ledger Entry 1 Query")
    var
        BinQuality: Query "ACC INV - Bin Blocked Qry";
        LotQuality: Query "ACC INV - Lot Blocked Qry";
        recL: Record Location;
        recI: Record Item;
        recLNI: Record "Lot No. Information";
        iTotalDay: Integer;
        iNumDay: Integer;
        dLitmit: Date;
        LotQChk: Boolean;
        dManufacturing: Date;
    begin
        Clear(dManufacturing);
        ACCSLADTmp.Init();

        LotQChk := true;
        LotQuality.SetRange(LocationCode, ivqACCILE1.Location_Code);
        LotQuality.SetRange(ItemNo, ivqACCILE1.Item_No);
        LotQuality.SetRange(LotNo, ivqACCILE1.Lot_No);
        if LotQuality.Open() then begin
            while LotQuality.Read() do begin
                LotQChk := false;
                ACCSLADTmp."Quality Quantity" := LotQuality.Quantity;
            end;
            LotQuality.Close();
        end;
        if LotQChk = true then begin
            BinQuality.SetRange(LocationCode, ivqACCILE1.Location_Code);
            BinQuality.SetRange(ItemNo, ivqACCILE1.Item_No);
            BinQuality.SetRange(LotNo, ivqACCILE1.Lot_No);
            if BinQuality.Open() then begin
                while BinQuality.Read() do begin
                    ACCSLADTmp."Quality Quantity" := BinQuality.Quantity;
                end;
                BinQuality.Close();
            end;
        end;

        ACCSLADTmp."Physical Inventory" := ivqACCILE1.QtySum;
        recRE.Reset();
        recRE.SetRange("Location Code", ivqACCILE1.Location_Code);
        recRE.SetRange("Item No.", ivqACCILE1.Item_No);
        recRE.SetRange("Lot No.", ivqACCILE1.Lot_No);
        recRE.SetRange("Source Type", 37);
        recRE.SetRange("Source Subtype", 1);
        recRE.SetRange("Reservation Status", "Reservation Status"::Reservation);
        if recRE.FindFirst() then begin
            recRE.CalcSums("Quantity (Base)");
            ACCSLADTmp."Physical Reserved" := recRE."Quantity (Base)";
        end;

        recRE.Reset();
        recRE.SetRange("Location Code", ivqACCILE1.Location_Code);
        recRE.SetRange("Item No.", ivqACCILE1.Item_No);
        recRE.SetRange("Lot No.", ivqACCILE1.Lot_No);
        recRE.SetRange("Source Type", 5741);
        recRE.SetRange("Source Subtype", 0);
        recRE.SetRange("Reservation Status", "Reservation Status"::Reservation);
        if recRE.FindFirst() then begin
            recRE.CalcSums("Quantity (Base)");
            ACCSLADTmp."Physical Reserved" += recRE."Quantity (Base)";
        end;

        recRE.Reset();
        recRE.SetRange("Location Code", ivqACCILE1.Location_Code);
        recRE.SetRange("Item No.", ivqACCILE1.Item_No);
        recRE.SetRange("Lot No.", ivqACCILE1.Lot_No);
        recRE.SetRange("Source Type", 39);
        recRE.SetRange("Source Subtype", 5);
        recRE.SetRange("Reservation Status", "Reservation Status"::Reservation);
        if recRE.FindFirst() then begin
            recRE.CalcSums("Quantity (Base)");
            ACCSLADTmp."Physical Reserved" += recRE."Quantity (Base)";
        end;
        ACCSLADTmp."Available Physical" := ACCSLADTmp."Physical Inventory" - ACCSLADTmp."Physical Reserved";
        ACCSLADTmp."Total Available" := ACCSLADTmp."Available Physical" - ACCSLADTmp."Quality Quantity";

        if (ACCSLADTmp."Physical Inventory" <> 0) or (ACCSLADTmp."Physical Reserved" <> 0)
            or (ACCSLADTmp."Available Physical" <> 0) or (ACCSLADTmp."Quality Quantity" <> 0) then begin
            ACCSLADTmp."Total Available" := ACCSLADTmp."Available Physical" - ACCSLADTmp."Quality Quantity";

            recL.Get(ivqACCILE1.Location_Code);
            recI.Get(ivqACCILE1.Item_No);

            ACCSLADTmp."Location Code" := ivqACCILE1.Location_Code;
            ACCSLADTmp."Item No" := ivqACCILE1.Item_No;
            ACCSLADTmp."Lot No" := ivqACCILE1.Lot_No;
            ACCSLADTmp.Description := recI.Description;
            ACCSLADTmp."Location Name" := recL.Name;

            recLNI.SetRange("Item No.", ivqACCILE1.Item_No);
            recLNI.SetRange("Lot No.", ivqACCILE1.Lot_No);
            if recLNI.FindFirst() then begin
                recLNI.CalcFields("BLACC Expiration Date");
                ACCSLADTmp."Expiration Date" := recLNI."BLACC Expiration Date";

                recLNI.CalcShelfLife();
                recLNI.CalcManufacturingDate();
                dManufacturing := recLNI."BLACC Manufacturing Date";
                ACCSLADTmp."Manufaturing Date" := dManufacturing;
                ACCSLADTmp.Remain_Near := ACCSLADTmp."Expiration Date";
                ACCSLADTmp.Remain_2_3 := recLNI."BLACC Days At 2/3";
                ACCSLADTmp.Remain_1_3 := recLNI."BLACC Days At 1/3";
            end;

            recILE.Reset();
            recILE.SetCurrentKey("Posting Date");
            recILE.SetAscending("Posting Date", true);
            recILE.SetRange("Item No.", ivqACCILE1.Item_No);
            recILE.SetRange("Lot No.", ivqACCILE1.Lot_No);
            recILE.SetFilter("Entry Type", '%1 | %2', "Item Ledger Entry Type"::"Positive Adjmt.", "Item Ledger Entry Type"::Purchase);
            if recILE.FindFirst() then begin
                ACCSLADTmp."Receipt Date" := recILE."Posting Date";
            end;

            recILE.Reset();
            recILE.SetCurrentKey("Posting Date");
            recILE.SetAscending("Posting Date", true);
            recILE.SetRange("Item No.", ivqACCILE1.Item_No);
            recILE.SetRange("Lot No.", ivqACCILE1.Lot_No);
            // recILE.SetRange("Entry Type", "Item Ledger Entry Type"::Sale);
            recILE.SetRange("Document Type", "Item Ledger Document Type"::"Purchase Receipt");
            if recILE.FindFirst() then begin
                recILE1.Reset();
                recILE1.SetRange("Item No.", ivqACCILE1.Item_No);
                recILE1.SetRange("Lot No.", ivqACCILE1.Lot_No);
                recILE1.SetRange("Posting Date", recILE."Posting Date");
                // recILE1.SetRange("Document Type", "Item Ledger Document Type"::"Sales Shipment");
                recILE1.SetRange("Document Type", "Item Ledger Document Type"::"Purchase Receipt");
                if recILE1.FindFirst() then begin
                    recPIL.Reset();
                    recPIL.SetRange("Order No.", recILE1."ACC Order No.");
                    recPIL.SetRange("Order Line No.", recILE1."Document Line No.");
                    if recPIL.FindFirst() then begin
                        ACCSLADTmp."Invoiced Date" := recPIL."Posting Date";
                    end;
                end;
            end;

            ACCSLADTmp.Insert();
        end;
    end;
    #endregion

    //Global
    var
        tsLocation: Text;
        tsItem: Text;
        tsLot: Text;
        dsFExpire: Date;
        dsTExpire: Date;
        // cuACCGP: Codeunit "ACC General Process";
        recRE: Record "Reservation Entry";
        recILE: Record "Item Ledger Entry";
        recILE1: Record "Item Ledger Entry";
        // recSIL: Record "Sales Invoice Line";
        recPIL: Record "Purch. Inv. Line";
}