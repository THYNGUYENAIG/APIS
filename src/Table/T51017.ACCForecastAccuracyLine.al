table 51017 "ACC Forecast Accuracy Line"
{
    Caption = 'APIS Forecast Accuracy Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(3; "BU Code"; Code[20])
        {
            Caption = 'BU Code';
        }
        field(4; Salesperson; Code[20])
        {
            Caption = 'Salesperson';
        }
        field(5; "Sales Quantity"; Decimal)
        {
            Caption = 'Sales Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(6; "FC T0"; Decimal)
        {
            Caption = 'FC T0';
            DecimalPlaces = 0 : 3;
        }
        field(7; "FC T-1"; Decimal)
        {
            Caption = 'FC T-1';
            DecimalPlaces = 0 : 3;
        }
        field(8; "FC T-2"; Decimal)
        {
            Caption = 'FC T-2';
            DecimalPlaces = 0 : 3;
        }
        field(9; "FC T-3"; Decimal)
        {
            Caption = 'FC T-3';
            DecimalPlaces = 0 : 3;
        }
        field(10; Budget; Decimal)
        {
            Caption = 'Budget';
            DecimalPlaces = 0 : 3;
        }
        field(11; "YM No."; Code[10])
        {
            Caption = 'YM No.';
        }
        field(12; "Period Date"; Date)
        {
            Caption = 'Period Date';
        }
        field(13; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
        }
        field(14; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(15; "Sales Agreement No."; Code[20])
        {
            Caption = 'Sales Agreement No.';
        }
        field(16; "ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            Editable = false;
            NotBlank = true;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
