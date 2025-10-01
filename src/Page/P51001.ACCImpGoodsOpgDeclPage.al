page 51001 "ACC Imp. Gds Opg. Decl. Page"
{
    ApplicationArea = All;
    Caption = 'Hàng nhập khẩu đang mở tờ khai - P51001';
    PageType = List;
    SourceTable = "ACC Imp. Gds Opg. Decl. Table";
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
                field("Document No."; Rec."Document No.") { }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.") { }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name") { }
                field("Warehouse No."; Rec."Warehouse No.") { }
                field("Warehouse Name"; Rec."Warehouse Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("HS Code"; Rec."HS Code") { }
                field(Quantity; Rec.Quantity) { }
                field("Country Name"; Rec."Country Name") { }
                field("Bill No."; Rec."Bill No.") { }
                field("Cont. Quantity"; Rec."Cont. Quantity") { }
                field("Cont./Block Type"; Rec."Cont./Block Type") { }
                field("Customs Area"; Rec."Customs Area") { }
                field("Customs Declaration Date"; Rec."Customs Declaration Date") { }
                field("Customs Declaration No."; Rec."Customs Declaration No.") { }
                field(ETA; Rec.ETA) { }
                field("Est. Date Of Receipt"; Rec."Est. Date Of Receipt") { }
                field("Form C/O"; Rec."Form C/O") { }
                field(Site; Rec.Site) { }
                field("Site Name"; Rec."Site Name") { }
                field("Type Code"; Rec."Type Code") { }
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
                action(ACCDOE)
                {
                    ApplicationArea = All;
                    Caption = 'Hàng nhập khẩu theo chi tiết ngày nhập kho';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "ACC Imp. Gds DoE WH Page";
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
        ImpGdsOpgDecl: Query "ACC Imp. Gds Opg. Decl. Query";
        LocationTable: Record Location;
        SiteDimTable: Record "Dimension Value";
        CountryRegion: Record "Country/Region";
        InventTable: Record Item;
        ContTypeLine: Record "BLTEC Container Type";
    begin
        ImpGdsOpgDecl.SetFilter(ImpGdsOpgDecl.DeclarationNo, '>%1', '');
        if ImpGdsOpgDecl.Open() then begin
            while ImpGdsOpgDecl.Read() do begin
                Rec.Init();
                Rec.ID := Rec.ID + 1;
                Rec."Document No." := ImpGdsOpgDecl.No;
                Rec."Buy-from Vendor No." := ImpGdsOpgDecl.BuyfromVendorNo;
                Rec."Buy-from Vendor Name" := ImpGdsOpgDecl.BuyfromVendorName;
                Rec."Warehouse No." := ImpGdsOpgDecl.LocationCode;
                if LocationTable.Get(ImpGdsOpgDecl.LocationCode) then begin
                    Rec."Warehouse Name" := LocationTable.Name;
                end;
                Rec."Item No." := ImpGdsOpgDecl.ItemNo;
                Rec."Item Name" := ImpGdsOpgDecl.Description;
                Rec.Quantity := ImpGdsOpgDecl.Quantity;
                rec."Bill No." := ImpGdsOpgDecl.BillNo;
                Rec."Customs Declaration No." := ImpGdsOpgDecl.CustomsDeclarationNo;
                if ImpGdsOpgDecl.CustomsDeclarationDate <> 0D then begin
                    Rec."Customs Declaration Date" := ImpGdsOpgDecl.CustomsDeclarationDate;
                end else begin
                    Rec."Customs Declaration Date" := ImpGdsOpgDecl.DeclarationDate;
                end;

                if InventTable.Get(ImpGdsOpgDecl.ItemNo) then begin
                    Rec."HS Code" := InventTable."BLTEC HS Code";
                    Rec."Form C/O" := InventTable."BLTEC C/O Type";
                end;
                Rec."Customs Area" := ImpGdsOpgDecl.CustomsOffice;
                Rec."Type Code" := ImpGdsOpgDecl.DeclarationKindCode;
                if CountryRegion.Get(ImpGdsOpgDecl.Country) then begin
                    Rec."Country Name" := CountryRegion.Name;
                end;
                Rec."Est. Date Of Receipt" := ImpGdsOpgDecl.ActualAvailableDate;
                Rec.ETA := ImpGdsOpgDecl.ETADate;

                Rec."Cont./Block Type" := ImpGdsOpgDecl.ContainerType;
                if ContTypeLine.Get(ImpGdsOpgDecl.ContainerType) then begin
                    Rec."Cont. Quantity" := ContTypeLine."BLTEC Quantity";
                end;
                Rec.Site := ImpGdsOpgDecl.Site;
                if SiteDimTable.Get('BRANCH', ImpGdsOpgDecl.Site) then begin
                    Rec."Site Name" := SiteDimTable.Name;
                end;

                Rec.Insert();
            end;
            ImpGdsOpgDecl.Close();
        end;
    end;
}
