pageextension 52019 "ACC Item Vendor Voucher Ext" extends "BLACC Item Vendor Voucher"
{
    layout
    {
        addlast(General)
        {
            field(ACC_Description; arrCellText[1])
            {
                ApplicationArea = All;
                Caption = 'Description';
                Editable = false;
            }
        }

        modify(Description)
        {
            trigger OnAfterValidate()
            var
            begin
                GetDesc();
            end;
        }
    }

    #region - ACC Func
    procedure GetDesc()
    begin
        arrCellText[1] := '';
        recBLACCVV.Reset();
        recBLACCVV.SetRange("BLACC Code", Rec."BLACC Code");
        if recBLACCVV.FindFirst() then arrCellText[1] := recBLACCVV."BLACC Description";
    end;
    #endregion

    #region - Sys Func
    trigger OnAfterGetRecord()
    begin
        GetDesc();
    end;
    #endregion

    //Global
    var
        arrCellText: array[3] of Text;
        recBLACCVV: Record "BLACC Vendor Voucher";
}