pageextension 51092 "ACC Customer List" extends "Customer List"
{
    layout
    {
        addafter("BLACC Customer Group")
        {
            field("Statistics Group"; Rec."Statistics Group")
            {
                ApplicationArea = All;
            }
            field(ARName; ARName)
            {
                ApplicationArea = All;
                Caption = 'AR Name';
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("ACC BU Ref"; Rec."ACC BU Ref")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Customer),
                              "No." = field("No.");
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(ACCExportExcel)
            {
                ApplicationArea = All;
                Caption = 'Send Sales Balance To Email';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ExportExcel: Codeunit "ACC Sales Balance Reminder";
                begin
                    ExportExcel.ExportExcelSPO();
                end;
            }
            action(ACCARSalesBalance)
            {
                ApplicationArea = All;
                Caption = 'Export Sales Balance To Excel';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ARSalesBalance: Page "ACC Excel Sales Balance";
                begin
                    ARSalesBalance.Run();
                end;
            }
            action(CustNameInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Check Customer Name';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CustTable: Record Customer;
                    JsonObject: JsonObject;
                    JsonText: Text;
                    CustList: Text;
                    DocName: Text;
                begin
                    CustTable.Reset();
                    if CustTable.FindSet() then begin
                        repeat
                            Clear(JsonObject);
                            JsonObject.Add('name', CustTable.Name);
                            JsonText := Format(JsonObject);
                            if StrPos(JsonText, '\') <> 0 then begin
                                if CustList = '' then begin
                                    CustList := CustTable."No.";
                                    DocName := JsonText;
                                end else begin
                                    CustList += '|' + CustTable."No.";
                                    DocName += '>>>' + JsonText;
                                end;
                            end;
                        until CustTable.Next() = 0;
                    end;
                    Message(CustList + '\' + DocName);
                end;
            }

            action(CustAddressInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Check Customer Address';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CustTable: Record Customer;
                    JsonObject: JsonObject;
                    JsonText: Text;
                    CustList: Text;
                    DocName: Text;
                begin
                    CustTable.Reset();
                    if CustTable.FindSet() then begin
                        repeat
                            Clear(JsonObject);
                            JsonObject.Add('address', CustTable.Address + '' + CustTable."Address 2");
                            JsonText := Format(JsonObject);
                            if StrPos(JsonText, '\') <> 0 then begin
                                if CustList = '' then begin
                                    CustList := CustTable."No.";
                                    DocName := JsonText;
                                end else begin
                                    CustList += '|' + CustTable."No.";
                                    DocName += '>>>' + JsonText;
                                end;
                            end;
                        until CustTable.Next() = 0;
                    end;
                    Message(CustList + '\' + DocName);
                end;
            }
        }
    }

    procedure GetSelection(): Text
    var
        CustTable: Record Customer;
    begin
        CurrPage.SetSelectionFilter(CustTable);
        exit(GetSelectionFilterForStatisticsGroup(CustTable));
    end;

    local procedure GetSelectionFilterForStatisticsGroup(var CustTable: Record Customer): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(CustTable);
        exit(GetSelectionFilter(RecRef, CustTable.FieldNo("No.")));
    end;

    local procedure GetSelectionFilter(var TempRecRef: RecordRef; SelectionFieldID: Integer): Text
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
    begin
        if TempRecRef.IsTemporary then begin
            RecRef := TempRecRef.Duplicate();
            RecRef.Reset();
        end else
            RecRef.Open(TempRecRef.Number, false, TempRecRef.CurrentCompany);

        TempRecRefCount := TempRecRef.Count();
        if TempRecRefCount > 0 then begin
            TempRecRef.Ascending(true);
            TempRecRef.Find('-');
            while TempRecRefCount > 0 do begin
                TempRecRefCount := TempRecRefCount - 1;
                RecRef.SetPosition(TempRecRef.GetPosition());
                RecRef.Find();
                FieldRef := RecRef.Field(SelectionFieldID);
                FirstRecRef := Format(FieldRef.Value);
                LastRecRef := FirstRecRef;
                More := TempRecRefCount > 0;
                while More do
                    if RecRef.Next() = 0 then
                        More := false
                    else begin
                        SavePos := TempRecRef.GetPosition();
                        TempRecRef.SetPosition(RecRef.GetPosition());
                        if not TempRecRef.Find() then begin
                            More := false;
                            TempRecRef.SetPosition(SavePos);
                        end else begin
                            FieldRef := RecRef.Field(SelectionFieldID);
                            LastRecRef := Format(FieldRef.Value);
                            TempRecRefCount := TempRecRefCount - 1;
                            if TempRecRefCount = 0 then
                                More := false;
                        end;
                    end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstRecRef = LastRecRef then
                    SelectionFilter := SelectionFilter + AddQuotes(FirstRecRef)
                else
                    SelectionFilter := SelectionFilter + AddQuotes(FirstRecRef) + '..' + AddQuotes(LastRecRef);
                if TempRecRefCount > 0 then
                    TempRecRef.Next();
            end;
            exit(SelectionFilter);
        end;
    end;

    local procedure AddQuotes(inString: Text): Text
    begin
        inString := ReplaceString(inString, '''', '''''');
        if DelChr(inString, '=', ' &|()*@<>=.!?') = inString then
            exit(inString);
        exit('''' + inString + '''');
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        while STRPOS(String, FindWhat) > 0 do begin
            NewString := NewString + DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith;
            String := COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        end;
        NewString := NewString + String;
    end;
    trigger OnAfterGetRecord()
    var
        StatisticsGroup: Record "BLACC Statistics group";
    begin
        if StatisticsGroup.Get(Rec."Statistics Group") then
            ARName := StatisticsGroup."BLACC Description";
    end;

    trigger OnOpenPage()
    var
        BCHelper: Codeunit "BC Helper";
        BusinessUnit: Text;
        BUFilter: Text;
    begin
        BusinessUnit := BCHelper.GetSalesByCurUserId();
        if BusinessUnit = '' then
            BusinessUnit := '*';
        BUFilter := StrSubstNo('%1|%2', BusinessUnit, '''''');
        Rec.Reset();
        Rec.FilterGroup(9);
        Rec.SetFilter("Responsibility Center", BUFilter);
        Rec.FilterGroup(0);
    end;

    var
        ARName: Text;
}
