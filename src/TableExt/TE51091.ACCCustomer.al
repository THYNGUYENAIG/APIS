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
    }
}
