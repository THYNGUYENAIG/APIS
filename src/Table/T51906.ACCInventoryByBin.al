table 51906 "ACC Inventory By Bin"
{
    Caption = 'ACC Inventory By Bin';
    TableType = Temporary;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(4; "Bin Type Code"; Code[10])
        {
            Caption = 'Bin Type Code';
        }
        field(5; "Block Movement"; Option)
        {
            Caption = 'Block Movement';
            OptionCaption = ' ,Inbound,Outbound,All';
            OptionMembers = " ",Inbound,Outbound,All;
        }
        field(6; "Item Conditions"; Code[20])
        {
            Caption = 'Item Conditions';
        }
        field(7; "Location Conditions"; Code[20])
        {
            Caption = 'Location Conditions';
        }
        field(8; Remark; Text[500])
        {
            Caption = 'Remark-BIN';
        }
        field(9; Unit; Code[10])
        {
            Caption = 'Unit';
        }
        field(10; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
        }
        field(11; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(12; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(13; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(14; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(15; "Item Name"; Text[255])
        {
            Caption = 'Item Name';
        }
        field(16; "Packing Group"; Code[20])
        {
            Caption = 'Packing Group';
        }
        field(17; "Quantity (Packing Group)"; Decimal)
        {
            Caption = 'Quantity (Packing Group)';
            DecimalPlaces = 0 : 3;
        }
        field(18; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
        }
        field(19; "Remark Lot"; Text[500])
        {
            Caption = 'Remark-LOT';
        }
    }
    keys
    {
        key(PK; "Location Code", "Item No.", "Bin Code", "Lot No.")
        {
            Clustered = true;
        }
    }
}
