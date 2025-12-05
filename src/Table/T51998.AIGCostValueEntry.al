table 51998 "AIG Cost Value Entry"
{
    Caption = 'APIS Cost Value Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
        }
        field(40; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            Editable = false;
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry No." = field("Item Ledger Entry No."),
                                                                         "Posting Date" = field("Posting Date"),
                                                                         //"Gen. Prod. Posting Group" = filter('GOODS|FG|SERVICE-511'),
                                                                         Adjustment = filter(false)));
        }
        field(50; "Cost Amount Adjustment"; Decimal)
        {
            Caption = 'Cost Amount Adjustment';
            Editable = false;
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry No." = field("Item Ledger Entry No."),
                                                                         "Posting Date" = field("Posting Date"),
                                                                         //"Gen. Prod. Posting Group" = filter('GOODS|FG|SERVICE-511'),
                                                                         Adjustment = filter(true)));
        }
        field(60; "AIG Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            DecimalPlaces = 0 : 2;
        }
        field(70; "AIG Cost Amount Adjustment"; Decimal)
        {
            Caption = 'Cost Amount Adjustment';
            DecimalPlaces = 0 : 2;
        }
        field(80; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.", "Item Ledger Entry No.", "Posting Date")
        {
            Clustered = true;
        }
    }
}
