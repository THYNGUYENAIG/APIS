page 52021 "ACC Transaction Inventory"
{
    AdditionalSearchTerms = 'inventory transactions';
    ApplicationArea = Basic, Suite;
    Caption = 'ACC Transaction Inventory';
    DataCaptionExpression = GetCaption();
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      order(descending);
    UsageCategory = History;
    Permissions = tabledata "Item Ledger Entry" = RM;

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
                // field(Description; Rec.Description)
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies a description of the entry.';
                // }
                field("ACC Item Description"; Rec."ACC Item Description")
                {
                    ToolTip = 'Specifies the value of the ACC Item Description field.', Comment = '%';
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
                field("ACC Base UOM"; Rec."ACC Base UOM")
                {
                    ToolTip = 'Specifies the value of the ACC Base UOM field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Visible = false;
                }
                field("Unit Price"; UnitPrice)
                {
                    DecimalPlaces = 0 : 3;
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
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the expected cost, in LCY, of the quantity posting.';
                    Visible = false;
                }
                field("Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the expected cost, in ACY, of the quantity posting.';
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)"; Rec."Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the adjusted cost of the entry, in the additional reporting currency.';
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the adjusted non-inventoriable cost, that is, an item charge assigned to an outbound entry in the additional reporting currency.';
                    Visible = false;
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
                field("ACC Invoice No"; Rec."ACC Invoice No")
                {
                    ToolTip = 'Specifies the value of the Invoice No field.', Comment = '%';
                }
                field("ACC EInvoice No"; Rec."ACC EInvoice No")
                {
                    ToolTip = 'Specifies the value of the E-Invoice No field.', Comment = '%';
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
                    Visible = true;
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
                field("ACC ECUS Item Name"; Rec."ACC ECUS Item Name")
                {
                    ToolTip = 'Specifies the value of the ACC ECUS Item Name field.', Comment = '%';
                    Caption = 'ECUS - Item Name';
                }
                field("ACC Salesperson Code"; Rec."ACC Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the ACC Salesperson Code field.', Comment = '%';
                }
                field("BLTEC Customs Declaration No."; Rec."BLTEC Customs Declaration No.")
                {
                    ToolTip = 'Specifies the value of the Customs Declaration No field.';

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
    var
        ItemEntryRelation: Record "Item Entry Relation";
        SalesInvoiceLine: Record "Sales Invoice Line";
        PurchLine: Record "Purchase Line";

    begin
        UnitPrice := 0;
        ItemEntryRelation.Reset();
        ItemEntryRelation.SetRange("Item Entry No.", Rec."Entry No.");
        if ItemEntryRelation.FindFirst() then begin
            if ItemEntryRelation."Source Type" = 121 then begin
                PurchLine.Reset();
                PurchLine.SetRange("Document No.", ItemEntryRelation."Order No.");
                PurchLine.SetRange("Line No.", ItemEntryRelation."Order Line No.");
                if PurchLine.FindFirst() then begin
                    UnitPrice := PurchLine."Direct Unit Cost";
                end;
            end;
            if ItemEntryRelation."Source Type" = 111 then begin
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Order No.", ItemEntryRelation."Order No.");
                SalesInvoiceLine.SetRange("Order Line No.", ItemEntryRelation."Order Line No.");
                if SalesInvoiceLine.FindFirst() then begin
                    UnitPrice := SalesInvoiceLine."Unit Price";
                end;
            end;
        end;
    end;


    trigger OnOpenPage()
    var
        AIGValueEntry: Codeunit "AIG Value Entry Relation";
        recILE: Record "Item Ledger Entry";
        lstRt: List of [Text];
        tOrderNo: Text;
        tCustName: Text;
        bMod: Boolean;
    begin
        AIGValueEntry.SetSalesValueEntry();
        AIGValueEntry.SetPurchValueEntry();
        OnBeforeOpenPage();

        // recILE.SetRange("ACC Order No.", '');
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
                //  else begin
                //     if recILE."ACC Customer Name" = '' then begin
                //         lstRt := recILE.GetACCOrderNo(recILE);
                //         tCustName := lstRt.Get(2);

                //         if tCustName <> '' then begin
                //             recILE."ACC Customer Name" := tCustName;
                //             bMod := true;
                //         end;
                //     end;
                // end;

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

        if (Rec.GetFilters() <> '') and not Rec.Find() then
            if Rec.FindFirst() then;

        SetDimVisibility();
    end;

    var
        CalcRunningInvBalance: Codeunit "Calc. Running Inv. Balance";
        InventoryLedgerSourceMgt: Codeunit "Invt. Ledger Source Mgt.";
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
        AdjustCostActionsVisible: Boolean;
        AppliedEntriesMarkedToAdjustMsg: Label 'The applied entries have been marked to be adjusted. You can run the cost adjustment from the Adjust Cost - Item Entries batch job.';
        arrCellText: array[5] of Text;
        recSSL: Record "Sales Shipment Line";
        recPRL: Record "Purch. Rcpt. Line";
        recVE: Record "Value Entry";
        recER: Record "BLTI eInvoice Register";
        UnitPrice: Decimal;

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

