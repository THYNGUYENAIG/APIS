table 51030 "ACC Sales Review"
{
    Caption = 'APIS Sales Review';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(10; "Sales Order"; Code[20])
        {
            Caption = 'Sales Order';
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sell-to Customer Name" where("No." = field("Sales Order")));
        }
        field(12; "Status"; Text[30])
        {
            Caption = 'Status';
        }

        field(13; "Requested Date"; Date)
        {
            Caption = 'Requested Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Requested Delivery Date" where("No." = field("Sales Order")));
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(31; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula = lookup(Item."BLTEC Item Name" where("No." = field("Item No.")));
            CalcFormula = lookup("Sales Line"."BLTEC Item Name" where("Document No." = field("Sales Order"),
                                                                      "Line No." = field("Line No.")));
        }
        field(32; Quantity; Decimal)
        {
            Caption = 'Lot Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(33; "Sales Quantity"; Decimal)
        {
            Caption = 'Sales Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(40; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(50; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(60; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(70; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
    }
    keys
    {
        key(PK; "Sales Order", "Line No.", "Lot No.")
        {
            Clustered = true;
        }
    }
}
