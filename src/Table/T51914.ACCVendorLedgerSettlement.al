table 51914 "ACC Vendor Ledger Settlement"
{
    Caption = 'ACC Vendor Ledger Settlement';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Detailed Entry No."; Integer)
        {
            Caption = 'Detailed Entry No.';
        }
        field(20; "Ledger Entry No."; Integer)
        {
            Caption = 'Ledger Entry No.';
        }
        field(30; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(40; "Purch. Inv. No."; Code[20])
        {
            Caption = 'Purch. Inv. No.';
        }
        field(50; "Declaration No."; Code[30])
        {
            Caption = 'Declaration No.';
        }
        field(60; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
        }
        field(70; "Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
        }
        field(80; "Vendor Posting Group Name"; Text[100])
        {
            Caption = 'Vendor Posting Group Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Vendor Posting Group".Description where(Code = field("Vendor Posting Group")));
        }
        field(90; "Vendor Account"; Code[20])
        {
            Caption = 'Vendor Account';
        }
        field(100; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor Account")));
        }
        field(110; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(120; "Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(130; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(140; "Date Of Settlement"; Date)
        {
            Caption = 'Date Of Settlement';
        }
        field(150; "Settled Currency"; Decimal)
        {
            Caption = 'Original Invoice Amount';
            DecimalPlaces = 0 : 2;
        }
        field(160; "Amount Settled"; Decimal)
        {
            Caption = 'Amount Settled';
            DecimalPlaces = 0 : 2;
        }
        field(170; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(180; "Modified At"; DateTime)
        {
            Caption = 'Modified At';
        }
        field(190; "Reset"; Boolean)
        {
            Caption = 'Reset';
        }
        field(200; "Offset Document No."; Code[20])
        {
            Caption = 'Offset Document No.';
        }
        field(210; "Settled Currency (LCY)"; Decimal)
        {
            Caption = 'Settled Currency (LCY)';
            DecimalPlaces = 0 : 2;
        }
        field(220; "Amount Settled (LCY)"; Decimal)
        {
            Caption = 'Amount Settled (LCY)';
            DecimalPlaces = 0 : 2;
        }
        field(230; "Original Payment Amount"; Decimal)
        {
            Caption = 'Original Payment Amount';
            DecimalPlaces = 0 : 2;
        }
        field(240; "Payment Description"; Text[100])
        {
            Caption = 'Payment Description';
        }
        field(250; "Full Settlement"; Boolean)
        {
            Caption = 'Full Settlement';
        }
    }
    keys
    {
        key(PK; "Detailed Entry No.", "Ledger Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ChkExist(EntryNo: Integer): Boolean
    var
        VendSettle: Record "ACC Vendor Ledger Settlement";
    begin
        VendSettle.Reset();
        VendSettle.SetCurrentKey("Ledger Entry No.");
        VendSettle.SetRange("Ledger Entry No.", EntryNo);
        if VendSettle.FindFirst() then
            exit(true);
        exit(false);
    end;
}
