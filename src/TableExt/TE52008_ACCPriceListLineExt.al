tableextension 52008 "ACC Price List Line Ext" extends "Price List Line"
{
    fields
    {
        field(52005; "ACC Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Product No.")));
        }
        field(52010; "ACC Header Description"; Text[250])
        {
            Caption = 'ACC Header Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Price List Header".Description where("Code" = field("Price List Code")));
        }
    }
}