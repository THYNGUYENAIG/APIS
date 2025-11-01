table 51014 "ACC MP Combine Table"
{
    Caption = 'APIS MP Combine Table';
    DataClassification = ToBeClassified;
    DataPerCompany = true;

    fields
    {
        field(1; "Site ID"; Code[20])
        {
            Caption = 'Site ID';
        }
        field(2; "Business Unit ID"; Code[20])
        {
            Caption = 'Business Unit ID';
        }
        field(3; "SKU ID"; Code[20])
        {
            Caption = 'SKU ID';
            TableRelation = Item."No.";
        }
        field(4; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value';
        }
        field(5; "Entity ID"; Code[20])
        {
            Caption = 'Entity ID';
        }
        field(6; Period; Code[20])
        {
            Caption = 'Period';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(8; "Period Date"; Date)
        {
            Caption = 'Period Date';
        }
        field(9; "Statistic Period Number"; Integer)
        {
            Caption = 'Statistic Period Number';
        }
        field(10; "PO Date Status"; Text[20])
        {
            Caption = 'PO Date Status';
        }
        field(11; "SA Quantity"; Decimal)
        {
            Caption = 'SA Quantity';
            DecimalPlaces = 0 : 3;
        }
    }
    keys
    {
        key(PK; "Site ID", "Business Unit ID", "SKU ID", "Dimension Value", "Period Date")
        {
            Clustered = true;
        }
    }
}
