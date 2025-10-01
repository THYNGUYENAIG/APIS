pageextension 51921 "ACC Payment Journal" extends "Payment Journal"
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
