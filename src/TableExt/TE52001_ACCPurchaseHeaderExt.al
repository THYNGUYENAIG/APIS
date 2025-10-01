tableextension 52001 "ACC Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(52005; "ACC Customs Declaration No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC Customs Declaration No.';
        }
        field(52010; "ACC Original Document"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Original Document';
            InitValue = 'AIG';
            TableRelation = "ACC Contract Document"."Doc No.";
        }
    }
}