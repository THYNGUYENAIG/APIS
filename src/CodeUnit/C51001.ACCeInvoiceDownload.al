codeunit 51001 "ACC eInvoice Download"
{
    trigger OnRun()
    begin
        eInvoiceSharepointOnline();
    end;

    procedure eInvoiceSharepointOnline()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        TemplateHeader: Record "BLTI Template Header";
        SalesInvoice: Query "ACC Sales Invoice Entry Qry";
        ShipmentHeader: Record "Sales Shipment Header";
        LocationTable: Record Location;
        CustTable: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        FileContent: InStream;
        TempReportSelections: Record "Report Selections" temporary;
        eInvoiceToken: SecretText;
        OAuthToken: SecretText;
        TransactionIDsList: List of [Text];

        DateFolder: Text;
        LocationFolder: Text;
        TempLocation: Text;
        eInvoiceInt: Integer;
        copyInt: Integer;
    begin
        DateFolder := StrSubstNo('%1_HDPXK_BC', Format(TODAY, 0, '<Year4><Month,2><Day,2>'));
        if TemplateHeader.Get('MISA-1C25TSG') then begin
            eInvoiceToken := BCHelper.GetOAuthTokeneInvoice(TemplateHeader);
        end;
        if SharepointConnector.Get('INVSHIPPDF') then begin
            OAuthToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            eInvoiceInt := SharepointConnector."Copy Packing Slip" + SharepointConnector."Copy eInvoice";
            if not SharepointConnectorLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            BCHelper.CreateSharePointFolder(SharepointConnectorLine, OAuthToken, '', DateFolder);
            SalesInvoice.SetFilter(eInvoiceNo, '>%1', '');
            SalesInvoice.SetFilter(PostingDate, Format(TODAY));
            //SalesInvoice.SetFilter(PostingDate, Format(CalcDate('-2D', TODAY)));
            if SalesInvoice.Open() then begin
                while SalesInvoice.Read() do begin
                    if TempLocation <> SalesInvoice.LocationCode then begin
                        LocationFolder := SalesInvoice.LocationCode;
                        LocationTable.Get(SalesInvoice.LocationCode);
                        BCHelper.CreateSharePointFolder(SharepointConnectorLine, OAuthToken, DateFolder, LocationFolder);
                    end;
                    ShipmentHeader.Get(SalesInvoice.DocumentNo);
                    ShipmentHeader.SetRecFilter();
                    if CustTable.Get(ShipmentHeader."Sell-to Customer No.") then begin
                        case CustTable."Report Layout" of
                            "ACC Packing Slip Layout"::"Layout 01":
                                TempReportSelections.SaveReportAsPDFInTempBlob(TempBlob, 51002, ShipmentHeader, TempReportSelections."Custom Report Layout Code", Enum::"Report Selection Usage"::"S.Shipment");
                            "ACC Packing Slip Layout"::"Layout 02":
                                TempReportSelections.SaveReportAsPDFInTempBlob(TempBlob, 51003, ShipmentHeader, TempReportSelections."Custom Report Layout Code", Enum::"Report Selection Usage"::"S.Shipment");
                            "ACC Packing Slip Layout"::"Layout 03":
                                TempReportSelections.SaveReportAsPDFInTempBlob(TempBlob, 51004, ShipmentHeader, TempReportSelections."Custom Report Layout Code", Enum::"Report Selection Usage"::"S.Shipment");
                        end;
                        TempBlob.CreateInStream(FileContent);
                        for copyInt := 1 to SharepointConnector."Copy Packing Slip" do begin
                            BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OAuthToken, Format(DateFolder + '/' + LocationFolder), FileContent, StrSubstNo('%1_0%2pxk.pdf', SalesInvoice.eInvoiceNo, copyInt), 'application/pdf');
                        end;
                    end;
                    TempLocation := SalesInvoice.LocationCode;
                    // eInvoice Download
                    //TransactionIDsList.Add('3JH5CEWXQM');
                    TransactionIDsList.Add(SalesInvoice.ReservationCode);
                    for copyInt := copyInt + 1 to eInvoiceInt do begin
                        BCHelper.GetVoucherPaper(TemplateHeader, eInvoiceToken, Format(DateFolder + '/' + LocationFolder), StrSubstNo('%1_0%2hd.pdf', SalesInvoice.eInvoiceNo, copyInt), LocationTable.Contact, TransactionIDsList, OAuthToken);
                    end;
                end;
                SalesInvoice.Close();
            end;
        end;
    end;
}
