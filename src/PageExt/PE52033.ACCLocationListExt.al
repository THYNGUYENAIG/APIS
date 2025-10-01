pageextension 52033 "ACC Location List Ext" extends "Location List"
{
    procedure GetValueFromFilter(ivtSeparators: Text): Text
    var
        recL: Record "Location";
        recRef: RecordRef;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        cuACCGP: Codeunit "ACC General Process";
        lst: List of [Text];
        iCnt: Integer;
        tSel: Text;
    begin
        CurrPage.SetSelectionFilter(recL);
        recRef.GetTable(recL);
        lst := cuACCGP.GetValueFromFilter(recRef, recL.FieldNo("Code"));
        for iCnt := 1 to lst.Count do begin
            tSel += Format(lst.Get(iCnt) + ivtSeparators);
        end;
        tSel := tSel.Remove(StrLen(tSel), 1);
        exit(tSel);
    end;
}