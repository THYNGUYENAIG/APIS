pageextension 52025 "ACC Posted Purch Receipt Line" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Caption = 'Posting Date';
            }
        }
        addbefore("Buy-from Vendor No.")
        {
            field("BLTEC Customs Declaration No."; Rec."BLTEC Customs Declaration No.")
            {
                ApplicationArea = All;
                Caption = 'Customs Declaration No.';
            }
        }
        // addafter("Quantity Invoiced")
        // {
        //     field(ACC_Packing_Size; arrCellValue[1])
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Packing Size';
        //     }
        // }
    }

    // trigger OnAfterGetRecord()
    // begin
    //     arrCellValue[1] := 0;

    //     recI.Reset();
    //     recI.SetRange("No.", Rec."No.");
    //     if recI.FindFirst() then begin
    //         if recI."BLACC Packing Group" <> '' then begin
    //             recBLACCPG.Reset();
    //             recBLACCPG.SetRange("BLACC Code", recI."BLACC Packing Group");
    //             if recBLACCPG.FindFirst() then arrCellValue[1] := cuACCGP.Divider(Rec.Quantity, recBLACCPG."BLACC Convertion");
    //         end;
    //     end;
    // end;

    var
    // arrCellValue: array[3] of Integer;
    // recI: Record Item;
    // recBLACCPG: Record "BLACC Packing Group";
    // cuACCGP: Codeunit "ACC General Process";
}
