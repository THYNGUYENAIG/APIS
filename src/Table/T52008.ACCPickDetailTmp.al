table 52008 "ACC Pick Detail Tmp"
{
    Caption = 'ACC  Pick Detail Tmp';
    TableType = Temporary;

    fields
    {
        field(5; "Entry No"; Integer) { Caption = 'Entry No'; }
        // field(10; "Document No"; Code[20]) { Caption = 'Document No'; }
        field(15; "Source No"; Code[20]) { Caption = 'Source No'; }
        field(20; "Item No"; Code[30]) { Caption = 'Item No'; }
        field(25; "Bin Code"; Code[20]) { Caption = 'Bin Code'; }
        field(30; "Lot No"; Code[30]) { Caption = 'Lot No'; }
        field(35; "Status"; Text[30]) { Caption = 'Status'; }
        field(40; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(45; "Item Name"; Text[250]) { Caption = 'Item Name'; }
        field(50; "Qty"; Decimal) { Caption = 'Qty'; }
        field(55; "Qty Packaging"; Decimal) { Caption = 'Qty Packaging'; }
        field(60; "Pallet From"; Code[2000]) { Caption = 'Pallet From'; }
        field(65; "Pallet To"; Text[2000]) { Caption = 'Pallet To'; }
        field(70; "Manufacturing Date"; Date) { Caption = 'Manufacturing Date'; }
        field(75; "Expiration Date"; Date) { Caption = 'Expire Date'; }
        field(80; "Received Date"; Date) { Caption = 'Create Date'; }
        field(85; "Best Date"; Date) { Caption = 'Best Date'; }
        field(90; "User Release"; Text[100]) { Caption = 'User Release'; }
        field(95; "User Ship"; Text[100]) { Caption = 'User Ship'; }
        field(100; "Pick No"; Text[1000]) { Caption = 'Pick No.'; }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
