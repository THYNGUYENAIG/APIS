tableextension 51014 "ACC Claim Insurance Entry" extends "BLACC Claim Insurance Entry"
{
    fields
    {
        field(50001; "Insurance Agent"; Text[500])
        {
            Caption = 'Insurance Agent';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Import Entry"."BLTEC Insurance Agent" where("Purchase Order No." = field("Purchase Order"),
                                                                                    "Line No." = field("Purchase Line No.")));
        }
    }
}
