page 51903 "AIG Merge PDF Page"
{
    ApplicationArea = All;
    Caption = 'AIG Merge PDF';
    PageType = Card;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            usercontrol(pdf; AIGPDF)
            {
                trigger DownloadPDF(pdfToNav: text)
                var
                    TempBlob: Codeunit "Temp Blob";
                    Convert64: Codeunit "Base64 Convert";
                    Ins: InStream;
                    Outs: OutStream;
                    Filename: Text;
                begin
                    if pdfToNav <> '' then begin
                        Filename := Format(PdfName + '.pdf');
                        TempBlob.CreateInStream(Ins);
                        TempBlob.CreateOutStream(Outs);
                        Convert64.FromBase64(pdfToNav, Outs);
                        DownloadFromStream(Ins, 'Download', '', '', Filename);
                    end;
                end;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(MergeByDocument)
            {
                Caption = 'Merge By Document';
                Image = Print;
                trigger OnAction()
                var
                    TemplateHeader: Record "BLTI Template Header";
                    eInvoiceToken: SecretText;
                    TransactionIDsList: List of [Text];
                    BCHelper: Codeunit "BC Helper";
                    SalesInvoice: Query "ACC Sales Invoice Entry Qry";
                    ShipmentHeader: Record "Sales Shipment Header";
                    RecRef: RecordRef;
                    LocationTable: Record Location;
                    CustTable: Record Customer;
                    TempLocation: Text;
                begin
                    MergePDF.ClearPDF();
                    //To check the JsonArray                    
                    //Get any record
                    if DocumentNo <> '' then begin
                        if TemplateHeader.Get(BCHelper.GeteInvoiceTemplate("AIG eInvoice Type"::"VAT Domestic")) then begin
                            eInvoiceToken := BCHelper.GetOAuthTokeneInvoice(TemplateHeader);
                        end;
                        SalesInvoice.SetFilter(eInvoiceNo, '<>%1', '');
                        SalesInvoice.SetFilter(eInvoiceCode, '<>%1', '');
                        //SalesInvoice.SetFilter(LocationCode, '>%1', '');
                        SalesInvoice.SetFilter(DocumentNo, DocumentNo);

                        if SalesInvoice.Open() then begin
                            while SalesInvoice.Read() do begin
                                ShipmentHeader.Get(SalesInvoice.DocumentNo);
                                ShipmentHeader.SetRecFilter();
                                RecRef.GetTable(ShipmentHeader);
                                if TempLocation <> SalesInvoice.LocationCode then begin
                                    LocationTable.Get(SalesInvoice.LocationCode);
                                end;
                                if CustTable.Get(ShipmentHeader."Sell-to Customer No.") then begin
                                    case CustTable."Report Layout" of
                                        "ACC Packing Slip Layout"::"Layout 01":
                                            MergePDF.AddShipmentToMerge(51002, RecRef, 3);
                                        "ACC Packing Slip Layout"::"Layout 02":
                                            MergePDF.AddShipmentToMerge(51003, RecRef, 3);
                                        "ACC Packing Slip Layout"::"Layout 03":
                                            MergePDF.AddShipmentToMerge(51004, RecRef, 3);
                                    end;
                                end;

                                if not eInvoiceToken.IsEmpty() then begin
                                    Clear(TransactionIDsList);
                                    TransactionIDsList.Add(SalesInvoice.ReservationCode);
                                    MergePDF.AddVoucherToMerge(TemplateHeader, eInvoiceToken, LocationTable.Contact, TransactionIDsList, 2);
                                end;
                                TempLocation := SalesInvoice.LocationCode;
                            end;
                            SalesInvoice.Close();
                        end;
                        if Format(MergePDF.GetJArray()) <> '' then begin
                            PdfName := StrSubstNo('INV_%1', Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
                            CurrPage.pdf.MergePDF(Format(MergePDF.GetJArray()));
                        end;
                    end;
                end;
            }

            action(Shipment)
            {
                Caption = 'Phiếu xuất kho (3 copy)';
                Image = Print;
                trigger OnAction()
                var
                    TransactionIDsList: List of [Text];
                    BCHelper: Codeunit "BC Helper";
                    SalesInvoice: Query "ACC Sales Invoice Entry Qry";
                    ShipmentHeader: Record "Sales Shipment Header";
                    RecRef: RecordRef;
                    CustTable: Record Customer;
                begin
                    MergePDF.ClearPDF();
                    //To check the JsonArray                    
                    //Get any record
                    if DocumentNo <> '' then begin
                        SalesInvoice.SetFilter(eInvoiceNo, '<>%1', '');
                        SalesInvoice.SetFilter(eInvoiceCode, '<>%1', '');
                        SalesInvoice.SetFilter(DocumentNo, DocumentNo);

                        if SalesInvoice.Open() then begin
                            while SalesInvoice.Read() do begin
                                ShipmentHeader.Get(SalesInvoice.DocumentNo);
                                ShipmentHeader.SetRecFilter();
                                RecRef.GetTable(ShipmentHeader);

                                if CustTable.Get(ShipmentHeader."Sell-to Customer No.") then begin
                                    case CustTable."Report Layout" of
                                        "ACC Packing Slip Layout"::"Layout 01":
                                            MergePDF.AddShipmentToMerge(51002, RecRef, 3);
                                        "ACC Packing Slip Layout"::"Layout 02":
                                            MergePDF.AddShipmentToMerge(51003, RecRef, 3);
                                        "ACC Packing Slip Layout"::"Layout 03":
                                            MergePDF.AddShipmentToMerge(51004, RecRef, 3);
                                    end;
                                end;
                            end;
                            SalesInvoice.Close();
                        end;
                        if Format(MergePDF.GetJArray()) <> '' then begin
                            PdfName := StrSubstNo('PXK3COPY_%1', Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
                            CurrPage.pdf.MergePDF(Format(MergePDF.GetJArray()));
                        end;
                    end;
                end;
            }

            action(ShipmentOne)
            {
                Caption = 'Phiếu xuất kho (1 copy)';
                Image = Print;
                trigger OnAction()
                var
                    TransactionIDsList: List of [Text];
                    BCHelper: Codeunit "BC Helper";
                    SalesInvoice: Query "ACC Sales Invoice Entry Qry";
                    ShipmentHeader: Record "Sales Shipment Header";
                    RecRef: RecordRef;
                    CustTable: Record Customer;
                begin
                    MergePDF.ClearPDF();
                    //To check the JsonArray                    
                    //Get any record
                    if DocumentNo <> '' then begin
                        SalesInvoice.SetFilter(eInvoiceNo, '<>%1', '');
                        SalesInvoice.SetFilter(eInvoiceCode, '<>%1', '');
                        SalesInvoice.SetFilter(DocumentNo, DocumentNo);

                        if SalesInvoice.Open() then begin
                            while SalesInvoice.Read() do begin
                                ShipmentHeader.Get(SalesInvoice.DocumentNo);
                                ShipmentHeader.SetRecFilter();
                                RecRef.GetTable(ShipmentHeader);

                                if CustTable.Get(ShipmentHeader."Sell-to Customer No.") then begin
                                    case CustTable."Report Layout" of
                                        "ACC Packing Slip Layout"::"Layout 01":
                                            MergePDF.AddShipmentToMerge(51002, RecRef, 1);
                                        "ACC Packing Slip Layout"::"Layout 02":
                                            MergePDF.AddShipmentToMerge(51003, RecRef, 1);
                                        "ACC Packing Slip Layout"::"Layout 03":
                                            MergePDF.AddShipmentToMerge(51004, RecRef, 1);
                                    end;
                                end;
                            end;
                            SalesInvoice.Close();
                        end;
                        if Format(MergePDF.GetJArray()) <> '' then begin
                            PdfName := StrSubstNo('PXK1COPY_%1', Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
                            CurrPage.pdf.MergePDF(Format(MergePDF.GetJArray()));
                        end;
                    end;
                end;
            }

            action(EInvoice)
            {
                Caption = 'Hóa đơn (2 copy)';
                Image = Print;
                trigger OnAction()
                var
                    TemplateHeader: Record "BLTI Template Header";
                    eInvoiceToken: SecretText;
                    TransactionIDsList: List of [Text];
                    BCHelper: Codeunit "BC Helper";
                    SalesInvoice: Query "ACC Sales Invoice Entry Qry";
                    ShipmentHeader: Record "Sales Shipment Header";
                    RecRef: RecordRef;
                    LocationTable: Record Location;
                begin
                    MergePDF.ClearPDF();

                    //To check the JsonArray                    
                    //Get any record
                    if DocumentNo <> '' then begin
                        if TemplateHeader.Get(BCHelper.GeteInvoiceTemplate("AIG eInvoice Type"::"VAT Domestic")) then begin
                            eInvoiceToken := BCHelper.GetOAuthTokeneInvoice(TemplateHeader);
                        end;
                        SalesInvoice.SetFilter(eInvoiceNo, '<>%1', '');
                        SalesInvoice.SetFilter(eInvoiceCode, '<>%1', '');
                        SalesInvoice.SetFilter(DocumentNo, DocumentNo);

                        if SalesInvoice.Open() then begin
                            while SalesInvoice.Read() do begin
                                ShipmentHeader.Get(SalesInvoice.DocumentNo);
                                ShipmentHeader.SetRecFilter();
                                RecRef.GetTable(ShipmentHeader);
                                LocationTable.Get(SalesInvoice.LocationCode);

                                if not eInvoiceToken.IsEmpty() then begin
                                    Clear(TransactionIDsList);
                                    TransactionIDsList.Add(SalesInvoice.ReservationCode);
                                    MergePDF.AddVoucherToMerge(TemplateHeader, eInvoiceToken, LocationTable.Contact, TransactionIDsList, 2);
                                end;
                            end;
                            SalesInvoice.Close();
                        end;
                        if Format(MergePDF.GetJArray()) <> '' then begin
                            PdfName := StrSubstNo('INV2COPY_%1', Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
                            CurrPage.pdf.MergePDF(Format(MergePDF.GetJArray()));
                        end;
                    end;
                end;
            }
        }
    }
    procedure TestMerge(DocumentNoArray: Text; VehicleNoArray: Text)
    var
    begin
        DocumentNo := DocumentNoArray;
        VehicleNo := VehicleNoArray;
    end;

    var
        MergePDF: Codeunit "AIG Merge PDF";
        DocumentNo: Text;
        VehicleNo: Text;
        PdfName: Text;
}
