tableextension 52006 "ACC Gen Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(52005; "ACC Statistic Group"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Statistic Group';
        }
        field(52010; "ACC Dimension Value ID"; Integer)
        {
            Caption = 'Dimension Value ID';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value ID"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Name" = const('Customer')));
        }
        field(52015; "ACC Customer Name Dimension"; Text[50])
        {
            Caption = 'Customer Name Dimension';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value"."Name" where("Dimension Value ID" = field("ACC Dimension Value ID"), "Global Dimension No." = const(7)));
        }
    }
}