page 51923 "ACC Vendor List"
{
    ApplicationArea = All;
    Caption = 'ACC Vendor List - P51923';
    PageType = List;
    SourceTable = Vendor;
    //CardPageID = "Vendor Card";
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
                field("Invoice Disc. Code"; Rec."Invoice Disc. Code") { }
                field("Vendor Posting Group"; Rec."Vendor Posting Group") { }
                field("Purchaser Code"; Rec."Purchaser Code") { }
                field("BLACC Purchaser Name"; Rec."BLACC Purchaser Name") { }
                field("BLACC Supplier Mgt. Code"; Rec."BLACC Supplier Mgt. Code") { }
                field("BLACC Supplier Mgt. Name"; Rec."BLACC Supplier Mgt. Name")
                {
                    Caption = 'Supplier Management Name';
                }
                field("ACC Accounting Code"; Rec."ACC Accounting Code") { }
                field("ACC Accounting Name"; Rec."ACC Accounting Name") { }
                field("ACC Planner Code"; Rec."ACC Planner Code") { }
                field("ACC Planner Name"; Rec."ACC Planner Name") { }
                field("BLACC Vendor Group"; Rec."BLACC Vendor Group") { }
                field(Blocked; Rec.Blocked) { }
                field("Payment Terms Code"; Rec."Payment Terms Code") { }
                field("VAT Registration No."; Rec."VAT Registration No.") { }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group") { }
                field("E-Mail"; Rec."E-Mail") { }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("Phone No."; Rec."Phone No.") { }
                field("Payment Method Code"; Rec."Payment Method Code") { }
                field("Shipment Method Code"; Rec."Shipment Method Code") { }
                field("Branch"; DimCellText[1]) { }
                //field("Branch Name"; DimCellText[2]) { }
                field("Division"; DimCellText[3]) { }
                //field("Division Name"; DimCellText[4]) { }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        DefaultDim: Record "Default Dimension";
    begin
        DefaultDim.Reset();
        DefaultDim.SetCurrentKey("Dimension Code");
        DefaultDim.SetRange("Table ID", 23);
        DefaultDim.SetRange("No.", Rec."No.");
        DefaultDim.SetAutoCalcFields("Dimension Value Name");
        if DefaultDim.FindSet() then begin
            repeat
                if DefaultDim."Dimension Code" = 'BRANCH' then begin
                    DimCellText[1] := DefaultDim."Dimension Value Code";
                    DimCellText[2] := DefaultDim."Dimension Value Name";
                end;
                if DefaultDim."Dimension Code" = 'DIVISION' then begin
                    DimCellText[3] := DefaultDim."Dimension Value Code";
                    DimCellText[4] := DefaultDim."Dimension Value Name";
                end;
            until DefaultDim.Next() = 0;
        end;
    end;

    var
        DimCellText: array[4] of Text;
}
