table 51918 "AIG Purchase Statistics"
{
    Caption = 'AIG Purchase Statistics';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(7; "Purchase Order"; Code[20])
        {
            Caption = 'Purchase Order';
            TableRelation = "Purchase Header"."No.";
        }
        field(8; "Vendor Account"; Code[20])
        {
            Caption = 'Vendor Account';
            TableRelation = Vendor."No.";
        }
        field(9; "Vendor Name"; Text[250])
        {
            Caption = 'Vendor Name';
        }
        field(10; "Item Number"; Code[20])
        {
            Caption = 'Item Number';
            TableRelation = Item."No.";
        }
        field(11; "Search Name"; Text[100])
        {
            Caption = 'Search Name';
        }
        field(12; "Description"; Text[2048])
        {
            Caption = 'Description';
        }
        field(13; "Unit"; Code[10])
        {
            Caption = 'Unit';
        }
        field(14; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(15; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(16; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(17; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }
        field(18; "Site"; Code[30])
        {
            Caption = 'Site';
        }
        field(19; "Purchase Tax Amount"; Decimal)
        {
            Caption = 'Purchase Tax Amount';
        }
        field(20; "Warehouse"; Code[10])
        {
            Caption = 'Warehouse';
            TableRelation = Location.Code;
        }
        field(21; "Product Receipt"; Code[20])
        {
            Caption = 'Product Receipt';
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(22; "BU Code"; Code[30])
        {
            Caption = 'Ngành Hàng';
        }
        field(23; "BU Name"; Text[100])
        {
            Caption = 'Tên Ngành Hàng';
        }
        field(24; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(25; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(26; "Invoice Account"; Code[20])
        {
            Caption = 'Invoice Account';
        }
        field(27; "Invoice Name"; Text[100])
        {
            Caption = 'Invoice Name';
        }
        field(28; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
        }
        field(29; "Vendor Group"; Code[20])
        {
            Caption = 'Vendor Group';
        }
        field(30; "Buyer Group"; Text[100])
        {
            Caption = 'Buyer Group';
        }
        field(31; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }
        field(32; "Customs Declaration"; Code[30])
        {
            Caption = 'Customs Declaration';
            TableRelation = "BLTEC Customs Declaration"."BLTEC Customs Declaration No.";
        }
        field(33; "Terms"; Text[50])
        {
            Caption = 'Terms';
        }
        field(34; "Term Of Payment"; Code[30])
        {
            Caption = 'Term Of Payment';
        }
        field(35; "Employee Name"; Text[30])
        {
            Caption = 'Nhân Viên';
        }
        field(36; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.", "Posting Date")
        {
            Clustered = true;
        }
    }
}
