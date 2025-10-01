page 51021 "AHH Customers"
{
    ApplicationArea = All;
    Caption = 'AHH Customers - P51021';
    PageType = List;
    SourceTable = "AHH Customer";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.") { }
                field("Customer Name"; Rec."Customer Name") { }
            }
        }
    }
}
