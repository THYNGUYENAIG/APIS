table 51904 "ACC DMS Item"
{
    Caption = 'APIS DMS Item';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SPO ID"; Integer)
        {
            Caption = 'SPO ID';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Purchase Name"; Text[300])
        {
            Caption = 'Purchase Name';
        }
        field(4; "Sales Name"; Text[2048])
        {
            Caption = 'Sales Name';
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(6; "Vendor Name"; Text[250])
        {
            Caption = 'Vendor Name';
        }
        field(7; Manufactory; Text[50])
        {
            Caption = 'Manufactory';
        }
        field(8; "Buyer Group"; code[20])
        {
            Caption = 'Buyer Group';
        }
        field(9; "Supplier Management Code"; Code[20])
        {
            Caption = 'Supplier Management Code';
        }
        field(10; "Supplier Management Name"; Text[50])
        {
            Caption = 'Supplier Management Name';
        }
        field(11; "Supplier Management Email"; Text[80])
        {
            Caption = 'Email';
        }
        field(20; Onhold; Boolean)
        {
            Caption = 'Onhold';
        }
        field(30; "Sync Count"; Integer)
        {
            Caption = 'Sync Count';
        }
        field(40; "SPO Email No."; Integer)
        {
            Caption = 'SPO Email No.';
        }
        field(50; "Ingredient Group"; Text[250])
        {
            Caption = 'Ingredient Group';
        }
    }
    keys
    {
        key(PK; "SPO ID")
        {
            Clustered = true;
        }
    }
}
