pageextension 51916 "ACC Sales Quote Card Ext" extends "Sales Quote"
{
    layout
    {
        addafter("Requested Delivery Date")
        {
            field("Agreement Start Date"; Rec."Agreement Start Date")
            {
                ApplicationArea = All;
            }
            field("Agreement End Date"; Rec."Agreement End Date")
            {
                ApplicationArea = All;
            }
        }
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
