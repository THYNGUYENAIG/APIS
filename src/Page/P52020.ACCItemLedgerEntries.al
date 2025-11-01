page 52020 "ACC Item Ledger Entries"
{
    AdditionalSearchTerms = 'inventory transactions';
    ApplicationArea = Basic, Suite;
    Caption = 'APIS Item Ledger Entries';
    DataCaptionExpression = GetCaption();
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      order(descending);
    UsageCategory = History;
    Permissions = tabledata "Item Ledger Entry" = RM,
                    tabledata "Sales Invoice Line" = r,
                    tabledata "Sales Cr.Memo Line" = r;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("ACC EInvoice Series"; Rec."ACC EInvoice Series")
                {
                    ToolTip = 'Specifies the value of the ACC EInvoice Series field.', Comment = '%';
                }
                field("ACC EInvoice Type"; Rec."ACC EInvoice Type")
                {
                    ToolTip = 'Specifies the value of the ACC EInvoice Type field.', Comment = '%';
                }
                field("ACC Invoice No"; Rec."ACC Invoice No")
                {
                    ToolTip = 'Specifies the value of the Invoice No field.', Comment = '%';
                }
                field("BLTEC Customs Declaration No."; Rec."BLTEC Customs Declaration No.")
                {
                    ToolTip = 'Specifies the value of the Customs Declaration No field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies what type of document was posted to create the item ledger entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("ACC Order No."; Rec."ACC Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Order No. field.', Comment = '%';
                }
                field("ACC Customer Name"; Rec."ACC Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the description of the item in the entry. Analysis mode must be used for sorting and filtering on this field.';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                    Visible = Dim1Visible;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                    Visible = Dim2Visible;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the last date that the item on the line can be used.';
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a serial number if the posted item carries such a number.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", Enum::"Item Tracking Type"::"Serial No.", Rec."Serial No.");
                    end;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", "Item Tracking Type"::"Lot No.", Rec."Lot No.");
                    end;
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a package number if the posted item carries such a number.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", "Item Tracking Type"::"Package No.", Rec."Package No.");
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                }
                field(TranferToCode; TranferToCode)
                {
                    ApplicationArea = All;
                    Caption = 'To Location';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field(RunningBalance; CalcRunningInvBalance.GetItemBalance(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory';
                    ToolTip = 'Specifies the inventory at date including this entry.';
                    DecimalPlaces = 0 : 5;
                    Visible = false;
                }
                field(RunningBalanceLoc; CalcRunningInvBalance.GetItemBalanceLoc(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory by Location';
                    ToolTip = 'Specifies the inventory at date including this entry, for this location.';
                    DecimalPlaces = 0 : 5;
                    Visible = false;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                    Visible = true;
                }
                field("Shipped Qty. Not Returned"; Rec."Shipped Qty. Not Returned")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.';
                    Visible = false;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the quantity per item unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Visible = false;
                }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the expected sales amount, in LCY.';
                    Visible = false;
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sales amount, in LCY.';

                    trigger OnDrillDown()
                    begin
                        Error('');
                    end;
                }
                // field("ACC Price"; Rec."ACC Price")
                // {
                //     Caption = 'Unit Price';
                //     ToolTip = 'Specifies the value of the ACC Price field.', Comment = '%';
                // }
                field("Unit Price"; -arrCellValue[1])
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                    // Editable = false;
                }
                field("Completely Invoiced"; Rec."Completely Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the entry has been fully invoiced or if more posted invoices are expected. Only completely invoiced entries can be revalued.';
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
                    Visible = false;
                }
                field("Assemble to Order"; Rec."Assemble to Order")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies if the posting represents an assemble-to-order sale.';
                    Visible = false;
                }
                field("Applied Entry to Adjust"; Rec."Applied Entry to Adjust")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                    Visible = AdjustCostActionsVisible;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which type of order that the entry was created in.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                    Visible = false;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line number of the order that created the entry.';
                    Visible = false;
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the line number of the production order component.';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the related project.';
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the related project task.';
                    Visible = false;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
                    Visible = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 3, which is one of dimension codes that you set up in the General Ledger Setup window.';
                    Visible = Dim3Visible;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 4, which is one of dimension codes that you set up in the General Ledger Setup window.';
                    Visible = Dim4Visible;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 5, which is one of dimension codes that you set up in the General Ledger Setup window.';
                    Visible = Dim5Visible;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 6, which is one of dimension codes that you set up in the General Ledger Setup window.';
                    Visible = Dim6Visible;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 7, which is one of dimension codes that you set up in the General Ledger Setup window.';
                    Visible = Dim7Visible;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 8, which is one of dimension codes that you set up in the General Ledger Setup window.';
                    Visible = Dim8Visible;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Shows the source type that applies to the source number that is shown in the Source No. field. If the entry was posted from an item journal line, the field is blank. If posted from a sales line, the source type is Customer. If posted from a purchase line, the source type is Vendor. If the entry resulted from the production of a BOM (bill of materials), the source type is Item.';
                    Visible = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Shows where the entry originated. If the entry was posted from an item journal line, the field will be empty. If the entry was posted from an purchase order, purchase invoice or purchase credit memo, the field displays the buy-from vendor number. If it is posted from sales the sell-to customer number will be displayed.';
                    Visible = false;
                    Caption = 'Customer/Vendor';
                }
                field("Source Description"; InventoryLedgerSourceMgt.GetSourceDescription(Rec."Source Type", Rec."Source No."))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source Description';
                    ToolTip = 'Specifies the name or description of the source. Analysis mode must be used for sorting and filtering on this field.';
                    Visible = false;
                }
                field("Source Order No."; InventoryLedgerSourceMgt.GetSourceOrderNo(Rec."Document Type", Rec."Document No."))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source Order No.';
                    ToolTip = 'Specifies the order number of the source document this entry is associated with. Analysis mode must be used for sorting and filtering on this field.';
                    Visible = false;
                }
                field("ACC Bill To"; Rec."ACC Bill To")
                {
                    ToolTip = 'Specifies the value of the ACC Bill To field.', Comment = '%';

                    trigger OnDrillDown()
                    begin
                        Error('');
                    end;
                }
                field("ACC Bill To Name"; Rec."ACC Bill To Name")
                {
                    ToolTip = 'Specifies the value of the ACC Bill To Name field.', Comment = '%';

                    trigger OnDrillDown()
                    begin
                        Error('');
                    end;
                }
                field("ACC Contact Name"; Rec."ACC Contact Name")
                {
                    ToolTip = 'Specifies the value of the ACC Contact Name field.', Comment = '%';

                    trigger OnDrillDown()
                    begin
                        Error('');
                    end;
                }
                field("ACC Delivery Notes"; Rec."ACC Delivery Notes")
                {
                    ToolTip = 'Specifies the value of the ACC Delivery Notes field.', Comment = '%';

                    trigger OnDrillDown()
                    begin
                        Error('');
                    end;
                }
                field("ACC Delivery Address"; Rec."ACC Delivery Address")
                {
                    ToolTip = 'Specifies the value of the ACC Delivery Address field.', Comment = '%';

                    trigger OnDrillDown()
                    begin
                        Error('');
                    end;
                }
                field(ACC_ECUS_Item_Name; arrCellText[1])
                {
                    ApplicationArea = All;
                    Caption = 'ECUS - Item Name';
                    // Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }



    trigger OnAfterGetRecord()
    begin
        TranferToCode := '';
        arrCellText[1] := '';
        arrCellValue[1] := 0;

        if Rec."Entry Type" = "Item Ledger Entry Type"::Sale then begin
            if Rec."Document Type" = "Item Ledger Document Type"::"Sales Shipment" then begin
                recSSL.Reset();
                recSSL.SecurityFiltering(SecurityFilter::Ignored);
                recSSL.SetRange("Document No.", Rec."Document No.");
                recSSL.SetRange("Line No.", Rec."Document Line No.");
                if recSSL.FindFirst() then arrCellText[1] := recSSL."BLTEC Item Name";

                if (Rec."Sales Amount (Actual)" <> 0) and (Rec."Invoiced Quantity" <> 0) then
                    arrCellValue[1] := Rec."Sales Amount (Actual)" / Rec."Invoiced Quantity";
            end else begin
                if Rec."Document Type" = "Item Ledger Document Type"::"Sales Return Receipt" then begin
                    if (Rec."Sales Amount (Actual)" <> 0) and (Rec."Invoiced Quantity" <> 0) then
                        arrCellValue[1] := Rec."Sales Amount (Actual)" / Rec."Invoiced Quantity";
                end;
            end;
        end;

        if (Rec."Entry Type" = "Item Ledger Entry Type"::Transfer) AND (Rec."Document Type" = "Item Ledger Document Type"::"Transfer Shipment") then begin
            RecTSL.Reset();
            RecTSL.SecurityFiltering(SecurityFilter::Ignored);
            RecTSL.SetRange("Document No.", Rec."Document No.");
            RecTSL.SetRange("Line No.", Rec."Document Line No.");
            RecTSL.SetRange("Transfer-from Code", Rec."Location Code");
            if RecTSL.FindFirst() then TranferToCode := RecTSL."Transfer-to Code";
        end;

    end;

    trigger OnOpenPage()
    var
        recUS: Record "User Setup";
        tBU: Text;
        cuACCGP: Codeunit "ACC General Process";
        recILE: Record "Item Ledger Entry";
        lstRt: List of [Text];
        tOrderNo: Text;
        tCustName: Text;
        bMod: Boolean;
    begin
        OnBeforeOpenPage();

        if (Rec.GetFilters() <> '') and not Rec.Find() then
            if Rec.FindFirst() then;

        if recILE.FindSet() then
            repeat
                bMod := false;

                if recILE."ACC Order No." = '' then begin
                    // lstRt := recILE.GetACCOrderNo(recILE, recILE."ACC Price");
                    lstRt := recILE.GetACCOrderNo(recILE);
                    tOrderNo := lstRt.Get(1);

                    if tOrderNo <> '' then begin
                        recILE."ACC Order No." := tOrderNo;
                        recILE."ACC Customer Name" := lstRt.Get(2);
                        bMod := true;
                    end;
                end;

                if recILE."ACC EInvoice No" = '' then begin
                    tOrderNo := recILE.GetACCEInvoice(recILE);
                    if tOrderNo <> '' then begin
                        recILE."ACC EInvoice No" := tOrderNo;

                        recER.Reset();
                        recER.SetRange("eInvoice No.", recILE."ACC EInvoice No");
                        if recER.FindFirst() then begin
                            recILE."ACC EInvoice Series" := StrSubstNo('%1%2', recER."eInvoice Template Code", recER."eInvoice Series");
                        end;

                        bMod := true;
                    end;
                end;

                if recILE."ACC Invoice No" = '' then begin
                    if recILE."Document Type" = "Item Ledger Document Type"::"Purchase Receipt" then begin
                        if recILE."BLTEC Customs Declaration No." = '' then begin
                            recPRL.Reset();
                            recPRL.SetRange("Document No.", recILE."Document No.");
                            recPRL.SetRange("Line No.", recILE."Document Line No.");
                            recPRL.SetRange("No.", recILE."Item No.");
                            if recPRL.FindFirst() then begin
                                recILE."ACC Invoice No" := recPRL."BLACC Invoice No.";
                                bMod := true;
                            end;
                        end else begin
                            recVE.Reset();
                            recVE.SetRange("Item Ledger Entry No.", recILE."Entry No.");
                            recVE.SetRange("Document Type", "Item Ledger Document Type"::"Purchase Invoice");
                            if recVE.FindFirst() then begin
                                recILE."ACC Invoice No" := recVE."External Document No.";
                                bMod := true;
                            end;
                        end;
                    end;
                end;

                if bMod then
                    recILE.Modify();

            until recILE.Next() < 1;

        SetDimVisibility();

        recUS.Reset();
        recUS.SetRange("User ID", UserId());
        recUS.SetFilter("Sales Resp. Ctr. Filter", '<> %1', '');
        if recUS.FindSet() then
            repeat
                if not tBU.Contains(recUS."Sales Resp. Ctr. Filter") then cuACCGP.AddString(tBU, recUS."Sales Resp. Ctr. Filter", '|');
            until recUS.Next() < 1;
        if tBU <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Global Dimension 2 Code", tBU);
        end;
    end;

    var
        CalcRunningInvBalance: Codeunit "Calc. Running Inv. Balance";
        InventoryLedgerSourceMgt: Codeunit "Invt. Ledger Source Mgt.";
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
        AdjustCostActionsVisible: Boolean;
        AppliedEntriesMarkedToAdjustMsg: Label 'The applied entries have been marked to be adjusted. You can run the cost adjustment from the Adjust Cost - Item Entries batch job.';
        arrCellText: array[5] of Text;
        arrCellValue: array[5] of Decimal;
        recSSL: Record "Sales Shipment Line";
        recPRL: Record "Purch. Rcpt. Line";
        recVE: Record "Value Entry";
        recER: Record "BLTI eInvoice Register";
        RecTSL: Record "Transfer Shipment Line";
        TranferToCode: Code[10];

    protected var
        Dim1Visible: Boolean;
        Dim2Visible: Boolean;
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        Dim5Visible: Boolean;
        Dim6Visible: Boolean;
        Dim7Visible: Boolean;
        Dim8Visible: Boolean;

    local procedure SetDimVisibility()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(Dim1Visible, Dim2Visible, Dim3Visible, Dim4Visible, Dim5Visible, Dim6Visible, Dim7Visible, Dim8Visible);
    end;

    local procedure GetCaption() Result: Text
    var
        GLSetup: Record "General Ledger Setup";
        ObjTransl: Record "Object Translation";
        Item: Record Item;
        Cust: Record Customer;
        Vend: Record Vendor;
        Dimension: Record Dimension;
        DimValue: Record "Dimension Value";
        SourceTableName: Text;
        SourceFilter: Text;
        SourceDescription: Text;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetCaption(Rec, Result, IsHandled);
        if IsHandled then
            exit;

        SourceDescription := '';

        case true of
            Rec.GetFilter("Item No.") <> '':
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);
                    SourceFilter := Rec.GetFilter("Item No.");
                    if MaxStrLen(Item."No.") >= StrLen(SourceFilter) then
                        if Item.Get(SourceFilter) then
                            SourceDescription := Item.Description;
                end;
            Rec.GetFilter("Source No.") <> '':
                case Rec."Source Type" of
                    Rec."Source Type"::Customer:
                        begin
                            SourceTableName :=
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                            SourceFilter := Rec.GetFilter("Source No.");
                            if MaxStrLen(Cust."No.") >= StrLen(SourceFilter) then
                                if Cust.Get(SourceFilter) then
                                    SourceDescription := Cust.Name;
                        end;
                    Rec."Source Type"::Vendor:
                        begin
                            SourceTableName :=
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 23);
                            SourceFilter := Rec.GetFilter("Source No.");
                            if MaxStrLen(Vend."No.") >= StrLen(SourceFilter) then
                                if Vend.Get(SourceFilter) then
                                    SourceDescription := Vend.Name;
                        end;
                end;
            Rec.GetFilter("Global Dimension 1 Code") <> '':
                begin
                    GLSetup.Get();
                    Dimension.Code := GLSetup."Global Dimension 1 Code";
                    SourceFilter := Rec.GetFilter("Global Dimension 1 Code");
                    SourceTableName := Dimension.GetMLName(GlobalLanguage);
                    if MaxStrLen(DimValue.Code) >= StrLen(SourceFilter) then
                        if DimValue.Get(GLSetup."Global Dimension 1 Code", SourceFilter) then
                            SourceDescription := DimValue.Name;
                end;
            Rec.GetFilter("Global Dimension 2 Code") <> '':
                begin
                    GLSetup.Get();
                    Dimension.Code := GLSetup."Global Dimension 2 Code";
                    SourceFilter := Rec.GetFilter("Global Dimension 2 Code");
                    SourceTableName := Dimension.GetMLName(GlobalLanguage);
                    if MaxStrLen(DimValue.Code) >= StrLen(SourceFilter) then
                        if DimValue.Get(GLSetup."Global Dimension 2 Code", SourceFilter) then
                            SourceDescription := DimValue.Name;
                end;
            Rec.GetFilter("Document Type") <> '':
                begin
                    SourceTableName := Rec.GetFilter("Document Type");
                    SourceFilter := Rec.GetFilter("Document No.");
                    SourceDescription := Rec.GetFilter("Document Line No.");
                end;
        end;
        exit(StrSubstNo('%1 %2 %3', SourceTableName, SourceFilter, SourceDescription));
    end;

    local procedure SetAppliedEntriesToAdjust()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntryEdit: Codeunit "Item Ledger Entry-Edit";
    begin
        CurrPage.SetSelectionFilter(ItemLedgerEntry);
        ItemLedgerEntryEdit.SetAppliedEntriesToAdjust(ItemLedgerEntry);
        Message(AppliedEntriesMarkedToAdjustMsg);
    end;

    procedure ShowCostAdjustmentActions()
    begin
        AdjustCostActionsVisible := true;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetCaption(var ItemLedgerEntry: Record "Item Ledger Entry"; var Result: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeOpenPage()
    begin
    end;
}

