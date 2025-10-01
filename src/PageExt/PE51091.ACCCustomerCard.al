pageextension 51091 "ACC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Disable Search by Name")
        {
            field(ReportLayout; Rec."Report Layout")
            {
                ApplicationArea = ALL;
                Caption = 'Report Layout';
            }
            field("ACC BU Ref"; Rec."ACC BU Ref")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Customer),
                              "No." = field("No.");
            }
        }
    }
}
