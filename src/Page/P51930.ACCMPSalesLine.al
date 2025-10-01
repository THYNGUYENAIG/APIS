page 51930 "ACC MP Sales Line"
{
    ApplicationArea = All;
    Caption = 'ACC MP Sales Line';
    PageType = List;
    SourceTable = "ACC MP Sales Line";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line Created At"; Rec."Line Created At") { }
                field("Sales No."; Rec."Sales No.") { }
                field("Line No."; Rec."Line No.") { }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field("Item Name"; Rec."Item Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Location Code"; Rec."Location Code") { }
                field(Quantity; Rec.Quantity) { }
                field(Onhand; Rec.Onhand) { }
                field(Remaining; Rec.Remaining) { }
                field("Manufacturing Policy"; Rec."Manufacturing Policy") { }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        MPItemLedgerEntry();
        MPSalesLine();
        Rec.SetRange("Sales Filter", true);
    end;



    local procedure CalcPhysicalOnhand(ItemNo: Text; SiteNo: Text): Decimal
    var
    begin
        if SiteNo <> '' then begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.SetRange("Site No.", SiteNo);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end else begin
            ItemLedgerRec.Reset();
            ItemLedgerRec.SetRange("Item No.", ItemNo);
            ItemLedgerRec.CalcSums(Quantity);
            exit(ItemLedgerRec.Quantity);
        end;
        exit(0);
    end;

    local procedure MPItemLedgerEntry()
    var
        ItemLedgerQry: Query "ACC MP Item Ledger Entry";
    begin
        ItemLedgerRec.Reset();
        ItemLedgerRec.DeleteAll();
        ItemLedgerRec.ID := 0;
        if ItemLedgerQry.Open() then begin
            while ItemLedgerQry.Read() do begin
                ItemLedgerRec.Init();
                ItemLedgerRec.ID += 1;
                ItemLedgerRec."Item No." := ItemLedgerQry.ItemNo;
                ItemLedgerRec."Location Code" := ItemLedgerQry.LocationCode;
                if ItemLedgerQry.LocationCode = 'INSTRANSIT' then begin
                    ItemLedgerRec."Site No." := CopyStr(ItemLedgerQry.TransferToCode, 1, 2);
                end else
                    ItemLedgerRec."Site No." := CopyStr(ItemLedgerQry.LocationCode, 1, 2);
                ItemLedgerRec.Quantity := ItemLedgerQry.RemainingQuantity;
                ItemLedgerRec.Insert();
            end;
            ItemLedgerQry.Close();
        end;
    end;

    local procedure MPSalesLine()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        MPSalesLine: Record "ACC MP Sales Line";
        SiteNo: Text;
        TmpNo: Text;
        NoTmp: Text;
        Onhand: Decimal;
        Quantity: Decimal;
        FCQuantity: Decimal;
        ToDate: Date;
    begin
        ToDate := CalcDate('CM', Today);
        ToDate := CalcDate('+2M', ToDate);
        MPSalesLine.Reset();
        MPSalesLine.DeleteAll();

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", "Sales Document Type"::Order);
        SalesHeader.SetFilter("Posting Date", '..%1', ToDate);
        if SalesHeader.FindSet() then
            repeat
                SalesLine.Reset();
                SalesLine.SetCurrentKey("No.", "Location Code");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, "Sales Line Type"::Item);
                SalesLine.SetFilter("No.", '<>SERVICE*');
                if SalesLine.FindSet() then begin
                    repeat
                        SiteNo := CopyStr(SalesLine."Location Code", 1, 2);
                        MPSalesLine.Init();
                        MPSalesLine."Line Created At" := SalesLine.SystemCreatedAt;
                        MPSalesLine."Sales No." := SalesLine."Document No.";
                        MPSalesLine."Line No." := SalesLine."Line No.";
                        MPSalesLine."Item No." := SalesLine."No.";
                        MPSalesLine.Description := SalesLine.Description;
                        MPSalesLine."Item Name" := SalesLine."BLTEC Item Name";
                        MPSalesLine."Location Code" := SalesLine."Location Code";
                        MPSalesLine."Site Code" := SiteNo;
                        MPSalesLine.Quantity := SalesLine.Quantity;

                        MPSalesLine."Posting Date" := SalesHeader."Posting Date";
                        MPSalesLine."Requested Date" := SalesHeader."Requested Delivery Date";

                        MPSalesLine.Onhand := CalcPhysicalOnhand(SalesLine."No.", SiteNo);
                        MPSalesLine.Insert();
                    until SalesLine.Next() = 0;
                end;
            until SalesHeader.Next() = 0;

        MPSalesLine.Reset();
        MPSalesLine.SetCurrentKey("Item No.", "Site Code", "Line Created At");
        if MPSalesLine.FindSet() then
            repeat
                NoTmp := StrSubstNo('%1-%2', MPSalesLine."Item No.", MPSalesLine."Site Code");
                if TmpNo <> NoTmp then begin
                    FCQuantity := MPSalesLine.Quantity;
                end else
                    FCQuantity += MPSalesLine.Quantity;
                MPSalesLine.Remaining := MPSalesLine.Onhand - FCQuantity;
                if MPSalesLine.Remaining < 0 then
                    MPSalesLine."Sales Filter" := true;
                MPSalesLine.Modify();
                TmpNo := NoTmp;
            until MPSalesLine.Next() = 0;
    end;

    var
        ItemLedgerRec: Record "ACC MP Item Ledger Entry";

}
