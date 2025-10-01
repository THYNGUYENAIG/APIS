pageextension 51920 "ACC General Journal" extends "General Journal"
{
    layout
    {
        addafter(JournalErrorsFactBox)
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Posted Gen. Journal Line"),
                              "No." = field("Document No.");
            }
        }
    }
}
