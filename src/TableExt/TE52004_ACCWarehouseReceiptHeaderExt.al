tableextension 52004 "ACC WH Receipt Header Ext" extends "Warehouse Receipt Header"
{
    fields
    {
        field(52005; "ACC Source No."; Text[1000])
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC Source No.';
        }
        field(52006; "Printed No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Printed No.';
        }
        field(52010; "ACC Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No';
        }
        field(52015; "ACC Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
        }
    }
}