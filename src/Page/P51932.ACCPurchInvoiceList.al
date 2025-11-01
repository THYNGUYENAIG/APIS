page 51932 "ACC Purchase Invoice List"
{
    ApplicationArea = All;
    Caption = 'APIS Purch. Invoice List';
    PageType = List;
    SourceTable = "AIG Value Entry Relation";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Table No." = filter(123 | 125));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Invoice No."; Rec."Invoice No.") { }
                field("Invoice Line No."; Rec."Invoice Line No.") { }
                field("Source No."; Rec."Source No.") { }
                field("Source Name"; Rec."Source Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Unit Code"; Rec."Unit Code") { }
                field(Quantity; Rec.Quantity) { }
                field("Unit Price"; Rec."Unit Price") { }
                field("Line Amount"; Rec."Line Amount") { }
                field("Exchange Rate"; Rec."Exchange Rate") { }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)") { }
                field("Document Date"; Rec."Document Date") { }
                field("Due Date"; Rec."Due Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("Declaration No."; Rec."Declaration No.") { }
                field("External Document No."; Rec."External Document No.") { }
            }
        }
    }
    trigger OnOpenPage()
    var
        ValueEntry: Codeunit "AIG Value Entry Relation";
    begin
        ValueEntry.SetPurchValueEntry();
    end;
}
