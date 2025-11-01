page 51906 "ACC DMS Items"
{
    ApplicationArea = All;
    Caption = 'APIS DMS Items';
    PageType = List;
    SourceTable = "ACC DMS Item";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SPO ID"; Rec."SPO ID")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Purchase Name"; Rec."Purchase Name")
                {
                }
                field("Sales Name"; Rec."Sales Name")
                {
                }
                field("Supplier Management Code"; Rec."Supplier Management Code")
                {
                }
                field("Supplier Management Name"; Rec."Supplier Management Name")
                {
                }
                field("Supplier Management Email"; Rec."Supplier Management Email")
                {
                }
                field("SPO Email No."; Rec."SPO Email No.")
                {
                }
                field("Buyer Group"; Rec."Buyer Group")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(Manufactory; Rec.Manufactory)
                {
                }

                field(Onhold; Rec.Onhold)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload file';
                Image = Import;
                trigger OnAction()
                begin
                    ImportItemCode();
                end;
            }

            action(SyncSPO)
            {
                ApplicationArea = All;
                Caption = 'Sync To SPO';
                Image = Document;
                Scope = Repeater;
                trigger OnAction()
                begin
                    UpdatedSPOList();
                end;
            }
        }
    }

    procedure UpdatedSPOList()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
        DMSItem: Record "ACC DMS Item";
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if SharepointConnector.Get('ITEMDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        DMSItem.SetFilter("SPO Email No.", '>0');
        if DMSItem.FindSet() then begin
            repeat
                Clear(JsonObject);
                JsonObject.Add('ItemId', DMSItem."Item No.");
                JsonObject.Add('PurchName', DMSItem."Purchase Name");
                JsonObject.Add('SalesName', DMSItem."Sales Name");
                JsonObject.Add('IngredientGroup', DMSItem."Ingredient Group");
                JsonObject.Add('VendAccount', DMSItem."Vendor No.");
                JsonObject.Add('VendName', DMSItem."Vendor Name");
                JsonObject.Add('BuyerGroup', DMSItem."Buyer Group");
                JsonObject.Add('OwnerLookupId', DMSItem."SPO Email No.");
                JsonText := Format(JsonObject);
                if (DMSItem."Item No." <> '') AND (DMSItem."Vendor No." <> '') then
                    BCHelper.UpdateDMSList(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'bb72ee54-9544-45ea-bc34-ba9a5b32b213', JsonText, DMSItem."SPO ID");
            until DMSItem.Next() = 0;
        end;
    end;

    procedure ImportItemCode()
    var
        Item: Record Item;
        Vend: Record Vendor;
        Purchaser: Record "Salesperson/Purchaser";
        IngredientGroup: Record "BLACC Item Ingredient Group";
        DMSItem: Record "ACC DMS Item";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        SPOID: Integer;
        ItemNo: Text;
        ManufactoryCode: Text;

        FileName: Text;
        SheetName: Text;
        Instream: InStream;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            // Ask the user to select the Excel file
            TmpExcelBuffer.Reset();
            TmpExcelBuffer.DeleteAll();
            // Load Excel contents into Excel Buffer
            SheetName := TmpExcelBuffer.SelectSheetsNameStream(InStream);
            TmpExcelBuffer.OpenBookStream(InStream, SheetName);
            TmpExcelBuffer.ReadSheet(); // Clear previous data

            // Now process the Excel rows
            //TmpExcelBuffer.Reset();
            TmpExcelBuffer.SetFilter("Row No.", '>1');
            if TmpExcelBuffer.FindSet() then
                repeat
                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, SPOID);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, ItemNo);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ManufactoryCode);
                    if Item.Get(ItemNo) then begin
                        Clear(DMSItem);
                        DMSItem.Init();
                        DMSItem."SPO ID" := SPOID;
                        DMSItem."Item No." := ItemNo;
                        DMSItem."Purchase Name" := '[' + ItemNo + '] ' + Item."BLACC Purchase Name";
                        DMSItem."Sales Name" := '[' + ItemNo + '] ' + Item."BLTEC Item Name";
                        if IngredientGroup.Get(Item."BLACC Item Ingredient Group") then
                            DMSItem."Ingredient Group" := IngredientGroup."BLACC Description";
                        if Vend.Get(Item."Vendor No.") then begin
                            DMSItem."Vendor No." := Vend."No.";
                            DMSItem."Vendor Name" := Vend.Name;
                            DMSItem."Buyer Group" := Vend."BLACC Vendor Group";
                            if Purchaser.Get(Vend."BLACC Supplier Mgt. Code") then begin
                                DMSItem."Supplier Management Code" := Purchaser.Code;
                                DMSItem."Supplier Management Name" := Purchaser.Name;
                                DMSItem."Supplier Management Email" := Purchaser."E-Mail";
                                DMSItem."SPO Email No." := Purchaser."SPO Email No.";
                            end;
                        end;
                        DMSItem.Onhold := Item."Purchasing Blocked";
                        DMSItem.Insert();
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure GetCellValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Text): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            Value := TempExcelBuffer."Cell Value as Text";
            exit(Value <> '');
        end;
        exit(false);
    end;

    local procedure GetIntegerValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Integer): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            IF EVALUATE(Value, TempExcelBuffer."Cell Value as Text") then
                exit(Value <> 0);
        end;
        exit(false);
    end;
}