table 51018 "ACC Whse Shipment Details"
{
    Caption = 'ACC Whse Shipment Details';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Sales Order"; Code[20])
        {
            Caption = 'Sales Order';
        }
        field(18; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(3; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
        }
        field(4; "Delivery Address"; Text[250])
        {
            Caption = 'Delivery Address';
        }
        field(5; "Delivery Note"; Text[2048])
        {
            Caption = 'Delivery Note';
        }
        field(6; "Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
        }
        field(7; Status; Enum "Warehouse Shipment Status")
        {
            Caption = 'Status';
        }
        field(8; "Source Document"; Enum "Warehouse Activity Source Document")
        {
            Caption = 'Source Document';
        }
        field(9; "Whse. Shipment No."; Code[20])
        {
            Caption = 'Whse. Shipment No.';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(11; "Item Name"; Text[255])
        {
            Caption = 'Item Name';
        }
        field(12; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 3;
        }
        field(13; "Packing Group"; Code[20])
        {
            Caption = 'Packing Group';
        }
        field(14; "Quantity (Packing)"; Decimal)
        {
            Caption = 'Quantity (Packing)';
            DecimalPlaces = 0 : 3;
        }
        field(15; "Lot No."; Code[35])
        {
            Caption = 'Lot No.';
        }
        field(16; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(17; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(19; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(20; "Payment Term Code"; Code[20])
        {
            Caption = 'Payment Term Code';
        }
        field(21; "Payment Term Name"; Text[100])
        {
            Caption = 'Payment Term Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Terms".Description where(Code = field("Payment Term Code")));
        }
        field(22; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Unit Price" where("Document No." = field("Sales Order"),
                                                                 "Line No." = field("Line No.")));
        }
        field(23; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."BLACC Agreement No." where("No." = field("Sales Order")));
        }
        field(24; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
        }
        field(25; "Salesperson Name"; Text[100])
        {
            Caption = 'Salesperson Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Salesperson Code")));
        }
        field(26; "Bill to Customer No."; Code[20])
        {
            Caption = 'Bill to Customer No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Bill-to Customer No." where("No." = field("Sales Order")));
        }
        field(27; "Bill to Customer Name"; Text[100])
        {
            Caption = 'Bill to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Bill-to Name" where("No." = field("Sales Order")));
        }
        field(28; "Responsibility Center"; Code[10])
        {
            Caption = 'BU Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Responsibility Center" where("No." = field("Sales Order")));
        }
        field(30; "Purchase Name"; Text[250])
        {
            Caption = 'Purchase Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."BLACC Purchase Name" where("No." = field("Item No.")));
        }
        field(35; "Ecus - Item Name"; Text[2048])
        {
            Caption = 'Ecus - Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."BLTEC Item Name" where("No." = field("Item No.")));
        }
    }
    keys
    {
        key(PK; "Sales Order", "Line No.", "Whse. Shipment No.", "Item No.", "Lot No.")
        {
            Clustered = true;
        }
    }
}
