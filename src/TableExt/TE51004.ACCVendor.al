tableextension 51004 "ACC Vendor" extends Vendor
{
    fields
    {
        field(50001; "ACC Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            DataClassification = ToBeClassified;
        }
        field(50002; "ACC Planner Code"; Code[20])
        {
            Caption = 'Planner Code';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(50003; "ACC Planner Name"; Text[50])
        {
            Caption = 'Planner Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("ACC Planner Code")));
        }
        field(50004; "ACC Accounting Code"; Code[20])
        {
            Caption = 'Accounting Code';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(50005; "ACC Accounting Name"; Text[50])
        {
            Caption = 'Accounting Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("ACC Accounting Code")));
        }
    }
}
