page 51922 "ACC Customer List"
{
    ApplicationArea = All;
    Caption = 'APIS Customer List - P51922';
    PageType = List;
    SourceTable = Customer;
    //CardPageId = "Customer Card";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field(Address; Rec."BLACC VN Address") { }
                field(City; Rec.City) { }
                field("Post Code"; Rec."Post Code") { }
                field("Country/Region Code"; Rec."Country/Region Code") { }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { }
                field("Customer Posting Group"; Rec."Customer Posting Group") { }
                field("BLACC Owner Group"; Rec."BLACC Owner Group") { }
                field("BLACC Group Credit Limit"; Rec."BLACC Group Credit Limit") { }
                field("BLACC Customer Group"; Rec."BLACC Customer Group") { }
                field("BLACC Customer Group Des."; Rec."BLACC Customer Group Des.") { }
                field("Statistics Group"; Rec."Statistics Group") { }
                field("Statistics Name"; StatisticsName) { }
                field("VAT Registration No."; Rec."VAT Registration No.") { }
                field("BLACC Sales Pool"; Rec."BLACC Sales Pool") { }
                field("Payment Terms Code"; Rec."Payment Terms Code") { }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)") { }
                field("BLACC Group Credit Limit (LCY)"; Rec."BLACC Group Credit Limit (LCY)") { }
                field("Salesperson Code"; Rec."Salesperson Code") { }
                field("BLACC Salesperson Name"; Rec."BLACC Salesperson Name") { }
                field("Responsibility Center"; Rec."Responsibility Center") { }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group") { }
                field("Payment Method Code"; Rec."Payment Method Code") { }
                field("BLACC Note"; Rec."BLACC Note") { }
                field("BLACC Delivery Note"; Rec."BLACC Delivery Note") { }
                field("BLACC Invoice Note"; Rec."BLACC Invoice Note") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("BLACC Email"; Rec."BLACC Email") { }
                field("Phone No."; Rec."Phone No.") { }
                field("Fax No."; Rec."Fax No.") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Branch"; DimCellText[1]) { }
                field("Branch Name"; DimCellText[2]) { }
                field("Business Unit"; DimCellText[3]) { }
                field("Business Unit Name"; DimCellText[4]) { }
                field("Cost Center"; DimCellText[5]) { }
                field("Cost Center Name"; DimCellText[6]) { }
                field("Division"; DimCellText[7]) { }
                field("Division Name"; DimCellText[8]) { }
                field("Employee"; DimCellText[9]) { }
                field("Employee Name"; DimCellText[10]) { }
                field("Total Sales Amount"; Rec."Total Sales Amount")
                {
                    Caption = 'Sales Amount';
                }
                field("Total Cost Amount"; Rec."Total Cost Amount")
                {
                    Caption = 'Cost (LCY)';
                }
                field("Profit (LCY)"; ProfitAmount)
                {
                    Caption = 'Profit (LCY)';
                }
                field("Profit %"; ProfitPercent)
                {
                    Caption = 'Profit %';
                    DecimalPlaces = 0 : 2;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        DefaultDim: Record "Default Dimension";
        Statistics: Record "BLACC Statistics group";
    begin
        Rec.CalcFields("Total Sales Amount", "Total Cost Amount");
        ProfitAmount := Rec."Total Sales Amount" - Rec."Total Cost Amount";
        if Rec."Total Sales Amount" = 0 then
            ProfitPercent := 0
        else
            ProfitPercent := (ProfitAmount / Rec."Total Sales Amount") * 100;

        if Statistics.Get(Rec."Statistics Group") then
            StatisticsName := Statistics."BLACC Description";
        DefaultDim.Reset();
        DefaultDim.SetCurrentKey("Dimension Code");
        DefaultDim.SetRange("Table ID", 18);
        DefaultDim.SetRange("No.", Rec."No.");
        DefaultDim.SetAutoCalcFields("Dimension Value Name");
        if DefaultDim.FindSet() then begin
            repeat
                if DefaultDim."Dimension Code" = 'BRANCH' then begin
                    DimCellText[1] := DefaultDim."Dimension Value Code";
                    DimCellText[2] := DefaultDim."Dimension Value Name";
                end;
                if DefaultDim."Dimension Code" = 'BUSINESSUNIT' then begin
                    DimCellText[3] := DefaultDim."Dimension Value Code";
                    DimCellText[4] := DefaultDim."Dimension Value Name";
                end;
                if DefaultDim."Dimension Code" = 'COSTCENTER' then begin
                    DimCellText[5] := DefaultDim."Dimension Value Code";
                    DimCellText[6] := DefaultDim."Dimension Value Name";
                end;
                if DefaultDim."Dimension Code" = 'DIVISION' then begin
                    DimCellText[7] := DefaultDim."Dimension Value Code";
                    DimCellText[8] := DefaultDim."Dimension Value Name";
                end;
                if DefaultDim."Dimension Code" = 'EMPLOYEE' then begin
                    DimCellText[9] := DefaultDim."Dimension Value Code";
                    DimCellText[10] := DefaultDim."Dimension Value Name";
                end;
            until DefaultDim.Next() = 0;
        end;
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
        DimCellText: array[10] of Text;
        StatisticsName: Text;
        ProfitAmount: Decimal;
        ProfitPercent: Decimal;
}
