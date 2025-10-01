tableextension 52003 "ACC WH Shipment Header Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(52005; "ACC Source No."; Text[1000])
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC Source No.';
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
    }
}