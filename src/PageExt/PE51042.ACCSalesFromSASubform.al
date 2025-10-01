pageextension 51042 "ACC Sales From SA Subform" extends "BLACC SalesPlngLinesSOFromSA14"
{
    layout
    {
        addafter("BLACC Qty. to Ship")
        {
            field("ACC Packing Size"; Rec."ACC Packing Size")
            {
                ApplicationArea = All;
            }
        }
    }
}
