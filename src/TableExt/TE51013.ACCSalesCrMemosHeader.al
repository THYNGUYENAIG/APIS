tableextension 51013 "ACC Sales Cr.Memos Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50001; "Salesperson Name"; Text[100])
        {
            Caption = 'Salesperson Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Salesperson Code")));
        }
    }
}
