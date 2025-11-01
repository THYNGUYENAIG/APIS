report 52011 "ACC Expected Arrival Report"
{
    Caption = 'APIS Expected Arrival Report - R52011';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52011_ACCExpectedArrivalRpt.rdl';

    dataset
    {
        //Main
        dataitem(BLTIE; "BLTEC Import Entry")
        {
            DataItemTableView = sorting("Purchase Order No.", "Line No.");

            column(BL_No; "BL No.") { }
            column(PO_No; "Purchase Order No.") { }
            column(Reference_No; "Reference No.") { }
            column(Location_Code; "Location Code") { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(Transport_Method; "Transport Method") { }
            column(Vendor_No; "Vendor No.") { }
            column(Vendor_Name; "Vendor Name") { }
            column(Item_No; "Item No.") { }
            column(Item_Description; "Item Description") { }
            column(Entry_Point; "Entry Point") { }
            column(Container_No; "Container No.") { }
            column(ETD_Request_Date; "ETD Request Date") { }
            column(ETD_Supplier_Date; "ETD Supplier Date") { }
            column(On_Board_Date; "On Board Date") { }
            column(ETA_Request_Date; "ETA Request Date") { }
            column(Latest_ETA_Date; "Latest ETA Date") { }
            column(Process_Status; "Process Status") { }
            column(Delivery_Date; "Delivery Date") { }
            column(BLACC_Purchaser_Code; "BLACC Purchaser Code") { }
            column(Purchaser_Name; "BLACC Purchaser Name") { }
            column(Suplier_Code; "BLACC Supplier Mgt. Code") { }
            column(Suplier_Name; "BLACC Supplier Mgt. Name") { }
            column(HS_Code; recI."BLTEC HS Code") { }


            column(Paym_Term; tfPaymTerm) { }
            column(BU; tfBu) { }
            column(Lead_Time; tfLeadTime) { }
            column(Vend_No_Parm; tsVendNo) { }
            column(Visa; tfVisa) { }
            column(Visa_Doc; tfVisaDoc) { }
            column(Visa_Eff; dfVisaEff) { }
            column(Visa_Exp; dfVisaExp) { }
            column(MA; tfMA) { }
            column(MA_Doc; tfMADoc) { }
            column(MA_Eff; dfMAEff) { }
            column(MA_Exp; dfMAExp) { }
            column(LOA; tfLOA) { }
            column(LOA_Doc; tfLOADoc) { }
            column(LOA_Eff; dfLOAEff) { }
            column(LOA_Exp; dfLOAExp) { }
            column(SA; tfSA) { }
            column(SA_Doc; tfSADoc) { }
            column(SA_Eff; dfSAEff) { }
            column(SA_Exp; dfSAExp) { }
            column(Delivery_Remaining_Qty; decfDeliveryRemainingQty) { }
            column(Remark; tfRemarks) { }

            // dataitem(V; Vendor)
            // {
            //     DataItemLink = "No." = field("Vendor No.");
            //     DataItemLinkReference = BLTIE;
            //     DataItemTableView = sorting("No.");

            //     column(Vendor_Type; "BLACC Vendor Type") { }
            //     column(Vendor_Type_Name; "BLACC Vendor Type Name") { }
            // }

            trigger OnAfterGetRecord()
            var
            begin
                recI.Reset();
                recI.Get("Item No.");

                tfViSa := 'No';
                tfViSaDoc := '';
                dfViSaEff := 0D;
                dfViSaExp := 0D;
                tfMA := 'No';
                tfMADoc := '';
                dfMAEff := 0D;
                dfMAExp := 0D;
                tfLOA := 'No';
                tfLOADoc := '';
                dfLOAEff := 0D;
                dfLOAExp := 0D;
                tfSA := 'No';
                tfSADoc := '';
                dfSAEff := 0D;
                dfSAExp := 0D;
                recBLACCIC.Reset();
                recBLACCIC.SetRange("Item No.", BLTIE."Item No.");
                if recBLACCIC.FindSet() then begin
                    repeat
                        case recBLACCIC.Type of
                            recBLACCIC.Type::Visa:
                                begin
                                    if recI."BLACC Visa" then begin
                                        tfViSa := 'Yes';
                                        tfViSaDoc := recBLACCIC."No.";
                                        dfViSaEff := recBLACCIC."Published Date";
                                        dfViSaExp := recBLACCIC."Expiration Date";
                                    end;
                                end;
                            recBLACCIC.Type::MA:
                                begin
                                    if recI."BLACC MA" then begin
                                        tfMA := 'Yes';
                                        tfMADoc := recBLACCIC."No.";
                                        dfMAEff := recBLACCIC."Published Date";
                                        dfMAExp := recBLACCIC."Expiration Date";
                                    end;
                                end;
                            recBLACCIC.Type::LOA:
                                begin
                                    if recI."BLACC LOA" then begin
                                        tfLOA := 'Yes';
                                        tfLOADoc := recBLACCIC."No.";
                                        dfLOAEff := recBLACCIC."Published Date";
                                        dfLOAExp := recBLACCIC."Expiration Date";
                                    end;
                                end;
                            recBLACCIC.Type::SA:
                                begin
                                    if recI."BLACC SA" then begin
                                        tfSA := 'Yes';
                                        tfSADoc := recBLACCIC."No.";
                                        dfSAEff := recBLACCIC."Published Date";
                                        dfSAExp := recBLACCIC."Expiration Date";
                                    end;
                                end;
                        end;
                    until recBLACCIC.Next() < 1;
                end;

                tfPaymTerm := '';
                tfBU := '';
                tfLeadTime := '';
                recPH.Reset();
                recPH.SetRange("No.", "Purchase Order No.");
                if recPH."Payment Terms Code" <> '' then begin
                    tfPaymTerm := recPH."Payment Terms Code";

                    tfRemarks := '';
                    recPL.Reset();
                    recPL.SetRange("Document No.", "Purchase Order No.");
                    recPL.SetRange("No.", BLTIE."Item No.");
                    recPL.SetRange("Line No.", BLTIE."Line No.");
                    if recPL.FindFirst() then begin
                        tfBU := cuACCGP.GetDimensionCodeValue(recPL."Dimension Set ID", 'BUSINESSUNIT');
                        tfLeadTime := StrSubstNo('%1', recPL."Lead Time Calculation");
                        tfRemarks := recPL."BLACC Remark";
                    end;
                end;

                decfDeliveryRemainingQty := 0;
                recTSTmp_PO.Reset();
                recTSTmp_PO.SetRange("Item No.", BLTIE."Item No.");
                if recTSTmp_PO.FindFirst() then begin
                    recTSTmp_PO.CalcSums("Quantity (Base)");
                    decfDeliveryRemainingQty := recTSTmp_PO."Quantity (Base)";
                end;
            end;

            trigger OnPreDataItem()
            var
                cuITDM: Codeunit "Item Tracking Doc. Management";
                recPH_OutStanding: Record "Purchase Header";
                recBLTECIE: Record "BLTEC Import Entry";
            begin
                recBLTECIE.Reset();
                if tsVendNo <> '' then recBLTECIE.SetRange("Vendor No.", tsVendNo);
                if recBLTECIE.FindSet() then begin
                    repeat
                        recPH_OutStanding.Reset();
                        recPH_OutStanding.SetRange("No.", recBLTECIE."Purchase Order No.");
                        recPH_OutStanding.SetRange(Status, "Purchase Document Status"::Released);
                        if recPH_OutStanding.FindSet() then begin
                            repeat
                                cuITDM.RetrieveDocumentItemTracking(recTSTmp_PO, recPH_OutStanding."No.", recPH_OutStanding.RecordId.TableNo, recPH_OutStanding."Document Type".AsInteger());
                            until recPH_OutStanding.Next() < 1;
                        end;
                    until recBLTECIE.Next() < 1;
                end;

                if tsVendNo <> '' then SetRange("Vendor No.", tsVendNo);
            end;
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
                    // field(dsF; dsF)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Order Date From';

                    //     trigger OnValidate()
                    //     begin
                    //         dsT := CalcDate('<CM>', dsF);
                    //     end;
                    // }

                    // field(dsT; dsT)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Order Date To';
                    // }

                    field(tsVendNo; tsVendNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Vendor."No.";
                        Caption = 'Vendor No.';
                        // Enabled = bEdit;
                        // ShowMandatory = true;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            // dsT := Today();
            // dsF := CalcDate('<-CM>', dsT);
            // // dsT := DMY2Date(27, 11, 2024);
            // // tsVendNo := '131TN00235';
        end;
    }

    #region - ACC Func
    #endregion

    //GLobal
    var
        // dsF: Date;
        // dsT: Date;
        tsVendNo: Text;
        recPH: Record "Purchase Header";
        tfPaymTerm: Text;
        tfViSa: Text;
        tfViSaDoc: Text;
        dfViSaEff: Date;
        dfViSaExp: Date;
        tfMA: Text;
        tfMADoc: Text;
        dfMAEff: Date;
        dfMAExp: Date;
        tfLOA: Text;
        tfLOADoc: Text;
        dfLOAEff: Date;
        dfLOAExp: Date;
        tfSA: Text;
        tfSADoc: Text;
        dfSAEff: Date;
        dfSAExp: Date;
        // recBLACCIIS: Record "BLACC Item Information Setup";
        recBLACCIC: Record "BLACC Item Certificate";
        recPL: Record "Purchase Line";
        tfBU: Text;
        cuACCGP: Codeunit "ACC General Process";
        recI: Record Item;
        tfLeadTime: Text;
        recTSTmp_PO: Record "Tracking Specification" temporary;
        decfDeliveryRemainingQty: Decimal;
        tfRemarks: Text;
}