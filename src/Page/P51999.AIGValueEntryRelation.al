page 51999 "AIG Value Entry Relation"
{
    ApplicationArea = All;
    Caption = 'AIG Value Entry Relation';
    PageType = List;
    SourceTable = "AIG Value Entry Relation";
    UsageCategory = Administration;
    InsertAllowed = false;
    //DeleteAllowed = false;
    //Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Row ID"; Rec."Source Row ID") { }
                field("Table No."; Rec."Table No.") { }
                field("Invoice No."; Rec."Invoice No.") { }
                field("Invoice Line No."; Rec."Invoice Line No.") { }
                field("Order No."; Rec."Order No.") { }
                field("Order Line No."; Rec."Order Line No.") { }
                field("Source No."; Rec."Source No.") { }
                field("Source Name"; Rec."Source Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Unit Code"; Rec."Unit Code") { }
                field(Quantity; Rec.Quantity) { }
                field("Unit Price"; Rec."Unit Price") { }
                field("Line Amount"; Rec."Line Amount") { }
                field("VAT Amount"; Rec."VAT Amount") { }
                field("Unit Cost"; Rec."Unit Cost") { }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)") { }
                field("Cost Amount Posted"; Rec."Cost Amount Posted") { }
                field("Cost Amount Adjustment"; Rec."Cost Amount Adjustment") { }
                field("Charge Amount"; Rec."Charge Amount") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Declaration No."; Rec."Declaration No.") { }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Due Date"; Rec."Due Date") { }
                field("Whse. Date"; Rec."Whse. Date") { }
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
                Image = Calculate;
                Caption = 'Init';
                trigger OnAction()
                var
                    AIGValueEntry: Codeunit "AIG Value Entry Relation";
                begin
                    AIGValueEntry.SetInitValueEntry();
                end;
            }
            action(ACCCalc)
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Calc';
                trigger OnAction()
                var
                    AIGValueEntry: Codeunit "AIG Value Entry Relation";
                begin
                    AIGValueEntry.SetSalesValueEntry();
                    AIGValueEntry.SetPurchValueEntry();
                end;
            }
            action(ACCReset)
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Reset';
                trigger OnAction()
                var
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                end;
            }
        }
    }
}
