tableextension 51905 "ACC Manufacturing Setup" extends "Manufacturing Setup"
{
    fields
    {
        field(50001; "Planned Adjust. Nos."; Code[20])
        {
            Caption = 'Planned Adjust. Nos.';
            TableRelation = "No. Series";
        }
    }
}
