tableextension 51012 "ACC Purch. Cr.Memo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50001; "ACC Cost Amount Posted"; Decimal)
        {
            Editable = false;
            Caption = 'ACC Cost Amount Posted';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Document No." = field("Document No."),
                                                                         "Document Line No." = field("Line No."),
                                                                         "Item No." = field("No."),
                                                                         "Posting Date" = field("Posting Date"),
                                                                         Adjustment = filter(false)));
        }
        field(50002; "ACC Cost Amount Adjustment"; Decimal)
        {
            Editable = false;
            Caption = 'ACC Cost Amount Adjustment';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Document No." = field("Document No."),
                                                                         "Document Line No." = field("Line No."),
                                                                         "Item No." = field("No."),
                                                                         "Posting Date" = field("Posting Date"),
                                                                         Adjustment = filter(true)));
        }
        field(50003; "ACC Balance Adjustment"; Decimal)
        {
            Editable = false;
            Caption = 'ACC Balance Adjustment';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Document No." = field("Document No."),
                                                                         "Document Line No." = field("Line No."),
                                                                         "Item No." = field("No."),
                                                                         Adjustment = filter(true)));
        }        
    }
}
