table 51006 "ACC Whse. Shipment Order Table"
{
    Caption = 'ACC Whse. Shipment Order Table';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Sales Order"; Code[20])
        {
            Caption = 'Sales Order';
        }
        field(2; "Sales Name"; Text[250])
        {
            Caption = 'Sales Name';
        }
        field(3; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(4; "Requested Ship Date"; Date)
        {
            Caption = 'Requested Ship Date';
        }
        field(5; "Shipment Date"; Date)
        {
            Caption = 'Ship Date';
        }
        field(6; Open; Decimal)
        {
            Caption = 'Open';
        }
        field(7; Picked; Decimal)
        {
            Caption = 'Picked';
        }
        field(8; Shipped; Decimal)
        {
            Caption = 'Shipped';
        }
        field(9; Status; Text[20])
        {
            Caption = 'Status';
        }
        field(10; Note; Text[150])
        {
            Caption = 'Note';
        }
        field(11; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }

        field(12; "Sales Open"; Boolean)
        {
            Caption = 'Sales Open';
        }
        field(13; "Actual Shipment Date"; DateTime)
        {
            Caption = 'Actual Shipment Date';
        }
        field(14; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(15; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(16; "Unpick"; Decimal)
        {
            Caption = 'Unpick';
        }
    }
    keys
    {
        key(PK; "Sales Order", "Requested Ship Date", "Location Code", "Actual Shipment Date")
        {
            Clustered = false;
        }
    }
}
