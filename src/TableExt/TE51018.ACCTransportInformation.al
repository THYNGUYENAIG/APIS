tableextension 51018 "ACC Transport Information" extends "BLACC Transport Information"
{
    fields
    {
        field(50001; "ACC Storage Condition"; Code[20])
        {
            Caption = 'Storage Condition';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Storage Condition" where("No." = field("BLACC Item No.")));
        }
    }
}
