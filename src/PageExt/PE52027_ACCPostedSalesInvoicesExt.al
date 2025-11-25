pageextension 52027 "ACC Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ACCChangeDocument)
            {
                ApplicationArea = All;
                Caption = 'Change External Document';
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    eInvoice: Page "ACC External Document Change";
                //Field: Record "Sales Invoice Header";
                //SelectionFilterManagement: Codeunit SelectionFilterManagement;
                //RecRef: RecordRef;
                //DocumentNo: Text;
                //PostingDate: Date;
                begin
                    //CurrPage.SetSelectionFilter(Field);
                    //RecRef.GetTable(Field);
                    //DocumentNo := SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("No."));
                    //Evaluate(PostingDate, SelectionFilterManagement.GetSelectionFilter(RecRef, Field.FieldNo("Posting Date")));
                    //eInvoice.SetInvoiceValue(DocumentNo, PostingDate);
                    eInvoice.SetInvoiceValue(Rec."No.", Rec."Posting Date");
                    eInvoice.Run();
                end;
            }
        }
    }

    procedure GetSelection(): Text
    var
        InvoiceHeader: Record "Sales Invoice Header";
    begin
        CurrPage.SetSelectionFilter(InvoiceHeader);
        exit(GetSelectionFilterForStatisticsGroup(InvoiceHeader));
    end;

    local procedure GetSelectionFilterForStatisticsGroup(var InvoiceHeader: Record "Sales Invoice Header"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(InvoiceHeader);
        exit(GetSelectionFilter(RecRef, InvoiceHeader.FieldNo("No.")));
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
}