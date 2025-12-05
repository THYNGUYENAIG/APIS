tableextension 52013 "ACC Requisition Line Ext" extends "Requisition Line"
{
    fields
    {
        field(50001; "ACC Chemical Categorization"; Text[250])
        {
            Caption = 'Phân Loại Hóa Chất';
            Editable = false;
        }

        field(50002; "ACC Origin of Country Code"; Code[10])
        {
            Caption = 'Origin of Country Code';
            TableRelation = "Country/Region";
            Editable = false;
        }

        field(50008; "ACC Origin of Country Name"; Text[50])
        {
            Caption = 'Origin of Country Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region".Name where("Code" = field("ACC Origin of Country Code")));
        }
    }
}