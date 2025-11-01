table 51001 "ACC Imp. Gds Opg. Decl. Table"
{
    Caption = 'APIS Imp. Gds Opg. Decl. Table';
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
            Caption = 'Purchase Order';
        }
        field(20; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Vendor Account';
        }
        field(30; "Buy-from Vendor Name"; Text[150])
        {
            Caption = 'Vendor Name';
        }
        field(40; "Warehouse No."; Code[20])
        {
            Caption = 'Warehouse';
        }
        field(50; "Warehouse Name"; Text[150])
        {
            Caption = 'Warehouse Name';
        }
        field(60; "Item No."; Code[20])
        {
            Caption = 'Item Number';
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
            Caption = 'Số lượng';
        }
        field(100; "Country Name"; Text[150])
        {
            Caption = 'Xuất xứ';
        }
        field(110; "Customs Declaration No."; Code[20])
        {
            Caption = 'Số tờ khai';
        }
        field(120; "Customs Declaration Date"; Date)
        {
            Caption = 'Ngày tờ khai';
        }
        field(130; "Bill No."; Code[20])
        {
            Caption = 'Số B/L';
        }
        field(140; "ETA"; Date)
        {
            Caption = 'ETA';
        }
        field(150; "Site"; Code[10])
        {
            Caption = 'Site';
        }
        field(160; "Site Name"; Text[100])
        {
            Caption = 'Site Name';
        }
        field(170; "Customs Area"; Text[100])
        {
            Caption = 'Khu vực hải quan';
        }
        field(180; "Type Code"; Code[10])
        {
            Caption = 'Mã loại hình';
        }
        field(190; "Cont./Block Type"; Code[20])
        {
            Caption = 'Loại Cont./Khối';
        }
        field(200; "Cont. Quantity"; Decimal)
        {
            Caption = 'Số lượng cont.';
        }
        field(210; "Est. Date Of Receipt"; Date)
        {
            Caption = 'Ngày nhận hàng dự kiến';
        }
        field(220; "Form C/O"; Code[20])
        {
            Caption = 'Form C/O';
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
