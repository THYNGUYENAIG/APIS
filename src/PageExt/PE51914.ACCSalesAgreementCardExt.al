pageextension 51914 "ACC Sales Agreement Card Ext" extends "BLACC Sales Agreement Card"
{
    layout
    {
        addafter(Control1902018507)
        {
            part(ACCICF_Factbox; "ACC Item Cert FactBox")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "No." = field("No.");
            }
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
