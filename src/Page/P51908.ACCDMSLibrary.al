page 51908 "ACC DMS Library"
{
    ApplicationArea = All;
    Caption = 'ACC DMS Library';
    PageType = List;
    SourceTable = "ACC DMS Library";
    UsageCategory = Lists;
    SourceTableView = sorting("SPO No") order(descending);
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SPO No"; Rec."SPO No") { }
                field("Content Type"; Rec."Content Type") { }
                field("File Name"; Rec."File Name") { }
                field("Original File Name"; Rec."Original File Name") { }
                field("Vendor Code"; Rec."Vendor Code") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Vendor Group"; Rec."Vendor Group") { }
                field("Supplier Management Code"; Rec."Supplier Management Code") { }
                field("Supplier Management Name"; Rec."Supplier Management Name") { }
                field("Item Code"; Rec."Item Code") { }
                field("Item Name"; Rec."Item Name") { }
                field("ECUS Name"; Rec."ECUS Name") { }
                field(Description; Rec.Description) { }
                field("Effective Date"; Rec."Effective Date") { }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExprTxt;
                }
                field("DMS ISO Type"; Rec."DMS ISO Type") { }
                field("DMS Report Type"; Rec."DMS Report Type") { }
                field("DMS Statement Type"; Rec."DMS Statement Type") { }
                field(Note; Rec.Note) { }
                field("Out Date"; Rec."Out Date") { }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { }
                field(SystemModifiedAt; Rec.SystemModifiedAt) { }
                field("File No"; Rec."File No") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewInRepeater)
            {
                ApplicationArea = All;
                Caption = 'View';
                Image = View;
                Scope = Repeater;
                ToolTip = 'Download the file to your device. Depending on the file, you will need an app to view or edit the file.';

                trigger OnAction()
                begin
                    Hyperlink(Rec.URL);
                end;
            }
            action(DownloadInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                Scope = Repeater;
                ToolTip = 'Download the file to your device. Depending on the file, you will need an app to view or edit the file.';

                trigger OnAction()
                begin
                    DownloadFile();
                end;
            }
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload A File';
                Image = Import;
                trigger OnAction()
                begin
                    UploadFileDialog();
                end;
            }
            action(UploadExcelTemplate)
            {
                ApplicationArea = All;
                Caption = 'Upload File Template';
                Image = Import;
                trigger OnAction()
                begin
                    UploadTemplateDialog();
                end;
            }
            action(RenameInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Rename File';
                Image = Change;
                Scope = Repeater;
                trigger OnAction()
                var
                    BCHelper: Codeunit "BC Helper";
                    SharepointConnector: Record "AIG Sharepoint Connector";
                    DestinLine: Record "AIG Sharepoint Connector Line";
                    OauthenToken: SecretText;

                    Field: Record "ACC DMS Library";
                    DMSLibrary: Record "ACC DMS Library";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    FileManagment: Codeunit "File Management";
                    RecRef: RecordRef;

                    DocumentName: Text;
                    PurchName: Text;
                    FileLength: Integer;
                    FileExtension: Text;
                    URL: Text;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    URL := 'https://asiachemicalcom.sharepoint.com/sites/DMS/Document System Metadata/SPM/';
                    if SharepointConnector.Get('DMSDOC') then begin
                        OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
                    end;
                    if not DestinLine.Get('DMSDOC', 1) then begin
                        exit;
                    end;
                    DMSLibrary.Reset();
                    DMSLibrary.SetCurrentKey("SPO No");
                    DMSLibrary.SetFilter("SPO No", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("SPO No")));
                    DMSLibrary.SetAutoCalcFields("Item Name", "Vendor Group");
                    if DMSLibrary.FindSet() then begin
                        repeat
                            FileExtension := FileManagment.GetExtension(DMSLibrary."File Name");
                            FileLength := StrLen(Format(DMSLibrary."Content Type")) + StrLen(DMSLibrary."Vendor Group") + StrLen(Format(DMSLibrary."SPO No")) + StrLen(FileExtension);
                            PurchName := StrReplaceSpec(DMSLibrary."Item Name");
                            if StrLen(PurchName) > (318 - FileLength) then
                                PurchName := PurchName.Substring(1, 318 - FileLength);
                            if DMSLibrary."Item Code" <> '' then begin
                                DocumentName := StrSubstNo('%1_%2_%3_%4.%5', DMSLibrary."Content Type", DMSLibrary."Vendor Group", PurchName, DMSLibrary."SPO No", FileExtension);
                            end else begin
                                DocumentName := StrSubstNo('%1_%2_%3.%4', DMSLibrary."Content Type", DMSLibrary."Vendor Group", DMSLibrary."SPO No", FileExtension);
                            end;
                            if DocumentName <> DMSLibrary."File Name" then begin
                                DMSLibrary."Document Name" := DocumentName;
                                DMSLibrary."File Name" := DocumentName;
                                DMSLibrary.URL := URL + DocumentName;
                                DMSLibrary.Modify();
                            end;
                            UpdateFileName(OauthenToken, DocumentName, DestinLine."Site ID", DestinLine."Drive ID", DMSLibrary."File No");
                            if DMSLibrary."SPO Email No." <> 0 then begin
                                UpdateMetadata(OauthenToken, BuildLibraryMeta(DMSLibrary), DestinLine."Site ID", DestinLine."Drive ID", DMSLibrary."File No");

                                UpdateContentType(OauthenToken, GetContentTypeId(DMSLibrary."Content Type"), DestinLine."Site ID", DestinLine."Drive ID", DMSLibrary."File No");

                                UpdateDMSItem(OauthenToken, DMSLibrary);
                            end;
                        until DMSLibrary.Next() = 0;
                    end;
                end;
            }

            action(SupplierManagementInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Change Supplier Management';
                Image = Change;
                Scope = Repeater;
                trigger OnAction()
                var
                    BCHelper: Codeunit "BC Helper";
                    SharepointConnector: Record "AIG Sharepoint Connector";
                    DestinLine: Record "AIG Sharepoint Connector Line";
                    OauthenToken: SecretText;

                    Field: Record "ACC DMS Library";
                    DMSLibrary: Record "ACC DMS Library";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    FileManagment: Codeunit "File Management";
                    RecRef: RecordRef;

                    FieldObject: JsonObject;
                    JsonText: Text;
                begin
                    CurrPage.SetSelectionFilter(Field);
                    RecRef.GetTable(Field);
                    if SharepointConnector.Get('DMSDOC') then begin
                        OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
                    end;
                    if not DestinLine.Get('DMSDOC', 1) then begin
                        exit;
                    end;
                    DMSLibrary.Reset();
                    DMSLibrary.SetCurrentKey("SPO No");
                    DMSLibrary.SetFilter("SPO No", SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("SPO No")));
                    if DMSLibrary.FindSet() then begin
                        repeat
                            if DMSLibrary."SPO Email No." <> 0 then begin
                                Clear(FieldObject);
                                FieldObject.Add('OwnerLookupId', DMSLibrary."SPO Email No.");
                                JsonText := Format(FieldObject);
                                UpdateMetadata(OauthenToken, JsonText, DestinLine."Site ID", DestinLine."Drive ID", DMSLibrary."File No");
                                UpdateDMSItemSupplierManagement(OauthenToken, DMSLibrary, JsonText);
                            end;
                        until DMSLibrary.Next() = 0;
                    end;
                end;
            }

            action(ItemDMSInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Item DMS';
                Image = Change;
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
                Caption = 'Item eInvoice';
                Image = Change;
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
    local procedure UploadTemplateDialog()
    var
        VendTbl: Record Vendor;
        ItemTbl: Record Item;
        Purchaser: Record "Salesperson/Purchaser";

        SharepointConnector: Record "AIG Sharepoint Connector";
        SourceLine: Record "AIG Sharepoint Connector Line";
        DestinLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;

        DMSLibrary: Record "ACC DMS Library";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        FileManagment: Codeunit "File Management";
        BCHelper: Codeunit "BC Helper";
        UploadName: Text;
        SheetName: Text;
        Instream: InStream;
        FileInstr: InStream;

        UploadMsg: Label 'Please choose the file...';

        FileId: Text;
        JsonObject: JsonObject;
        ContentObject: JsonObject;
        FieldObject: JsonObject;
        JsonText: Text;
        MimeType: Text;

        ContentType: Text;
        ContentTypeId: Text;
        OrigFileName: Text;
        DestFileName: Text;
        DocumentName: Text;
        EffectiveDate: Text;
        ExpirationDate: Text;
        VendCode: Text;
        Description: Text;
        ItemCode: Text;
        FactoryId: Text;
        ISOType: Text;
        Statement: Text;
        ReportType: Text;
        Notes: Text;
        SPOPath: Text;

        URL: Text;
        SPOID: Integer;
        PurchName: Text;
        FileLength: Integer;
        FileExtension: Text;

        DMSEffectiveDate: Date;
        DMSExpirationDate: Date;
        DMSContentType: Enum "ACC DOC Content Type";
        Infolog: Text;
        MsgDocName: Text;
        DocNameTxt: Text;
    begin
        MsgDocName := '';
        URL := 'https://asiachemicalcom.sharepoint.com/sites/DMS/Document System Metadata/SPM/';
        if UploadIntoStream(UploadMsg, '', '', UploadName, Instream) then begin
            if SharepointConnector.Get('DMSDOC') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not DestinLine.Get('DMSDOC', 1) then begin
                exit;
            end;
            if not SourceLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
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
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ContentType);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, ContentTypeId);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, OrigFileName);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, DestFileName);
                    EffectiveDate := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, EffectiveDate);
                    ExpirationDate := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, ExpirationDate);
                    VendCode := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 7, VendCode);
                    Description := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 8, Description);
                    ItemCode := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 9, ItemCode);
                    FactoryId := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 10, FactoryId);
                    ISOType := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, ISOType);
                    Statement := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, Statement);
                    ReportType := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 13, ReportType);
                    Notes := '';
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 14, Notes);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 15, SPOPath);

                    DownloadFromSharePoint(OauthenToken, SourceLine."Site ID", SourceLine."Drive ID", SPOPath + OrigFileName, FileInstr);
                    if FileInstr.Length > 0 then begin
                        MimeType := FileManagment.GetFileNameMimeType(OrigFileName);
                        FileId := BCHelper.UploadFilesToSharePoint(DestinLine, OauthenToken, 'SPM', FileInstr, 'I' + Format(TmpExcelBuffer."Row No.") + DestFileName, ExistMimeType(OrigFileName, MimeType));
                    end;
                    if FileId <> '' then begin
                        SPOID := GetSPOMetaID(OauthenToken, FileId);
                        Evaluate(DMSEffectiveDate, EffectiveDate);
                        Evaluate(DMSExpirationDate, ExpirationDate);
                        Evaluate(DMSContentType, ContentType);
                        if InsertDMSLibrary(DMSLibrary, FileId, SPOID, DestFileName, OrigFileName, Description, URL, DMSEffectiveDate, DMSExpirationDate, ISOType, Statement, ReportType, Notes, DMSContentType, ItemCode, VendCode) then begin
                            DMSLibrary.CalcFields("Item Name", "Vendor Group");
                            FileExtension := FileManagment.GetExtension(OrigFileName);
                            FileLength := StrLen(Format(DMSLibrary."Content Type")) + StrLen(DMSLibrary."Vendor Group") + StrLen(Format(DMSLibrary."SPO No")) + StrLen(FileExtension);
                            PurchName := StrReplaceSpec(DMSLibrary."Item Name");
                            if StrLen(PurchName) > (318 - FileLength) then
                                PurchName := PurchName.Substring(1, 318 - FileLength);
                            if DMSLibrary."Item Code" <> '' then begin
                                DocumentName := StrSubstNo('%1_%2_%3_%4.%5', DMSLibrary."Content Type", DMSLibrary."Vendor Group", PurchName, DMSLibrary."SPO No", FileExtension);
                            end else begin
                                DocumentName := StrSubstNo('%1_%2_%3.%4', DMSLibrary."Content Type", DMSLibrary."Vendor Group", DMSLibrary."SPO No", FileExtension);
                            end;
                            if DocumentName <> DMSLibrary."File Name" then begin
                                DMSLibrary."Document Name" := DocumentName;
                                DMSLibrary."File Name" := DocumentName;
                                DMSLibrary.URL := URL + DocumentName;
                                DMSLibrary.Modify();
                                DocNameTxt := ChkDocName(DocumentName);
                                if DocNameTxt = '' then begin
                                    UpdateFileName(OauthenToken, DocumentName, DestinLine."Site ID", DestinLine."Drive ID", DMSLibrary."File No");
                                end else begin
                                    if MsgDocName = '' then begin
                                        MsgDocName := Rec."Item Code" + ' >>> ' + DocNameTxt + ' >>> Yêu cầu kiểm tra Purchase Name';
                                    end else begin
                                        MsgDocName += '\' + Rec."Item Code" + ' >>> ' + DocNameTxt + ' >>> Yêu cầu kiểm tra Purchase Name';
                                    end;
                                end;
                            end;

                            UpdateMetadata(OauthenToken, BuildLibraryMeta(DMSLibrary), DestinLine."Site ID", DestinLine."Drive ID", FileId);

                            UpdateContentType(OauthenToken, GetContentTypeId(DMSContentType), DestinLine."Site ID", DestinLine."Drive ID", FileId);

                            UpdateDMSItem(OauthenToken, DMSLibrary);

                            if Infolog = '' then begin
                                Infolog := StrSubstNo('File %1 tải lên thành công.', DestFileName);
                            end else begin
                                Infolog := Infolog + '\' + StrSubstNo('File %1 tải lên thành công', DestFileName);
                            end;
                        end else begin
                            if Infolog = '' then begin
                                Infolog := StrSubstNo('Mã hàng %1 hoặc mã nhà cung %2 không tồn tại.', ItemCode, VendCode);
                            end else begin
                                Infolog += '\' + StrSubstNo('Mã hàng %1 hoặc mã nhà cung %2 không tồn tại.', ItemCode, VendCode);
                            end;
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
        if MsgDocName <> '' then
            Infolog += MsgDocName;
        Message(Infolog);
    end;

    local procedure UploadFileDialog()
    var
        Item: Record Item;
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;

        DMSLibrary: Record "ACC DMS Library";
        FileManagment: Codeunit "File Management";
        BCHelper: Codeunit "BC Helper";

        FileInstr: InStream;
        FileName: Text[250];
        UploadMsg: Label 'Please choose the file...';
        Msg: Label 'Upload file name: %1 successful.';
        FileId: Text;
        JsonObject: JsonObject;
        FieldObject: JsonObject;
        JsonText: Text;

        DocumentName: Text;
        PurchName: Text;
        FileLength: Integer;
        FileExtension: Text;
        URL: Text;
        SPOID: Integer;
        MsgDocName: Text;
        DocNameTxt: Text;
    begin
        MsgDocName := '';
        if Rec."SPO No" > 250 then begin
            Message(StrSubstNo('Anh chị chọn lại dòng upload file nhé'));
            exit;
        end;
        URL := 'https://asiachemicalcom.sharepoint.com/sites/DMS/Document System Metadata/SPM/';
        if Rec."File Name" = '' then begin
            if UploadIntoStream(UploadMsg, '', '', FileName, FileInstr) then begin
                if SharepointConnector.Get('DMSDOC') then begin
                    OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
                end;
                if not SharepointConnectorLine.Get('DMSDOC', 1) then begin
                    exit;
                end;

                FileId := BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OauthenToken, 'SPM', FileInstr, FileName, FileManagment.GetFileNameMimeType(FileName));
                if FileId <> '' then begin
                    SPOID := GetSPOMetaID(OauthenToken, FileId);
                    Rec.CalcFields("Vendor Name", "Vendor Group", "Item Name", "Item Ingredient Group");
                    FileExtension := FileManagment.GetExtension(FileName);
                    FileLength := StrLen(Format(Rec."Content Type")) + StrLen(Rec."Vendor Group") + StrLen(Format(SPOID)) + StrLen(FileExtension);
                    PurchName := StrReplaceSpec(Rec."Item Name");
                    if StrLen(PurchName) > (318 - FileLength) then
                        PurchName := PurchName.Substring(1, 318 - FileLength);
                    if Rec."Item Code" <> '' then begin
                        DocumentName := StrSubstNo('%1_%2_%3_%4.%5', Rec."Content Type", Rec."Vendor Group", PurchName, SPOID, FileExtension);
                    end else begin
                        DocumentName := StrSubstNo('%1_%2_%3.%4', Rec."Content Type", Rec."Vendor Group", SPOID, FileExtension);
                    end;
                    if DocumentName <> Rec."File Name" then begin
                        Rec."Document Name" := DocumentName;
                        Rec."File Name" := DocumentName;
                        Rec.URL := URL + DocumentName;
                        Rec."File No" := FileId;
                        Rec."Original File Name" := FileName;
                        Rec.Modify();
                        if Rec."SPO No" <> SPOID then
                            Rec.Rename(SPOID);
                        DocNameTxt := ChkDocName(DocumentName);
                        if DocNameTxt = '' then begin
                            UpdateFileName(OauthenToken, DocumentName, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No");
                        end else begin
                            MsgDocName := Rec."Item Code" + ' >>> ' + DocNameTxt + ' >>> \ ký tự ẩn';
                        end;
                        UpdateMetadata(OauthenToken, BuildLibraryMeta(Rec), SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);

                        UpdateContentType(OauthenToken, GetContentTypeId(Rec."Content Type"), SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", FileId);

                        UpdateDMSItem(OauthenToken, Rec);
                    end;
                end;
            end;
        end else begin
            Message(StrSubstNo('File %1 exists.', FileName));
        end;
        if MsgDocName <> '' then
            Message(MsgDocName);
    end;

    local procedure StrReplaceSpec(SourceTxt: Text): Text
    var
        DestinationTxt: Text;
    begin
        if SourceTxt = '' then
            exit('');
        DestinationTxt := SourceTxt.Replace('/', '-');
        DestinationTxt := DestinationTxt.Replace('\', '');
        DestinationTxt := DestinationTxt.Replace('|', '');
        DestinationTxt := DestinationTxt.Replace('.', ',');
        DestinationTxt := DestinationTxt.Replace('?', '');
        DestinationTxt := DestinationTxt.Replace('*', '');
        DestinationTxt := DestinationTxt.Replace('"', '');
        DestinationTxt := DestinationTxt.Replace(':', '');
        DestinationTxt := DestinationTxt.Replace('<', '');
        DestinationTxt := DestinationTxt.Replace('>', '');
        DestinationTxt := DestinationTxt.Replace('#', '-');
        DestinationTxt := DestinationTxt.Replace('"', '');
        DestinationTxt := DestinationTxt.Replace('%', 'percent');
        exit(DestinationTxt);
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

    local procedure GetContentTypeId(ContentType: Enum "ACC DOC Content Type"): Text
    var
    begin
        case ContentType of
            "ACC DOC Content Type"::Defaults:
                exit('0x010100FFE19FDCDD0A794F94CF3DD5E72EDA53');
            "ACC DOC Content Type"::"Bank Information":
                exit('0x0101009EA47B5F4D9C0F4A97598739D3EA7CED');
            "ACC DOC Content Type"::BRC:
                exit('0x01010016AE09AE72A32247A24489572CAA796C');
            "ACC DOC Content Type"::"Business Licence":
                exit('0x010100FA501438680ADB4B92F709C3E33E874D');
            "ACC DOC Content Type"::"Business Review":
                exit('0x01010085B035AD5DEF3F4CA71216EC201F3D71');
            "ACC DOC Content Type"::"Clinical Study":
                exit('0x010100B8B68308A2540048A739CD4DD36A1322');
            "ACC DOC Content Type"::"Composition List Ingredient List":
                exit('0x0101008AD9F4C6B9031D40AE00B1378E8DA543');
            "ACC DOC Content Type"::"Distributor Agreement":
                exit('0x0101002A0A225018ADEC40A66E87376D5EC399');
            "ACC DOC Content Type"::"Dossier - Product Information Package":
                exit('0x01010020C860B52274824A956385B44296252D');
            "ACC DOC Content Type"::"Flowchart with CCP":
                exit('0x01010066BA4ECE0DFD7248A89B930319950726');
            "ACC DOC Content Type"::FSSC:
                exit('0x0101009C4EAD57C86CB1448A0C1E977E970B98');
            "ACC DOC Content Type"::"GMO cert IP cert":
                exit('0x0101008ECF3A6A10832344841D40A67D4159C1');
            "ACC DOC Content Type"::GMP:
                exit('0x010100D897441BC2B0B8459E7FF844C3F16A1B');
            "ACC DOC Content Type"::HACCP:
                exit('0x01010016C8E481352A924F85F8D0A677BF1BC1');
            "ACC DOC Content Type"::HALAL:
                exit('0x010100820977CFCAC2AF4493EB78B154458557');
            "ACC DOC Content Type"::ISO:
                exit('0x01010020E9C5628F75F543BB8FFDE8BB8BDE14');
            "ACC DOC Content Type"::KOSHER:
                exit('0x0101001B4C524D26816D43B145C20403E9810E');
            "ACC DOC Content Type"::Label:
                exit('0x010100C0AB2AE88F6255448154C8934219875B');
            "ACC DOC Content Type"::"Method of analysis (MoA)":
                exit('0x01010012249764F45A9B4E8E121E3F5DE8BF7E');
            "ACC DOC Content Type"::"MSDS-SDS":
                exit('0x010100D6D04891C43A2B42AC5CE87FF2BBEE57');
            "ACC DOC Content Type"::Packaging:
                exit('0x010100FD7F18B6DB77024B8BE3F55451939022');
            "ACC DOC Content Type"::"Plant information":
                exit('0x01010024AF788E398BE642810DF43834F49454');
            "ACC DOC Content Type"::"Product Check List":
                exit('0x0101003368FD37F3C9594BB711061294DD9B65');
            "ACC DOC Content Type"::Specifications:
                exit('0x01010043952AAF407E9048B3293256D0B3112C');
            "ACC DOC Content Type"::SQF:
                exit('0x010100BB6F9A96D2169144841B5A62C6A445EB');
            "ACC DOC Content Type"::Statement:
                exit('0x010100D95EC872353B62429C7995AA49606B92');
            "ACC DOC Content Type"::"Suppier Presentation":
                exit('0x0101002AF08F090790B44AA9A01F076B932017');
            "ACC DOC Content Type"::"Supplier Application":
                exit('0x010100B5C89205001B1647A45EC1BBF9B14BB8');
            "ACC DOC Content Type"::"Test report (Supplier)":
                exit('0x010100DA3D9A66DA52C24B8C5A2AFE42EC4EA7');
            "ACC DOC Content Type"::Vendor:
                exit('0x0101005B1326144B9D8C42AE95085FBA927F49');
            "ACC DOC Content Type"::"ORGANIC CERT":
                exit('0x010100DBE48CCD0B3592418345C436FD2161E1');
            "ACC DOC Content Type"::IFS:
                exit('0x0101002EC01A1E521B9F46B902071664B860E7');
            "ACC DOC Content Type"::RSPO:
                exit('0x01010099E942586740004C9BA60BCE7DB1CD55');
        end;
    end;

    local procedure GetFileSPOID(OauthToken: SecretText; FileUrl: Text; FileName: Text): Text
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;
    begin
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/root:/SPM/%3', '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn90V6QIz1SSSL9gtBSX-P3u', FileName);
        // Initialize the HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        //RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;
        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging            
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                if JsonResponse.Get('id', JsonToken) then begin
                    if not JsonToken.AsValue().IsNull then begin
                        exit(JsonToken.AsValue().AsText());
                    end;
                end;
            end else begin
                exit('');
            end;
        end else
            exit('');
        exit('');
    end;

    local procedure GetSPOMetaID(OauthToken: SecretText; FileNo: Text): Integer
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        JsonItemResponse: JsonObject;
        JsonItemToken: JsonToken;

        SharePointFileUrl: Text;
        ResponseText: Text;
    begin
        SharePointFileUrl := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3?expand=listItem', '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn90V6QIz1SSSL9gtBSX-P3u', FileNo);
        // Initialize the HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        //RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;
        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging            
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                if JsonResponse.Get('listItem', JsonToken) then begin
                    JsonItemResponse := JsonToken.AsObject();
                    if JsonItemResponse.Get('id', JsonItemToken) then begin
                        if not JsonItemToken.AsValue().IsNull then begin
                            exit(JsonItemToken.AsValue().AsInteger());
                        end;
                    end;
                end;
            end else begin
                exit(0);
            end;
        end else
            exit(0);
        exit(0);
    end;

    local procedure DownloadFile()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('DMSDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;

        if Rec."File No" <> '' then
            BCHelper.SPODownloadFile(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'b!NnljHTvOtEKgc-R9W-kISPvkv83RYX5LgUzdK-WNrn90V6QIz1SSSL9gtBSX-P3u', Rec."File No", Rec."File Name");
    end;

    local procedure DownloadFromSharePoint(OauthToken: SecretText; SiteId: Text; DriverId: Text; RootURL: Text; var FileContent: InStream)
    var

        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;
        Headers: HttpHeaders;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/root:/%3:/content', SiteId, DriverId, RootURL);
        // Prepare HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        // Send the request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode then begin
                HttpResponseMessage.Content.ReadAs(FileContent);
            end;
        end;
    end;

    local procedure UpdateContentType(OauthToken: SecretText; ContentType: Text; SiteId: Text; DriveId: Text; FileId: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;

        Headers: HttpHeaders;
        JsonObject: JsonObject;
        FieldObject: JsonObject;
        JsonText: Text;
    //AccessToken: Text;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3/listItem', SiteId, DriveId, FileId);
        // Prepare HTTP request
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        Clear(JsonObject);
        Clear(FieldObject);
        FieldObject.Add('id', ContentType);
        JsonObject.Add('contentType', FieldObject);
        JsonText := Format(JsonObject);
        // Add JSON content        
        RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(RequestContentHeaders);
        RequestContentHeaders.Clear();
        RequestContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Graph API');
    end;

    local procedure UpdateMetadata(OauthToken: SecretText; JsonText: Text; SiteId: Text; DriveId: Text; FileId: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;

        Headers: HttpHeaders;
    //AccessToken: Text;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3/listItem/fields', SiteId, DriveId, FileId);
        // Prepare HTTP request
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(RequestContentHeaders);
        RequestContentHeaders.Clear();
        RequestContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Graph API');
    end;

    local procedure UpdateFileName(OauthToken: SecretText; DocumentName: Text; SiteId: Text; DriveId: Text; FileId: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        RequestContent: HttpContent;
        RequestContentHeaders: HttpHeaders;
        Url: Text;

        Headers: HttpHeaders;
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        // Build the SharePoint REST API URL
        Url := StrSubstNo('https://graph.microsoft.com/v1.0/sites/%1/drives/%2/items/%3', SiteId, DriveId, FileId);
        // Prepare HTTP request
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));

        // Add JSON content        
        Clear(JsonObject);
        JsonObject.Add('name', DocumentName);
        JsonText := Format(JsonObject);

        RequestContent.WriteFrom(JsonText);
        RequestContent.GetHeaders(RequestContentHeaders);
        RequestContentHeaders.Clear();
        RequestContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content := RequestContent;

        // Send the request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Graph API');
    end;

    local procedure UpdateDMSItem(OauthenToken: SecretText; DMSDocLibrary: Record "ACC DMS Library")
    var
        BCHelper: Codeunit "BC Helper";

        ItemTbl: Record Item;
        DMSItem: Record "ACC DMS Item";
        VendTbl: Record Vendor;
        Purchsr: Record "Salesperson/Purchaser";
        IngredientGroup: Record "BLACC Item Ingredient Group";
        JsonObject: JsonObject;
        FieldObject: JsonObject;
        JsonText: Text;
        SPOID: Integer;
        ForExecute: Boolean;
        SalesName: Text;
        PurchName: Text;
    begin
        DMSItem.SetRange("Item No.", DMSDocLibrary."Item Code");
        DMSItem.SetRange("Vendor No.", DMSDocLibrary."Vendor Code");
        if DMSItem.FindSet() then begin
            repeat
                ForExecute := false;
                if ItemTbl.Get(DMSDocLibrary."Item Code") then begin
                    Clear(FieldObject);
                    //FieldObject.Add('FactoryId', DMSItem.Manufactory);
                    PurchName := '[' + ItemTbl."No." + '] ' + ItemTbl."BLACC Purchase Name";
                    SalesName := '[' + ItemTbl."No." + '] ' + ItemTbl."BLTEC Item Name";
                    if DMSItem."Purchase Name" <> PurchName then begin
                        DMSItem."Purchase Name" := PurchName;
                        FieldObject.Add('PurchName', PurchName);
                        ForExecute := true;
                    end;
                    if DMSItem."Sales Name" <> SalesName then begin
                        DMSItem."Sales Name" := SalesName;
                        FieldObject.Add('SalesName', SalesName);
                        ForExecute := true;
                    end;

                    if IngredientGroup.Get(ItemTbl."BLACC Item Ingredient Group") then begin
                        if DMSItem."Ingredient Group" <> IngredientGroup."BLACC Description" then begin
                            DMSItem."Ingredient Group" := IngredientGroup."BLACC Description";
                            FieldObject.Add('IngredientGroup', IngredientGroup."BLACC Description");
                            ForExecute := true;
                        end;
                    end;
                    if VendTbl.Get(DMSDocLibrary."Vendor Code") then begin
                        if DMSItem."Vendor Name" <> VendTbl.Name then begin
                            DMSItem."Vendor Name" := VendTbl.Name;
                            FieldObject.Add('VendName', VendTbl.Name);
                            FieldObject.Add('BuyerGroup', VendTbl."BLACC Vendor Group");
                            ForExecute := true;
                        end;
                        if Purchsr.Get(VendTbl."BLACC Supplier Mgt. Code") then begin
                            if DMSItem."Supplier Management Code" <> Purchsr.Code then begin
                                DMSItem."Supplier Management Code" := Purchsr.Code;
                                DMSItem."Supplier Management Name" := Purchsr.Name;
                                DMSItem."Supplier Management Email" := Purchsr."E-Mail";
                                DMSItem."SPO Email No." := Purchsr."SPO Email No.";
                                FieldObject.Add('OwnerLookupId', Purchsr."SPO Email No.");
                                ForExecute := true;
                            end;
                        end else begin
                            ForExecute := false;
                        end;
                    end else begin
                        ForExecute := false;
                    end;
                    // Kiểm tra sau khi chạy thời gian.
                    if DMSItem.Onhold <> ItemTbl."Purchasing Blocked" then begin
                        DMSItem.Onhold := ItemTbl."Purchasing Blocked";
                    end;
                    if ForExecute then begin
                        if DMSItem.Modify() then begin
                            JsonText := Format(FieldObject);
                            if Evaluate(SPOID, BCHelper.UpdateDMSList(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'bb72ee54-9544-45ea-bc34-ba9a5b32b213', JsonText, DMSItem."SPO ID")) then begin
                            end;
                        end;
                    end
                end;
            until DMSItem.Next() = 0;
        end else begin
            ForExecute := true;
            if ItemTbl.Get(DMSDocLibrary."Item Code") then begin
                Clear(DMSItem);
                Clear(JsonObject);
                Clear(FieldObject);
                DMSItem.Init();
                DMSItem."SPO ID" := 1;
                DMSItem."Item No." := ItemTbl."No.";
                DMSItem."Purchase Name" := '[' + ItemTbl."No." + '] ' + ItemTbl."BLACC Purchase Name";
                DMSItem."Sales Name" := '[' + ItemTbl."No." + '] ' + ItemTbl."BLTEC Item Name";
                FieldObject.Add('ItemId', ItemTbl."No.");
                FieldObject.Add('PurchName', '[' + ItemTbl."No." + '] ' + ItemTbl."BLACC Purchase Name");
                FieldObject.Add('SalesName', '[' + ItemTbl."No." + '] ' + ItemTbl."BLTEC Item Name");
                if IngredientGroup.Get(ItemTbl."BLACC Item Ingredient Group") then
                    FieldObject.Add('IngredientGroup', IngredientGroup."BLACC Description");
                //FieldObject.Add('FactoryId', '');
                if VendTbl.Get(DMSDocLibrary."Vendor Code") then begin
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
                        ForExecute := false;
                    end;
                end else begin
                    ForExecute := false;
                end;
                DMSItem.Onhold := ItemTbl."Purchasing Blocked";
                if ForExecute then begin
                    if DMSItem.Insert() then begin
                        JsonObject.Add('fields', FieldObject);
                        JsonText := Format(JsonObject);
                        if Evaluate(SPOID, BCHelper.CreateDMSList(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'bb72ee54-9544-45ea-bc34-ba9a5b32b213', JsonText)) then begin
                            if DMSItem.Get(1) then
                                DMSItem.Rename(SPOID);
                        end else begin
                            DMSItem.Delete();
                        end;
                    end;
                end
            end;
        end;
    end;

    local procedure UpdateDMSItemSupplierManagement(OauthenToken: SecretText; DMSDocLibrary: Record "ACC DMS Library"; JsonText: Text)
    var
        BCHelper: Codeunit "BC Helper";
        DMSItem: Record "ACC DMS Item";
        SPOID: Integer;
    begin
        DMSItem.SetRange("Item No.", DMSDocLibrary."Item Code");
        DMSItem.SetRange("Vendor No.", DMSDocLibrary."Vendor Code");
        if DMSItem.FindSet() then begin
            repeat
                if Evaluate(SPOID, BCHelper.UpdateDMSList(OauthenToken, '1d637936-ce3b-42b4-a073-e47d5be90848', 'bb72ee54-9544-45ea-bc34-ba9a5b32b213', JsonText, DMSItem."SPO ID")) then begin
                end;
            until DMSItem.Next() = 0;
        end;
    end;

    local procedure InsertDMSLibrary(var DMSLibrary: Record "ACC DMS Library";
                                     FileId: Text;
                                     SPOID: Integer;
                                     DestFileName: Text;
                                     OrigFileName: Text;
                                     Description: Text;
                                     URL: Text;
                                     EffectiveDate: Date;
                                     ExpirationDate: Date;
                                     ISOType: Text;
                                     Statement: Text;
                                     ReportType: Text;
                                     Notes: Text;
                                     ContentType: Enum "ACC DOC Content Type";
                                     ItemCode: Text;
                                     VendCode: Text): Boolean
    var
        ItemTbl: Record Item;
        VendTbl: Record Vendor;
        Purchaser: Record "Salesperson/Purchaser";
        ForInsert: Boolean;
    begin
        ForInsert := true;
        if not DMSLibrary.Get(SPOID) then begin
            Clear(DMSLibrary);
            DMSLibrary.Init();
            DMSLibrary."File No" := FileId;
            DMSLibrary."SPO No" := SPOID;
            DMSLibrary."File Name" := DestFileName;
            DMSLibrary."Original File Name" := OrigFileName;
            DMSLibrary.Description := Description;
            DMSLibrary.URL := URL + DestFileName;
            DMSLibrary."Effective Date" := EffectiveDate;
            DMSLibrary."Expiration Date" := ExpirationDate;
            DMSLibrary."DMS ISO Type" := ISOType;
            DMSLibrary."DMS Statement Type" := Statement;
            DMSLibrary."DMS Report Type" := ReportType;
            DMSLibrary.Note := Notes;
            DMSLibrary."Content Type" := ContentType;

            ItemTbl.Reset();
            if ItemTbl.Get(ItemCode) then begin
                ForInsert := true;
                DMSLibrary."Item Code" := ItemTbl."No.";
                DMSLibrary."Purchase Name" := '[' + ItemTbl."No." + '] ' + ItemTbl."BLACC Purchase Name";
                DMSLibrary."Sales Name" := '[' + ItemTbl."No." + '] ' + ItemTbl."BLTEC Item Name";
                if VendCode = '' then
                    VendCode := ItemTbl."Vendor No.";
                VendTbl.Reset();
                if VendTbl.Get(VendCode) then begin
                    DMSLibrary."Vendor Code" := VendTbl."No.";
                    Purchaser.Reset();
                    if Purchaser.Get(VendTbl."BLACC Supplier Mgt. Code") then begin
                        DMSLibrary."SPO Email No." := Purchaser."SPO Email No.";
                    end;
                end;
            end else begin
                VendTbl.Reset();
                if VendTbl.Get(VendCode) then begin
                    ForInsert := true;
                    DMSLibrary."Vendor Code" := VendTbl."No.";
                    Purchaser.Reset();
                    if Purchaser.Get(VendTbl."BLACC Supplier Mgt. Code") then begin
                        DMSLibrary."SPO Email No." := Purchaser."SPO Email No.";
                    end;
                end;
            end;
            if ForInsert then
                DMSLibrary.Insert();
        end;
        exit(ForInsert);
    end;

    local procedure BuildLibraryMeta(DMSItemLibrary: Record "ACC DMS Library"): Text
    var
        Ingrdient: Record "BLACC Item Ingredient Group";
        FieldObject: JsonObject;
        JsonText: Text;
    begin
        DMSItemLibrary.CalcFields("Vendor Name", "Vendor Group", "Item Ingredient Group");
        Clear(FieldObject);
        FieldObject.Add('Document_x0020_name', DMSItemLibrary."Document Name");
        FieldObject.Add('FileNameOrig', DMSItemLibrary."Original File Name");
        FieldObject.Add('Vendor_x0020_code', DMSItemLibrary."Vendor Code");
        FieldObject.Add('Vendorname', DMSItemLibrary."Vendor Name");
        FieldObject.Add('Buyer_x0020_Group', DMSItemLibrary."Vendor Group");
        FieldObject.Add('Item_x0020_purchase_x0020_name', DMSItemLibrary."Purchase Name");
        FieldObject.Add('Item_x0020_sale_x0020_name', DMSItemLibrary."Sales Name");
        FieldObject.Add('Item_x0020_code', DMSItemLibrary."Item Code");
        if Ingrdient.Get(DMSItemLibrary."Item Ingredient Group") then
            FieldObject.Add('Item_x0020_Ingredient_x0020_Group', Ingrdient."BLACC Description");
        FieldObject.Add('Statement_x0020_Type', DMSItemLibrary."DMS Statement Type");
        FieldObject.Add('ISOType', DMSItemLibrary."DMS ISO Type");
        FieldObject.Add('Report_x0020_type', DMSItemLibrary."DMS Report Type");
        FieldObject.Add('Notes0', DMSItemLibrary.Note);
        FieldObject.Add('Obsolete', DMSItemLibrary."Out Date");
        if DMSItemLibrary."Effective Date" <> 0D then
            FieldObject.Add('Effective_x0020_date', DMSItemLibrary."Effective Date");
        if DMSItemLibrary."Expiration Date" <> 0D then
            FieldObject.Add('Expiration_x0020_date0', DMSItemLibrary."Expiration Date");
        if DMSItemLibrary."SPO Email No." <> 0 then begin
            FieldObject.Add('OwnerLookupId', DMSItemLibrary."SPO Email No.");
        end;
        exit(Format(FieldObject));
    end;

    local procedure ExistMimeType(FileName: Text; MimeType: Text): Text
    var
    begin
        if MimeType = '' then begin
            if FileName.EndsWith('.msg') then
                MimeType := 'application/vnd.ms-outlook';
            if FileName.EndsWith('.pdf') then
                MimeType := 'application/pdf';
            if FileName.EndsWith('.png') then
                MimeType := 'image/png';
            if FileName.EndsWith('.docx') then
                MimeType := 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            if FileName.EndsWith('.xlsx') then
                MimeType := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        end;
        exit(MimeType);
    end;

    local procedure ChkDocName(DocName: Text): Text
    var
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        Clear(JsonObject);
        JsonObject.Add('name', DocName);
        JsonText := Format(JsonObject);
        if StrPos(JsonText, '\') <> 0 then begin
            exit(JsonText);
        end;
        exit('');
    end;

    trigger OnAfterGetRecord()
    var
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('+1D', Today);
        ToDate := CalcDate('+31D', Today);
        StyleExprTxt := '';
        if Rec."Expiration Date" < Today then
            StyleExprTxt := 'Unfavorable';
        if (Rec."Expiration Date" >= FromDate) AND (Rec."Expiration Date" <= ToDate) then
            StyleExprTxt := 'Ambiguous';
    end;

    Var
        StyleExprTxt: Text;
}
