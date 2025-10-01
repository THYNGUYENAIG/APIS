tableextension 51006 "ACC Whse. Pick Request" extends "Whse. Pick Request"
{
    fields
    {
        field(50001; "Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Header"."ACC Requested Delivery Date" where("No." = field("Document No."),
                                                                                                 "ACC Source No." = filter(<> '')));
        }
    }
}
