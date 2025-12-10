pageextension 52017 "ACC WH Receipt Subform Ext" extends "Whse. Receipt Subform"
{
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        tfSourceNo: Text;
    begin
        recWRL.Reset();
        recWRL.SetRange("No.", Rec."No.");
        if recWRL.FindSet() then
            repeat
                if StrPos(tfSourceNo, recWRL."Source No.") = 0 then begin
                    if tfSourceNo = '' then begin
                        tfSourceNo += recWRL."Source No."
                    end else begin
                        tfSourceNo += ' | ' + recWRL."Source No.";
                    end;
                end;
            until recWRL.Next() < 1;

        if tfSourceNo = '' then begin
            recWRH.Reset();
            recWRH.SetRange("No.", Rec."No.");
            if recWRH.FindFirst() then begin
                recWRH."ACC Source No." := '';
                recWRH.Modify();
            end;
        end else begin
            recWRH.Reset();
            recWRH.SetRange("No.", Rec."No.");
            if recWRH.FindFirst() then begin
                recWRH."ACC Source No." := tfSourceNo;
                recWRH.Modify();
            end;
        end;
    end;

    //Global
    var
        recWRL: Record "Warehouse Receipt Line";
        recWRH: Record "Warehouse Receipt Header";
}