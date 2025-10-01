report 52010 "ACC Inventory Onhand Report"
{
    Caption = 'ACC Inventory Onhand Report - R52010';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52010_ACCInventoryOnhandRpt.rdl';

    dataset
    {
        dataitem(int; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnAfterGetRecord()
            var
                qACCILE1: Query "ACC Item Ledger Entry 1 Query";
            begin
                // recPH.Reset();
                // recPH.SetRange(Status, "Purchase Document Status"::Released);
                // if recPH.FindSet() then begin
                //     repeat
                //         cuITDM.RetrieveDocumentItemTracking(recTSTmp_PO, recPH."No.", recPH.RecordId.TableNo, recPH."Document Type".AsInteger());
                //     until recPH.Next() < 1;
                // end;

                // recSH.Reset();
                // recSH.SetRange(Status, "Sales Document Status"::Released);
                // if recSH.FindSet() then begin
                //     repeat
                //         cuITDM.RetrieveDocumentItemTracking(recTSTmp_SO, recSH."No.", recSH.RecordId.TableNo, recSH."Document Type".AsInteger());
                //     until recSH.Next() < 1;
                // end;

                if dsT <> 0D then qACCILE1.SetRange(Posting_Date_Filter, 0D, dsT);
                if tsLocation <> '' then qACCILE1.SetRange(Location_Code_Filter, tsLocation);
                if tsItem <> '' then qACCILE1.SetRange(Item_No_Filter, tsItem);
                if tsLot <> '' then qACCILE1.SetRange(Lot_No_Filter, tsLot);
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
            column(Expiration_Date; "Expiration Date") { }
            column(Manufaturing_Date; "Manufaturing Date") { }
            column(Received_Date; "Received Date") { }
            column(Physical_Inventory; "Physical Inventory") { }
            column(Physical_Reserved; "Physical Reserved") { }
            column(Available_Physical; "Available Physical") { }
            column(Location_Name; "Location Name") { }
            column(Storage_Condition; "Storage Condition") { }
            // column(Ordered; Ordered) { }
            // column(Ordered_Reserved; "Ordered Reserved") { }
            column(Quality_Quantity; "Quality Quantity") { }
            column(Invoiced_Quantity; "Posted Quantity") { }
            column(Total_Available; "Total Available") { }
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
                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Date To';
                    }
                }
            }
        }

        // trigger OnOpenPage()
        // begin
        // end;
    }

    #region - ACC Func
    local procedure InitData(ivqACCILE1: Query "ACC Item Ledger Entry 1 Query")
    var
        recL: Record Location;
        recI: Record Item;
        recLNI: Record "Lot No. Information";
        BinQuality: Query "ACC INV - Bin Blocked Qry";
        LotQuality: Query "ACC INV - Lot Blocked Qry";
        iTotalDay: Integer;
        iNumDay: Integer;
        dLitmit: Date;
        LotQChk: Boolean;
    begin
        recI.Get(ivqACCILE1.Item_No);

        ACCSLADTmp.Init();
        ACCSLADTmp."Location Code" := ivqACCILE1.Location_Code;
        ACCSLADTmp."Item No" := ivqACCILE1.Item_No;
        ACCSLADTmp."Lot No" := ivqACCILE1.Lot_No;
        ACCSLADTmp.Description := recI.Description;
        if ivqACCILE1.Location_Code <> '' then begin
            recL.Get(ivqACCILE1.Location_Code);
            ACCSLADTmp."Location Name" := recL.Name;
        end;
        ACCSLADTmp."Storage Condition" := recI."BLACC Storage Condition";

        recLNI.SetRange("Item No.", ivqACCILE1.Item_No);
        recLNI.SetRange("Lot No.", ivqACCILE1.Lot_No);
        if recLNI.FindFirst() then begin
            recLNI.CalcFields("ACC Receipt Date", "BLACC Expiration Date");
            // ACCSLADTmp."Expiration Date" := ivqACCILE1.Expiration_Date;
            // ACCSLADTmp."Manufaturing Date" := cuACCGP.GetManuFacturingDateFromItemLedgerEntries(ivqACCILE1.Item_No, ivqACCILE1.Lot_No);
            ACCSLADTmp."Expiration Date" := recLNI."BLACC Expiration Date";
            ACCSLADTmp."Received Date" := recLNI."ACC Receipt Date";

            recLNI.CalcShelfLife();
            recLNI.CalcManufacturingDate();
            ACCSLADTmp."Manufaturing Date" := recLNI."BLACC Manufacturing Date";
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
        //ACCSLADTmp."Physical Reserved" := ivqACCILE1.ReservedQtySum;
        ACCSLADTmp."Available Physical" := ACCSLADTmp."Physical Inventory" + ACCSLADTmp."Physical Reserved";

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

        ACCSLADTmp."Posted Quantity" := ivqACCILE1.InvQtySum;

        if (ACCSLADTmp."Physical Inventory" <> 0) or (ACCSLADTmp."Physical Reserved" <> 0) or (ACCSLADTmp."Available Physical" <> 0)
            or (ACCSLADTmp."Quality Quantity" <> 0) or (ACCSLADTmp."Posted Quantity" <> 0) then begin
            ACCSLADTmp."Total Available" := ACCSLADTmp."Available Physical" - ACCSLADTmp."Quality Quantity";

            // recILE.Reset();
            // recILE.SetCurrentKey("Posting Date");
            // recILE.SetAscending("Posting Date", true);
            // recILE.SetRange("Document Type", "Item Ledger Document Type"::"Purchase Receipt");
            // recILE.SetRange("Item No.", ivqACCILE1.Item_No);
            // recILE.SetRange("Lot No.", ivqACCILE1.Lot_No);
            // if recILe.FindFirst() then ACCSLADTmp."Received Date" := recILE."Posting Date";

            ACCSLADTmp.Insert();
        end;
    end;
    #endregion

    //Global
    var
        tsLocation: Text;
        tsItem: Text;
        tsLot: Text;
        dsT: Date;
        // cuITDM: Codeunit "Item Tracking Doc. Management";
        // recSH: Record "Sales Header";
        // recPH: Record "Purchase Header";
        // recTSTmp_SO: Record "Tracking Specification" temporary;
        // recTSTmp_PO: Record "Tracking Specification" temporary;
        recRE: Record "Reservation Entry";
        recSL: Record "Sales Line";
        recILE: Record "Item Ledger Entry";
    // cuACCGP: Codeunit "ACC General Process";
}