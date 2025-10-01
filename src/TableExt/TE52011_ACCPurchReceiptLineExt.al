tableextension 52011 "ACC Purch Receipt Line Ext" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(52005; "ACC Purchase Name"; Text[250])
        {
            Caption = 'ACC Purchase Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."BLACC Purchase Name" where("No." = field("No.")));
        }
        field(52010; "ACC Ecus - Item Name"; Text[2048])
        {
            Caption = 'ACC Ecus - Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."BLTEC Item Name" where("No." = field("No.")));
        }
    }
}