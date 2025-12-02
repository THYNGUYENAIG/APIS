tableextension 52012 "ACC Posted WH Ship. Hdr. Ext" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(52012; "ACC WS Created By"; Code[50])
        {
            Caption = 'ACC WS Created By';
            DataClassification = ToBeClassified;
        }
        field(52013; "ACC WS Created At"; DateTime)
        {
            Caption = 'ACC WS Created At';
            DataClassification = ToBeClassified;
        }
    }
}