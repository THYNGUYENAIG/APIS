page 52026 "ACC Onhand"
{
    Caption = 'ACC Onhand - P52026';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "ACC Shelf Life As Date Tmp";
    SourceTableTemporary = true;
    Editable = false;
    // UsageCategory = History;
    Permissions = tabledata "ACC Inventory By Month" = r;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field("Item No"; Rec."Item No")
                {
                    ToolTip = 'Specifies the value of the Item No field.', Comment = '%';
                }
                field("Lot No"; Rec."Lot No")
                {
                    ToolTip = 'Specifies the value of the LotNo field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("ECUS - Item Name"; Rec."ECUS - Item Name")
                {
                    ToolTip = 'Specifies the value of the ECUS - Item Name field.', Comment = '%';
                }
                field("Manufaturing Date"; Rec."Manufaturing Date")
                {
                    ToolTip = 'Specifies the value of the Manufaturing Date field.', Comment = '%';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field("Physical Inventory"; Rec."Physical Inventory")
                {
                    ToolTip = 'Specifies the value of the Physical Inventory field.', Comment = '%';
                }
                field("Physical Reserved"; Rec."Physical Reserved")
                {
                    ToolTip = 'Specifies the value of the Physical Reserved field.', Comment = '%';
                }
                field("Available Physical"; Rec."Available Physical")
                {
                    ToolTip = 'Specifies the value of the Available Physical field.', Comment = '%';
                }
                field("Quality Quantity"; Rec."Quality Quantity")
                {
                    ToolTip = 'Specifies the value of the Tồn Q field.', Comment = '%';
                }
                field("Total Available"; Rec."Total Available")
                {
                    ToolTip = 'Specifies the value of the Total Available field.', Comment = '%';
                }
                field("Location Name"; Rec."Location Name")
                {
                    ToolTip = 'Specifies the value of the Location Name field.', Comment = '%';
                }
                field(Remain_1_3; Rec.Remain_1_3)
                {
                    ToolTip = 'Specifies the value of the Remain 1/3 Shelf Life field.', Comment = '%';
                }
                field(Remain_2_3; Rec.Remain_2_3)
                {
                    ToolTip = 'Specifies the value of the Remain 2/3 Shelf Life field.', Comment = '%';
                }
                field(Remain_Near; Rec.Remain_Near)
                {
                    ToolTip = 'Specifies the value of the Remain Near Shelf Life field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Calculate Onhand")
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                //ToolTip = 'Calculate the data based on the latest entries.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    bUpd: Boolean;
                begin
                    bUpd := false;
                    if Rec.FindSet() then
                        repeat
                            // Message('%1 - %2', Rec."Item No", Rec."Lot No");
                            CalculateOnhand();
                            bUpd := true;
                        until Rec.Next() < 1;

                    // if bUpd then CurrPage.Update(true) else CurrPage.Update(false);
                    CurrPage.Update(false);
                end;
            }
            action(ACCInventoryByBin)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Image = Open;
                //ToolTip = 'Calculate the data based on the latest entries.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ByBin: Page "ACC Inventory By Bin";
                begin
                    ByBin.SetOnhandFilter(Rec."Location Code", Rec."Item No", Rec."Lot No");
                    ByBin.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        qACCILE1: Query "ACC Item Ledger Entry 1 Query";
        qACCIBM: Query "ACC Inventory By Month Query";
        iRows: Integer;
        dLast: Date;
        dRF: Date;
        dRT: Date;
    begin
        iRows := recACCIBM.Count;

        if iRows = 0 then begin
            // qACCILE1.SetRange(Item_No_Filter, '23717802062');
            // qACCILE1.SetRange(Lot_No_Filter, 'XW92502012');
            qACCILE1.Open();
            while qACCILE1.Read() do begin
                InitData(qACCILE1);
            end;
            qACCILE1.Close();
        end else begin
            recACCIBM.Reset();
            if recACCIBM.FindLast() then begin
                dLast := recACCIBM."Posting Date";

                qACCIBM.Open();
                while qACCIBM.Read() do begin
                    InitDataFromACCInventoryByMonth(qACCIBM);
                end;
                qACCIBM.Close();

                dRT := WorkDate();
                if dLast < dRT then begin
                    dRF := CalcDate('<1D>', dLast);
                    qACCILE1.SetRange(Posting_Date_Filter, dRF, dRT);
                    qACCILE1.Open();
                    while qACCILE1.Read() do begin
                        Rec.Reset();
                        Rec.SetRange("Location Code", qACCILE1.Location_Code);
                        Rec.SetRange("Item No", qACCILE1.Item_No);
                        Rec.SetRange("Lot No", qACCILE1.Lot_No);
                        if Rec.FindFirst() then begin
                            ModData(qACCILE1);
                        end else begin
                            InitData(qACCILE1);
                        end;
                    end;
                end;
            end;
        end;

        Rec.Reset();
    end;

    #region - ACC Func
    local procedure InitDataFromACCInventoryByMonth(ivqACCIBM: Query "ACC Inventory By Month Query")
    var
    begin
        Rec.Init();

        Rec."Physical Inventory" := ivqACCIBM.Quantity;
        Rec."Available Physical" := Rec."Physical Inventory";

        if Rec."Available Physical" <> 0 then begin
            recI.Get(ivqACCIBM.Item_No);

            Rec."Location Code" := ivqACCIBM.Location_Code;
            Rec."Item No" := ivqACCIBM.Item_No;
            Rec."Lot No" := ivqACCIBM.Lot_No;
            Rec.Description := recI.Description;
            Rec."ECUS - Item Name" := recI."BLTEC Item Name";
            if ivqACCIBM.Location_Code <> '' then begin
                recL.Get(ivqACCIBM.Location_Code);
                Rec."Location Name" := recL.Name;
            end;

            recLNI.Reset();
            recLNI.SetRange("Item No.", ivqACCIBM.Item_No);
            recLNI.SetRange("Lot No.", ivqACCIBM.Lot_No);
            if recLNI.FindFirst() then begin
                recLNI.CalcFields("BLACC Expiration Date");
                recLNI.CalcRemainingShelfLife();
                recLNI.CalcManufacturingDate();
                Rec."Expiration Date" := recLNI."BLACC Expiration Date";
                Rec."Manufaturing Date" := recLNI."BLACC Manufacturing Date";
                Rec.Remain_Near := recLNI."BLACC Expiration Date";
                Rec.Remain_2_3 := recLNI."BLACC Days At 2/3";
                Rec.Remain_1_3 := recLNI."BLACC Days At 1/3";
            end;

            Rec.Insert();
        end;
    end;

    local procedure InitData(ivqACCILE1: Query "ACC Item Ledger Entry 1 Query")
    var
    begin
        Rec.Init();

        Rec."Physical Inventory" := ivqACCILE1.QtySum;
        Rec."Available Physical" := Rec."Physical Inventory";

        if Rec."Available Physical" <> 0 then begin
            recI.Get(ivqACCILE1.Item_No);

            Rec."Location Code" := ivqACCILE1.Location_Code;
            Rec."Item No" := ivqACCILE1.Item_No;
            Rec."Lot No" := ivqACCILE1.Lot_No;
            Rec.Description := recI.Description;
            Rec."ECUS - Item Name" := recI."BLTEC Item Name";
            if ivqACCILE1.Location_Code <> '' then begin
                recL.Get(ivqACCILE1.Location_Code);
                Rec."Location Name" := recL.Name;
            end;

            recLNI.Reset();
            recLNI.SetRange("Item No.", ivqACCILE1.Item_No);
            recLNI.SetRange("Lot No.", ivqACCILE1.Lot_No);
            if recLNI.FindFirst() then begin
                recLNI.CalcFields("BLACC Expiration Date");
                recLNI.CalcRemainingShelfLife();
                recLNI.CalcManufacturingDate();
                Rec."Expiration Date" := recLNI."BLACC Expiration Date";
                Rec."Manufaturing Date" := recLNI."BLACC Manufacturing Date";
                Rec.Remain_Near := recLNI."BLACC Expiration Date";
                Rec.Remain_2_3 := recLNI."BLACC Days At 2/3";
                Rec.Remain_1_3 := recLNI."BLACC Days At 1/3";
            end;

            Rec.Insert();
        end;
    end;

    local procedure ModData(ivqACCILE1: Query "ACC Item Ledger Entry 1 Query")
    var
    begin
        Rec."Physical Inventory" += ivqACCILE1.QtySum;
        Rec."Available Physical" := Rec."Physical Inventory";
        Rec.Modify();
    end;

    local procedure CalculateOnhand()
    begin
        Rec."Physical Reserved" := GetReserved(Rec."Location Code", Rec."Item No", Rec."Lot No");
        Rec."Available Physical" := Rec."Physical Inventory" + Rec."Physical Reserved";
        Rec."Quality Quantity" := GetLotQ(Rec."Location Code", Rec."Item No", Rec."Lot No", Rec."Available Physical");
        Rec."Total Available" := Rec."Available Physical" - Rec."Quality Quantity";
        Rec.Modify();
    end;

    local procedure GetReserved(ivtLocation: Text; ivtItem: Text; ivtLot: Text) ovdec: Decimal
    begin
        recRE.Reset();
        recRE.SetRange("Location Code", ivtLocation);
        recRE.SetRange("Item No.", ivtItem);
        recRE.SetRange("Lot No.", ivtLot);
        recRE.SetRange("Source Type", 37);
        recRE.SetRange("Source Subtype", 1);
        recRE.SetRange("Reservation Status", "Reservation Status"::Reservation);
        if recRE.FindFirst() then begin
            recRE.CalcSums("Quantity (Base)");
            ovdec := recRE."Quantity (Base)";
        end;

        recRE.Reset();
        recRE.SetRange("Location Code", ivtLocation);
        recRE.SetRange("Item No.", ivtItem);
        recRE.SetRange("Lot No.", ivtLot);
        recRE.SetRange("Source Type", 5741);
        recRE.SetRange("Source Subtype", 0);
        recRE.SetRange("Reservation Status", "Reservation Status"::Reservation);
        if recRE.FindFirst() then begin
            recRE.CalcSums("Quantity (Base)");
            ovdec += recRE."Quantity (Base)";
        end;

        recRE.Reset();
        recRE.SetRange("Location Code", ivtLocation);
        recRE.SetRange("Item No.", ivtItem);
        recRE.SetRange("Lot No.", ivtLot);
        recRE.SetRange("Source Type", 39);
        recRE.SetRange("Source Subtype", 5);
        recRE.SetRange("Reservation Status", "Reservation Status"::Reservation);
        if recRE.FindFirst() then begin
            recRE.CalcSums("Quantity (Base)");
            ovdec += recRE."Quantity (Base)";
        end;
    end;

    local procedure GetLotQ(ivtLocation: Text; ivtItem: Text; ivtLot: Text; ivdecAvailable: Decimal) ovdec: Decimal
    var
        bLotQChk: Boolean;
    begin
        bLotQChk := true;

        recLNI.Reset();
        recLNI.SetRange("Item No.", ivtItem);
        recLNI.SetRange("Lot No.", ivtLot);
        if recLNI.FindFirst() then begin
            if recLNI.Blocked then begin
                bLotQChk := false;
                ovdec := ivdecAvailable;
            end;
        end;

        if bLotQChk then begin
            recBC.Reset();
            recBC.SetRange("Location Code", ivtLocation);
            recBC.SetRange("Item No.", ivtItem);
            recBC.SetFilter("Block Movement", '<> %1', optBlockBin::" ");
            if recBC.FindSet() then
                repeat
                    recWE.Reset();
                    recWE.SetRange("Location Code", recBC."Location Code");
                    recWE.SetRange("Bin Code", recBC."Bin Code");
                    recWE.SetRange("Item No.", recBC."Item No.");
                    recWE.SetRange("Unit of Measure Code", recBC."Unit of Measure Code");
                    recWE.SetRange("Lot No.", ivtLot);
                    if recWE.FindFirst() then begin
                        recWE.CalcSums(Quantity);
                        ovdec += recWE.Quantity;
                    end;
                until recBC.Next() < 1;
        end;
    end;
    #endregion

    //Global
    var
        recRE: Record "Reservation Entry";
        recACCIBM: Record "ACC Inventory By Month";
        recL: Record Location;
        recI: Record Item;
        recLNI: Record "Lot No. Information";
        recBC: Record "Bin Content";
        recWE: Record "Warehouse Entry";
        optBlockBin: Option " ",Inbound,Outbound,All;
}