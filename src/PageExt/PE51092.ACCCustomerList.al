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
