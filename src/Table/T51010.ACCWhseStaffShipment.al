table 51010 "ACC Whse. Staff Shipment"
{
    Caption = 'ACC Warehouse Staff';
    DataClassification = ToBeClassified;

    fields
    {
        field(50001; "ID"; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(2; "Whse. Order Printer"; Code[20])
        {
            Caption = 'Whse. Order Printer';
            TableRelation = Employee."No.";
        }
        field(3; "Whse. Order Printer Name"; Text[250])
        {
            Caption = 'Whse. Order Printer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Whse. Order Printer")));
        }
        field(4; "Whse. Keeper"; Code[20])
        {
            Caption = 'Whse. Keeper';
            TableRelation = Employee."No.";
        }
        field(5; "Whse. Keeper Name"; Text[250])
        {
            Caption = 'Whse. Keeper Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Whse. Keeper")));
        }
        /*
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        */
        field(7; "Active Print "; Boolean)
        {
            Caption = 'Active Print ';
        }
        field(8; "PO Order Printer"; Code[20])
        {
            Caption = 'PO Order Printer';
            TableRelation = Employee."No.";
        }
        field(9; "PO Order Printer Name"; Text[250])
        {
            Caption = 'PO Order Printer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("PO Order Printer")));
        }
        field(10; "PO Keeper"; Code[20])
        {
            Caption = 'PO Keeper';
            TableRelation = Employee."No.";
        }
        field(11; "PO Keeper Name"; Text[250])
        {
            Caption = 'PO Keeper Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("PO Keeper")));
        }
    }
    keys
    {
        key(PK; ID, "Location Code")
        {
            Clustered = true;
        }
    }
}
