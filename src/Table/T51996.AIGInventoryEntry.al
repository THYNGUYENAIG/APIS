table 51996 "AIG Inventory Entry"
{
    Caption = 'AIG Inventory Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(30; "Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Entry Type';
            Editable = false;
        }
        field(40; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
        }
        field(50; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(61; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Editable = false;
        }
        field(70; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            Editable = false;
            TableRelation = "Lot No. Information";
        }
        field(80; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(90; Site; Code[20])
        {
            Caption = 'Site';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(110; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(120; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(130; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(140; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(150; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(160; "Lot Blocked"; Boolean)
        {
            Caption = 'Lot Blocked';
            Editable = false;
        }
        field(170; "Bin Blocked"; Decimal)
        {
            Caption = 'Bin Blocked';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
