table 51021 "AHH Sales Statistics"
{
    Caption = 'AHH Sales Statistics';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Sales No."; Code[20])
        {
            Caption = 'Sales No.';
            TableRelation = "Sales Header"."No.";
        }
        field(11; "Document No."; Code[20])
        {
            Caption = 'Sales No.';
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(13; "eInvoice No."; Code[30])
        {
            Caption = 'eInvoice No.';
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = "AHH Customer"."Customer No.";
        }
        field(30; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
        }
        field(40; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(50; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLTEC Item Name" where("No." = field("Item No.")));
        }
        field(60; UnitId; Code[10])
        {
            Caption = 'UnitId';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }
        field(70; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(80; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 2;
        }
        field(90; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 2;
        }
        field(100; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            DecimalPlaces = 0 : 2;
        }
        field(101; "Cost Price"; Decimal)
        {
            Caption = 'Cost Price';
            DecimalPlaces = 0 : 2;
        }
        field(110; GM1; Decimal)
        {
            Caption = 'GM1';
            DecimalPlaces = 0 : 2;
        }
        field(120; "Charge Amount"; Decimal)
        {
            Caption = 'Charge Amount';
            DecimalPlaces = 0 : 2;
        }
        field(130; GM2; Decimal)
        {
            Caption = 'GM2';
            DecimalPlaces = 0 : 2;
        }
        field(140; "BU Code"; Code[10])
        {
            Caption = 'BU Code';
        }
        field(150; Salesperson; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(151; "Salesperson Name"; Text[100])
        {
            Caption = 'Salesperson Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field(Salesperson)));
        }
        field(160; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(170; "Commission Entry No."; Integer)
        {
            Caption = 'Commission Entry No.';
            Editable = false;
            TableRelation = "AHH Commission Price"."Entry No.";
        }
        field(180; "Commission Price"; Decimal)
        {
            Caption = 'Commission Price';
            DecimalPlaces = 0 : 2;
        }
        field(190; "Sales Return"; Boolean)
        {
            Caption = 'Sales Return';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
