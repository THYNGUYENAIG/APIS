table 51008 "ACC Whse. Shipment Unposted"
{
    Caption = 'ACC Whse. Shipment Unposted';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(51001; "Code Index"; Integer)
        {
            Caption = 'Code Index';
        }
        field(51002; "WS No."; Code[20])
        {
            Caption = 'WS No.';
            TableRelation = "Warehouse Shipment Header"."No.";
        }
        field(51003; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(51004; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(51005; "Seller Name"; Text[250])
        {
            Caption = 'Seller Name';
        }
        field(51006; "Registration No"; Text[30])
        {
            Caption = 'Registration No';
        }
        field(51007; "Invoice Address"; Text[250])
        {
            Caption = 'Invoice Address';
        }
        field(51008; "Delivery Address"; Text[1000])
        {
            Caption = 'Delivery Address';
        }
        field(51009; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(51010; "Location Name"; Text[1000])
        {
            Caption = 'Location Name';
        }
        field(51011; "WS Bar Code"; Text[1000])
        {
            Caption = 'WS Bar Code';
        }
        field(51012; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(51013; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
        }
        field(51014; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
        }
        field(51015; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(51016; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(51017; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(51018; "Production Date"; Date)
        {
            Caption = 'Production Date';
        }
        field(51019; LineQRCode; Text[1000])
        {
            Caption = 'LineQRCode';
        }
        field(51020; "Location Manager"; Text[150])
        {
            Caption = 'Location Manager';
        }
        field(51021; "Delivery Note"; Text[2024])
        {
            Caption = 'Delivery Note';
        }
        field(51022; "Delivery Person"; Text[150])
        {
            Caption = 'Delivery Person';
        }
        field(51023; "Delivery Mobile"; Text[50])
        {
            Caption = 'Delivery Mobile';
        }
        field(51024; "Company Name"; Text[150])
        {
            Caption = 'Company Name';
        }
        field(51025; "Company Address"; Text[150])
        {
            Caption = 'Company Address';
        }
        field(51026; "Company Fax"; Text[50])
        {
            Caption = 'Company Fax';
        }
        field(51027; "Company Mobile"; Text[50])
        {
            Caption = 'Company Mobile';
        }
        field(51028; "Seller No"; Code[20])
        {
            Caption = 'Seller No';
        }
        field(51029; ImageQRCode; Blob)
        {
            Caption = 'ImageQRCode';
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
