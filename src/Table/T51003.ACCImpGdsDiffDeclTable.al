table 51003 "ACC Imp. Gds Diff. Decl. Table"
{
    Caption = 'APIS Imp. Gds With Diff. Decl. Table';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Purchase order';
        }
        field(20; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Vendor Account';
        }
        field(30; "Buy-from Vendor Name"; Text[150])
        {
            Caption = 'Vendor Name';
        }
        field(60; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(70; "Item Name"; Text[150])
        {
            Caption = 'Item Name';
        }
        field(80; "HS Code"; Code[20])
        {
            Caption = 'HS Code';
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Số lượng tờ khai';
        }
        field(100; "Receipt Quantity"; Decimal)
        {
            Caption = 'Số lượng_Kho nhận thực tế';
        }
        field(110; "Customs Declaration No."; Code[30])
        {
            Caption = 'Số tờ khai';
        }
        field(120; "Customs Declaration Date"; Date)
        {
            Caption = 'Ngày tờ khai';
        }
        field(130; "Site"; Code[10])
        {
            Caption = 'Site';
        }
        field(140; "Site Name"; Text[100])
        {
            Caption = 'Site Name';
        }
        field(150; "Customs Area"; Text[100])
        {
            Caption = 'Khu vực hải quan';
        }
        field(160; "Type Code"; Code[10])
        {
            Caption = 'Mã loại hình';
        }
        field(170; "PSI Invoice"; Code[20])
        {
            Caption = 'Invoice';
        }
        field(180; "Cont. Quantity"; Decimal)
        {
            Caption = 'Số lượng cont.';
        }
        field(190; "Cont. 20 Qty"; Decimal)
        {
            Caption = 'Cont. 20 Qty';
        }
        field(200; "Cont. 40 Qty"; Decimal)
        {
            Caption = 'Cont. 40 Qty';
        }
        field(210; "Difference Quantity"; Decimal)
        {
            Caption = 'Số lượng chênh lệch';
        }
        field(220; "Container Type"; Code[30])
        {
            CalcFormula = lookup("BLTEC Customs Declaration"."BLTEC Container Type" where("BLTEC Customs Declaration No." = field("Customs Declaration No.")));
            Caption = 'Container Type';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; ID, "Document No.", "Item No.")
        {
            Clustered = true;
        }
        key(FK001; "Customs Declaration No.")
        {
            Clustered = false;
        }
    }
}
