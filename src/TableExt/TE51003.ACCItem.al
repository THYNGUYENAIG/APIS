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

        modify("BLACC Lot Default Lock")
        {
            trigger OnAfterValidate()
            var
                BLACCItemConditions: Record "BLACC Item Conditions";
                BLACCLocationConditions: Record "BLACC Location Conditions";
            begin
                if Rec."BLACC Lot Default Lock" then begin
                    if Rec."BLACC Item Conditions Default" = '' then
                        if BLACCItemConditions.Get('CCHUNGTHU') then
                            Rec."BLACC Item Conditions Default" := 'CCHUNGTHU';
                    if Rec."BLACC Location Con. Default" = '' then
                        if BLACCLocationConditions.Get('CCHUNGTHU') then
                            Rec."BLACC Location Con. Default" := 'CCHUNGTHU';
                end;
            end;
        }
    }
}
