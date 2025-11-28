page 51900 "AIG Sharepoint Connector"
{
    ApplicationArea = All;
    Caption = 'AIG Sharepoint Connector';
    PageType = List;
    SourceTable = "AIG Sharepoint Connector";
    UsageCategory = Administration;
    CardPageId = "AIG Sharepoint Connector Card";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application ID"; Rec."Application ID") { }
                field("Tenant ID"; Rec."Tenant ID") { }
                field("Client ID"; Rec."Client ID") { }
                field("Client Secret"; Rec."Client Secret") { }
                field(Scope; Rec.Scope) { }
                field("Access Token URL"; Rec."Access Token URL") { }
                field("Access Token URL 2"; Rec."Access Token URL 2") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(InitSharepoint)
            {
                Caption = 'Init';
                trigger OnAction()
                var
                    SharepointConnector: Record "AIG Sharepoint Connector";
                    SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
                begin
                end;
            }

            action(ACCImportQuality)
            {
                Caption = 'Công Bố Chất Lượng';
                trigger OnAction()
                var
                begin
                    ImportQuality();
                end;
            }
            action(ACCImportLabel)
            {
                Caption = 'Nhãn';
                trigger OnAction()
                var
                begin
                    ImportLabel();
                end;
            }
            action(ACCImportOffice)
            {
                Caption = 'Công Văn';
                trigger OnAction()
                var
                begin
                    ImportOfficialDispatch();
                end;
            }
            action(ACCImportQuota)
            {
                Caption = 'Quota';
                trigger OnAction()
                var
                begin
                    ImportQuota();
                end;
            }

            action(LibraryInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Library';
                Image = Import;
                Scope = Repeater;
                trigger OnAction()
                begin
                    ImportLibrary();
                end;
            }
            action(PropertyInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Properties';
                Image = Import;
                Scope = Repeater;
                trigger OnAction()
                begin
                    ImportProperties();
                end;
            }
            action(FileNameInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Original File';
                Image = Import;
                Scope = Repeater;
                trigger OnAction()
                begin
                    ImportFileName();
                end;
            }
        }
    }
    local procedure ImportLibrary()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
        FileName: Text;
        SheetName: Text;
        Instream: InStream;
        Item: Record Item;
        Vend: Record Vendor;

        Purchaser: Record "Salesperson/Purchaser";
        DMSLibrary: Record "ACC DMS Library";
        TmpExcelBuffer: Record "Excel Buffer" temporary;

        SPOID: Integer;
        NameFile: Text;
        URL: Text;
        AXVendCode: Text;
        VendCode: Text;
        AXItemCode: Text;
        ItemCode: Text;
        EffectiveDate: Text;
        ExpirationDate: Text;
        ISOType: Text;
        Note: Text;
        ContentType: Text;
    begin
        if SharepointConnector.Get('DMSDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
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
                    SPOID := 0;
                    NameFile := '';
                    URL := '';
                    AXVendCode := '';
                    VendCode := '';
                    AXItemCode := '';
                    ItemCode := '';
                    EffectiveDate := '';
                    ExpirationDate := '';
                    ISOType := '';
                    Note := '';
                    ContentType := '';
                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, SPOID);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, NameFile);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, URL);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, AXVendCode);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, VendCode);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, AXItemCode);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 7, ItemCode);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 8, EffectiveDate);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 9, ExpirationDate);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 10, ISOType);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 11, Note);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 12, ContentType);
                    Clear(DMSLibrary);
                    DMSLibrary.Init();
                    DMSLibrary."SPO No" := SPOID;
                    DMSLibrary."File Name" := NameFile;
                    DMSLibrary.URL := URL;
                    DMSLibrary."AX Vendor Code" := AXVendCode;
                    Evaluate(DMSLibrary."Effective Date", EffectiveDate);
                    Evaluate(DMSLibrary."Expiration Date", ExpirationDate);
                    DMSLibrary."DMS ISO Type" := ISOType;
                    DMSLibrary.Note := Note;
                    Evaluate(DMSLibrary."Content Type", ContentType);
                    Vend.Reset();
                    if Vend.Get(VendCode) then begin
                        DMSLibrary."Vendor Code" := Vend."No.";
                        Purchaser.Reset();
                        if Purchaser.Get(Vend."BLACC Supplier Mgt. Code") then begin
                            DMSLibrary."SPO Email No." := Purchaser."SPO Email No.";
                        end;
                    end;
                    DMSLibrary."AX Item Code" := AXItemCode;
                    Item.Reset();
                    if Item.Get(ItemCode) then begin
                        DMSLibrary."Item Code" := Item."No.";
                        DMSLibrary."Purchase Name" := '[' + Item."No." + '] ' + Item."BLACC Purchase Name";
                        DMSLibrary."Sales Name" := '[' + Item."No." + '] ' + Item."BLTEC Item Name";
                        if VendCode = '' then begin
                            Vend.Reset();
                            if Vend.Get(Item."Vendor No.") then begin
                                Purchaser.Reset();
                                if Purchaser.Get(Vend."BLACC Supplier Mgt. Code") then begin
                                    DMSLibrary."SPO Email No." := Purchaser."SPO Email No.";
                                end;
                            end;
                        end;
                    end;
                    DMSLibrary."File No" := GetFileSPOID(OauthenToken, URL, NameFile);
                    DMSLibrary.Insert();
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure ImportProperties()
    var
        FileName: Text;
        SheetName: Text;
        Instream: InStream;

        DMSLibrary: Record "ACC DMS Library";
        TmpExcelBuffer: Record "Excel Buffer" temporary;

        ISOTable: Record "ACC DMS ISO Type";
        StateTable: Record "ACC DMS Statement";
        ReportTable: Record "ACC DMS Report Type";

        SPOID: Integer;
        ISOType: Integer;
        StatementType: Text;
        ReportType: Text;

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
                    SPOID := 0;
                    ISOType := 0;
                    StatementType := '';
                    ReportType := '';

                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, SPOID);
                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, ISOType);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, ReportType);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, StatementType);

                    DMSLibrary.Reset();
                    if DMSLibrary.Get(SPOID) then begin
                        if Format(ISOType) <> DMSLibrary."DMS ISO Type" then begin
                            DMSLibrary."ISO Type" := Format(ISOType);
                            if ISOTable.Get(ISOType) then
                                DMSLibrary."DMS ISO Type" := Format(ISOType);
                        end;

                        if StatementType.ToUpper() <> DMSLibrary."DMS Statement Type" then begin
                            DMSLibrary."Statement Name" := StatementType;
                            if StateTable.Get(StatementType.ToUpper()) then
                                DMSLibrary."DMS Statement Type" := StatementType.ToUpper();
                        end;
                        if ReportType.ToUpper() <> DMSLibrary."DMS Report Type" then
                            if ReportTable.Get(ReportType.ToUpper()) then
                                DMSLibrary."DMS Report Type" := ReportType.ToUpper();
                        DMSLibrary.Modify();
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure ImportFileName()
    var
        FileName: Text;
        SheetName: Text;
        Instream: InStream;
        Item: Record Item;
        Vend: Record Vendor;

        Purchaser: Record "Salesperson/Purchaser";
        DMSLibrary: Record "ACC DMS Library";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        FileManagement: Codeunit "File Management";

        SPOID: Integer;
        NameFile: Text;

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
                    SPOID := 0;
                    NameFile := '';

                    GetIntegerValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, SPOID);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, NameFile);

                    DMSLibrary.Reset();
                    if DMSLibrary.Get(SPOID) then begin
                        if DMSLibrary."Original File Name" <> NameFile then begin
                            DMSLibrary."Original File Name" := NameFile;
                            DMSLibrary.Modify();
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure ImportQuota()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SourceLine: Record "AIG Sharepoint Connector Line";
        DestinationLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
        OauthenTokenSync: SecretText;

        Item: Record Item;
        Certificate: Record "BLACC Item Certificate";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        //ExcelBuffer: Record "Excel Buffer";

        InStream: InStream;
        FileContent: InStream;
        FileName: Text;
        SheetName: Text;
        ItemNo: Text;
        ItemTmp: Text;
        CertificateNo: Text;
        CertificateType: Text;
        PublishDate: Text;
        ExpirationDate: Text;
        LineNo: Integer;

        SourceURL: Text;
        SourceRoot: Text;
        SourceFile: Text;
        FolderRoot: Text;
        FileRoot: Text;
        FileId: Text;

        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            SourceRoot := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/';
            SourceFile := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/Department (ACC)/QMD/QA-QC/Data BC 2025/';
            if SharepointConnector.Get('INVSHIPPDF') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SourceLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            if not DestinationLine.Get('ITEMDOC', 1) then begin
                exit;
            end;
            GetToken(OauthenTokenSync);
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
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ItemNo);
                    if Item.Get(ItemNo) then begin
                        if not SetItemCertificate(ItemNo, OauthenTokenSync) then begin
                            Certificate."Item No." := ItemNo;
                            Certificate."Line No." := Certificate.GetLastLineNo(ItemNo) + 10000;
                            if ItemTmp <> ItemNo then begin
                                BCHelper.CreateSharePointFolder(DestinationLine, OauthenToken, '', ItemNo);
                            end;

                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, CertificateNo) then
                                Certificate."No." := CertificateNo;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, CertificateType) then begin
                                Evaluate(Certificate.Type, CertificateType);
                            end;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, PublishDate) then
                                Evaluate(Certificate."Published Date", PublishDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, ExpirationDate) then
                                Evaluate(Certificate."Expiration Date", ExpirationDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, SourceURL) then begin
                                FolderRoot := SourceURL.Replace(SourceRoot, '');
                                FileRoot := SourceURL.Replace(StrSubstNo('%1%2/', SourceFile, UpperCase(CertificateType)), '');
                            end;
                            BCHelper.DownloadFromSharePoint(OauthenToken, SourceLine."Site ID", SourceLine."Drive ID", FolderRoot, FileRoot, FileContent);
                            FileId := BCHelper.UploadFilesToSharePoint(DestinationLine, OauthenToken, ItemNo, FileContent, FileRoot, 'application/pdf');
                            Certificate."Document URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/Items', ItemNo, FileRoot);
                            Certificate."File Name" := FileRoot;
                            Certificate."File Extension" := 'pdf';
                            Certificate."File No." := FileId;
                            Certificate.Insert();
                            Clear(JsonObject);
                            JsonObject.Add('ItemNo', Format(ItemNo));
                            JsonObject.Add('ItemName', Format(Item.Description));
                            if Certificate."Published Date" <> 0D then
                                JsonObject.Add('PublishDate', Format(Certificate."Published Date"));
                            if Certificate."Expiration Date" <> 0D then
                                JsonObject.Add('ExpirationDate', Format(Certificate."Expiration Date"));
                            JsonObject.Add('_ExtendedDescription', Certificate."No.");
                            JsonObject.Add('CertificateType', Format(Certificate.Type));
                            JsonText := Format(JsonObject);

                            BCHelper.UpdateMetadata(OauthenToken, JsonText, DestinationLine."Site ID", DestinationLine."Drive ID", FileId);
                            ItemTmp := ItemNo;
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure ImportLabel()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SourceLine: Record "AIG Sharepoint Connector Line";
        DestinationLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
        OauthenTokenSync: SecretText;

        Item: Record Item;
        Certificate: Record "BLACC Item Certificate";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        //ExcelBuffer: Record "Excel Buffer";

        InStream: InStream;
        FileContent: InStream;
        FileName: Text;
        SheetName: Text;
        ItemNo: Text;
        ItemTmp: Text;
        CertificateNo: Text;
        CertificateType: Text;
        PublishDate: Text;
        ExpirationDate: Text;
        LineNo: Integer;

        SourceURL: Text;
        SourceRoot: Text;
        SourceFile: Text;
        FolderRoot: Text;
        FileRoot: Text;
        FileId: Text;

        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            SourceRoot := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/';
            SourceFile := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/Department (ACC)/QMD/QA-QC/Data BC 2025/Label/';
            if SharepointConnector.Get('INVSHIPPDF') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SourceLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            if not DestinationLine.Get('ITEMDOC', 1) then begin
                exit;
            end;
            GetToken(OauthenTokenSync);
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
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ItemNo);
                    if Item.Get(ItemNo) then begin
                        if not SetItemCertificate(ItemNo, OauthenTokenSync) then begin
                            Certificate."Item No." := ItemNo;
                            Certificate."Line No." := Certificate.GetLastLineNo(ItemNo) + 10000;
                            if ItemTmp <> ItemNo then begin
                                BCHelper.CreateSharePointFolder(DestinationLine, OauthenToken, '', ItemNo);
                            end;

                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, CertificateNo) then
                                Certificate."No." := CertificateNo;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, CertificateType) then begin
                                Evaluate(Certificate."Quality Group", CertificateType);
                            end;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, PublishDate) then
                                Evaluate(Certificate."Published Date", PublishDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, ExpirationDate) then
                                Evaluate(Certificate."Expiration Date", ExpirationDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, SourceURL) then begin
                                FolderRoot := SourceURL.Replace(SourceRoot, '');
                                FileRoot := SourceURL.Replace(SourceFile, '');
                            end;
                            BCHelper.DownloadFromSharePoint(OauthenToken, SourceLine."Site ID", SourceLine."Drive ID", FolderRoot, FileRoot, FileContent);
                            FileId := BCHelper.UploadFilesToSharePoint(DestinationLine, OauthenToken, ItemNo, FileContent, FileRoot, 'application/pdf');
                            Certificate."Document URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/Items', ItemNo, FileRoot);
                            Certificate."File Name" := FileRoot;
                            Certificate."File Extension" := 'pdf';
                            Certificate."File No." := FileId;
                            Certificate.Type := "BLACC Item Certificate Type"::"Quality Declaration";
                            Certificate.Insert();
                            Clear(JsonObject);
                            JsonObject.Add('ItemNo', Format(ItemNo));
                            JsonObject.Add('ItemName', Format(Item.Description));
                            if Certificate."Published Date" <> 0D then
                                JsonObject.Add('PublishDate', Format(Certificate."Published Date"));
                            if Certificate."Expiration Date" <> 0D then
                                JsonObject.Add('ExpirationDate', Format(Certificate."Expiration Date"));
                            JsonObject.Add('_ExtendedDescription', Certificate."No.");
                            JsonObject.Add('CertificateType', Format(Certificate.Type));
                            JsonText := Format(JsonObject);

                            BCHelper.UpdateMetadata(OauthenToken, JsonText, DestinationLine."Site ID", DestinationLine."Drive ID", FileId);
                            ItemTmp := ItemNo;
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure ImportQuality()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SourceLine: Record "AIG Sharepoint Connector Line";
        DestinationLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
        OauthenTokenSync: SecretText;

        Item: Record Item;
        Certificate: Record "BLACC Item Certificate";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        //ExcelBuffer: Record "Excel Buffer";

        InStream: InStream;
        FileContent: InStream;
        FileName: Text;
        SheetName: Text;
        ItemNo: Text;
        ItemTmp: Text;
        CertificateNo: Text;
        QualityGroup: Text;
        PublishDate: Text;
        ExpirationDate: Text;
        LineNo: Integer;

        SourceURL: Text;
        SourceRoot: Text;
        SourceFile: Text;
        FolderRoot: Text;
        FileRoot: Text;
        FileId: Text;

        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            SourceRoot := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/';
            SourceFile := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/Department (ACC)/QMD/RA-QMD/CONGBO/CONG BO APIS/CONG BO/TPNK/';
            if SharepointConnector.Get('INVSHIPPDF') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SourceLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            if not DestinationLine.Get('ITEMDOC', 1) then begin
                exit;
            end;
            GetToken(OauthenTokenSync);

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
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ItemNo);
                    if Item.Get(ItemNo) then begin
                        if not SetItemCertificate(ItemNo, OauthenTokenSync) then begin
                            Certificate.Type := "BLACC Item Certificate Type"::"Quality Declaration";
                            Certificate."Item No." := ItemNo;
                            Certificate."Line No." := Certificate.GetLastLineNo(ItemNo) + 10000;
                            if ItemTmp <> ItemNo then begin
                                //LineNo := 1;
                                BCHelper.CreateSharePointFolder(DestinationLine, OauthenToken, '', ItemNo);
                            end;
                            //Certificate."Line No." := LineNo;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, CertificateNo) then
                                Certificate."No." := CertificateNo;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, QualityGroup) then
                                Evaluate(Certificate."Quality Group", QualityGroup);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, PublishDate) then
                                Evaluate(Certificate."Published Date", PublishDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, ExpirationDate) then
                                Evaluate(Certificate."Expiration Date", ExpirationDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, SourceURL) then begin
                                FolderRoot := SourceURL.Replace(SourceRoot, '');
                                FileRoot := SourceURL.Replace(SourceFile, '');
                            end;
                            BCHelper.DownloadFromSharePoint(OauthenToken, SourceLine."Site ID", SourceLine."Drive ID", FolderRoot, FileRoot, FileContent);
                            FileId := BCHelper.UploadFilesToSharePoint(DestinationLine, OauthenToken, ItemNo, FileContent, FileRoot, 'application/pdf');
                            Certificate."Document URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/Items', ItemNo, FileRoot);
                            Certificate."File Name" := FileRoot;
                            Certificate."File Extension" := 'pdf';
                            Certificate."File No." := FileId;
                            Certificate.Insert();
                            Clear(JsonObject);
                            JsonObject.Add('ItemNo', Format(ItemNo));
                            JsonObject.Add('ItemName', Format(Item.Description));
                            if Certificate."Published Date" <> 0D then
                                JsonObject.Add('PublishDate', Format(Certificate."Published Date"));
                            if Certificate."Expiration Date" <> 0D then
                                JsonObject.Add('ExpirationDate', Format(Certificate."Expiration Date"));
                            JsonObject.Add('_ExtendedDescription', Certificate."No.");
                            JsonObject.Add('CertificateType', Format(Certificate.Type));
                            JsonText := Format(JsonObject);

                            BCHelper.UpdateMetadata(OauthenToken, JsonText, DestinationLine."Site ID", DestinationLine."Drive ID", FileId);
                            ItemTmp := ItemNo;
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure ImportOfficialDispatch()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SourceLine: Record "AIG Sharepoint Connector Line";
        DestinationLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
        OauthenTokenSync: SecretText;

        Item: Record Item;
        Certificate: Record "BLACC Item Certificate";
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        //ExcelBuffer: Record "Excel Buffer";

        InStream: InStream;
        FileContent: InStream;
        FileName: Text;
        SheetName: Text;
        ItemNo: Text;
        ItemTmp: Text;
        CertificateNo: Text;
        QualityGroup: Text;
        PublishDate: Text;
        ExpirationDate: Text;
        LineNo: Integer;

        SourceURL: Text;
        SourceRoot: Text;
        SourceFile: Text;
        FolderRoot: Text;
        FileRoot: Text;
        FileId: Text;

        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            SourceRoot := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/';
            SourceFile := 'https://asiachemicalcom.sharepoint.com/sites/Home/Shared Documents/Department (ACC)/QMD/QA-QC/Data BC 2025/CONG VAN/';
            if SharepointConnector.Get('INVSHIPPDF') then begin
                OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            end;
            if not SourceLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            if not DestinationLine.Get('ITEMDOC', 1) then begin
                exit;
            end;
            GetToken(OauthenTokenSync);
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
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, ItemNo);
                    if Item.Get(ItemNo) then begin
                        if not SetItemCertificate(ItemNo, OauthenTokenSync) then begin
                            Certificate.Type := "BLACC Item Certificate Type"::"Quality Declaration";
                            Certificate."Item No." := ItemNo;
                            Certificate."Line No." := Certificate.GetLastLineNo(ItemNo) + 10000;
                            if ItemTmp <> ItemNo then begin
                                BCHelper.CreateSharePointFolder(DestinationLine, OauthenToken, '', ItemNo);
                            end;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, CertificateNo) then
                                Certificate."No." := CertificateNo;
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 3, QualityGroup) then
                                Evaluate(Certificate."Quality Group", QualityGroup);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 4, PublishDate) then
                                Evaluate(Certificate."Published Date", PublishDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 5, ExpirationDate) then
                                Evaluate(Certificate."Expiration Date", ExpirationDate);
                            if GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 6, SourceURL) then begin
                                FolderRoot := SourceURL.Replace(SourceRoot, '');
                                FileRoot := SourceURL.Replace(SourceFile, '');
                            end;
                            BCHelper.DownloadFromSharePoint(OauthenToken, SourceLine."Site ID", SourceLine."Drive ID", FolderRoot, FileRoot, FileContent);
                            FileId := BCHelper.UploadFilesToSharePoint(DestinationLine, OauthenToken, ItemNo, FileContent, FileRoot, 'application/pdf');
                            Certificate."Document URL" := StrSubstNo('%1/%2/%3', 'https://asiachemicalcom.sharepoint.com/sites/AIG-ERP/Items', ItemNo, FileRoot);
                            Certificate."File Name" := FileRoot;
                            Certificate."File Extension" := 'pdf';
                            Certificate."File No." := FileId;
                            Certificate.Insert();
                            Clear(JsonObject);
                            JsonObject.Add('ItemNo', Format(ItemNo));
                            JsonObject.Add('ItemName', Format(Item.Description));
                            if Certificate."Published Date" <> 0D then
                                JsonObject.Add('PublishDate', Format(Certificate."Published Date"));
                            if Certificate."Expiration Date" <> 0D then
                                JsonObject.Add('ExpirationDate', Format(Certificate."Expiration Date"));
                            JsonObject.Add('_ExtendedDescription', Certificate."No.");
                            JsonObject.Add('CertificateType', Format(Certificate.Type));
                            JsonText := Format(JsonObject);

                            BCHelper.UpdateMetadata(OauthenToken, JsonText, DestinationLine."Site ID", DestinationLine."Drive ID", FileId);
                            ItemTmp := ItemNo;
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
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

    local procedure GetToken(var OauthenToken: SecretText): Boolean
    var
        SharepointConnector: Record "AIG Sharepoint Connector";
        ItemCertificate: Record "BLACC Item Certificate";
    begin
        if SharepointConnector.Get('ACCAPIConnector') then begin
            OauthenToken := GetOAuthTokenSharepointOnline(SharepointConnector);
            if not OauthenToken.IsEmpty() then
                exit(true);
        end;
        exit(false);
    end;

    local procedure GetItemCertificate(ItemNo: Code[20]): Boolean
    var
        SharepointConnector: Record "AIG Sharepoint Connector";
        OauthenToken: SecretText;
        ItemCertificate: Record "BLACC Item Certificate";
    begin
        if SharepointConnector.Get('ACCAPIConnector') then begin
            OauthenToken := GetOAuthTokenSharepointOnline(SharepointConnector);
            if not OauthenToken.IsEmpty() then begin
                exit(SetItemCertificate(ItemNo, OauthenToken));
            end;
        end;
        exit(false);
    end;

    local procedure SetItemCertificate(ItemNo: Code[20]; OauthToken: SecretText): Boolean
    var
        SharepointLine: Record "AIG Sharepoint Connector Line";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        ResponseText: Text;
        URI: Text;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ArrayToken: JsonToken;
        TokenText: Text;
    begin
        if not SharepointLine.Get('ITEMDOC', 1) then begin
            exit;
        end;
        URI := StrSubstNo(SharepointLine."Synchronize URL", ItemNo);
        // Create and configure the HTTP request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(URI);
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        //HttpClient.DefaultRequestHeaders().Add('Authorization', SecretStrSubstNo('Bearer %1', OauthToken));
        // Send the request
        //if HttpClient.Get(URI, HttpResponseMessage) then begin
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Clear(JsonObject);
                if not JsonObject.ReadFrom(ResponseText) then
                    Error('Invalid JSON format');
                if JsonObject.Get('value', JsonToken) then begin
                    JsonArray := JsonToken.AsArray();
                    if JsonArray.Count >= 1 then begin
                        foreach ArrayToken in JsonArray do
                            ProcessItemCertificate(ArrayToken.AsObject());
                        exit(true);
                    end;
                    exit(false);
                end;
            end else begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('API returned error: Status %1, Response: %2',
                    HttpResponseMessage.HttpStatusCode, ResponseText);
                exit(false);
            end;
        end;
        // Return the full response for further processing
        exit(false);
    end;

    local procedure ProcessItemCertificate(JObject: JsonObject)
    var
        ItemCertifiCate: Record "BLACC Item Certificate";
        CertificateType: Enum "BLACC Item Certificate Type";
        QualityGroup: Enum "ACC Quality Group";

        ItemNo: Code[20];
        LineNo: Integer;
        FileNo: Text;
    begin

        // Extract all fields from the JSON object
        ItemNo := GetJsonValueAsCode(JObject, 'itemNo');
        LineNo := GetJsonValueAsInteger(JObject, 'lineNo');
        FileNo := GetJsonValueAsText(JObject, 'fileNo');
        if FileNo = '' then
            exit;
        if ItemCertifiCate.Get(ItemNo, LineNo) then begin
            Evaluate(ItemCertifiCate.Type, GetJsonValueAsText(JObject, 'type'));
            ItemCertifiCate."No." := GetJsonValueAsText(JObject, 'no');
            ItemCertifiCate."BLACC OutDate" := GetJsonValueAsBoolean(JObject, 'blaccOutDate');
            ItemCertifiCate.Description := GetJsonValueAsText(JObject, 'description');
            ItemCertifiCate."Document URL" := GetJsonValueAsText(JObject, 'documentURL');
            ItemCertifiCate."Expiration Date" := GetJsonValueAsDate(JObject, 'expirationDate');
            ItemCertifiCate."File Extension" := GetJsonValueAsText(JObject, 'fileExtension');
            ItemCertifiCate."File Name" := GetJsonValueAsText(JObject, 'fileName');
            ItemCertifiCate."File No." := FileNo;
            Evaluate(ItemCertifiCate."File Type", GetJsonValueAsText(JObject, 'fileType'));
            ItemCertifiCate."Published Date" := GetJsonValueAsDate(JObject, 'publishedDate');
            Evaluate(ItemCertifiCate."Quality Group", GetJsonValueAsCode(JObject, 'qualityGroup'));
            //ItemCertifiCate."Storage Condition" := GetJsonValueAsText(JObject, 'storageCondition');
            //ItemCertifiCate."Vendor Code" := GetJsonValueAsCode(JObject, 'vendorCode');
            ItemCertifiCate."Is Synchronize" := true;
            ItemCertifiCate.Modify();
        end else begin
            ItemCertifiCate.Init();
            ItemCertifiCate."Item No." := GetJsonValueAsCode(JObject, 'itemNo');
            ItemCertifiCate."Line No." := GetJsonValueAsInteger(JObject, 'lineNo');
            Evaluate(ItemCertifiCate.Type, GetJsonValueAsText(JObject, 'type'));
            ItemCertifiCate."No." := GetJsonValueAsText(JObject, 'no');
            ItemCertifiCate."BLACC OutDate" := GetJsonValueAsBoolean(JObject, 'blaccOutDate');
            ItemCertifiCate.Description := GetJsonValueAsText(JObject, 'description');
            ItemCertifiCate."Document URL" := GetJsonValueAsText(JObject, 'documentURL');
            ItemCertifiCate."Expiration Date" := GetJsonValueAsDate(JObject, 'expirationDate');
            ItemCertifiCate."File Extension" := GetJsonValueAsText(JObject, 'fileExtension');
            ItemCertifiCate."File Name" := GetJsonValueAsText(JObject, 'fileName');
            ItemCertifiCate."File No." := FileNo;
            Evaluate(ItemCertifiCate."File Type", GetJsonValueAsText(JObject, 'fileType'));
            ItemCertifiCate."Published Date" := GetJsonValueAsDate(JObject, 'publishedDate');
            Evaluate(ItemCertifiCate."Quality Group", GetJsonValueAsCode(JObject, 'qualityGroup'));
            ItemCertifiCate."Is Synchronize" := true;
            ItemCertifiCate.Insert();
        end;
    end;

    local procedure GetJsonValueAsText(JObject: JsonObject; KeyName: Text): Text
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsText());
        exit('');
    end;

    local procedure GetJsonValueAsCode(JObject: JsonObject; KeyName: Text): Code[20]
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsCode());
        exit('');
    end;

    local procedure GetJsonValueAsInteger(JObject: JsonObject; KeyName: Text): Integer
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsInteger());
        exit(0);
    end;

    local procedure GetJsonValueAsBoolean(JObject: JsonObject; KeyName: Text): Boolean
    var
        JToken: JsonToken;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then
            exit(JToken.AsValue().AsBoolean());
        exit(false);
    end;

    local procedure GetJsonValueAsDate(JObject: JsonObject; KeyName: Text): Date
    var
        JToken: JsonToken;
        DateText: Text;
        ResultDate: Date;
    begin
        if JObject.Get(KeyName, JToken) and (not JToken.AsValue().IsNull()) then begin
            DateText := JToken.AsValue().AsText();
            if Evaluate(ResultDate, DateText) then
                exit(ResultDate);
        end;
        exit(0D);
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Counld not find a token with key %1', TokenKey);
    end;

    local procedure GetJsonTextValue(JsonObj: JsonObject; PropertyName: Text; var Result: Text): Boolean
    var
        JsonToken: JsonToken;
    begin
        if JsonObj.Get(PropertyName, JsonToken) then begin
            Result := JsonToken.AsValue().AsText();
            exit(true);
        end;

        Result := '';
        exit(false);
    end;

    local procedure GetOAuthTokenSharepointOnline(SharepointConnector: Record "AIG Sharepoint Connector") AuthToken: SecretText
    var
        //SharepointConnector: Record "AIG Sharepoint Connector";
        ClientID: Text;
        ClientSecret: Text;
        TenantID: Text;
        AccessTokenURL: Text;
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        //if SharepointConnector.Get('INVSHIPPDF') then begin
        ClientID := SharepointConnector."Client ID";
        ClientSecret := SharepointConnector."Client Secret";
        TenantID := SharepointConnector."Tenant ID";
        AccessTokenURL := StrSubstNo(SharepointConnector."Access Token URL", SharepointConnector."Tenant ID"); // https://login.microsoftonline.com/%1/oauth2/v2.0/token
        Scopes.Add(SharepointConnector.Scope); // https://graph.microsoft.com/.default
        if not OAuth2.AcquireTokenWithClientCredentials(ClientID, ClientSecret, AccessTokenURL, '', Scopes, AuthToken) then
            Error('Failed to get access token from response\%1', GetLastErrorText());
        //end;
    end;
}
