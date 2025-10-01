tableextension 51003 "ACC Item" extends Item
{
    fields
    {
        field(50001; "ACC Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = ToBeClassified;
        }
        field(50002; "ACC Planner Code"; Code[20])
        {
            Caption = 'Planner Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."ACC Planner Code" where("No." = field("Vendor No.")));
        }
        field(50003; "ACC BU Ref"; Code[20])
        {
            Caption = 'BU Ref';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
    }
}
