table 51013 "ACC Quality Control Line"
{
    Caption = 'ACC Quality Control Line';
    DataClassification = ToBeClassified;
    DrillDownPageID = "ACC Quality Control Line";
    LookupPageID = "ACC Quality Control Line";
    fields
    {
        field(1; "Truck Number"; Code[20])
        {
            Caption = 'Số Xe';
        }
        field(2; "Delivery Date"; Date)
        {
            Caption = 'Ngày giao hàng';
        }
        field(3; "Delivery Times"; Integer)
        {
            Caption = 'Số lần giao';
        }
        field(4; "Source Document No."; Code[20])
        {
            Caption = 'Source Document No.';
            TableRelation = if (Type = const(Input)) "Warehouse Receipt Line"."No."
            else
            if (Type = const(Output)) "Warehouse Shipment Line"."No.";
        }
        field(5; "Type"; Enum "ACC Classification Type")
        {
            Caption = 'Type';
        }
        field(6; "Source Document Line No."; Integer)
        {
            Caption = 'Source Document Line No.';
        }
        field(7; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Số đơn hàng';
            TableRelation = if (Type = const(Input)) "Purchase Header"."No." where("Document Type" = const(Order))
            else
            if (Type = const(Output)) "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Mã hàng';
            TableRelation = Item;
        }
        field(30; "Item Name"; Text[150])
        {
            Caption = 'Tên hàng hóa';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(40; "Lot No."; Code[50])
        {
            Caption = 'Số lot';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
        }
        field(50; "Packing No."; Code[20])
        {
            Caption = 'Quy cách';
            TableRelation = "BLACC Packing Group";
        }
        field(60; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(70; Quantity; Decimal)
        {
            Caption = 'Số lượng';
        }
        field(80; "Broken Quantity"; Decimal)
        {
            Caption = 'Số lượng vỡ';
        }
        field(90; "Reality Packing No."; Code[20])
        {
            Caption = 'Quy cách thực';
            TableRelation = "BLACC Packing Group";
        }
        field(100; "Packaging Label"; Boolean)
        {
            Caption = 'Nhãn chính, bao bì';
        }
        field(110; "Packaging State"; Boolean)
        {
            Caption = 'Tình trạng bao bì';
        }
        field(120; "No Strange Smell"; Boolean)
        {
            Caption = 'Không mùi lạ';
        }
        field(130; "No Insects"; Boolean)
        {
            Caption = 'Không côn trùng';
        }
        field(140; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
    }
    keys
    {
        key(PK; "Location Code", "Truck Number", "Delivery Date", "Delivery Times", "Line No.")
        {
            Clustered = true;
        }
        key(FK; "Document No.", "Item No.", "Lot No.")
        {
            Clustered = false;
        }
    }
}
