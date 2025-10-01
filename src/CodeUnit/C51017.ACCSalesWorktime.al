codeunit 51017 "ACC Sales Worktime"
{
    TableNo = "Sales Header";
    procedure SalesTimeInday(TransDate: Date; ReasonCode: Code[20]): Boolean
    var
        ReasonTable: Record "ACC Sales Reason";
        ForChecked: Boolean;
    begin
        if TransDate = Today then
            ForChecked := true;
        if ReasonCode <> '' then begin
            ReasonTable.Reset();
            ReasonTable.SetRange(Code, ReasonCode);
            ReasonTable.SetRange(Type, "ACC Sales Reason Type"::SONew);
            if ReasonTable.FindFirst() then
                ForChecked := false;
        end;
        exit(ForChecked);
    end;

    procedure SalesTimeSubmit(DocumentNo: Code[20]; TransDate: Date; ReasonCode: Code[20]): Boolean
    var
        SalesLine: Record "Sales Line";
        ReasonTable: Record "ACC Sales Reason";
        RequestDate: Date;
        ForChecked: Boolean;
        SiteNo: Code[20];
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", "Sales Document Type"::Order);
        SalesLine.SetRange("Document No.", DocumentNo);
        SalesLine.SetRange(Type, "Sales Line Type"::Item);
        SalesLine.SetFilter("Location Code", '<>%1', '');
        if SalesLine.FindFirst() then
            SiteNo := CopyStr(SalesLine."Location Code", 1, 2);

        RequestDate := CalcDate('-1D', TransDate);
        if RequestDate = Today then begin
            if TimeChecked(SiteNo) then
                ForChecked := true;
        end;
        if ReasonCode <> '' then begin
            ReasonTable.Reset();
            ReasonTable.SetRange(Code, ReasonCode);
            ReasonTable.SetRange(Type, "ACC Sales Reason Type"::SOTime);
            if ReasonTable.FindFirst() then
                ForChecked := false;
        end;
        exit(ForChecked);
    end;

    local procedure TimeChecked(SiteNo: Code[20]): Boolean
    var
        SalesTime: Record "ACC Sales Worktime";
        TypeHelper: Codeunit "Type Helper";
        CurTime: Time;
        Hour: Integer;
        Minute: Integer;
        Second: Integer;
        CurInt: Integer;
        PamInt: Integer;
    begin
        PamInt := 0;
        CurTime := Time;
        TypeHelper.GetHMSFromTime(Hour, Minute, Second, CurTime);
        CurInt := (Hour * 10000) + (Minute * 100) + Second;
        SalesTime.Reset();
        SalesTime.SetRange("Site No.", SiteNo);
        if SalesTime.FindFirst() then
            PamInt := SalesTime.Time;
        if PamInt = 0 then
            exit(false);
        if CurInt < PamInt then begin
            exit(false);
        end;
        exit(true);
    end;
}
