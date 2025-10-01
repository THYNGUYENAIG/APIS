tableextension 51002 "ACC Purch Receipt Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(51001; "Posted Purchase Invoice"; Text[500])
        {
            Caption = 'Posted Purchase Invoice';
            DataClassification = ToBeClassified;
        }
        field(51002; "Vendor Invoice No."; Text[500])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = ToBeClassified;
        }
        field(51003; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            DataClassification = ToBeClassified;
        }
        field(51005; "Purchase Quantity"; Decimal)
        {
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("Document No." = field("No."),
                                                                  Type = filter("Purchase Line Type"::Item)));
            Caption = 'Purchase Quantity';
            FieldClass = FlowField;
        }
        field(52005; "ACC Location Code"; Code[20])
        {
            Caption = 'ACC Location Code';
            DataClassification = ToBeClassified;
        }
        field(52010; "ACC Location"; Code[20])
        {
            Caption = 'ACC Location Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Whse. Receipt Line"."Location Code" where("Posted Source No." = field("No."),
                                                                                    "Posting Date" = field("Posting Date")));
        }
    }
}
