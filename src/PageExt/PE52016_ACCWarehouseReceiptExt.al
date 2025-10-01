pageextension 52016 "ACC WH Receipt Ext" extends "Warehouse Receipt"
{
    layout
    {
        addlast(General)
        {
            field("ACC Vendor No"; Rec."ACC Vendor No")
            {
                ApplicationArea = All;
                Caption = 'Vendor/Customer No';
                Editable = false;
            }
            field("ACC Vendor Name"; Rec."ACC Vendor Name")
            {
                ApplicationArea = All;
                Caption = 'Vendor/Customer Name';
                Editable = false;
            }
        }
    }

    //Global
    var
}