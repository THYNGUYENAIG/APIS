table 51015 "ACC MP Combine Line"
{
    Caption = 'APIS MP Combine Line';
    DataClassification = ToBeClassified;
    DataPerCompany = true;

    fields
    {
        field(1; "Site ID"; Code[20])
        {
            Caption = 'Site ID';
        }
        field(2; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(3; "Business Unit ID"; Code[20])
        {
            Caption = 'Business Unit ID';
        }
        field(4; "SKU ID"; Code[20])
        {
            Caption = 'SKU ID';
            TableRelation = Item."No.";
        }
        field(5; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value';
        }
        field(6; "Entity ID"; Code[20])
        {
            Caption = 'Entity ID';
        }
        field(7; Period; Code[20])
        {
            Caption = 'Period';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(9; "Period Date"; Date)
        {
            Caption = 'Period Date';
        }
        field(10; "Statistic Period Number"; Integer)
        {
            Caption = 'Statistic Period Number';
        }
        field(11; "PO Date Status"; Text[20])
        {
            Caption = 'PO Date Status';
        }
        field(12; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            Editable = false;
            NotBlank = true;
        }
        field(13; "SA Quantity"; Decimal)
        {
            Caption = 'SA Quantity';
            DecimalPlaces = 0 : 3;
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
