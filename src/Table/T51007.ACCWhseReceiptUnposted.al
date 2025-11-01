table 51007 "ACC Whse. Receipt Unposted"
{
    Caption = 'APIS Whse. Receipt Unposted';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(51001; "Code Index"; Integer)
        {
            Caption = 'Code Index';
        }
        field(1; "WR No."; Code[20])
        {
            Caption = 'WR No.';
            TableRelation = "Warehouse Receipt Header"."No.";
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Buyer Name"; Text[250])
        {
            Caption = 'Buyer Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Location Name"; Text[150])
        {
            Caption = 'Location Name';
        }
        field(7; WRBarCode; Text[1000])
        {
            Caption = 'WRBarCode';
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(9; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
        }
        field(10; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(12; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(13; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(14; "Production Date"; Date)
        {
            Caption = 'Production Date';
        }
        field(15; LineQRCode; Text[1000])
        {
            Caption = 'LineQRCode';
        }
        field(16; "Location Manager"; Text[150])
        {
            Caption = 'Location Manager';
        }
        field(17; ImageQRCode; Blob)
        {
            Caption = 'ImageQRCode';
        }
        field(18; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(19; "Transport Name"; Text[255])
        {
            Caption = 'Transport Name';
        }
    }
    keys
    {
        key(PK; "Code Index")
        {
            Clustered = false;
        }
    }
}
