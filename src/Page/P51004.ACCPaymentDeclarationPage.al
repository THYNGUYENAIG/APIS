page 51004 "ACC Payment Declaration Page"
{
    ApplicationArea = All;
    Caption = 'Thanh toán theo tờ khai - P51004';
    PageType = List;
    SourceTable = "ACC Payment Declaration Table";
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
                field("Financial Date"; Rec."Financial Date") { }
                field("Due Date"; Rec."Due Date") { }
                field(Invoice; Rec.Invoice) { }
                field("Invoice Description"; Rec."Invoice Description") { }
                field("Document No."; Rec."Document No.") { }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.") { }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name") { }
                field("Terms Of Payment"; Rec."Terms Of Payment") { }
                field("Payment Terms Name"; Rec."Payment Terms Name") { }
                field("Payment Status"; Rec."Payment Status") { }
                field("Bank Name"; Rec."Bank Name") { }
                field(Amount; Rec.Amount) { }
                field("Amount (GL)"; Rec."Amount (GL)") { }
                field(Balance; Rec.Balance) { }
                field("Currency Code"; Rec."Currency Code") { }
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
                action(ACCDIFF)
                {
                    ApplicationArea = All;
                    Caption = 'Hàng nhập khẩu chênh lệch tờ khai so với nhập kho';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "ACC Imp. Gds Diff. Decl. Page";
                }
                */
            }
        }
    }
    trigger OnOpenPage()
    var
        PaymentDecl: Query "ACC Payment Declaration Query";
        SettleDecla: Query "ACC Settle Declaration Query";
        PaymentTerm: Query "ACC PaymTerm Declaration Query";
        CustomsDecl: Record "BLTEC Customs Declaration";
        VendBankAcc: Record "Vendor Bank Account";
        BankAccount: Record "Bank Account";
        PaymentNo: Integer;
    begin
        PaymentDecl.SetFilter(PaymentDecl.DeclarationNo, '>%1', '');
        if PaymentDecl.Open() then begin
            while PaymentDecl.Read() do begin
                PaymentNo := PaymentNo + 1;
                Rec.Init();
                Rec."No." := StrSubstNo('PD_%1', PaymentNo);
                if PaymentDecl.DeclarationNo <> '' then begin
                    Rec."Customs Declaration No." := PaymentDecl.DeclarationNo;
                end else begin
                    Rec."Customs Declaration No." := PaymentDecl.CustomsDeclarationNo;
                end;

                Rec."Customs Declaration Date" := PaymentDecl.DeclarationDate;
                if Rec."Customs Declaration No." <> '' then begin
                    CustomsDecl.SetRange("BLTEC Customs Declaration No.", Rec."Customs Declaration No.");
                    if CustomsDecl.FindFirst() then
                        Rec."Customs Area" := CustomsDecl."BLTEC Customs Office";
                end;
                Rec."Document No." := PaymentDecl.DocumentNo;
                Rec."Buy-from Vendor No." := PaymentDecl.VendorNo;
                Rec."Buy-from Vendor Name" := PaymentDecl.VendorName;
                Rec.Invoice := PaymentDecl.ExternalDocumentNo;
                Rec."Invoice Description" := PaymentDecl.Description;
                Rec."Financial Date" := PaymentDecl.PostingDate;
                Rec."Due Date" := PaymentDecl.DueDate;
                Rec."Currency Code" := PaymentDecl.CurrencyCode;
                PaymentTerm.SetRange(DeclarationNo, PaymentDecl.DeclarationNo);
                if PaymentTerm.Open() then begin
                    if PaymentTerm.Read() then begin
                        Rec."Terms Of Payment" := PaymentTerm.PaymentTermsCode;
                        Rec."Payment Terms Name" := PaymentTerm.Description;
                    end;
                    PaymentTerm.Close();
                end;
                Rec.Amount := PaymentDecl.Amount;
                Rec."Amount (GL)" := PaymentDecl.AmountLCY;
                Rec.Balance := PaymentDecl.RemainingAmount;
                Rec."Payment Status" := PaymentDecl.DocumentType;
                Rec.Insert();
            end;
            PaymentDecl.Close();
        end;
        SettleDecla.SetFilter(SettleDecla.DeclarationNo, '>%1', '');
        if SettleDecla.Open() then begin
            while SettleDecla.Read() do begin
                PaymentNo := PaymentNo + 1;
                Rec.Init();
                Rec."No." := StrSubstNo('PD_%1', PaymentNo);
                if SettleDecla.DeclarationNo <> '' then begin
                    Rec."Customs Declaration No." := SettleDecla.DeclarationNo;
                end else begin
                    Rec."Customs Declaration No." := SettleDecla.CustomsDeclarationNo;
                end;

                Rec."Customs Declaration Date" := SettleDecla.DeclarationDate;
                if Rec."Customs Declaration No." <> '' then begin
                    CustomsDecl.SetRange("BLTEC Customs Declaration No.", Rec."Customs Declaration No.");
                    if CustomsDecl.FindFirst() then
                        Rec."Customs Area" := CustomsDecl."BLTEC Customs Office";
                end;
                Rec."Document No." := SettleDecla.DocumentNo;
                Rec."Buy-from Vendor No." := SettleDecla.VendorNo;
                Rec."Buy-from Vendor Name" := SettleDecla.VendorName;
                Rec.Invoice := SettleDecla.ExternalDocumentNo;
                Rec."Invoice Description" := SettleDecla.Description;
                Rec."Financial Date" := SettleDecla.PostingDate;
                Rec."Due Date" := SettleDecla.DueDate;
                Rec."Currency Code" := SettleDecla.CurrencyCode;

                if BankAccount.Get(SettleDecla.BalAccountNo) then
                    Rec."Bank Name" := BankAccount.Name;
                Rec.Amount := SettleDecla.Amount;
                Rec."Amount (GL)" := SettleDecla.AmountLCY;
                Rec."Payment Status" := SettleDecla.DocumentType;
                Rec.Insert();
            end;
            SettleDecla.Close();
        end;
    end;
}
