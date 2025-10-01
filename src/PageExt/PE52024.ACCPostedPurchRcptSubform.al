pageextension 52024 "ACC Posted Purch Rcpt Sub Ext" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Quantity Invoiced")
        {
            field(ACC_Invoice_No; Rec."BLACC Invoice No.")
            {
                ApplicationArea = All;
                Caption = 'Invoice No';
                // Editable = false;
            }
        }
    }
}