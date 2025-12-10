pageextension 52005 "ACC Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        addafter(Status)
        {
            field("ACC Customs Declaration No."; Rec."ACC Customs Declaration No.")
            {
                ApplicationArea = All;
                Caption = 'ACC Customs Declaration No.';
                TableRelation = "BLTEC Customs Declaration"."BLTEC Customs Declaration No." where("BLTEC Customs Declaration No." = filter(<> ''));
                Editable = Rec.Status = "Purchase Document Status"::Open;

                trigger OnValidate()
                begin
                    if Rec."ACC Customs Declaration No." <> '' then Rec."Vendor Invoice No." := Rec."ACC Customs Declaration No." else Rec."Vendor Invoice No." := '';
                end;
            }
        }
    }
}