tableextension 52007 "ACC Bin Content Ext" extends "Bin Content"
{
    fields
    {
        field(52005; "ACC Item Name"; Text[150])
        {
            Caption = 'Item Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item".Description where("No." = field("Item No.")));
        }
    }
}