pageextension 52006 "ACC Lot No Info Card Ext" extends "Lot No. Information Card"
{
    layout
    {
        addlast(General)
        {
            field("ACC UnBlock Created By"; Rec."ACC UnBlock Created By")
            {
                ApplicationArea = All;
                Caption = 'ACC UnBlock Created By';
                Editable = false;
            }

            field("ACC UnBlock Created At"; Rec."ACC UnBlock Created At")
            {
                ApplicationArea = All;
                Caption = 'ACC UnBlock Created At';
                Editable = false;
            }
        }
        modify("BLACC Manufacturing Date")
        {
            Visible = true;
        }
        addafter("BLACC Expiration Date")
        {
            field("ACC Receipt Date"; Rec."ACC Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Date field.', Comment = '%';
            }
            field("ACC Receipt Location"; Rec."ACC Receipt Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Date field.', Comment = '%';
            }
            field("ACC Custom Declaration No"; Rec."ACC Custom Declaration No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Declaration No. field.', Comment = '%';
            }
            field("ACC PO No"; Rec."ACC PO No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Location field.', Comment = '%';
            }
        }

        modify(Blocked)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Blocked = false then begin
                    Rec."ACC UnBlock Created At" := CurrentDateTime;
                    Rec."ACC UnBlock Created By" := UserId;
                end;
            end;
        }
    }
}