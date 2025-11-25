tableextension 52003 "ACC WH Shipment Header Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(52005; "ACC Source No."; Text[1000])
        {
            Caption = 'ACC Source No.';
            DataClassification = ToBeClassified;
            //Editable = false;
            //FieldClass = FlowField;
            //CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("No.")));
        }
        field(52006; "Printed No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Printed No.';
        }
        field(52007; "ACC Requested Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Requested Delivery Date';
        }
        field(52008; "ACC Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No';
        }
        field(52009; "ACC Customer Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
        }
        field(52010; "ACC Delivery Address"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Delivery Address';
        }

        field(52011; "ACC Delivery Note"; Text[2024])
        {
            DataClassification = ToBeClassified;
            Caption = 'Delivery Note';
        }
        field(52012; "ACC Total Quantity"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 2;
            Caption = 'Total Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Shipment Line".Quantity where("No." = field("No.")));
        }
        field(52013; "ACC Total OutStanding"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 2;
            Caption = 'Total OutStanding';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Shipment Line"."Qty. Outstanding" where("No." = field("No.")));
        }
        field(52014; "ACC Quantity Picked"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 2;
            Caption = 'Quantity Picked';
            FieldClass = FlowField;
            CalcFormula = - sum("Warehouse Entry"."Qty. (Base)" where("Whse. Document No." = field("No."),
                                                                      "Zone Code" = filter('PUTPICK')));
        }
    }
}