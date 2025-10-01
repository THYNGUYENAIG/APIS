pageextension 51913 "ACC Sales Agreement List Ext" extends "BLACC Sales Agreements"
{
    layout
    {
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Sales Header"),
                              "No." = field("No.");
            }
        }
    }
}
