pageextension 51919 "ACC Posted General Journal" extends "Posted General Journal"
{
    layout
    {
        addafter(Control1900919607)
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Posted Gen. Journal Line"),
                              "No." = field("BLACC Pre-Document No.");
            }
        }
    }
}
