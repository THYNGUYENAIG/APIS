page 51931 "ACC CSR Customer List"
{
    ApplicationArea = All;
    Caption = 'APIS CSR Customer List';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("BLACC Email"; Rec."BLACC Email")
                {
                }
                field("BLACC Delivery Note"; Rec."BLACC Delivery Note")
                {
                    MultiLine = true;
                }
                field("BLACC Invoice Note"; Rec."BLACC Invoice Note")
                {
                    MultiLine = true;
                }
            }
        }
    }
}
