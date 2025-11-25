tableextension 51091 "ACC Customer" extends Customer
{
    fields
    {
        field(50001; "Report Layout"; Enum "ACC Packing Slip Layout")
        {
            Caption = 'Report Layout';
            InitValue = 'Layout 02';
            DataClassification = ToBeClassified;
        }
        field(50002; "ACC BU Ref"; Code[20])
        {
            Caption = 'BU Ref';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
        field(50003; "Total Sales Amount"; Decimal)
        {
            Caption = 'Total Sales Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cust. Ledger Entry"."Sales (LCY)" where("Customer No." = field("No."),
                                                                       "Posting Date" = field("Date Filter")));
        }
        field(50004; "Total Cost Amount"; Decimal)
        {
            Caption = 'Total Cost Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = - sum("Value Entry"."Cost Amount (Actual)" where("Source Type" = const(Customer),
                                                                         "Source No." = field("No."),
                                                                         "Posting Date" = field("Date Filter")));
        }
    }
}
