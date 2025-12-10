pageextension 52030 "ACC Customs Decl. List Ext" extends "BLTEC Customs Decl. List"
{
    trigger OnOpenPage()
    var
        recBTECCD: Record "BLTEC Customs Declaration";
        recBTECCDL: Record "BLTEC Customs Decl. Line";
        recI: Record Item;
        tPO: Text;
        tItemName: Text;
        tCO: Text;
        tVend: Text;
        iPos: Integer;
    begin
        recBTECCD.Reset();
        recBTECCD.SetRange(Status, "BLTEC Doc. Status"::Released);
        recBTECCD.SetRange("ACC Title", '');
        if recBTECCD.FindSet() then
            repeat
                tPO := '';
                tItemName := '';
                tCO := '';
                recBTECCDL.Reset();
                recBTECCDL.SetRange("Document No.", recBTECCD."Document No.");
                if recBTECCDL.FindFirst() then begin
                    tPO := recBTECCDL."Source Document No.";
                    // tItemName := recBTECCDL."BLTEC Item Name";
                    tCO := recBTECCDL."BLTEC C/O No.";

                    recI.Reset();
                    recI.SetRange("No.", recBTECCDL."Item No.");
                    if recI.FindFirst() then tItemName := recI.Description;
                end;

                tVend := recBTECCD."Vendor Name";
                iPos := tVend.IndexOf(' ');
                if iPos <> 0 then begin
                    tVend := recBTECCD."Vendor Name".Substring(1, iPos - 1);
                end;

                recBTECCD."ACC Title" := StrSubstNo('NCC# %1 - TK# %2 BL# %3 PO# %4 - %5 FORM# %6'
                                                        , tVend, recBTECCD."BLTEC Customs Declaration No."
                                                        , recBTECCD."BL No.", tPO, tItemName, tCO);
                recBTECCD.Modify();
            until recBTECCD.Next() < 1;
    end;
}