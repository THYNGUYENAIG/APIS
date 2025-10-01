pageextension 51034 "ACC Posted Sales Invoice Lines" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
            }
        }
        addafter(Amount)
        {
            field("ACC Cost Amount Posted"; Rec."ACC Cost Amount Posted")
            {
                ApplicationArea = All;
                Caption = 'Cost Amt.';
            }
            field("ACC Cost Amount Adjustment"; Rec."ACC Cost Amount Adjustment")
            {
                ApplicationArea = All;
                Caption = 'Cost Amt. Adjust.';
            }
            field("Salesperson Name"; SalespersonName)
            {
                ApplicationArea = All;
            }
        }        
    }
    trigger OnAfterGetRecord()
    var
        SalesInvHeader: Record "Sales Invoice Header";
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if SalesInvHeader.Get(Rec."Document No.") then begin
            if Salesperson.Get(SalesInvHeader."Salesperson Code") then
                SalespersonName := Salesperson.Name;
        end;
    end;

    var
        SalespersonName: Text;
}
