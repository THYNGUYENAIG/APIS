page 51921 "AIG eInvoice Merge PDF"
{
    ApplicationArea = All;
    Caption = 'AIG eInvoice Merge PDF';
    PageType = Card;
    //UsageCategory = Administration;
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
            }
        }
    }
    procedure TestMerge(DocumentNoArray: Text)
    var
    begin
        DocumentNo := DocumentNoArray;
        //VehicleNo := VehicleNoArray;
    end;

    trigger OnOpenPage()
    var
        TemplateHeader: Record "BLTI Template Header";
        eInvoiceToken: SecretText;
        TransactionIDsList: List of [Text];
        BCHelper: Codeunit "BC Helper";
        SalesInvoice: Query "ACC Sales Invoice Entry Qry";
        ShipmentHeader: Record "Sales Shipment Header";
        WhseStaff: Record "ACC Whse. Staff Shipment";
        RecRef: RecordRef;
        LocationTable: Record Location;
        CustTable: Record Customer;
        TempLocation: Text;
        WhseOrderPinterName: Text;
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
                        WhseOrderPinterName := '';
                        if LocationTable.Get(SalesInvoice.LocationCode) then begin
                            WhseStaff.SetRange("Location Code", LocationTable.Code);
                            WhseStaff.SetRange("Active Print ", true);
                            WhseStaff.SetAutoCalcFields("Whse. Order Printer Name");
                            if WhseStaff.FindFirst() then begin
                                WhseOrderPinterName := WhseStaff."Whse. Order Printer Name";
                            end;
                        end;
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
                        MergePDF.AddVoucherToMerge(TemplateHeader, eInvoiceToken, WhseOrderPinterName, TransactionIDsList, 2);
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

    var
        MergePDF: Codeunit "AIG Merge PDF";
        DocumentNo: Text;
        VehicleNo: Text;
        PdfName: Text;
}
