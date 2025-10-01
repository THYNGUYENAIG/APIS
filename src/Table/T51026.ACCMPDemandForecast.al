table 51026 "ACC MP Demand Forecast"
{
    Caption = 'ACC MP Demand Forecast';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(3; "Business Unit"; Code[10])
        {
            Caption = 'Business Unit';
        }
        field(4; "Site No."; Code[10])
        {
            Caption = 'Site No.';
        }
        field(5; "Forecast Date"; Date)
        {
            Caption = 'Forecast Date';
        }
        field(6; "Forecast Quantity"; Decimal)
        {
            Caption = 'Forecast Quantity';
        }
        field(7; "Type"; Text[100])
        {
            Caption = 'Type';
        }
    }
    keys
    {
        key(PK; "Item No.", "Location Code", "Business Unit", "Forecast Date", Type)
        {
            Clustered = true;
        }
    }
}
