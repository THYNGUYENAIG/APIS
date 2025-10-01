pageextension 51906 "ACC Item Card Ext" extends "Item Card"
{
    layout
    {
        modify("Unit Cost")
        {
            Visible = false;
        }
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Item),
                              "No." = field("No.");
            }
        }
        addlast(Planning)
        {
            field(ManufacturingPolicy; Rec."Manufacturing Policy") { ApplicationArea = All; }

        }
        addlast("BLACC Item Infomation")
        {
            field("ACC BU Ref"; Rec."ACC BU Ref") { ApplicationArea = All; }
        }
    }
}
