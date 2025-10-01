pageextension 51910 "ACC Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addafter("BLACC Supplier Mgt. Name")
        {
            field("ACC Planner Code"; Rec."ACC Planner Code")
            {
                ApplicationArea = All;
            }
            field("ACC Planner Name"; Rec."ACC Planner Name")
            {
                ApplicationArea = All;
            }
            field("ACC Accounting Code"; Rec."ACC Accounting Code")
            {
                ApplicationArea = All;
            }
            field("ACC Accounting Name"; Rec."ACC Accounting Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Vendor),
                              "No." = field("No.");
            }
        }
    }
}
