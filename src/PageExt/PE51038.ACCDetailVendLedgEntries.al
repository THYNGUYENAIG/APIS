pageextension 51038 "ACC Detail. Vend Ledg. Entries" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
            {
                ApplicationArea = All;
                Caption = 'Applied Vend. Ledger Entry No.';
            }
        }
    }
}
