table 51999 "AIG Value Entry Relation"
{
    Caption = 'AIG Value Entry Relation';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Source Row ID"; Text[250])
        {
            Caption = 'Source Row ID';
            Editable = false;
        }
        field(20; "Table No."; Integer)
        {
            Caption = 'Table No.';
            Editable = false;
        }
        field(30; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            Editable = false;
        }
        field(40; "Invoice Line No."; Integer)
        {
            Caption = 'Invoice Line No.';
            Editable = false;
        }
        field(50; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(60; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            Editable = false;
        }
        field(70; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(80; "Source Name"; Text[250])
        {
            Caption = 'Source Name';
            Editable = false;
        }
        field(90; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(100; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
            Editable = false;
        }
        field(101; "Search Name"; Text[100])
        {
            Caption = 'Search Name';
            Editable = false;
        }
        field(102; "Item Type"; Enum "AIG Item Type")
        {
            Caption = 'Item Type';
            Editable = false;
        }
        field(120; "Unit Code"; Code[10])
        {
            Caption = 'Unit Code';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(130; Quantity; Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
            DecimalPlaces = 0 : 3;
        }
        field(140; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(150; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(151; "Line Amount (LCY)"; Decimal)
        {
            Caption = 'Line Amount (LCY)';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(152; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(153; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(160; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(170; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(180; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(190; "Unit Cost (LCY)"; Decimal)
        {
            Caption = 'Unit Cost (LCY)';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(200; "Declaration No."; Code[30])
        {
            Caption = 'Declaration No.';
            Editable = false;
        }
        field(210; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
        }
        field(220; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(230; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = false;
        }
        field(240; "Whse. Date"; Date)
        {
            Caption = 'Whse. Date';
            Editable = false;
        }
        field(250; "Cost Amount Posted"; Decimal)
        {
            Caption = 'Cost Amount Posted';
            Editable = false;
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("AIG Cost Value Entry"."AIG Cost Amount" where("Document No." = field("Invoice No."),
                                                                             "Line No." = field("Invoice Line No."),
                                                                             "Posting Date" = field("Posting Date")));
        }
        field(260; "Cost Amount Adjustment"; Decimal)
        {
            Caption = 'Cost Amount Adjustment';
            Editable = false;
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("AIG Cost Value Entry"."AIG Cost Amount Adjustment" where("Document No." = field("Invoice No."),
                                                                                        "Line No." = field("Invoice Line No."),
                                                                                        "Posting Date" = field("Posting Date")));
        }
        field(270; "Charge Amount"; Decimal)
        {
            Caption = 'Charge Amount';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }

        field(290; "Item Tax Group"; Code[20])
        {
            Caption = 'Item Tax Group';
            Editable = false;
        }
        field(291; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            Editable = false;
        }
        field(300; "Invoice Account"; Code[20])
        {
            Caption = 'Invoice Account';
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(310; "Invoice Name"; Text[100])
        {
            Caption = 'Invoice Name';
            Editable = false;
        }
        field(320; "eInvoice No."; Code[30])
        {
            Caption = 'eInvoice No.';
            Editable = false;
        }
        field(330; "Branch Code"; Code[30])
        {
            Caption = 'Branch Code';
            Editable = false;
        }
        field(340; "Branch Name"; Text[100])
        {
            Caption = 'Branch Name';
            Editable = false;
        }
        field(350; "BU Code"; Code[30])
        {
            Caption = 'BU Code';
            Editable = false;
        }
        field(360; "BU Name"; Text[100])
        {
            Caption = 'BU Name';
            Editable = false;
        }
        field(370; "Cost Center"; Code[30])
        {
            Caption = 'Cost Center';
            Editable = false;
        }
        field(380; "Cost Center Name"; Text[100])
        {
            Caption = 'Cost Center Name';
            Editable = false;
        }
        field(390; "Sales Taker"; Code[30])
        {
            Caption = 'Sales Taker';
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(400; "Sales Taker Name"; Text[100])
        {
            Caption = 'Sales Taker Name';
            Editable = false;
        }
        field(410; "Sales District"; Text[100])
        {
            Caption = 'Sales District';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Source Row ID")
        {
            Clustered = true;
        }
    }
}
