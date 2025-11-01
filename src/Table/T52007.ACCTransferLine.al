table 52007 "ACC Transfer Line"
{
    Caption = 'APIS Transfer Line';

    fields
    {
        field(3; "Entry No"; Integer) { Caption = 'Entry No'; }
        field(5; "Document No"; Code[20]) { Caption = 'Document No'; }
        field(10; "Line No"; Integer) { Caption = 'Line No'; }
        field(15; "Status"; Code[20]) { Caption = 'Status'; }
        field(20; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(25; "Shipment No"; Code[20])
        {
            Caption = 'Shipment No';
            TableRelation = "Transfer Shipment Header"."No.";
        }
        field(30; "Shipment Date"; Date) { Caption = 'Shipment Date'; }
        field(35; "Receipt No"; Code[20])
        {
            Caption = 'Receipt No';
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(40; "Receipt Date"; Date) { Caption = 'Receipt Date'; }
        field(45; "Item No"; Code[20]) { Caption = 'Item No'; }
        field(50; "Description"; Text[100]) { Caption = 'Description'; }
        field(55; "Lot No"; Code[50]) { Caption = 'Lot No'; }
        field(60; "Quantity"; Decimal) { Caption = 'Quantity'; }
        field(65; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; }
        field(70; "Shortcut Dimension 1 Code"; Text[20])
        {
            Caption = 'Branch Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("No." = field("Transfer-to Code"), "Table ID" = const(14), "Dimension Code" = const('BRANCH')));
        }
        field(75; "Shortcut Dimension 2 Code"; Code[20]) { Caption = 'Shortcut Dimension 2 Code'; }
        field(80; "Transfer-from Code"; Code[10]) { Caption = 'Transfer-from Code'; }
        field(85; "Transfer-to Code"; Code[10]) { Caption = 'Transfer-to Code'; }
        field(90; "eInvoice No"; Code[30])
        {
            Caption = 'EInvoice No';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Shipment Header"."BLTI eInvoice No." where("No." = field("Shipment No")));
        }
        field(95; "Name Of Transporter"; Text[250])
        {
            Caption = 'Name Of Transporter';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Shipment Header"."BLTI Name of Transporter" where("No." = field("Shipment No")));
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
