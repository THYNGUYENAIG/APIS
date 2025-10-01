table 51915 "ACC Cust. Ledger Settlement"
{
    Caption = 'ACC Customer Ledger Settlement';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Detailed Ledger Entry No."; Integer)
        {
            Caption = 'Detailed Ledger Entry No.';
        }
        field(2; "Ledger Entry No."; Integer)
        {
            Caption = 'Ledger Entry No.';
        }
        field(3; "Voucher"; Code[20])
        {
            Caption = 'Voucher';
        }
        field(4; "Sales Inv. No."; Code[20])
        {
            Caption = 'Sales Inv. No.';
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Invoice"; Code[35])
        {
            Caption = 'Invoice';
        }
        field(7; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
        }
        field(8; "Offset Voucher"; Code[20])
        {
            Caption = 'Offset Voucher';
        }
        field(9; "Customer Account"; Code[20])
        {
            Caption = 'Customer Account';
        }
        field(10; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer Account")));
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(13; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(14; "Date Of Settlement"; Date)
        {
            Caption = 'Date Of Settlement';
        }
        field(15; "Settled Currency"; Decimal)
        {
            Caption = 'Settled Currency';
            DecimalPlaces = 0 : 2;
        }
        field(16; "Amount Settled"; Decimal)
        {
            Caption = 'Amount Settled';
            DecimalPlaces = 0 : 2;
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(18; "Modified At"; DateTime)
        {
            Caption = 'Modified At';
        }
        field(19; "Site"; Code[20])
        {
            Caption = 'Site';
        }
        field(20; "BU"; Code[20])
        {
            Caption = 'BU';
        }
        field(21; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group';
        }
        field(22; "Statistics Group Name"; Text[100])
        {
            Caption = 'Statistics Group Name';
            FieldClass = FlowField;
            CalcFormula = lookup("BLACC Statistics group"."BLACC Description" where("BLACC Statistics group" = field("Statistics Group")));
        }
        field(23; "Reset"; Boolean)
        {
            Caption = 'Reset';
        }
    }
    keys
    {
        key(PK; "Detailed Ledger Entry No.")
        {
            Clustered = true;
        }
    }
}
