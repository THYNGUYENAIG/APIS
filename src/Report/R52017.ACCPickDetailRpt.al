report 52017 "ACC Pick Detail Report"
{
    Caption = 'APIS Pick Detail Report - R52017';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52017_ACCPickDetailRpt.rdl';

    dataset
    {
        dataitem(WSH; "Warehouse Shipment Header")
        {
            // DataItemTableView = sorting("No.") where("No." = const('SH000010'));
            DataItemTableView = sorting("No.");

            dataitem(WSL; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemLinkReference = WSH;
                DataItemTableView = sorting("No.", "Line No.");

                trigger OnAfterGetRecord()
                var
                    decTotalPicked: Decimal;
                    decTotalShipped: Decimal;
                    decTotalOpen: Decimal;
                    tStatus: Text;
                    dRequest: Date;
                    decConvert: Decimal;
                    tUserShip: Text;
                    tPalletF: Text;
                    tPalletT: Text;
                    PickNo: Text;
                    PickTmp: Text;
                begin
                    WhseShipment.SetRange(SourceNo, WSL."Source No.");
                    // WhseShipment.SetRange(SourceDocument, "Warehouse Activity Source Document"::"Sales Order");
                    if WhseShipment.Open() then begin
                        while WhseShipment.Read() do begin
                            decTotalShipped += WhseShipment.Quantity;
                        end;
                        WhseShipment.Close();
                    end;

                    RecWHACTLine.SetRange("Whse. Document No.", WSH."No.");
                    if RecWHACTLine.FindSet() then
                        repeat
                            if PickTmp <> RecWHACTLine."No." then begin
                                if PickNo = '' then begin
                                    PickNo := RecWHACTLine."No.";
                                end else begin
                                    PickNo := PickNo + '|' + RecWHACTLine."No.";
                                end;
                            end;
                            PickTmp := RecWHACTLine."No.";
                        until RecWHACTLine.Next() = 0;

                    WhseRegistered.SetRange(SourceNo, WSL."Source No.");
                    // WhseRegistered.SetRange(SourceDocument, "Warehouse Activity Source Document"::"Sales Order");
                    if WhseRegistered.Open() then begin
                        while WhseRegistered.Read() do begin
                            decTotalPicked := WhseRegistered.Quantity;
                        end;
                        WhseRegistered.Close();
                    end;

                    decTotalOpen := 0;

                    recSL.Reset();
                    recSL.SetRange("Document No.", WSL."Source No.");
                    if recSL.FindFirst() then begin
                        recSL.CalcSums(recSL.Quantity);
                        decTotalOpen := recSL.Quantity;
                    end;

                    if decTotalShipped = 0 then begin
                        if decTotalPicked <> 0 then begin
                            if decTotalOpen = decTotalPicked then tStatus := 'Picked' else tStatus := 'Part Picked';
                        end else
                            tStatus := 'Open';
                    end else begin
                        if decTotalPicked <> 0 then begin
                            if decTotalPicked <> decTotalShipped then begin
                                tStatus := 'Part Shipped';
                            end else begin
                                tStatus := 'Shipped';
                            end;
                        end else begin
                            tStatus := 'Shipped';
                        end;
                    end;

                    case "Source Document" of
                        "Warehouse Activity Source Document"::"Sales Order":
                            begin
                                recSH.Reset();
                                recSH.SetRange("No.", WSL."Source No.");
                                if recSH.FindFirst() then dRequest := recSH."Requested Delivery Date";
                            end;
                        "Warehouse Activity Source Document"::"Outbound Transfer":
                            begin
                                dRequest := WSL."Shipment Date";
                            end;
                    end;

                    decConvert := recI."Net Weight";
                    recPWSL.Reset();
                    recPWSL.SetRange("Source No.", WSL."Source No.");
                    if recPWSL.FindFirst() then begin
                        recU.Reset();
                        recU.SetRange("User Security ID", recPWSL.SystemCreatedBy);
                        if recU.FindFirst() then begin
                            tUserShip := recU."User Name";
                        end;
                    end;

                    Clear(qACCWE);
                    qACCWE.SetRange(Source_No_Filter, WSL."Source No.");
                    qACCWE.SetRange(Item_No_Filter, WSL."Item No.");
                    qACCWE.SetRange(Zone_Code_Filter, 'PUTPICK');
                    qACCWE.Open();
                    while qACCWE.Read() do begin
                        recMLPC.Reset();
                        recMLPC.SetRange("Location Code", qACCWE.Location_Code);
                        recMLPC.SetRange("Bin Code", qACCWE.Bin_Code);
                        recMLPC.SetRange("No.", WSL."Item No.");
                        recMLPC.SetRange("Lot No.", qACCWE.Lot_No);
                        if recMLPC.FindFirst() then tPalletF := recMLPC."License Plate No.";

                        tPalletT := LookupTotes(WSL);

                        iLineNo += 1;
                        ACCPDTmp.Reset();
                        // ACCPDTmp.SetRange("Document No", WSH."No.");
                        ACCPDTmp.SetRange("Source No", WSL."Source No.");
                        ACCPDTmp.SetRange("Item No", WSL."Item No.");
                        ACCPDTmp.SetRange("Bin Code", qACCWE.Bin_Code);
                        ACCPDTmp.SetRange("Lot No", qACCWE.Lot_No);
                        ACCPDTmp.SetRange("Pallet From", tPalletF);
                        ACCPDTmp.SetRange("Pallet To", tPalletT);
                        if ACCPDTmp.FindFirst() then begin
                            ACCPDTmp.Qty += qACCWE.QtySum;
                            ACCPDTmp."Qty Packaging" := cuACCGP.Divider(ACCPDTmp.Qty, decConvert);
                        end else begin
                            ACCPDTmp.Init();
                            ACCPDTmp."Entry No" := iLineNo;
                            ACCPDTmp."Source No" := WSL."Source No.";
                            ACCPDTmp."Item No" := WSL."Item No.";
                            ACCPDTmp."Bin Code" := qACCWE.Bin_Code;
                            ACCPDTmp."Lot No" := qACCWE.Lot_No;
                            ACCPDTmp."Pallet From" := tPalletF;
                            ACCPDTmp."Pallet To" := tPalletT;
                            ACCPDTmp.Status := tStatus;
                            ACCPDTmp."Posting Date" := dRequest;
                            ACCPDTmp."Item Name" := WSL.Description;
                            ACCPDTmp.Qty := -qACCWE.QtySum;
                            ACCPDTmp."Qty Packaging" := cuACCGP.Divider(ACCPDTmp.Qty, decConvert);

                            recLNI.Reset();
                            recLNI.SetRange("Item No.", qACCWE.Item_No);
                            recLNI.SetRange("Lot No.", qACCWE.Lot_No);
                            if recLNI.FindFirst() then begin
                                // ACCPDTmp."Manufacturing Date" := cuACCGP.GetManuFacturingDateFromItemLedgerEntries(qACCWE.Item_No, qACCWE.Lot_No);
                                ACCPDTmp."Manufacturing Date" := recLNI."BLACC Manufacturing Date";
                                ACCPDTmp."Expiration Date" := recLNI."BLACC Expiration Date";
                            end;

                            recILE.Reset();
                            recILE.SetCurrentKey("Posting Date");
                            recILE.SetAscending("Posting Date", true);
                            recILE.SetRange("Document Type", "Item Ledger Document Type"::"Purchase Receipt");
                            recILE.SetRange("Item No.", qACCWE.Item_No);
                            recILE.SetRange("Lot No.", qACCWE.Lot_No);
                            if recILE.FindFirst() then ACCPDTmp."Received Date" := recILE."Posting Date";

                            recU.Reset();
                            recU.SetRange("User Security ID", WSH.SystemCreatedBy);
                            if recU.FindFirst() then begin
                                ACCPDTmp."User Release" := recU."User Name";
                            end;

                            ACCPDTmp."User Ship" := tUserShip;
                            ACCPDTmp."Pick No" := PickNo;
                            ACCPDTmp.Insert();
                        end;
                    end;
                    qACCWE.Close();
                end;
            }

            trigger OnPreDataItem()
            begin
                if (dsF <> 0D) and (dsT <> 0D) then begin
                    SetRange("Posting Date", dsF, dsT);
                    if tsLoc <> '' then SetRange("Location Code", tsLoc);
                end;
            end;
        }

        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");

            column(CompanyName; Name) { }
            column(CompanyAddress; Address + ' ' + "Address 2") { }
            column(CompanyPhone; "Phone No.") { }
            column(CompanyTeleFax; "Telex No.") { }
            column(VAT_Registration_No; "VAT Registration No.") { }

            column(CompanyPic; Picture) { }

            dataitem(ACCPDTmp; "ACC Pick Detail Tmp")
            {
                UseTemporary = true;
                DataItemTableView = sorting("Entry No");
                column(BestDate; "Best Date") { }
                column(BinCode; "Bin Code") { }
                column(ReceivedDate; "Received Date") { }
                column(EntryNo; "Entry No") { }
                column(ExpirationDate; "Expiration Date") { }
                column(ItemName; "Item Name") { }
                column(ItemNo; "Item No") { }
                column(LotNo; "Lot No") { }
                column(PalletFrom; "Pallet From") { }
                column(PalletTo; "Pallet To") { }
                column(PostingDate; "Posting Date") { }
                column(ManufacturingDate; "Manufacturing Date") { }
                column(Qty; Qty) { }
                column(QtyPackaging; "Qty Packaging") { }
                column(Status; Status) { }
                column(UserRelease; "User Release") { }
                column(UserShip; "User Ship") { }
                column(SourceNo; "Source No") { }
                column(PickNo; "Pick No") { }
                column(DF_Parm; dsF) { }
                column(DT_Parm; dsT) { }
                column(Loc_Parm; tsLoc) { }
            }
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
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsF := DMY2Date(1, 1, 2025);
            // tsCustNo := '10-00001-00';
        end;
    }

    #region ACC Func
    procedure LookupTotes(var _WhseShipmentLine: Record "Warehouse Shipment Line") _ToteTxt: Text
    var
        MobWmsRegistration: Record "MOB WMS Registration";
    begin
        MobWmsRegistration.SetCurrentKey("Whse. Document Type", "Whse. Document No.", "Whse. Document Line No.", "Tote ID");
        MobWmsRegistration.SetRange("Whse. Document Type", MobWmsRegistration."Whse. Document Type"::Shipment);
        MobWmsRegistration.SetRange("Whse. Document No.", _WhseShipmentLine."No.");
        MobWmsRegistration.SetRange("Whse. Document Line No.", _WhseShipmentLine."Line No.");
        _ToteTxt := BuildToteTxt(MobWmsRegistration);
    end;

    local procedure BuildToteTxt(var _MobWmsRegistration: Record "MOB WMS Registration") _ToteTxt: Text;
    var
        LastToteId: Code[100];
    begin
        Clear(LastToteId);
        if _MobWmsRegistration.FindSet() then
            repeat
                // Since the registrations are sorted by the tote id this check will prevent the same tote id from being added multiple times
                if LastToteId <> _MobWmsRegistration."Tote ID" then begin
                    if _ToteTxt = '' then
                        _ToteTxt := _MobWmsRegistration."Tote ID"
                    else
                        _ToteTxt += ', ' + _MobWmsRegistration."Tote ID";
                    // Remember the last tote
                    LastToteId := _MobWmsRegistration."Tote ID";
                end;
            until _MobWmsRegistration.Next() = 0;
    end;
    #endregion

    //GLobal
    var
        dsF: Date;
        dsT: Date;
        tsLoc: Text;
        iLineNo: Integer;
        WhseRegistered: Query "ACC Whse. Registered Qry";
        WhseShipment: Query "ACC Posted Whse. Shipment Qry";
        recSL: Record "Sales Line";
        qACCWE: Query "ACC WH Entry Query";
        recSH: Record "Sales Header";
        recI: Record Item;
        recBLACCPG: Record "BLACC Packing Group";
        cuACCGP: Codeunit "ACC General Process";
        recLNI: Record "Lot No. Information";
        recILE: Record "Item Ledger Entry";
        recU: Record User;
        recPWSL: Record "Posted Whse. Shipment Line";
        recMLPC: Record "MOB License Plate Content";
        RecWHACTLine: Record "Warehouse Activity Line";
    // MobWmsToolbox: Codeunit "MOB WMS Toolbox";
}