page 51914 "ACC Item List"
{
    ApplicationArea = All;
    Caption = 'ACC Item List - P51914';
    PageType = List;
    SourceTable = Item;
    //CardPageId = "Item Card";
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
                field("Manufacturing Policy"; Rec."Manufacturing Policy") { }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code") { }
                field("Vendor No."; Rec."Vendor No.") { }
                field("BLACC Vendor Name"; Rec."BLACC Vendor Name") { }
                field("Costing Method"; Rec."Costing Method") { }
                field("Inventory Posting Group"; Rec."Inventory Posting Group") { }
                field("BLACC Product Type"; Rec."BLACC Product Type") { }
                field("BLTEC Import Tax %"; Rec."BLTEC Import Tax %") { }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group") { }
                field("No."; Rec."No.") { }
                field(Description; Rec.Description) { }
                field("BLTEC Item Name"; Rec."BLTEC Item Name") { }
                field("BLACC Purchase Name"; Rec."BLACC Purchase Name") { }
                field("Search Description"; Rec."Search Description") { }
                field("BLTEC HS Code"; Rec."BLTEC HS Code") { }
                field("Base Unit of Measure"; Rec."Base Unit of Measure") { }
                field("BLACC Packing Group"; Rec."BLACC Packing Group") { }
                field("BLACC Storage Condition"; Rec."BLACC Storage Condition") { }
                field("BLACC Quality Declaration Rq"; Rec."BLACC Quality Declaration Rq") { }
                field("Certificate No."; ItemCertificate."No.") { }
                field("Published Date"; ItemCertificate."Published Date") { }
                field("Expiration Date"; ItemCertificate."Expiration Date") { }
                field("BLACC Visa Rq"; Rec."BLACC Visa Rq") { }
                field("VISA DOC"; ItemVISA."No.") { }
                field("VISA Publised Date"; ItemVISA."Published Date") { }
                field("VISA Expiration Date"; ItemVISA."Expiration Date") { }
                field("BLACC SA Rq"; Rec."BLACC SA Rq") { }
                field("SA DOC"; ItemSA."No.") { }
                field("SA Publised Date"; ItemSA."Published Date") { }
                field("SA Expiration Date"; ItemSA."Expiration Date") { }
                field("BLACC MA Rq"; Rec."BLACC MA Rq") { }
                field("MA DOC"; ItemMA."No.") { }
                field("MA Publised Date"; ItemMA."Published Date") { }
                field("MA Expiration Date"; ItemMA."Expiration Date") { }
                field("BLACC LOA Rq"; Rec."BLACC LOA Rq") { }
                field("LOA DOC"; ItemLOA."No.") { }
                field("LOA Publised Date"; ItemLOA."Published Date") { }
                field("LOA Expiration Date"; ItemLOA."Expiration Date") { }
                field("BLACC Medical Checkup Rq"; Rec."BLACC Medical Checkup Rq") { }
                field("BLACC Plant Quarantine Rq"; Rec."BLACC Plant Quarantine Rq") { }
                field("BLACC Plant Quar. (BNNPTNT) Rq"; Rec."BLACC Plant Quar. (BNNPTNT) Rq") { }
                field("BLACC Animal Quarantine Rq"; Rec."BLACC Animal Quarantine Rq") { }
                field("BLACC Ani. Quar. (BNNPTNT) Rq"; Rec."BLACC Ani. Quar. (BNNPTNT) Rq") { }
                field("BLACC Shelf Life"; Rec."BLACC Shelf Life") { }
                field("BLACC Supplier Lead Time"; Rec."BLACC Supplier Lead Time") { }
                field("BLACC Inland Lead Time"; Rec."BLACC Inland Lead Time") { }
                field("BLACC Sailing Lead Time"; Rec."BLACC Sailing Lead Time") { }
                field("BLACC Custom Clearance LT"; Rec."BLACC Custom Clearance LT") { }
                field("Lead Time Calculation"; Rec."Lead Time Calculation") { }
                field("BLTEC C/O Type"; Rec."BLTEC C/O Type") { }
                field("BLACC Commodity Group"; Rec."BLACC Commodity Group") { }
                field("BLACC Item Group"; Rec."BLACC Item Group") { }
                field("BLACC Planner"; Rec."BLACC Planner") { }
                field("BLACC Salesperson Code"; Rec."BLACC Salesperson Code") { }
                field("Vendor Item No."; Rec."Vendor Item No.") { }
                field("Common Item No."; Rec."Common Item No.") { }
                field("Net Weight"; Rec."Net Weight") { }
                field("Purchasing Blocked"; Rec."Purchasing Blocked") { }
                field(Blocked; Rec.Blocked) { }
                field("Sales Blocked"; Rec."Sales Blocked") { }
                field("Transport Method"; Rec."BLACC Transport Method") { }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { }
                field(SystemCreatedByName; GetUserName(Rec.SystemCreatedBy)) { Caption = 'Created By Name'; }
                field(SystemModifiedAt; Rec.SystemModifiedAt) { }
                field(SystemModifiedByName; GetUserName(Rec.SystemModifiedBy)) { Caption = 'Modified By Name'; }
            }
        }
    }
    local procedure GetUserName(UserId: Guid): Code[50]
    var
        User: Record User;
    begin
        User.Get(UserId);
        exit(User."User Name");
    end;

    trigger OnAfterGetRecord()
    var
    begin
        ItemCertificate.Reset();
        ItemCertificate.SetRange("Item No.", Rec."No.");
        ItemCertificate.SetRange("Quality Group", Enum::"ACC Quality Group"::CBCL);
        ItemCertificate.SetRange(Outdated, false);
        if ItemCertificate.FindFirst() then begin
        end else begin
            Clear(ItemCertificate);
        end;

        ItemVISA.Reset();
        ItemVISA.SetRange("Item No.", Rec."No.");
        ItemVISA.SetRange(Type, Enum::"BLACC Item Certificate Type"::Visa);
        ItemVISA.SetRange(Outdated, false);
        if ItemVISA.FindFirst() then begin
        end else begin
            Clear(ItemVISA);
        end;

        ItemLOA.Reset();
        ItemLOA.SetRange("Item No.", Rec."No.");
        ItemLOA.SetRange(Type, Enum::"BLACC Item Certificate Type"::LOA);
        ItemLOA.SetRange(Outdated, false);
        if ItemLOA.FindFirst() then begin
        end else begin
            Clear(ItemLOA);
        end;

        ItemMA.Reset();
        ItemMA.SetRange("Item No.", Rec."No.");
        ItemMA.SetRange(Type, Enum::"BLACC Item Certificate Type"::MA);
        ItemMA.SetRange(Outdated, false);
        if ItemMA.FindFirst() then begin
        end else begin
            Clear(ItemMA);
        end;

        ItemSA.Reset();
        ItemSA.SetRange("Item No.", Rec."No.");
        ItemSA.SetRange(Type, Enum::"BLACC Item Certificate Type"::SA);
        ItemSA.SetRange(Outdated, false);
        if ItemSA.FindFirst() then begin
        end else begin
            Clear(ItemSA);
        end;
    end;

    var
        ItemCertificate: Record "BLACC Item Certificate";
        ItemVISA: Record "BLACC Item Certificate";
        ItemLOA: Record "BLACC Item Certificate";
        ItemMA: Record "BLACC Item Certificate";
        ItemSA: Record "BLACC Item Certificate";
}
