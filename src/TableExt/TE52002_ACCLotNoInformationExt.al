tableextension 52002 "ACC Lot No Information Ext" extends "Lot No. Information"
{
    fields
    {
        field(52005; "ACC UnBlock Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC UnBlock Created At';
        }
        field(52010; "ACC UnBlock Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC UnBlock Created By';
        }
        field(52015; "ACC Receipt Entry No"; Integer)
        {
            Caption = 'Receipt Entry No';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min("Item Ledger Entry"."Entry No." where("Item No." = field("Item No."), "Lot No." = field("Lot No."),
                                                                    "Posting Date" = field("ACC Receipt Date"),
                                                                    "Entry Type" = filter("Item Ledger Entry Type"::"Positive Adjmt." | "Item Ledger Entry Type"::Purchase)));
        }
        field(52020; "ACC Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min("Item Ledger Entry"."Posting Date" where("Item No." = field("Item No."), "Lot No." = field("Lot No."),
                                                                    "Entry Type" = filter("Item Ledger Entry Type"::"Positive Adjmt." | "Item Ledger Entry Type"::Purchase)));
        }
        field(52025; "ACC Receipt Location"; Code[10])
        {
            Caption = 'Receipt Location';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min("Item Ledger Entry"."Location Code" where("Entry No." = field("ACC Receipt Entry No")));
        }
        field(52030; "ACC Custom Declaration No."; Code[30])
        {
            Caption = 'Custom Declaration No. - Not Use';
            Editable = false;
        }
        field(52033; "ACC Custom Declaration No"; Code[30])
        {
            Caption = 'Custom Declaration No';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."BLTEC Customs Declaration No." where("Item No." = field("Item No."), "Lot No." = field("Lot No.")
                                                                , "BLTEC Customs Declaration No." = filter(<> '')
                                                                , "Entry Type" = filter("Item Ledger Entry Type"::Purchase)
                                                                , "Document Type" = filter("Item Ledger Document Type"::"Purchase Receipt")));
        }
        field(52035; "ACC PO No"; Code[30])
        {
            Caption = 'PO No';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."ACC Order No." where("Item No." = field("Item No."), "Lot No." = field("Lot No.")
                                                                //, "BLTEC Customs Declaration No." = field("ACC Custom Declaration No.")
                                                                , "Entry Type" = filter("Item Ledger Entry Type"::Purchase)
                                                                , "Document Type" = filter("Item Ledger Document Type"::"Purchase Receipt")));
        }
    }
}