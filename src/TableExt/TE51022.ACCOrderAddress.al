tableextension 51022 "ACC Order Address" extends "Order Address"
{
    fields
    {
        field(50001; "ACC Vendor Address"; Text[250])
        {
            Caption = 'Vendor Address';
        }
    }
}