page 51005 "ACC Cust. Decl. Statistics"
{
    ApplicationArea = All;
    Caption = 'Báo cáo tờ khai - P51005';
    //DataCaptionExpression = DataCaptionExpressionTxt;
    PageType = List;
    SourceTable = "BLTEC Customs Declaration";
    UsageCategory = ReportsAndAnalysis;
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("BLTEC Customs Declaration No."; Rec."BLTEC Customs Declaration No.")
                {
                    Editable = false;
                }
                field("Declaration Date"; Rec."Declaration Date")
                {
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date") { }
                field("Import Tax"; Rec."Import Tax") { }
                field("Import Tax (GL)"; Rec."Import Tax (GL)") { }
                field("GL Import Tax"; Rec."GL Import Tax") { }
                field("Value Added Tax"; Rec."Value Added Tax") { }
                field("Value Added Tax (GL)"; Rec."Value Added Tax (GL)") { }
                field("GL Value Added Tax"; Rec."GL Value Added Tax") { }
                field("Anti-dumping Tax"; Rec."Anti-dumping Tax") { }
                field("Anti-dumping Tax (GL)"; Rec."Anti-dumping Tax (GL)") { }
                field("GL Anti-dumping Tax"; Rec."GL Anti-dumping Tax") { }
                field("Customs Tax Amount"; Rec."Customs Tax Amount") { }
                field("Ledger Tax Amount"; Rec."Ledger Tax Amount") { }
                field("Total Tax Amount"; Rec."Total Tax Amount") { }
                field("Payment State"; Rec."Payment State") { }
                field(Note; Rec.Note) { }
                field("Customs Office"; Rec."Customs Office") { }
                field("Customs Office Name"; Rec."Customs Office Name") { }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ACCAction)
            {
                Caption = 'Action';
                action(ACCLast2Month)
                {
                    ApplicationArea = All;
                    Caption = 'Last 2 Month';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        BCHelper: Codeunit "BC Helper";
                        FromDate: Date;
                        ToDate: Date;
                    begin
                        FromDate := CalcDate('-CM', TODAY);
                        FromDate := CalcDate('-2M', FromDate);
                        ToDate := CalcDate('CM', FromDate);
                        FromDate := 20250501D;
                        CustomsStatistics(FromDate, ToDate);
                    end;
                }
                action(ACCLastMonth)
                {
                    ApplicationArea = All;
                    Caption = 'Last Month';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        BCHelper: Codeunit "BC Helper";
                        FromDate: Date;
                        ToDate: Date;
                    begin
                        FromDate := CalcDate('-CM', TODAY);
                        FromDate := CalcDate('-1M', FromDate);
                        ToDate := CalcDate('CM', FromDate);
                        CustomsStatistics(FromDate, ToDate);
                    end;
                }
                action(ACCThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'This Month';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        BCHelper: Codeunit "BC Helper";
                        FromDate: Date;
                        ToDate: Date;
                    begin
                        FromDate := CalcDate('-CM', TODAY);
                        ToDate := CalcDate('CM', FromDate);
                        CustomsStatistics(FromDate, ToDate);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
    //CompanyInfo: Record "Company Information";
    begin
        //CompanyInfo.Get();
        //DataCaptionExpressionTxt := StrSubstNo('%1 Báo cáo tờ khai - P51005', CompanyInfo."Custom System Indicator Text");
        Rec.SetFilter("BLTEC Customs Declaration No.", '<>%1', '');
    end;

    local procedure CustomsStatistics(FromDate: Date; ToDate: Date)
    var
        PurchVATDecl: Query "ACC Purch. VAT Tax Decl. Query";
        PaymVATDecla: Query "ACC Paym. VAT Tax Decl. Query";
        InvVATDeclar: Query "ACC Inv. VAT Tax Decl. Query";

        //CustDeclStat: Record "BLTEC Customs Declaration";
        CustDeclTabl: Record "BLTEC Customs Declaration";
        DueDate: Date;
        Forupdate: Boolean;
        CustomsFilter: Text;
    begin
        CustDeclTabl.SetFilter("BLTEC Customs Declaration No.", '<>%1', '');
        CustDeclTabl.SetRange("Declaration Date", FromDate, ToDate);
        if CustDeclTabl.FindSet() then
            repeat
                //if CustDeclTabl.Get(CustDeclTabl."Document No.") then begin
                CustomsFilter := StrSubstNo('*%1', CustDeclTabl."BLTEC Customs Declaration No.");
                CustDeclTabl."Import Tax" := 0;
                CustDeclTabl."Import Tax (GL)" := 0;
                CustDeclTabl."GL Import Tax" := 0;
                CustDeclTabl."Value Added Tax" := 0;
                CustDeclTabl."Value Added Tax (GL)" := 0;
                CustDeclTabl."GL Value Added Tax" := 0;
                CustDeclTabl."Anti-dumping Tax" := 0;
                CustDeclTabl."Anti-dumping Tax (GL)" := 0;
                CustDeclTabl."GL Anti-dumping Tax" := 0;
                if CustDeclTabl."Declaration Date" <> 0D then begin
                    DueDate := CalcDate('CM', CustDeclTabl."Declaration Date");
                    CustDeclTabl."Due Date" := CalcDate('+10D', DueDate);
                end;
                PurchVATDecl.SetFilter(CustomsDeclarationNo, CustomsFilter);
                if PurchVATDecl.Open() then begin
                    while PurchVATDecl.Read() do begin
                        //if PurchVATDecl.VendorPostingGroup = 'IMPORT' then
                        CustDeclTabl."Import Tax" := PurchVATDecl.ImportTaxAmount;
                        //if PurchVATDecl.VendorPostingGroup = 'GTGT' then
                        CustDeclTabl."Value Added Tax" := PurchVATDecl.VATAmount;
                        //if PurchVATDecl.VendorPostingGroup = 'TCPG' then
                        CustDeclTabl."Anti-dumping Tax" := PurchVATDecl.AntiDumpingDutyAmount;
                    end;
                    PurchVATDecl.Close();
                end;
                PaymVATDecla.SetFilter(CustomsDeclarationNo, CustomsFilter);
                if PaymVATDecla.Open() then begin
                    while PaymVATDecla.Read() do begin
                        if PaymVATDecla.VendorPostingGroup = 'IMPORT' then
                            CustDeclTabl."Import Tax (GL)" := PaymVATDecla.AmountLCY;
                        if PaymVATDecla.VendorPostingGroup = 'GTGT' then
                            CustDeclTabl."Value Added Tax (GL)" := PaymVATDecla.AmountLCY;
                        if PaymVATDecla.VendorPostingGroup = 'TCPG' then
                            CustDeclTabl."Anti-dumping Tax (GL)" := PaymVATDecla.AmountLCY;
                    end;
                    PaymVATDecla.Close();
                end;
                InvVATDeclar.SetFilter(CustomsDeclarationNo, CustomsFilter);
                if InvVATDeclar.Open() then begin
                    while InvVATDeclar.Read() do begin
                        if InvVATDeclar.VendorPostingGroup = 'IMPORT' then
                            CustDeclTabl."GL Import Tax" := InvVATDeclar.AmountLCY;
                        if InvVATDeclar.VendorPostingGroup = 'GTGT' then
                            CustDeclTabl."GL Value Added Tax" := InvVATDeclar.AmountLCY;
                        if InvVATDeclar.VendorPostingGroup = 'TCPG' then
                            CustDeclTabl."GL Anti-dumping Tax" := InvVATDeclar.AmountLCY;
                    end;
                    InvVATDeclar.Close();
                end;
                CustDeclTabl."Customs Tax Amount" := Round(CustDeclTabl."Import Tax" + CustDeclTabl."Value Added Tax" + CustDeclTabl."Anti-dumping Tax" + CustDeclTabl."Self-defense Tax");
                CustDeclTabl."Ledger Tax Amount" := CustDeclTabl."Import Tax (GL)" + CustDeclTabl."Value Added Tax (GL)" + CustDeclTabl."Anti-dumping Tax (GL)" + CustDeclTabl."Self-defense Tax (GL)";
                CustDeclTabl."Total Tax Amount" := CustDeclTabl."Customs Tax Amount" - CustDeclTabl."Ledger Tax Amount";

                CustDeclTabl."Payment State" := "ACC Customs Payment State"::None;
                if (CustDeclTabl."Customs Tax Amount" <> 0) AND
                    (CustDeclTabl."Ledger Tax Amount" <> 0) AND
                    (CustDeclTabl."Total Tax Amount" < -50000) then begin
                    CustDeclTabl."Payment State" := "ACC Customs Payment State"::Paymore;
                end;
                if (CustDeclTabl."Customs Tax Amount" <> 0) AND
                    (CustDeclTabl."Ledger Tax Amount" <> 0) AND
                    (CustDeclTabl."Total Tax Amount" > 50000) then begin
                    CustDeclTabl."Payment State" := "ACC Customs Payment State"::Partial;
                end;
                if (CustDeclTabl."Customs Tax Amount" <> 0) AND
                    (CustDeclTabl."Ledger Tax Amount" <> 0) AND
                   ((CustDeclTabl."Total Tax Amount" >= -50000) AND
                    (CustDeclTabl."Total Tax Amount" <= 50000)) then begin
                    CustDeclTabl."Payment State" := "ACC Customs Payment State"::Adjust;
                end;
                if (CustDeclTabl."Customs Tax Amount" = 0) AND
                    (CustDeclTabl."Ledger Tax Amount" <> 0) AND
                    (CustDeclTabl."Total Tax Amount" <> 0) then begin
                    CustDeclTabl."Payment State" := "ACC Customs Payment State"::Ledger;
                end;
                if (CustDeclTabl."Customs Tax Amount" <> 0) AND
                    (CustDeclTabl."Ledger Tax Amount" <> 0) AND
                   ((CustDeclTabl."Total Tax Amount" > -1) AND
                    (CustDeclTabl."Total Tax Amount" < 1)) then begin
                    CustDeclTabl."Payment State" := "ACC Customs Payment State"::Payoff;
                end;
                if (CustDeclTabl."Customs Tax Amount" = 0) AND
                    (CustDeclTabl."Ledger Tax Amount" = 0) AND
                    (CustDeclTabl."Total Tax Amount" = 0) then begin
                    CustDeclTabl."Payment State" := "ACC Customs Payment State"::Payoff;
                end;
                CustDeclTabl.Modify();
            //end;
            until CustDeclTabl.Next() = 0;
    end;

    var
        DataCaptionExpressionTxt: Text;
}
