table 52010 "ACC Sales Line Tmp"
{
    Caption = 'ACC Sales Line Tmp';
    TableType = Temporary;

    fields
    {
        field(5; "Entry No"; Integer) { Caption = 'Entry No'; }
        field(10; "No"; Code[20]) { Caption = 'No'; }
        field(15; "Ship-to Name"; Text[150]) { Caption = 'Ship-to Name'; }
        field(20; "Ship-to Address"; Text[150]) { Caption = 'Ship-to Address'; }
        field(25; "MOQ"; Decimal) { Caption = 'MOQ'; DecimalPlaces = 0 : 5; }
        field(30; "From Date"; Date) { Caption = 'From Date'; }
        field(35; "To Date"; Date) { Caption = 'To Date'; }
        field(40; "Expiration Date"; Date) { Caption = 'Expiration Date'; }
        field(45; "Sales Pool Code"; Code[20]) { Caption = 'Sales Pool Code'; }
        field(50; "Bill-to Customer No"; Code[20]) { Caption = 'Bill-to Customer No'; }
        field(55; "Bill-to Customer Name"; Text[150]) { Caption = 'Bill-to Customer Name'; }
        field(60; "Payment Method"; Code[10]) { Caption = 'Payment Method'; }
        field(65; "Payment Term"; Code[10]) { Caption = 'Payment Term'; }
        field(70; "Currency Code"; Code[10]) { Caption = 'Currency Code'; }
        field(75; "Sell-to Customer No"; Code[20]) { Caption = 'Sell-to Customer No'; }
        field(80; "Sell-to Customer Name"; Text[150]) { Caption = 'Sell-to Customer Name'; }
        field(90; "Exch Rate"; Decimal) { Caption = 'Exch Rate'; }
        field(95; "Salesperson Code"; Code[20]) { Caption = 'Salesperson Code'; }
        field(100; "Status"; Enum "Sales Document Status") { Caption = 'Status'; }
        field(105; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(110; "Item Description"; Text[100]) { Caption = 'Item Description'; }
        field(115; "UOM"; Text[50]) { Caption = 'UOM'; }
        field(120; "Quantity"; Decimal) { Caption = 'Quantity'; DecimalPlaces = 0 : 5; }
        field(125; "Quantity Shipped"; Decimal) { Caption = 'Quantity Shipped'; DecimalPlaces = 0 : 5; }
        field(130; "Quantity Invoiced"; Decimal) { Caption = 'Quantity Invoiced'; DecimalPlaces = 0 : 5; }
        field(135; "OutStanding Quantity"; Decimal) { Caption = 'OutStanding Quantity'; DecimalPlaces = 0 : 5; }
        field(140; "Reserved Quantity"; Decimal) { Caption = 'Reserved Quantity'; DecimalPlaces = 0 : 5; }
        field(145; "Unit Price"; Decimal) { Caption = 'Unit Price'; DecimalPlaces = 0 : 5; }
        field(150; "Line Amount"; Decimal) { Caption = 'Line Amount'; DecimalPlaces = 0 : 5; }
        field(155; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; }
        field(160; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Code"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('EMPLOYEE')));
        }
        field(165; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Name"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('EMPLOYEE')));
        }
        field(170; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Code"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('BRANCH')));
        }
        field(175; "Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Name"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('BRANCH')));
        }
        field(180; "BU Code"; Code[20])
        {
            Caption = 'BU Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Code"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('BUSINESSUNIT')));
        }
        field(185; "BU Name"; Text[50])
        {
            Caption = 'BU Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Name"
                                    where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('BUSINESSUNIT')));
        }

        // field(160; "Employee ID"; Integer)
        // {
        //     Caption = 'Employee ID';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Dimension Set Entry"."Dimension Value ID"
        //                             where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Name" = const('Employee')));
        // }
        // field(155; "Employee Name"; Text[50])
        // {
        //     Caption = 'Employee Name';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Dimension Value"."Name" where("Dimension Value ID" = field("Employee ID"), "Global Dimension No." = const(4)));
        // }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
    var
        SH: Record "Sales Header";
        SL: Record "Sales Line";
}
