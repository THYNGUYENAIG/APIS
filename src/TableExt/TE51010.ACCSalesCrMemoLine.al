tableextension 51010 "ACC Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50001; "ACC Cost Amount Posted"; Decimal)
        {
            Editable = false;
            Caption = 'Cost Amt Posted';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("AIG Cost Value Entry"."AIG Cost Amount" where("Document No." = field("Document No."),
                                                                             "Line No." = field("Line No."),
                                                                             "Posting Date" = field("Posting Date")));
        }
        field(50002; "ACC Cost Amount Adjustment"; Decimal)
        {
            Editable = false;
            Caption = 'Cost Amount Adjustment';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("AIG Cost Value Entry"."AIG Cost Amount Adjustment" where("Document No." = field("Document No."),
                                                                                        "Line No." = field("Line No."),
                                                                                        "Posting Date" = field("Posting Date")));
        }
        field(50003; "ACC Balance Adjustment"; Decimal)
        {
            Editable = false;
            Caption = 'ACC Balance Adjustment';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("AIG Cost Value Entry"."AIG Cost Amount Adjustment" where("Document No." = field("Document No."),
                                                                                        "Line No." = field("Line No.")));
        }
        field(50004; "Return Reason Name"; Text[100])
        {
            Editable = false;
            Caption = 'Return Reason Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Return Reason".Description where(Code = field("Return Reason Code")));
        }
    }
}
