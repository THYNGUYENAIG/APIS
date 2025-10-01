table 51020 "AHH Commission Price"
{
    Caption = 'AHH Commission Price';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            Caption = 'No.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = "AHH Customer"."Customer No.";
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(5; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLTEC Item Name" where("No." = field("Item No.")));
        }
        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(8; Unit; Code[10])
        {
            Caption = 'Unit';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Item No.")));
        }
        field(9; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(10; State; Enum "AHH Price State")
        {
            Caption = 'State';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetLastNo(): Integer
    var
        FindRecMgt: Codeunit "Find Record Management";
    begin
        exit(FindRecMgt.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;
}
