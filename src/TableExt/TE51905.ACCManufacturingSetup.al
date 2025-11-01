tableextension 51905 "ACC Manufacturing Setup" extends "Manufacturing Setup"
{
    fields
    {
        field(50001; "Planned Adjust. Nos."; Code[20])
        {
            Caption = 'Planned Adjust. Nos.';
            TableRelation = "No. Series";
        }
        field(50002; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(50003; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
    }
}
