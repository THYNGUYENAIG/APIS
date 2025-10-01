table 51921 "ACC MP Sales Line Available"
{
    Caption = 'ACC MP Sales Line Available';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Sales No."; Code[20])
        {
            Caption = 'Sales No.';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(40; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
        }
        field(50; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(60; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(61; Period; Integer)
        {
            Caption = 'Period';
        }
        field(70; "Requested Date"; Date)
        {
            Caption = 'Requested Date';
        }
        field(80; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(81; "Site Code"; Code[20])
        {
            Caption = 'Site Code';
        }
        field(82; "Sales Filter"; Boolean)
        {
            Caption = 'Sales Filter';
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(91; "Total Quantity"; Decimal)
        {
            Caption = 'Total Quantity';
        }
        field(100; "Onhand"; Decimal)
        {
            Caption = 'Onhand';
            DecimalPlaces = 0 : 3;
        }
        field(101; "Remaining"; Decimal)
        {
            Caption = 'Remaining';
            DecimalPlaces = 0 : 3;
        }
        field(110; "Available"; Decimal)
        {
            Caption = 'Available';
            DecimalPlaces = 0 : 3;
        }
        field(120; "Line Created At"; DateTime)
        {
            Caption = 'Line Created At';
        }
        field(130; "Manufacturing Policy"; Enum "Manufacturing Policy")
        {
            Caption = 'Manufacturing Policy';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Manufacturing Policy" where("No." = field("Item No.")));
        }
        field(140; "BU Code"; Code[20])
        {
            Caption = 'BU Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Shortcut Dimension 2 Code" where("Document No." = field("Sales No."),
                                                                                "Line No." = field("Line No.")));
        }
    }
    keys
    {
        key(PK; "Sales No.", "Line No.")
        {
            Clustered = true;
        }
        key(PKItemSite; "Item No.", "Site Code")
        {
            SumIndexFields = Quantity;
        }
    }
}
