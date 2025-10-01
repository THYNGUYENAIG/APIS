page 51924 "AIG Shipment Merge PDF"
{
    ApplicationArea = All;
    Caption = 'AIG Shipment Merge PDF';
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
            //SalesInvoice.SetFilter(eInvoiceNo, '<>%1', '');
            //SalesInvoice.SetFilter(eInvoiceCode, '<>%1', '');
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

    trigger OnAfterGetRecord()
    begin
        CurrPage.Close();
    end;

    var
        MergePDF: Codeunit "AIG Merge PDF";
        DocumentNo: Text;
        //VehicleNo: Text;
        PdfName: Text;
}
