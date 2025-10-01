codeunit 51002 "ACC Packing Slip Download"
{
    procedure PackingSlipSharepointOnline()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        SalesShipment: Query "ACC Sales Invoice Entry Qry";
        ShipmentHeader: Record "Sales Shipment Header";
        CustTable: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        FileContent: InStream;
        TempReportSelections: Record "Report Selections" temporary;

        eInvoiceToken: SecretText;
        OAuthToken: SecretText;
        TransactionIDsList: List of [Text];
        DateFolder: Text;
        LocationFolder: Text;
        TempDate: Date;
        TempLocation: Text;
        LocationTemp: Text;
        copyInt: Integer;
        Tomorrow: Date;
    begin
        Tomorrow := CalcDate('+1D', TODAY);
        if SharepointConnector.Get('INVSHIPPDF') then begin
            OAuthToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
            if not SharepointConnectorLine.Get('INVSHIPPDF', 1) then begin
                exit;
            end;
            SalesShipment.SetFilter(LocationCode, '>%1', '');
            SalesShipment.SetFilter(ShipmentDate, Format(Tomorrow));
            if SalesShipment.Open() then begin
                while SalesShipment.Read() do begin
                    if TempDate <> SalesShipment.ShipmentDate then begin
                        DateFolder := StrSubstNo('%1_PXKNOINVOICEID_BC', Format(SalesShipment.ShipmentDate, 0, '<Year4><Month,2><Day,2>'));
                        BCHelper.CreateSharePointFolder(SharepointConnectorLine, OAuthToken, '', DateFolder);
                    end;
                    LocationTemp := StrSubstNo('%1%2', Format(SalesShipment.ShipmentDate, 0, '<Year4><Month,2><Day,2>'), SalesShipment.LocationCode);
                    if TempLocation <> LocationTemp then begin
                        LocationFolder := SalesShipment.LocationCode;
                        BCHelper.CreateSharePointFolder(SharepointConnectorLine, OAuthToken, DateFolder, LocationFolder);
                    end;
                    ShipmentHeader.Get(SalesShipment.DocumentNo);
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
                            BCHelper.UploadFilesToSharePoint(SharepointConnectorLine, OAuthToken, Format(DateFolder + '/' + LocationFolder), FileContent, StrSubstNo('%1_0%2.pdf', ShipmentHeader."No.", copyInt), 'application/pdf');
                        end;
                    end;
                    TempDate := SalesShipment.ShipmentDate;
                    TempLocation := StrSubstNo('%1%2', Format(SalesShipment.ShipmentDate, 0, '<Year4><Month,2><Day,2>'), SalesShipment.LocationCode);
                end;
                SalesShipment.Close();
            end;
        end;
    end;
}
