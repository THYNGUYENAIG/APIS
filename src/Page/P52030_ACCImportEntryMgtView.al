page 52030 "Import Entry Mgt. View"
{
    Caption = 'Import Entry Mgt. View';
    PageType = List;
    SourceTable = "BLTEC Import Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Process Status"; Rec."Process Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO No. field.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO No. field.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference No. field.';
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    Editable = false;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Posting Group field.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Editable = false;
                }
                field("BLTEC Item ECUS Name"; Rec."BLTEC Item ECUS Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item ECUS Name field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Editable = false;
                }
                field("Origin Country"; Rec."Origin Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Origin Country field.';
                    Editable = false;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    // Editable = false;
                }
                field("Invoice No"; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    // Editable = false;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Date field.';
                    // Editable = false;
                }
                field("BL No"; Rec."BL No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BL No. field.';
                    // Editable = false;
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container No. field.';
                }
                // field("CO Form"; Rec."CO Form")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the CO Form field.';
                //     Editable = false;
                // }
                field("Entry Point"; Rec."Entry Point")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Point field.';
                }
                field("BLTEC Entry Point Description"; Rec."BLTEC Entry Point Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Point Description field.';
                }
                // field("Original EXW Date"; Rec."Original EXW Date")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     ToolTip = 'Specifies the value of the Original EXW field.';
                // }
                // field("ETD Date"; Rec."Original ETD Date")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the ETD Date field.';
                //     Editable = false;
                // }
                // field("ETA Date"; Rec."Original ETA Date")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the ETA Date field.';
                //     Editable = false;
                // }
                // field("Original Available Date"; Rec."Original Available Date")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     ToolTip = 'Specifies the value of the Original Available Date field.';
                // }
                field("ETD Request Date"; Rec."ETD Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA Request Date field.';
                }
                field("ETA Request Date"; Rec."ETA Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA Request Date field.';
                }
                field("ETD Request Update Date"; Rec."ETD Request Update Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD Request Update Date field.';
                }
                field("ETA Request Update Date"; Rec."ETA Request Update Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA Request Update Date field.';
                }
                field("ETD Supplier Date"; Rec."ETD Supplier Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD Supplier Date field.';
                }
                field("ETA Supplier Date"; Rec."ETA Supplier Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA Supplier Date field.';
                }
                field("On Board Date"; Rec."On Board Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the On Board Datefield.';
                    trigger OnValidate()
                    var
                        lCurrValue: Boolean;
                    begin
                        Rec.ValidateAction(Format(Rec."Process Status"::"On board (Shipped)"));
                        lCurrValue := Rec.IsItalic;
                        Rec.IsItalic := not lCurrValue;
                        Rec.Modify(true);
                        CurrPage.Update();
                    end;
                }
                field("Latest ETA Date"; Rec."Latest ETA Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Latest ETA Date field.';
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'You can only adjust the Delivery Date through the calculation formula.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                    Editable = false;
                }
                field("BLTEC C/O No."; Rec."BLTEC C/O No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BLTEC C/O No. field.';
                }
                field("BLTEC C/O Date"; Rec."BLTEC C/O Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BLTEC C/O Date field.';
                }
                field("BLTEC C/O Type"; Rec."BLTEC C/O Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BLTEC C/O Type field.';
                }
                field("Actual EXW Date"; Rec."Actual EXW Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual EXW field.';
                }
                field("Actual ETD Date"; Rec."Actual ETD Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual ETD field.';
                }
                field("Actual ETA Date"; Rec."Actual ETA Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gStyle;
                    ToolTip = 'Specifies the value of the Actual ETA field.';
                }
                field("Actual Available Date"; Rec."Actual Available Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual Available Date field.';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration No. field.';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
                field("Reg. Expire Date"; Rec."Reg. Expire Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reg. Expire Date field.';
                }
                field("Free DEM"; Rec."Free DEM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Free DEM field.';
                }
                field("Free DET"; Rec."Free DET")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Free DET field.';
                }
                field("Release Date"; Rec."Release Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Release Date field.';
                }
                field("Customs Declaration No."; Rec."BLTEC Customs Declaration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customs Declaration No. field.';
                }
                field("Customs Declaration Date"; Rec."Customs Declaration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customs Declaration Date field.';
                }
                field("Declaration Status"; Rec."Declaration Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Declaration Status field.';
                }
                field("Customs Clearance Date"; Rec."Customs Clearance Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customs Clearance Date field.';
                }
                field("Consultant Minutes"; Rec."Consultant Minutes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consultant Minutes field.';
                }
                field("Consultant Status"; Rec."Consultant Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consultant Status field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    Editable = false;
                }
                field("Puling Cont. Date"; Rec."Puling Cont. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Puling Cont. Date field.';
                }
                field("Returning Cont. Date"; Rec."Returning Cont. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Returning Cont. Date field.';
                }
                field("Incurred DEM"; Rec."Incurred DEM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incurred DEM field.';
                    Editable = false;
                }
                field("Incurred DET"; Rec."Incurred DET")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incurred DET field.';
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    // Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Insurance No."; Rec."Insurance No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance No. field.';
                }
                field("Note 1"; Rec."Delivery Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Note field.';
                }
                field("Warehouse - Shipping Agent"; Rec."Warehouse - Shipping Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warehouse - Shipping Agent field.';
                }
                field("Warehouse - Shipping Agent Des"; Rec."Warehouse - Shipping Agent Des")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warehouse - Shipping Agent Des field.';
                }
                field("Using Location"; Rec."Using Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Using Location field.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Direct Unit Cost field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipment Method Code field.';
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transport Method field.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                }
                field("Payment Terms Name"; Rec."Payment Terms Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Terms Name field.';
                }
                field("UnloadingPortCode"; Rec.UnloadingPortCode)
                {
                    Caption = 'Unloading Port Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unloading Port Code field.';
                    Editable = false;
                }
                field("UnloadingPortName"; Rec.UnloadingPortName)
                {
                    Caption = 'Unloading Port Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unloading Port Name field.';
                    Editable = false;
                }
                field("LoadingLocationCode"; Rec.LoadingLocationCode)
                {
                    Caption = 'Loading Location Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loading Location Code field.';
                    Editable = false;
                }
                field("LoadingLocationName"; Rec.LoadingLocationName)
                {
                    Caption = 'Loading Location Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loading Location Name field.';
                    Editable = false;
                }
                field("PO SystemCreatedAt"; Rec."PO SystemCreatedAt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field("Posted Receipt No."; Rec."Posted Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Receipt No. field.';
                }
                field("Posted Receipt Date"; Rec."Posted Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Receipt Date field.';
                }
                field("Posted Receipt Qty."; Rec."Posted Receipt Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Receipt Qty. field.';
                }
                field("BLTEC Deliver Remainder"; Rec."BLTEC Deliver Remainder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deliver Remainder field.';
                }
                field("BLTEC Insured"; Rec."BLTEC Insured")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insured field.';
                }
                field("BLTEC Sent Docs To Ins. Comp."; Rec."BLTEC Sent Docs To Ins. Comp.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sent Docs To Insurance Company field.';
                }
                field("BLTEC Insurance Fee"; Rec."BLTEC Insurance Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Fee field.';
                }
                field("BLTEC HS Code"; Rec."BLTEC HS Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HS Code field.';
                }
                field("BLTEC Upload Date"; Rec."BLTEC Upload Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Upload Date field.';
                }
                field("BLTEC Insurance Agent"; Rec."BLTEC Insurance Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Agent field.';
                }
                field("BLTEC Insurance Rate"; Rec."BLTEC Insurance Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Rate field.';
                }
                field("BLTEC Customs Office"; Rec."BLTEC Customs Office")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customs Office field.';
                }
            }
        }
    }

    var
        gStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Process Status", '<>%1', Rec."Process Status"::Finished);
    end;

    trigger OnAfterGetRecord()
    begin
        gStyle := Rec.IEO_GetStyle();
    end;

    procedure GetDatafomrPurchOrder() ReturnTotal: Integer
    var
        lRec_PurchHeader: Record "Purchase Header";
        lRec_PurchHdrUpdate: Record "Purchase Header";
        lRec_PurchLine: Record "Purchase Line";
        lRec_CustomsDecl: Record "BLTEC Customs Declaration";
        lRec_CustomsDeclTMP: Record "BLTEC Customs Declaration" temporary;
        lRec_CustomsDeclLine: Record "BLTEC Customs Decl. Line";
        lRec_ImportEntry: Record "BLTEC Import Entry";
        lRec_Item: Record Item;
    begin
        lRec_PurchHeader.Reset();
        lRec_PurchHeader.SetRange("Document Type", lRec_PurchHeader."Document Type"::Order);
        // lRec_PurchHeader.SetRange(Status, lRec_PurchHeader.Status::Released); //issues 225: Lấy status từ bên PO list qa import entry
        lRec_PurchHeader.SetRange("BLTEC Is Created Import", false);
        if lRec_PurchHeader.FindSet() then
            repeat
                lRec_PurchLine.SetRange("Document Type", lRec_PurchHeader."Document Type");
                lRec_PurchLine.SetRange("Document No.", lRec_PurchHeader."No.");
                lRec_PurchLine.SetRange(Type, lRec_PurchLine.Type::Item);
                if lRec_PurchLine.FindSet() then
                    repeat
                        if not lRec_CustomsDeclTMP.Get(lRec_PurchLine."Document No.") then begin
                            Clear(lRec_CustomsDecl);
                            lRec_CustomsDecl.GetHeaderFromPurchaseLine(lRec_PurchLine."Document No.", lRec_PurchLine."Line No.");
                            lRec_CustomsDeclTMP.Init();
                            lRec_CustomsDeclTMP."Document No." := lRec_PurchLine."Document No.";
                            lRec_CustomsDeclTMP.Insert();
                        end;

                        lRec_Item.Get(lRec_PurchLine."No.");
                        Clear(lRec_ImportEntry);
                        if not lRec_ImportEntry.Get(lRec_PurchLine."Document No.", lRec_PurchLine."Line No.") then begin
                            lRec_ImportEntry.Init();
                            lRec_ImportEntry."Purchase Order No." := lRec_PurchHeader."No.";
                            lRec_ImportEntry."Line No." := lRec_PurchLine."Line No.";
                            lRec_ImportEntry."Registration No." := lRec_PurchHeader."BLTEC Registration No.";
                            // if lRec_ImportEntry."Registration No." = '' then
                            //     lRec_ImportEntry."Registration No." := lRec_CustomsDecl."Registration No.";
                            lRec_ImportEntry."Reg. Expire Date" := lRec_PurchHeader."BLTEC Reg. Receipt Date";
                            lRec_ImportEntry."Free DEM" := lRec_PurchHeader."BLTEC Free DEM";
                            lRec_ImportEntry."Free DET" := lRec_PurchHeader."BLTEC Free DET";
                            // lRec_ImportEntry."Release Date" := lRec_CustomsDecl."Release of Goods";
                            // lRec_ImportEntry."BLTEC Customs Declaration No." := lRec_CustomsDecl."BLTEC Customs Declaration No.";
                            // lRec_ImportEntry."Customs Declaration Date" := lRec_CustomsDecl."Customs Clearance Date";
                            // lRec_ImportEntry."Declaration Status" := lRec_CustomsDecl."Declaration Status";
                            // lRec_ImportEntry."Customs Clearance Date" := lRec_CustomsDecl."Customs Clearance Date";
                            // lRec_ImportEntry."Consultant Minutes" := lRec_CustomsDecl."Consultant Minutes";
                            // lRec_ImportEntry."Consultant Status" := lRec_CustomsDecl."Consultant Status";

                            lRec_ImportEntry."PO SystemCreatedAt" := lRec_PurchLine.SystemCreatedAt;

                            // luôn luôn lúc mới từ PO qua luôn là Unconfirm -> chị Dung confirm
                            lRec_ImportEntry.Validate("Process Status", lRec_ImportEntry."Process Status"::"Unconfirmed PO");

                            POToImportEntry(lRec_ImportEntry, lRec_PurchHeader, lRec_PurchLine, lRec_Item);

                            OnBeforeInsertCopy(lRec_ImportEntry, lRec_PurchLine);
                            lRec_ImportEntry.Insert(true);
                        end else begin

                            POToImportEntry(lRec_ImportEntry, lRec_PurchHeader, lRec_PurchLine, lRec_Item);

                            OnBeforeModifyCopy(lRec_ImportEntry, lRec_PurchLine);
                            lRec_ImportEntry.Modify();
                        end;
                        ReturnTotal += 1;
                    until lRec_PurchLine.Next() = 0;

                lRec_PurchHdrUpdate := lRec_PurchHeader;
                lRec_PurchHdrUpdate."BLTEC Is Created Import" := true;
                lRec_PurchHdrUpdate.Modify();
            until lRec_PurchHeader.Next() = 0;
    end;

    procedure POToImportEntry(var pImportEntry: Record "BLTEC Import Entry"; pPurchHeader: Record "Purchase Header"; pPurchLine: Record "Purchase Line"; pItem: Record Item)
    begin
        if pImportEntry."Process Status" in [pImportEntry."Process Status"::"Unconfirmed PO", pImportEntry."Process Status"::"Confirmed PO", pImportEntry."Process Status"::"Confirmed ETD", pImportEntry."Process Status"::"On board (Shipped)"] then begin
            pImportEntry."Vendor No." := pPurchHeader."Buy-from Vendor No.";
            pImportEntry."Vendor Name" := pPurchHeader."Buy-from Vendor Name";
            pImportEntry."Vendor Posting Group" := pPurchHeader."Vendor Posting Group";
            pImportEntry."Reference No." := pPurchHeader."BLTEC Reference No.";
            pImportEntry.Validate("Item No.", pPurchLine."No.");
            pImportEntry."Item Description" := pPurchLine.Description;
            pImportEntry.Validate(Quantity, pPurchLine.Quantity);
            pImportEntry."Origin Country" := pItem."Country/Region of Origin Code";
            pImportEntry."Contract No." := pPurchHeader."BLTEC Contract No.";
            pImportEntry."BLTEC C/O No." := pPurchLine."BLTEC C/O No.";
            pImportEntry."BLTEC C/O Date" := pPurchLine."BLTEC C/O Date";
            pImportEntry."BLTEC C/O Type" := pPurchLine."BLTEC C/O Type";
            pImportEntry."Expected Receipt Date" := pPurchLine."Expected Receipt Date";
            pImportEntry."Entry Point" := pPurchHeader."Entry Point";
            pImportEntry."Currency Code" := pPurchHeader."Currency Code";
            pImportEntry."Shortcut Dimension 1 Code" := pPurchLine."Shortcut Dimension 1 Code";
            pImportEntry."Shortcut Dimension 2 Code" := pPurchLine."Shortcut Dimension 2 Code";
            pImportEntry."Shipment Method Code" := pPurchHeader."Shipment Method Code";
            pImportEntry."Transport Method" := pPurchHeader."Transport Method";
            pImportEntry."Payment Terms Code" := pPurchHeader."Payment Terms Code";
            pImportEntry."Using Location" := pPurchLine."BLTEC Using Location";
            pImportEntry."Direct Unit Cost" := pPurchLine."Direct Unit Cost";
            pImportEntry."Line Amount" := pPurchLine."Line Amount";
            pImportEntry."Location Code" := pPurchLine."Location Code";
            pImportEntry."Warehouse - Shipping Agent" := pPurchLine."Warehouse - Shipping Agent";

            // Nhập ETD nhảy ETA trong GAPs. Chị Tuyết confirm là khi sync qua thì lấy y chang PO qua cho c -> bỏ check 0D
            // if pImportEntry."ETD Request Date" = 0D then
            pImportEntry.Validate("ETD Request Date", pPurchLine."BLTEC ETD Request Date");
            // if pImportEntry."ETA Request Date" = 0D then
            pImportEntry.Validate("ETA Request Date", pPurchLine."BLTEC ETA Request Date");
            // if pImportEntry."ETD Request Update Date" = 0D then
            pImportEntry.Validate("ETD Request Update Date", pPurchLine."BLTEC ETD Request Update Date");
            // if pImportEntry."ETA Request Update Date" = 0D then
            pImportEntry.Validate("ETA Request Update Date", pPurchLine."BLTEC ETA Request Update Date");
            // if pImportEntry."ETD Supplier Date" = 0D then
            pImportEntry.Validate("ETD Supplier Date", pPurchLine."BLTEC ETD Supplier Date");
            // if pImportEntry."ETA Supplier Date" = 0D then
            pImportEntry.Validate("ETA Supplier Date", pPurchLine."BLTEC ETA Supplier Date");
            pImportEntry.Validate("Latest ETA Date", pPurchLine."BLTEC Latest ETA Date");
            pImportEntry.Validate("On Board Date", pPurchLine."BLTEC On Board Date");
        end;
    end;

    procedure UpdateCustomDeclaInfo()
    var
        lRec_CustomsDecl: Record "BLTEC Customs Declaration";
        lRec_PurchHdrTMP: Record "Purchase Header" temporary;
        lRec_DeclaLine: Record "BLTEC Customs Decl. Line";
        lRec_ImportEntry: Record "BLTEC Import Entry";
        lRec_ImportEntryUpdate: Record "BLTEC Import Entry";
        lRec_Item: Record "Lot No. Information";
    begin
        lRec_ImportEntry.Reset();
        lRec_ImportEntry.SetFilter("Process Status", '<>%1', lRec_ImportEntry."Process Status"::Finished);
        lRec_ImportEntry.SetFilter("BLTEC Customs Declaration No.", '%1', '');
        if lRec_ImportEntry.FindSet() then
            repeat
                if lRec_CustomsDecl.GetHeaderFromPurchaseLine(lRec_ImportEntry."Purchase Order No.", lRec_ImportEntry."Line No.") then begin
                    lRec_ImportEntryUpdate := lRec_ImportEntry;
                    lRec_ImportEntryUpdate."Invoice No." := lRec_CustomsDecl."Invoice No";
                    lRec_ImportEntryUpdate."Invoice Date" := lRec_CustomsDecl."Invoice Date";
                    lRec_ImportEntryUpdate."Registration No." := lRec_CustomsDecl."Registration No.";
                    lRec_ImportEntryUpdate."Registration Date" := lRec_CustomsDecl."Registration Date";
                    // lRec_ImportEntryUpdate."BL No." := lRec_CustomsDecl."BL No.";
                    lRec_ImportEntryUpdate."BLTEC Customs Declaration No." := lRec_CustomsDecl."BLTEC Customs Declaration No.";
                    lRec_ImportEntryUpdate."Customs Declaration Date" := lRec_CustomsDecl."Declaration Date";
                    lRec_ImportEntryUpdate."Declaration Status" := lRec_CustomsDecl."Declaration Status";
                    lRec_ImportEntryUpdate."Customs Clearance Date" := lRec_CustomsDecl."Customs Clearance Date";
                    lRec_ImportEntryUpdate."Consultant Minutes" := lRec_CustomsDecl."Consultant Minutes";
                    lRec_ImportEntryUpdate."Consultant Status" := lRec_CustomsDecl."Consultant Status";
                    lRec_ImportEntryUpdate."Release Date" := lRec_CustomsDecl."Release of Goods";
                    lRec_ImportEntryUpdate.UnloadingPortCode := lRec_CustomsDecl."BLTEC UnloadingPortCode";
                    lRec_ImportEntryUpdate.UnloadingPortName := lRec_CustomsDecl."BLTEC UnloadingPortName";
                    lRec_ImportEntryUpdate.Modify(true);
                end;
            until lRec_ImportEntry.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertCopy(var ImportEntry: Record "BLTEC Import Entry"; var PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyCopy(var ImportEntry: Record "BLTEC Import Entry"; var PurchLine: Record "Purchase Line")
    begin
    end;
}
