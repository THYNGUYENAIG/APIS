table 51993 "ACC BU Inventory Entry"
{
    Caption = 'ACC BU Inventory Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(30; "Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Entry Type';
            Editable = false;
        }
        field(50; "Document Type"; Enum "AIG Item Ledger Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(80; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(90; Site; Code[20])
        {
            Caption = 'Site';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }

        field(110; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            var
            begin
                if (Rec."Entry Type" = "Item Ledger Entry Type"::Sale) OR (Rec."Entry Type" = "Item Ledger Entry Type"::Purchase) then
                    if Rec."Business Unit" <> xRec."Business Unit" then
                        Error(StrSubstNo('Giao dịch %1 không chỉnh BU.', Rec."Entry Type"));
            end;
        }
        field(120; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }

        field(140; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(150; "Adjustment"; Boolean)
        {
            Caption = 'Adjustment';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry Type", "Document Type", "Order No.", "Item No.", Site, "Business Unit")
        {
            Clustered = true;
        }
    }
}
