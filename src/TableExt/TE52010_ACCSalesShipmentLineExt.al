tableextension 52010 "ACC Sales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(52005; "ACC Salesperson Code"; Code[20])
        {
            Caption = 'ACC Salesperson Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Salesperson Code" where("No." = field("Document No.")));
        }
    }
}