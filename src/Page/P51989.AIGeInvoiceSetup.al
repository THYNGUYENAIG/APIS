page 51989 "AIG eInvoice Setup"
{
    ApplicationArea = All;
    Caption = 'AIG eInvoice Setup';
    PageType = List;
    SourceTable = "AIG eInvoice Setup";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company No."; Rec."Company No.")
                {
                }
                field("eInvoice Type"; Rec."eInvoice Type")
                {
                }
                field("eInvoice Template No."; Rec."eInvoice Template No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
