table 51023 "ACC MP Commitment Line"
{
    Caption = 'APIS MP Commitment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ID"; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(20; "Location No."; Code[20])
        {
            Caption = 'Location No.';
        }
        field(30; "Unit No."; Code[10])
        {
            Caption = 'Unit No.';
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(50; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(60; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(70; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(80; Status; Enum "ACC Status Type")
        {
            Caption = 'Status';
        }
        field(90; "Site No."; Code[10])
        {
            Caption = 'Site No.';
        }
        field(100; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
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
