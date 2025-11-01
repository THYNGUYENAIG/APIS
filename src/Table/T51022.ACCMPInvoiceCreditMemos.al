table 51022 "ACC MP Invoice & Credit Memos"
{
    Caption = 'APIS MP Invoice & Credit Memos';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Sales Order"; Code[20])
        {
            Caption = 'Sales Order';
        }
        field(11; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(13; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            TableRelation = "Lot No. Information"."Lot No.";
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(30; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(40; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(50; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(60; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
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
        field(100; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
        }
        field(110; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(120; "BU Code"; Code[20])
        {
            Caption = 'BU Code';
        }
        field(130; City; Text[30])
        {
            Caption = 'City';
        }
        field(140; "Salesperson Name"; Text[50])
        {
            Caption = 'Salesperson Name';
        }
        field(150; "Sales Status"; Text[50])
        {
            Caption = 'Sales Status';
        }
        field(160; "Created At"; DateTime)
        {
            Caption = 'Created At';
        }
    }
    keys
    {
        key(PK; "Invoice No.", "Line No.", "Lot No.")
        {
            Clustered = true;
        }
    }
}
