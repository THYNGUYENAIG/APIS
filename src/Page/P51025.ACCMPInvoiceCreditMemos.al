page 51025 "ACC MP Invoice & Credit Memos"
{
    ApplicationArea = All;
    Caption = 'ACC MP Actual Sales - P51025';
    PageType = List;
    SourceTable = "ACC MP Invoice & Credit Memos";
    UsageCategory = ReportsAndAnalysis;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(City; Rec.City)
                {
                }
                field("Salesperson Name"; Rec."Salesperson Name")
                {
                }
                field("Sales Order"; Rec."Sales Order")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Lot No."; Rec."Lot No.") { }
                field(Quantity; Rec.Quantity)
                {
                }

                field(Amount; Rec.Amount)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("BU Code"; Rec."BU Code")
                {
                }
                field("Sales Status"; Rec."Sales Status")
                {
                }
                field("Created At"; Rec."Created At") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCFCACalc)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Calc';
                trigger OnAction()
                var
                begin
                    InvocieMemos();
                end;
            }
        }
    }
    local procedure InvocieMemos()
    var
        InvoiLine: Query "ACC MP Invoice Line Qry";
        MemosLine: Query "ACC MP Credit Memos Line Qry";
        SalesLine: Query "ACC MP Sales Line Qry";
        InvoMemos: Record "ACC MP Invoice & Credit Memos";
    begin
        InvoMemos.Reset();
        InvoMemos.DeleteAll();
        If InvoiLine.Open() then begin
            while InvoiLine.Read() do begin
                InvoMemos.Init();
                InvoMemos."Sales Order" := InvoiLine.OrderNo;
                InvoMemos."Invoice No." := InvoiLine.DocumentNo;
                InvoMemos."Line No." := InvoiLine.LineNo;
                InvoMemos."Customer No." := InvoiLine.SelltoCustomerNo;
                InvoMemos."Customer Name" := InvoiLine.SelltoCustomerName;
                InvoMemos."Posting Date" := InvoiLine.PostingDate;
                InvoMemos."Item No." := InvoiLine.ItemNo;
                InvoMemos."Item Name" := InvoiLine.ItemName;
                InvoMemos.Quantity := -InvoiLine.Quantity;
                InvoMemos."Unit Price" := InvoiLine.UnitPrice;
                InvoMemos.Amount := InvoiLine.Amount;
                InvoMemos."Branch Code" := CopyStr(InvoiLine.LocationCode, 1, 2);
                InvoMemos."BU Code" := InvoiLine.BusinessUnit;
                InvoMemos."Location Code" := InvoiLine.LocationCode;
                InvoMemos.City := InvoiLine.City;
                InvoMemos."Salesperson Name" := InvoiLine.SalespersonName;
                InvoMemos."Sales Status" := 'Invoiced';
                InvoMemos."Lot No." := InvoiLine.LotNo;
                InvoMemos.Insert();
            end;
            InvoiLine.Close();
        end;
        If MemosLine.Open() then begin
            while MemosLine.Read() do begin
                InvoMemos.Init();
                InvoMemos."Sales Order" := MemosLine.OrderNo;
                InvoMemos."Invoice No." := MemosLine.DocumentNo;
                InvoMemos."Line No." := MemosLine.LineNo;
                InvoMemos."Customer No." := MemosLine.SelltoCustomerNo;
                InvoMemos."Customer Name" := MemosLine.SelltoCustomerName;
                InvoMemos."Posting Date" := MemosLine.PostingDate;
                InvoMemos."Item No." := MemosLine.ItemNo;
                InvoMemos."Item Name" := MemosLine.ItemName;
                InvoMemos.Quantity := -MemosLine.Quantity;
                InvoMemos."Unit Price" := MemosLine.UnitPrice;
                InvoMemos.Amount := MemosLine.Amount;
                InvoMemos."Branch Code" := CopyStr(MemosLine.LocationCode, 1, 2);
                InvoMemos."BU Code" := MemosLine.BusinessUnit;
                InvoMemos."Location Code" := MemosLine.LocationCode;
                InvoMemos.City := MemosLine.City;
                InvoMemos."Salesperson Name" := MemosLine.SalespersonName;
                InvoMemos."Sales Status" := 'Invoiced';
                InvoMemos."Lot No." := MemosLine.LotNo;
                InvoMemos.Insert();
            end;
            MemosLine.Close();
        end;

        If SalesLine.Open() then begin
            while SalesLine.Read() do begin
                InvoMemos.Init();
                InvoMemos."Sales Order" := SalesLine.OrderNo;
                InvoMemos."Invoice No." := SalesLine.DocumentNo;
                InvoMemos."Line No." := SalesLine.LineNo;
                InvoMemos."Customer No." := SalesLine.SelltoCustomerNo;
                InvoMemos."Customer Name" := SalesLine.SelltoCustomerName;
                InvoMemos."Posting Date" := SalesLine.PostingDate;
                InvoMemos."Item No." := SalesLine.ItemNo;
                InvoMemos."Item Name" := SalesLine.ItemName;
                InvoMemos.Quantity := SalesLine.Quantity;
                InvoMemos."Unit Price" := SalesLine.UnitPrice;
                InvoMemos.Amount := SalesLine.Amount;
                InvoMemos."Branch Code" := CopyStr(SalesLine.LocationCode, 1, 2);
                InvoMemos."BU Code" := SalesLine.BusinessUnit;
                InvoMemos."Location Code" := SalesLine.LocationCode;
                InvoMemos.City := SalesLine.City;
                InvoMemos."Salesperson Name" := SalesLine.SalespersonName;
                InvoMemos."Sales Status" := 'Open Order';
                InvoMemos."Lot No." := '';
                InvoMemos."Created At" := SalesLine.SystemCreatedAt;
                InvoMemos.Insert();
            end;
            SalesLine.Close();
        end;
    end;
}
