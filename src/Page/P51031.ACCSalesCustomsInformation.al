page 51031 "ACC Sales Customs Information"
{
    ApplicationArea = All;
    Caption = 'APIS Sales Customs Information - P51031';
    PageType = List;
    SourceTable = "ACC Sales Customs Information";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Declaration No."; Rec."Declaration No.") { }
                field("Purch. No."; Rec."Purch. No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Lot No."; Rec."Lot No.") { }
                field("Sales No."; Rec."Sales No.") { }
                field("Sales Name"; Rec."Sales Name") { }
                field("Invoice Account"; Rec."Invoice Account") { }
                field("Invoice Name"; Rec."Invoice Name") { }
                field("Invoice Date"; Rec."Invoice Date") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCInit)
            {
                ApplicationArea = All;
                Image = Info;
                Caption = 'Init';
                trigger OnAction()
                var
                begin
                    SalesCustomsInit();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        SalesCustoms();
    end;

    local procedure SalesCustomsInit()
    var
        AIGValueEntry: Codeunit "AIG Value Entry Relation";
        SalesInfor: Query "ACC Sales Customs Lot Qry";
        PurchNo: Text;
        CustomsNo: Text;
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-CM', Today);
        FromDate := CalcDate('-3M', FromDate);
        ToDate := Today;
        AIGValueEntry.SetSalesValueEntry();
        AIGValueEntry.SetPurchValueEntry();
        Rec.Reset();
        Rec.DeleteAll();
        SalesInfor.SetRange(PostingDate, FromDate, ToDate);
        if SalesInfor.Open() then begin
            while SalesInfor.Read() do begin
                if not Rec.Get(SalesInfor.OrderNo, SalesInfor.ItemNo, SalesInfor.LotNo) then begin
                    Rec.Init();
                    Rec."Sales No." := SalesInfor.OrderNo;
                    Rec."Sales Name" := SalesInfor.SourceName;
                    Rec."Item No." := SalesInfor.ItemNo;
                    Rec."Item Name" := SalesInfor.Description;
                    Rec."Lot No." := SalesInfor.LotNo;
                    Rec."Invoice Date" := SalesInfor.PostingDate;
                    PurchCustoms(SalesInfor.ItemNo, SalesInfor.LotNo, PurchNo, CustomsNo);
                    Rec."Purch. No." := PurchNo;
                    Rec."Declaration No." := CustomsNo;
                    Rec.Insert();
                end;
            end;
            SalesInfor.Close();
        end;
    end;

    local procedure SalesCustoms()
    var
        AIGValueEntry: Codeunit "AIG Value Entry Relation";
        SalesInfor: Query "ACC Sales Customs Lot Qry";
        PurchNo: Text;
        CustomsNo: Text;
        FromDate: Date;
        ToDate: Date;
    begin
        FromDate := CalcDate('-14D', Today);
        ToDate := Today;
        AIGValueEntry.SetSalesValueEntry();
        AIGValueEntry.SetPurchValueEntry();
        SalesInfor.SetRange(PostingDate, FromDate, ToDate);
        if SalesInfor.Open() then begin
            while SalesInfor.Read() do begin
                if not Rec.Get(SalesInfor.OrderNo, SalesInfor.ItemNo, SalesInfor.LotNo) then begin
                    Rec.Init();
                    Rec."Sales No." := SalesInfor.OrderNo;
                    Rec."Sales Name" := SalesInfor.SourceName;
                    Rec."Item No." := SalesInfor.ItemNo;
                    Rec."Item Name" := SalesInfor.Description;
                    Rec."Lot No." := SalesInfor.LotNo;
                    Rec."Invoice Date" := SalesInfor.PostingDate;
                    PurchCustoms(SalesInfor.ItemNo, SalesInfor.LotNo, PurchNo, CustomsNo);
                    Rec."Purch. No." := PurchNo;
                    Rec."Declaration No." := CustomsNo;
                    Rec.Insert();
                end;
            end;
            SalesInfor.Close();
        end;
    end;

    local procedure PurchCustoms(ItemNo: Text; LotNo: Text; var PurchNo: Text; var CustomsNo: Text)
    var
        PurchInfor: Query "ACC Purchase Customs Lot Qry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        FromDate: Date;
        ToDate: Date;
    begin
        PurchInfor.SetRange(ItemNo, ItemNo);
        PurchInfor.SetRange(LotNo, LotNo);
        if PurchInfor.Open() then begin
            while PurchInfor.Read() do begin
                PurchNo := PurchInfor.OrderNo;
                CustomsNo := PurchInfor.DeclarationNo;
                break;
            end;
            PurchInfor.Close();
        end;
        if (PurchNo = '') OR (CustomsNo = '') then begin
            FromDate := 20220801D;
            ToDate := 20250531D;
            ItemLedgerEntry.Reset();
            ItemLedgerEntry.SetRange("Posting Date", FromDate, ToDate);
            ItemLedgerEntry.SetRange("Entry Type", "Item Ledger Entry Type"::"Positive Adjmt.");
            ItemLedgerEntry.SetRange("Item No.", ItemNo);
            ItemLedgerEntry.SetRange("Lot No.", LotNo);
            if ItemLedgerEntry.FindFirst() then begin
                PurchNo := ItemLedgerEntry."Document No.";
                CustomsNo := 'OPENING';
            end;
        end;
    end;
}
