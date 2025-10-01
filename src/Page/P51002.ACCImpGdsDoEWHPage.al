page 51002 "ACC Imp. Gds DoE WH Page"
{
    ApplicationArea = All;
    Caption = 'Hàng nhập khẩu theo chi tiết ngày nhập kho - P51002';
    PageType = List;
    SourceTable = "ACC Imp. Gds by DoE WH Table";
    SourceTableView = sorting("Customs Declaration No.");
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    AnalysisModeEnabled = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customs Declaration No."; Rec."Customs Declaration No.") { }
                field("Customs Declaration Date"; Rec."Customs Declaration Date") { }
                field("Customs Area"; Rec."Customs Area") { }
                field("Type Code"; Rec."Type Code") { }
                field("PSI Invoice"; Rec."PSI Invoice") { }
                field("ETA Request"; Rec."ETA Request") { }
                field("Document No."; Rec."Document No.") { }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.") { }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name") { }
                field("Form C/O"; Rec."Form C/O") { }
                field("Country/Region Code"; Rec."Country/Region Code") { }
                field("Certificate Date"; Rec."Certificate Date") { }
                field("Actual ETA"; Rec."Actual ETA") { }
                field("Receipt Date"; Rec."Receipt Date") { }
                field(Site; Rec.Site) { }
                field("Site Name"; Rec."Site Name") { }
                field("Warehouse No."; Rec."Warehouse No.") { }
                field("Warehouse Name"; Rec."Warehouse Name") { }
                field("Physical Date"; Rec."Physical Date") { }
                field("Quarantine Opening Day"; Rec."Quarantine Opening Day") { }
                field("Date Of First Sale"; Rec."Date Of First Sale") { }
                field("Container Type"; Rec."Container Type") { }
                field("Cont. Quantity"; Rec."Cont. Quantity") { }
                field("Cont. 20 Qty"; Rec."Cont. 20 Qty") { }
                field("Cont. 40 Qty"; Rec."Cont. 40 Qty") { }
                field("HS Code"; Rec."HS Code") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("C/O Type"; Rec."C/O Type") { }
                field(Quantity; Rec.Quantity) { }
                field("Receipt Quantity"; Rec."Receipt Quantity") { }
                field("Difference Quantity"; Rec."Difference Quantity") { }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ACCAction)
            {
                /*
                Caption = 'Action';
                action(ACCOPG)
                {
                    ApplicationArea = All;
                    Caption = 'Hàng nhập khẩu đang mở tờ khai';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "ACC Imp. Gds Opg. Decl. Page";
                }
                action(ACCDIFF)
                {
                    ApplicationArea = All;
                    Caption = 'Hàng nhập khẩu chênh lệch tờ khai so với nhập kho';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "ACC Imp. Gds Diff. Decl. Page";
                }
                action(ACCPAYMENT)
                {
                    ApplicationArea = All;
                    Caption = 'Thanh toán theo tờ khai';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "ACC Payment Declaration Page";
                }
                */
            }
        }
    }
    trigger OnOpenPage()
    var
        ImpGdsDoEWH: Query "ACC Imp. Gds by DoE WH Query";
        SalesLotNum: Query "ACC Sales Lot Number Query ";
        PurchQuarantine: Query "ACC Purch. Quarantine Query";
        WhseLocation: Query "ACC Posted Whse. Receipt Line";
        PurchInvoice: Record "Purch. Inv. Line";
        PurchHeader: Record "Purchase Header";
        InventTable: Record Item;
        SiteDimTabl: Record "Dimension Value";
        LocationTbl: Record Location;
        ContTypeLine: Record "BLTEC Container Type";
        LocationCode: Code[20];
        MaxDate: Date;
    begin
        MaxDate := DMY2DATE(31, 12, 9999);
        ImpGdsDoEWH.SetFilter(ImpGdsDoEWH.DeclarationNo, '>%1', '');
        if ImpGdsDoEWH.Open() then begin
            while ImpGdsDoEWH.Read() do begin
                Rec.Init();
                Rec.ID := Rec.ID + 1;
                Rec."Document No." := ImpGdsDoEWH.PONo;
                Rec."Line No." := ImpGdsDoEWH.POLine;
                if PurchHeader.Get("Purchase Document Type"::Order, ImpGdsDoEWH.PONo) then begin
                    Rec."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                    Rec."Buy-from Vendor Name" := PurchHeader."Buy-from Vendor Name";
                end;
                if ContTypeLine.Get(ImpGdsDoEWH.ContainerType) then begin
                    Rec."Cont. 20 Qty" := ContTypeLine."BLTEC Cont. 20 Qty";
                    Rec."Cont. 40 Qty" := ContTypeLine."BLTEC Cont. 40 Qty";
                    Rec."Cont. Quantity" := ContTypeLine."BLTEC Quantity";
                end;

                Rec."Customs Area" := ImpGdsDoEWH.CustomsOffice;
                Rec."Customs Declaration No." := ImpGdsDoEWH.CustomsDeclarationNo;
                if ImpGdsDoEWH.CustomsDeclarationDate <> 0D then begin
                    Rec."Customs Declaration Date" := ImpGdsDoEWH.CustomsDeclarationDate;
                end else begin
                    Rec."Customs Declaration Date" := ImpGdsDoEWH.DeclarationDate;
                end;
                Rec."ETA Request" := ImpGdsDoEWH.ETARequestDate;
                Rec."Item No." := ImpGdsDoEWH.ItemNo;
                Rec."Item Name" := ImpGdsDoEWH.ItemName;
                if InventTable.Get(ImpGdsDoEWH.ItemNo) then begin
                    Rec."HS Code" := InventTable."BLTEC HS Code";
                end;

                PurchInvoice.SetRange("Order No.", ImpGdsDoEWH.PONo);
                PurchInvoice.SetRange("Order Line No.", ImpGdsDoEWH.POLine);
                if PurchInvoice.FindFirst() then Rec."PSI Invoice" := PurchInvoice."Document No.";

                Rec.Quantity := ImpGdsDoEWH.Quantity;
                Rec."Physical Date" := ImpGdsDoEWH.ReceiptDate;

                PurchQuarantine.SetRange(CustomsDeclarationNo, ImpGdsDoEWH.CustomsDeclarationNo);
                PurchQuarantine.SetRange(OrderNo, ImpGdsDoEWH.PONo);
                PurchQuarantine.SetRange(ItemNo, ImpGdsDoEWH.ItemNo);
                PurchQuarantine.SetRange(CreatedAt, CreateDateTime(ImpGdsDoEWH.ReceiptDate, 0T), CreateDateTime(MaxDate, 0T));
                if PurchQuarantine.Open() then begin
                    if PurchQuarantine.Read() then begin
                        Rec."Quarantine Opening Day" := DT2Date(PurchQuarantine.CreatedAt);
                        SalesLotNum.SetRange(CustomsDeclarationNo, ImpGdsDoEWH.CustomsDeclarationNo);
                        SalesLotNum.SetRange(ItemNo, ImpGdsDoEWH.ItemNo);
                        SalesLotNum.SetRange(PostingDate, Rec."Quarantine Opening Day", MaxDate);
                        if SalesLotNum.Open() then begin
                            if SalesLotNum.Read() then begin
                                Rec."Date Of First Sale" := SalesLotNum.PostingDate;
                            end;
                            SalesLotNum.Close();
                        end;
                    end;
                    PurchQuarantine.Close();
                end;
                if Rec."Physical Date" = 0D then
                    Rec."Physical Date" := Rec."Quarantine Opening Day";

                Rec."Receipt Quantity" := ImpGdsDoEWH.ReceiptQuantity;
                Rec.Site := ImpGdsDoEWH.Site;
                if SiteDimTabl.Get('BRANCH', ImpGdsDoEWH.Site) then begin
                    Rec."Site Name" := SiteDimTabl.Name;
                end;
                Rec."Type Code" := ImpGdsDoEWH.DeclarationKindCode;

                WhseLocation.SetRange(SourceNo, ImpGdsDoEWH.PONo);
                WhseLocation.SetRange(SourceLineNo, ImpGdsDoEWH.POLine);
                WhseLocation.SetFilter(Quantity, '<>0');
                if WhseLocation.Open() then begin
                    while WhseLocation.Read() do begin
                        LocationCode := WhseLocation.LocationCode;
                        break;
                    end;
                    WhseLocation.Close();
                end;

                Rec."Warehouse No." := LocationCode;
                if LocationTbl.Get(LocationCode) then begin
                    Rec."Warehouse Name" := LocationTbl.Name;
                end;
                Rec."Difference Quantity" := ImpGdsDoEWH.Quantity - ImpGdsDoEWH.ReceiptQuantity;
                Rec.Insert();
            end;
            ImpGdsDoEWH.Close();
        end;
    end;
}
