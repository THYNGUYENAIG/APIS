table 51027 "ACC Sales Customs Information"
{
    Caption = 'ACC Sales Customs Information';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales No."; Code[20])
        {
            Caption = 'Sales No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(4; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }
        field(5; "Sales Name"; Text[100])
        {
            Caption = 'Sales Name';
        }
        field(6; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
        }
        field(7; "Invoice Account"; Code[20])
        {
            Caption = 'Invoice Account';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header Archive"."Bill-to Customer No." where("No." = field("Sales No.")));
        }
        field(8; "Invoice Name"; Text[100])
        {
            Caption = 'Invoice Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header Archive"."Bill-to Name" where("No." = field("Sales No.")));
        }
        field(9; "Purch. No."; Code[20])
        {
            Caption = 'Purch. No.';
        }
        field(10; "Declaration No."; Code[35])
        {
            Caption = 'Declaration No.';
        }
    }
    keys
    {
        key(PK; "Sales No.", "Item No.", "Lot No.")
        {
            Clustered = true;
        }
    }
}
