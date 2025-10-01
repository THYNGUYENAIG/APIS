table 51024 "ACC MP Commitment"
{
    Caption = 'ACC MP Commitment - P51024';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(11; "Item Name"; Text[250])
        {
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Purchase Name" where("No." = field("Item No.")));
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("Item No.")));
        }
        field(13; "Purch No."; Code[30])
        {
            Caption = 'Purch No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."ACC Order No." where("Item No." = field("Item No."), "Lot No." = field("Lot No."),
                                                                           "Entry Type" = filter("Item Ledger Entry Type"::Purchase),
                                                                           "Document Type" = filter("Item Ledger Document Type"::"Purchase Receipt")));
        }
        field(14; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            FieldClass = FlowField;
            CalcFormula = min("Item Ledger Entry"."Posting Date" where("Item No." = field("Item No."), "Lot No." = field("Lot No."),
                                                                       "Entry Type" = filter("Item Ledger Entry Type"::"Positive Adjmt." | "Item Ledger Entry Type"::Purchase)));
        }
        field(20; "Site No."; Code[10])
        {
            Caption = 'Site No.';
        }
        field(30; "Unit No."; Code[10])
        {
            Caption = 'Unit No.';
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(50; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(60; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(70; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(80; Status; Enum "ACC Status Type")
        {
            Caption = 'Status';
        }
        field(90; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
        }
    }
    keys
    {
        key(PK; "Item No.", "Site No.", "Lot No.", Status)
        {
            Clustered = true;
        }
    }
}
