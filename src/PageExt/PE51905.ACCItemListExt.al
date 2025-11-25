pageextension 51905 "ACC Item List Ext" extends "Item List"
{
    layout
    {
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Item),
                              "No." = field("No.");
            }
        }
        addlast(Control1)
        {
            field("ACC Planner Code"; Rec."ACC Planner Code") { ApplicationArea = All; }
            field("Planner Name"; PlannerName) { ApplicationArea = All; }
            field("BLACC Quality Declaration Rq"; Rec."BLACC Quality Declaration Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Quality Declaration is required.';
            }
            field("BLACC Visa Rq"; Rec."BLACC Visa Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Visa is required.';
            }
            field("BLACC Quota Rq"; Rec."BLACC Quota Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Quota is required.';
            }
            field("BLACC SA Rq"; Rec."BLACC SA Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the SA is required.';
            }
            field("BLACC LOA Rq"; Rec."BLACC LOA Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the LOA is required.';
            }
            field("BLACC MA Rq"; Rec."BLACC MA Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the MA is required.';
            }
            field("BLACC Medical Checkup Rq"; Rec."BLACC Medical Checkup Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Medical Checkup is required.';
            }
            field("BLACC Plant Quarantine Rq"; Rec."BLACC Plant Quarantine Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BNNPTNT field.';
            }
            field("BLACC Plant Quar. (BNNPTNT) Rq"; Rec."BLACC Plant Quar. (BNNPTNT) Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Plant Quarantine (BNNPTNT) field.';
            }
            field("BLACC Animal Quarantine Rq"; Rec."BLACC Animal Quarantine Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Animal Quarantine is required.';
            }
            field("BLACC Ani. Quar. (BNNPTNT) Rq"; Rec."BLACC Ani. Quar. (BNNPTNT) Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Animal Quarantine (BNNPTNT) field.';
            }
            field(ManufacturingPolicy; Rec."Manufacturing Policy")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(CopyItem)
        {
            action(BulkDeleteSelectedItems)
            {
                Caption = 'Bulk Delete Selected Items';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Delete;

                trigger OnAction()
                var
                    Item: Record "Item";
                begin
                    Item.Reset();
                    CurrPage.SetSelectionFilter(Item);
                    if Item.FindSet() then
                        Item.DeleteAll(true);
                end;
            }
        }
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ItemDMSInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Check Purchase Name';
                Image = Check;
                Scope = Repeater;
                trigger OnAction()
                var
                    ItemTable: Record Item;
                    JsonObject: JsonObject;
                    JsonText: Text;
                    ItemList: Text;
                    DocName: Text;
                begin
                    ItemTable.Reset();
                    ItemTable.SetRange("Inventory Posting Group", 'A-01');
                    if ItemTable.FindSet() then begin
                        repeat
                            Clear(JsonObject);
                            JsonObject.Add('name', ItemTable."BLACC Purchase Name");
                            JsonText := Format(JsonObject);
                            if StrPos(JsonText, '\') <> 0 then begin
                                if ItemList = '' then begin
                                    ItemList := ItemTable."No.";
                                    DocName := JsonText;
                                end else begin
                                    ItemList += '|' + ItemTable."No.";
                                    DocName += '>>>' + JsonText;
                                end;
                            end;
                        until ItemTable.Next() = 0;
                    end;
                    Message(ItemList + '\' + DocName);
                end;
            }

            action(ItemeInvoiceInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Check Item Name';
                Image = Check;
                Scope = Repeater;
                trigger OnAction()
                var
                    ItemTable: Record Item;
                    JsonObject: JsonObject;
                    JsonText: Text;
                    ItemList: Text;
                    DocName: Text;
                begin
                    ItemTable.Reset();
                    ItemTable.SetFilter("Inventory Posting Group", 'A-01|B-01|C-01');
                    if ItemTable.FindSet() then begin
                        repeat
                            Clear(JsonObject);
                            JsonObject.Add('name', ItemTable."BLTEC Item Name");
                            JsonText := Format(JsonObject);
                            if StrPos(JsonText, '\') <> 0 then begin
                                if ItemList = '' then begin
                                    ItemList := ItemTable."No.";
                                    DocName := JsonText;
                                end else begin
                                    ItemList += '|' + ItemTable."No.";
                                    DocName += '>>>' + JsonText;
                                end;
                            end;
                        until ItemTable.Next() = 0;
                    end;
                    Message(ItemList + '\' + DocName);
                end;
            }
        }
    }

    procedure SyncItem()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";

        OauthenToken: SecretText;
        DMSItem: Record "ACC DMS Item";
        VendTbl: Record Vendor;
        Purchsr: Record "Salesperson/Purchaser";
        IngredientGroup: Record "BLACC Item Ingredient Group";
        JsonObject: JsonObject;
        FieldObject: JsonObject;
        JsonText: Text;
        SPOID: Integer;
        ForInsert: Boolean;
    begin
        if SharepointConnector.Get('ITEMDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        DMSItem.SetRange("Item No.", Rec."No.");
        if DMSItem.FindSet() then begin
            repeat
            until DMSItem.Next() = 0;
        end else begin
            ForInsert := true;
            Clear(DMSItem);
            Clear(JsonObject);
            Clear(FieldObject);
            DMSItem.Init();
            DMSItem."SPO ID" := 1;
            DMSItem."Item No." := Rec."No.";
            DMSItem."Purchase Name" := '[' + Rec."No." + '] ' + Rec."BLACC Purchase Name";
            DMSItem."Sales Name" := '[' + Rec."No." + '] ' + Rec."BLTEC Item Name";
            FieldObject.Add('ItemId', Rec."No.");
            FieldObject.Add('PurchName', '[' + Rec."No." + '] ' + Rec."BLACC Purchase Name");
            FieldObject.Add('SalesName', '[' + Rec."No." + '] ' + Rec."BLTEC Item Name");
            if IngredientGroup.Get(Rec."BLACC Item Ingredient Group") then
                FieldObject.Add('IngredientGroup', IngredientGroup."BLACC Description");
            FieldObject.Add('FactoryId', '');
            if VendTbl.Get(Rec."Vendor No.") then begin
                DMSItem."Vendor No." := VendTbl."No.";
                DMSItem."Vendor Name" := VendTbl.Name;
                FieldObject.Add('VendAccount', VendTbl."No.");
                FieldObject.Add('VendName', VendTbl.Name);
                FieldObject.Add('BuyerGroup', VendTbl."BLACC Vendor Group");
                if Purchsr.Get(VendTbl."BLACC Supplier Mgt. Code") then begin
                    DMSItem."Supplier Management Code" := Purchsr.Code;
                    DMSItem."Supplier Management Name" := Purchsr.Name;
                    DMSItem."Supplier Management Email" := Purchsr."E-Mail";
                    DMSItem."SPO Email No." := Purchsr."SPO Email No.";
                    FieldObject.Add('OwnerLookupId', Purchsr."SPO Email No.");
                end else begin
                    ForInsert := false;
                end;
            end else begin
                ForInsert := false;
            end;
            DMSItem.Onhold := Rec."Purchasing Blocked";
            if ForInsert then begin
                if DMSItem.Insert() then begin
                    JsonObject.Add('fields', FieldObject);
                    JsonText := Format(JsonObject);
                    if Evaluate(SPOID, BCHelper.CreateDMSList(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'bb72ee54-9544-45ea-bc34-ba9a5b32b213', JsonText)) then begin
                        if DMSItem.Get(1) then
                            DMSItem.Rename(SPOID);
                    end;
                end;
            end else begin
                Message(StrSubstNo('Anh chị cập nhật lại thông tin Vendor trên Item và Supplier Management Code trên Vendor.'));
            end;
            ;
        end;
    end;

    procedure GetSelection(): Text
    var
        ItemTable: Record Item;
    begin
        CurrPage.SetSelectionFilter(ItemTable);
        exit(GetSelectionFilterForStatisticsGroup(ItemTable));
    end;

    local procedure GetSelectionFilterForStatisticsGroup(var ItemTable: Record Item): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ItemTable);
        exit(GetSelectionFilter(RecRef, ItemTable.FieldNo("No.")));
    end;

    local procedure GetSelectionFilter(var TempRecRef: RecordRef; SelectionFieldID: Integer): Text
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
    begin
        if TempRecRef.IsTemporary then begin
            RecRef := TempRecRef.Duplicate();
            RecRef.Reset();
        end else
            RecRef.Open(TempRecRef.Number, false, TempRecRef.CurrentCompany);

        TempRecRefCount := TempRecRef.Count();
        if TempRecRefCount > 0 then begin
            TempRecRef.Ascending(true);
            TempRecRef.Find('-');
            while TempRecRefCount > 0 do begin
                TempRecRefCount := TempRecRefCount - 1;
                RecRef.SetPosition(TempRecRef.GetPosition());
                RecRef.Find();
                FieldRef := RecRef.Field(SelectionFieldID);
                FirstRecRef := Format(FieldRef.Value);
                LastRecRef := FirstRecRef;
                More := TempRecRefCount > 0;
                while More do
                    if RecRef.Next() = 0 then
                        More := false
                    else begin
                        SavePos := TempRecRef.GetPosition();
                        TempRecRef.SetPosition(RecRef.GetPosition());
                        if not TempRecRef.Find() then begin
                            More := false;
                            TempRecRef.SetPosition(SavePos);
                        end else begin
                            FieldRef := RecRef.Field(SelectionFieldID);
                            LastRecRef := Format(FieldRef.Value);
                            TempRecRefCount := TempRecRefCount - 1;
                            if TempRecRefCount = 0 then
                                More := false;
                        end;
                    end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstRecRef = LastRecRef then
                    SelectionFilter := SelectionFilter + AddQuotes(FirstRecRef)
                else
                    SelectionFilter := SelectionFilter + AddQuotes(FirstRecRef) + '..' + AddQuotes(LastRecRef);
                if TempRecRefCount > 0 then
                    TempRecRef.Next();
            end;
            exit(SelectionFilter);
        end;
    end;

    local procedure AddQuotes(inString: Text): Text
    begin
        inString := ReplaceString(inString, '''', '''''');
        if DelChr(inString, '=', ' &|()*@<>=.!?') = inString then
            exit(inString);
        exit('''' + inString + '''');
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        while STRPOS(String, FindWhat) > 0 do begin
            NewString := NewString + DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith;
            String := COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        end;
        NewString := NewString + String;
    end;

    trigger OnAfterGetRecord()
    var
        Vend: Record Vendor;
        Planner: Record "Salesperson/Purchaser";
    begin
        if Vend.Get(Rec."Vendor No.") then
            if Planner.Get(Vend."ACC Planner Code") then
                PlannerName := Planner.Name;
    end;

    var
        PlannerName: Text;
}
