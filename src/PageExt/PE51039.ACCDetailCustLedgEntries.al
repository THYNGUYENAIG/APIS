pageextension 51039 "ACC Detail. Cust Ledg. Entries" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
                Caption = 'Applied Cust. Ledger Entry No.';
            }
        }
    }
}
