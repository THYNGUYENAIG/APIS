page 51013 "ACC Quality Control Line"
{
    ApplicationArea = All;
    Caption = 'ACC Quality Control Line - P51013';
    PageType = ListPart;
    SourceTable = "ACC Quality Control Line";
    UsageCategory = Lists;
    AutoSplitKey = true;
    DelayedInsert = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Document No."; Rec."Source Document No.")
                {
                    Editable = false;
                }
                field("Truck Number"; Rec."Truck Number")
                {
                    Editable = false;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    Editable = false;
                }
                field("Delivery times"; Rec."Delivery Times")
                {
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Broken Quantity"; Rec."Broken Quantity") { }
                field("Packing No."; Rec."Packing No.")
                {
                    Editable = false;
                }
                field("Reality Packing No."; Rec."Reality Packing No.") { }
                field("Packaging Label"; Rec."Packaging Label") { }
                field("Packaging State"; Rec."Packaging State") { }
                field("No Insects"; Rec."No Insects") { }
                field("No Strange Smell"; Rec."No Strange Smell") { }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        QualityHeader: Record "ACC Quality Control Header";
    begin
        if QualityHeader.Get(Rec."Location Code", Rec."Truck Number", Rec."Delivery Date", Rec."Delivery Times") then begin
            Rec.Type := QualityHeader.Type;
        end;
    end;
}
