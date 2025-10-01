page 52028 "Import Entry Mgt. Sales"
{
    Caption = 'Import Entry Management (Sales)';
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
                field("BLACC Remark"; Rec."BLACC Remark")
                {
                    ToolTip = 'Specifies the value of the Remark field.', Comment = '%';
                }
                field("BLACC Reason"; Rec."BLACC Reason")
                {
                    ToolTip = 'Specifies the value of the Reason field.', Comment = '%';
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
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                    Editable = false;
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
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Note field.';
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
                field("BLACC Air Freight"; Rec."BLACC Air Freight")
                {
                    ToolTip = 'Specifies the value of the Air Freight field.', Comment = '%';
                }
                field("BLACC Air Reason"; Rec."BLACC Air Reason")
                {
                    ToolTip = 'Specifies the value of the Air Reason field.', Comment = '%';
                }
                field("BLACC Air/Sea"; Rec."BLACC Air/Sea")
                {
                    ToolTip = 'Specifies the value of the Air/Sea field.', Comment = '%';
                }
                field("BLACC Copy Docs Date"; Rec."BLACC Copy Docs Date")
                {
                    ToolTip = 'Specifies the value of the Copy Docs Date field.', Comment = '%';
                }
                field("BLACC Customer Name"; Rec."BLACC Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("BLACC Customer No."; Rec."BLACC Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("BLACC Document Date"; Rec."BLACC Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("BLACC GAP Reason"; Rec."BLACC GAP Reason")
                {
                    ToolTip = 'Specifies the value of the GAP Reason field.', Comment = '%';
                }
                field("BLACC Invoice No."; Rec."BLACC Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                }
                field("BLACC Item Group"; Rec."BLACC Item Group")
                {
                    ToolTip = 'Specifies the value of the Item Group field.', Comment = '%';
                }
                field("BLACC LOA Expire Date"; Rec."BLACC LOA Expire Date")
                {
                    ToolTip = 'Specifies the value of the LOA Expire Date field.', Comment = '%';
                }
                field("BLACC MA Expire Date"; Rec."BLACC MA Expire Date")
                {
                    ToolTip = 'Specifies the value of the MA Expire Date field.', Comment = '%';
                }
                field("BLACC Note"; Rec."BLACC Note")
                {
                    ToolTip = 'Specifies the value of the Note field.', Comment = '%';
                }
                field("BLACC Order Date"; Rec."BLACC Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.', Comment = '%';
                }
                field("BLACC Original Quantity"; Rec."BLACC Original Quantity")
                {
                    ToolTip = 'Specifies the value of the Original Quantity field.', Comment = '%';
                }
                field("BLACC Payer"; Rec."BLACC Payer")
                {
                    ToolTip = 'Specifies the value of the Payer field.', Comment = '%';
                }
                field("BLACC Planning DateTime"; Rec."BLACC Planning DateTime")
                {
                    ToolTip = 'Specifies the value of the Planning DateTime field.', Comment = '%';
                }
                field("BLACC Purchase Request No."; Rec."BLACC Purchase Request No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Request No. field.', Comment = '%';
                }
                field("BLACC Purchaser Code"; Rec."BLACC Purchaser Code")
                {
                    ToolTip = 'Specifies the value of the Purchaser Code field.', Comment = '%';
                }
                field("BLACC Purchaser Name"; Rec."BLACC Purchaser Name")
                {
                    ToolTip = 'Specifies the value of the Purchaser Name field.', Comment = '%';
                }
                field("BLACC Req. DateTime"; Rec."BLACC Req. DateTime")
                {
                    ToolTip = 'Specifies the value of the Requistion DateTime field.', Comment = '%';
                }
                field("BLACC SA Expire Date"; Rec."BLACC SA Expire Date")
                {
                    ToolTip = 'Specifies the value of the SA Expire Date field.', Comment = '%';
                }
                field("BLACC Supplier Mgt. Code"; Rec."BLACC Supplier Mgt. Code")
                {
                    ToolTip = 'Specifies the value of the Supplier Management Code field.', Comment = '%';
                }
                field("BLACC Supplier Mgt. Name"; Rec."BLACC Supplier Mgt. Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Management Name field.', Comment = '%';
                }
                field("BLACC Vendor Item No."; Rec."BLACC Vendor Item No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Item No. field.', Comment = '%';
                }
                field("BLACC VISA Expire Date"; Rec."BLACC VISA Expire Date")
                {
                    ToolTip = 'Specifies the value of the VISA Expire Date field.', Comment = '%';
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

                            POToImportEntry(lRec_ImportEntry, lRec_PurchHeader, lRec_PurchLine, lRec_Item);

                            // luôn luôn lúc mới từ PO qua luôn là Unconfirm -> chị Dung confirm
                            lRec_ImportEntry.Validate("Process Status", lRec_ImportEntry."Process Status"::"Unconfirmed PO");

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

    procedure POToImportEntry(var lRec_ImportEntry: Record "BLTEC Import Entry"; lRec_PurchHeader: Record "Purchase Header"; lRec_PurchLine: Record "Purchase Line"; lRec_Item: Record Item)
    begin
        lRec_ImportEntry."Vendor No." := lRec_PurchHeader."Buy-from Vendor No.";
        lRec_ImportEntry."Vendor Name" := lRec_PurchHeader."Buy-from Vendor Name";
        lRec_ImportEntry."Vendor Posting Group" := lRec_PurchHeader."Vendor Posting Group";
        lRec_ImportEntry."Reference No." := lRec_PurchHeader."BLTEC Reference No.";
        lRec_ImportEntry.Validate("Item No.", lRec_PurchLine."No.");
        lRec_ImportEntry."Item Description" := lRec_PurchLine.Description;
        lRec_ImportEntry.Validate(Quantity, lRec_PurchLine.Quantity);
        lRec_ImportEntry."Origin Country" := lRec_Item."Country/Region of Origin Code";
        lRec_ImportEntry."Contract No." := lRec_PurchHeader."BLTEC Contract No.";

        lRec_ImportEntry."BLTEC C/O No." := lRec_PurchLine."BLTEC C/O No.";
        lRec_ImportEntry."BLTEC C/O Date" := lRec_PurchLine."BLTEC C/O Date";
        lRec_ImportEntry."BLTEC C/O Type" := lRec_PurchLine."BLTEC C/O Type";
        if lRec_ImportEntry."Expected Receipt Date" = 0D then // fix issues do sai ngay từ trên PO, mới sửa trên IE -> c Dung bảo khóa sync để đỡ phải update ngược
            lRec_ImportEntry."Expected Receipt Date" := lRec_PurchLine."Expected Receipt Date";
        lRec_ImportEntry."Entry Point" := lRec_PurchHeader."Entry Point";
        // lRec_ImportEntry."Original ETD Date" := lRec_PurchLine."BLTEC ETD Date";
        // lRec_ImportEntry."Original ETA Date" := lRec_PurchLine."BLTEC ETA Date";
        // lRec_ImportEntry."Original EXW Date" := lRec_PurchLine."BLTEC EXW Date";
        // lRec_ImportEntry."Original Available Date" := lRec_PurchLine."BLTEC Available Date";
        lRec_ImportEntry."Currency Code" := lRec_PurchHeader."Currency Code";
        lRec_ImportEntry."Shortcut Dimension 1 Code" := lRec_PurchLine."Shortcut Dimension 1 Code";
        lRec_ImportEntry."Shortcut Dimension 2 Code" := lRec_PurchLine."Shortcut Dimension 2 Code";
        lRec_ImportEntry."Shipment Method Code" := lRec_PurchHeader."Shipment Method Code";
        lRec_ImportEntry."Transport Method" := lRec_PurchHeader."Transport Method";
        lRec_ImportEntry."Payment Terms Code" := lRec_PurchHeader."Payment Terms Code";
        lRec_ImportEntry."Using Location" := lRec_PurchLine."BLTEC Using Location";
        lRec_ImportEntry."Direct Unit Cost" := lRec_PurchLine."Direct Unit Cost";
        lRec_ImportEntry."Line Amount" := lRec_PurchLine."Line Amount";
        lRec_ImportEntry."Location Code" := lRec_PurchLine."Location Code";
        lRec_ImportEntry."Warehouse - Shipping Agent" := lRec_PurchLine."Warehouse - Shipping Agent";

        // Nhập ETD nhảy ETA trong GAPs. Chị Tuyết confirm là khi sync qua thì lấy y chang PO qua cho c -> bỏ check 0D
        // if lRec_ImportEntry."ETD Request Date" = 0D then
        lRec_ImportEntry.Validate("ETD Request Date", lRec_PurchLine."BLTEC ETD Request Date");
        // if lRec_ImportEntry."ETA Request Date" = 0D then
        lRec_ImportEntry.Validate("ETA Request Date", lRec_PurchLine."BLTEC ETA Request Date");
        // if lRec_ImportEntry."ETD Request Update Date" = 0D then
        lRec_ImportEntry.Validate("ETD Request Update Date", lRec_PurchLine."BLTEC ETD Request Update Date");
        // if lRec_ImportEntry."ETA Request Update Date" = 0D then
        lRec_ImportEntry.Validate("ETA Request Update Date", lRec_PurchLine."BLTEC ETA Request Update Date");
        // if lRec_ImportEntry."ETD Supplier Date" = 0D then
        lRec_ImportEntry.Validate("ETD Supplier Date", lRec_PurchLine."BLTEC ETD Supplier Date");
        // if lRec_ImportEntry."ETA Supplier Date" = 0D then
        lRec_ImportEntry.Validate("ETA Supplier Date", lRec_PurchLine."BLTEC ETA Supplier Date");
        // if lRec_ImportEntry."On Board Date" = 0D then
        lRec_ImportEntry.Validate("On Board Date", lRec_PurchLine."BLTEC On Board Date");
        // if lRec_ImportEntry."Latest ETA Date" = 0D then
        lRec_ImportEntry.Validate("Latest ETA Date", lRec_PurchLine."BLTEC Latest ETA Date");
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
                    lRec_ImportEntryUpdate.LoadingLocationCode := lRec_CustomsDecl."BLTEC LoadingLocationCode";
                    lRec_ImportEntryUpdate.LoadingLocationName := lRec_CustomsDecl."BLTEC LoadingLocationName";
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
