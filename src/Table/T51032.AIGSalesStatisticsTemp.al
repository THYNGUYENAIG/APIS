table 51032 "AIG Sales Statistics Temp"
{
    Caption = 'AIG Sales Statistics Temp';
    TableType = Temporary;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(4; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            Editable = false;
        }
        field(5; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(6; "Cost Amount Adjust."; Decimal)
        {
            Caption = 'Cost Amount Adjust.';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(7; "Sales Order"; Code[20])
        {
            Caption = 'Sales Order';
            Editable = false;
            TableRelation = "Sales Header"."No.";
        }
        field(8; "Customer Account"; Code[20])
        {
            Caption = 'Customer Account';
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(9; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(10; "Item Number"; Code[20])
        {
            Caption = 'Item Number';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(11; "Search Name"; Text[100])
        {
            Caption = 'Search Name';
            Editable = false;
        }
        field(12; "Description"; Text[2048])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(13; "Unit"; Code[10])
        {
            Caption = 'Unit';
            Editable = false;
        }
        field(14; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
        }
        field(15; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;
        }
        field(16; "Amount"; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(17; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            Editable = false;
        }
        field(18; "Charge Amount"; Decimal)
        {
            Caption = 'Charge Amount';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(19; "Sales Tax Amount"; Decimal)
        {
            Caption = 'Sales Tax Amount';
            Editable = false;
        }
        field(20; "Warehouse"; Code[10])
        {
            Caption = 'Warehouse';
            Editable = false;
            TableRelation = Location.Code;
        }
        field(21; "Packing Slip"; Code[20])
        {
            Caption = 'Packing Slip';
            Editable = false;
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(22; "Physical Date"; Date)
        {
            Caption = 'Physical Date';
            Editable = false;
        }
        field(23; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
            Editable = false;
        }
        field(24; "Item Sales Tax Group"; Code[20])
        {
            Caption = 'Item Sales Tax Group';
            Editable = false;
        }
        field(25; "Sales District"; Text[100])
        {
            Caption = 'Sales District';
            Editable = false;
        }
        field(26; "Sales Taker"; Code[30])
        {
            Caption = 'Sales Taker';
            Editable = false;
        }
        field(27; "Sales Taker Name"; Text[100])
        {
            Caption = 'Sales Taker Name';
            Editable = false;
        }
        field(28; "Branch Code"; Code[30])
        {
            Caption = 'Chi Nhánh';
            Editable = false;
        }
        field(29; "Branch Name"; Text[100])
        {
            Caption = 'Tên Chi Nhánh';
            Editable = false;
        }
        field(30; "BU Code"; Code[30])
        {
            Caption = 'Ngành Hàng';
            Editable = false;
        }
        field(31; "BU Name"; Text[100])
        {
            Caption = 'Tên Ngành Hàng';
            Editable = false;
        }
        field(32; "Cost Center"; Code[30])
        {
            Caption = 'Mục Phí';
            Editable = false;
        }
        field(33; "Cost Center Name"; Text[100])
        {
            Caption = 'Tên Mục Phí';
            Editable = false;
        }
        field(34; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            Editable = false;
        }
        field(35; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
            Editable = false;
        }
        field(36; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(37; "Invoice Account"; Code[20])
        {
            Caption = 'Invoice Account';
            Editable = false;
        }
        field(38; "Invoice Name"; Text[100])
        {
            Caption = 'Invoice Name';
            Editable = false;
        }
        field(50; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(51; "Credit Note"; Boolean)
        {
            Caption = 'Credit Note';
            Editable = false;
        }
        field(52; "Orig eInvoice No."; Code[35])
        {
            Caption = 'Orig eInvoice No.';
            Editable = false;
        }
        field(53; "Orig Invoice Date"; Date)
        {
            Caption = 'Orig Invoice Date';
            Editable = false;
        }
        field(54; "Orig Invoice No."; Code[20])
        {
            Caption = 'Orig Invoice No.';
            Editable = false;
        }
        field(55; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
        }
        field(56; "Customer Group"; Code[20])
        {
            Caption = 'Customer Group';
            Editable = false;
        }
        field(57; "Customer Group Name"; Text[100])
        {
            Caption = 'Customer Group Name';
            Editable = false;
        }
        field(58; "eInvoice Series"; Code[20])
        {
            Caption = 'eInvoice Series';
            Editable = false;
        }
        field(59; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            Editable = false;
        }
        field(60; "From Date"; Date)
        {
            Caption = 'From Date';
            Editable = false;
        }
        field(61; "To Date"; Date)
        {
            Caption = 'To Date';
            Editable = false;
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
