page 51003 "ACC Imp. Gds Diff. Decl. Page"
{
    ApplicationArea = All;
    Caption = 'Hàng nhập khẩu chênh lệch tờ khai so với nhập kho - P51003';
    PageType = List;
    SourceTable = "ACC Imp. Gds Diff. Decl. Table";
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
                //field("PSI Invoice"; Rec."PSI Invoice") { }
                field("Document No."; Rec."Document No.") { }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.") { }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name") { }
                field(Site; Rec.Site) { }
                field("Site Name"; Rec."Site Name") { }

                field("Container Type"; Rec."Container Type") { }
                field("Cont. Quantity"; Rec."Cont. Quantity") { }
                field("Cont. 20 Qty"; Rec."Cont. 20 Qty") { }
                field("Cont. 40 Qty"; Rec."Cont. 40 Qty") { }
                field("HS Code"; Rec."HS Code") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
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
                action(ACCDOE)
                {
                    ApplicationArea = All;
                    Caption = 'Hàng nhập khẩu theo chi tiết ngày nhập kho';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "ACC Imp. Gds DoE WH Page";
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
        ImpGdsDecla: Query "ACC Imp. Gds Diff. Decl. Query";
        PurchInvoice: Record "Purch. Inv. Line";
        PurchHeader: Record "Purchase Header";
        InventTable: Record Item;
        SiteDimTabl: Record "Dimension Value";
        LocationTbl: Record Location;
        ContTypeLine: Record "BLTEC Container Type";
    begin
        ImpGdsDecla.SetFilter(ImpGdsDecla.DeclarationNo, '>%1', '');
        if ImpGdsDecla.Open() then begin
            while ImpGdsDecla.Read() do begin
                Rec.Init();
                Rec.ID := Rec.ID + 1;
                Rec."Customs Declaration No." := ImpGdsDecla.DeclarationNo;
                Rec."Document No." := ImpGdsDecla.PONo;
                if PurchHeader.Get("Purchase Document Type"::Order, ImpGdsDecla.PONo) then begin
                    Rec."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                    Rec."Buy-from Vendor Name" := PurchHeader."Buy-from Vendor Name";
                end;
                if ContTypeLine.Get(ImpGdsDecla.ContainerType) then begin
                    Rec."Cont. 20 Qty" := ContTypeLine."BLTEC Cont. 20 Qty";
                    Rec."Cont. 40 Qty" := ContTypeLine."BLTEC Cont. 40 Qty";
                    Rec."Cont. Quantity" := ContTypeLine."BLTEC Quantity";
                end;

                Rec."Customs Area" := ImpGdsDecla.CustomsOffice;
                if ImpGdsDecla.CustomsDeclarationDate <> 0D then begin
                    Rec."Customs Declaration Date" := ImpGdsDecla.CustomsDeclarationDate;
                end else begin
                    Rec."Customs Declaration Date" := ImpGdsDecla.DeclarationDate;
                end;

                Rec."Item No." := ImpGdsDecla.ItemNo;
                Rec."Item Name" := ImpGdsDecla.ItemName;
                if InventTable.Get(ImpGdsDecla.ItemNo) then begin
                    Rec."HS Code" := InventTable."BLTEC HS Code";
                end;
                /*
                PurchInvoice.SetRange("Order No.", ImpGdsDecla.PONo);
                //PurchInvoice.SetRange("Order Line No.", ImpGdsDecla.POLine);
                if PurchInvoice.FindFirst() then Rec."PSI Invoice" := PurchInvoice."Document No.";
                */
                Rec.Quantity := ImpGdsDecla.Quantity;
                Rec."Receipt Quantity" := ImpGdsDecla.ReceiptQuantity;
                Rec.Site := ImpGdsDecla.Site;
                if SiteDimTabl.Get('BRANCH', ImpGdsDecla.Site) then begin
                    Rec."Site Name" := SiteDimTabl.Name;
                end;
                Rec."Type Code" := ImpGdsDecla.DeclarationKindCode;
                Rec."Difference Quantity" := ImpGdsDecla.Quantity - ImpGdsDecla.ReceiptQuantity;
                Rec.Insert();
            end;
            ImpGdsDecla.Close();
        end;
    end;
}
