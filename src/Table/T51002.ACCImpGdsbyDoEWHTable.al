table 51002 "ACC Imp. Gds by DoE WH Table"
{
    Caption = 'APIS Imp. Gds by DoE WH Table';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Purchase order';
        }
        field(11; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(20; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Vendor Account';
        }
        field(30; "Buy-from Vendor Name"; Text[150])
        {
            Caption = 'Vendor Name';
        }
        field(40; "Warehouse No."; Code[20])
        {
            Caption = 'Warehouse';
        }
        field(50; "Warehouse Name"; Text[150])
        {
            Caption = 'Warehouse Name';
        }
        field(60; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(70; "Item Name"; Text[150])
        {
            Caption = 'Item Name';
        }
        field(80; "HS Code"; Code[20])
        {
            Caption = 'HS Code';
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Số lượng tờ khai';
        }
        field(100; "Receipt Quantity"; Decimal)
        {
            Caption = 'Số lượng_Kho nhận thực tế';
        }
        field(110; "Customs Declaration No."; Code[30])
        {
            Caption = 'Số tờ khai';
        }
        field(120; "Customs Declaration Date"; Date)
        {
            Caption = 'Ngày tờ khai';
        }
        field(130; "ETA Request"; Date)
        {
            Caption = 'ETA Request';
        }
        field(140; "Site"; Code[10])
        {
            Caption = 'Site';
        }
        field(150; "Site Name"; Text[100])
        {
            Caption = 'Site Name';
        }
        field(160; "Customs Area"; Text[100])
        {
            Caption = 'Khu vực hải quan';
        }
        field(170; "Type Code"; Code[10])
        {
            Caption = 'Mã loại hình';
        }
        field(180; "PSI Invoice"; Code[20])
        {
            Caption = 'Invoice';
        }
        field(190; "Cont. Quantity"; Decimal)
        {
            Caption = 'Số lượng cont.';
        }
        field(200; "Cont. 20 Qty"; Decimal)
        {
            Caption = 'Cont. 20 Qty';
        }
        field(210; "Cont. 40 Qty"; Decimal)
        {
            Caption = 'Cont. 40 Qty';
        }
        field(220; "Physical Date"; Date)
        {
            Caption = 'Ngày nhận hàng thực tế_Physical date';
        }
        field(230; "Quarantine Opening Day"; Date)
        {
            Caption = 'Ngày mở Q';
        }
        field(240; "Date Of First Sale"; Date)
        {
            Caption = 'Ngày đơn hàng bán đầu tiên';
        }
        field(250; "Difference Quantity"; Decimal)
        {
            Caption = 'Số lượng chênh lệch';
        }
        field(260; "Form C/O"; Code[100])
        {
            CalcFormula = lookup("BLTEC Customs Decl. Line"."BLTEC C/O Origin Criteria" where("Source Document No." = field("Document No."),
                                                                                              "Source Document Line No." = field("Line No.")));
            Caption = 'Form C/O';
            FieldClass = FlowField;
        }

        field(270; "Country/Region Code"; Code[10])
        {
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("Item No.")));
            Caption = 'Xuất xứ';
            FieldClass = FlowField;
        }
        field(280; "Certificate Date"; Date)
        {
            CalcFormula = lookup("BLACC CD Certificate Files"."BLACC Valid From" where("BLACC Customs Declaration No." = field("Customs Declaration No.")));
            Caption = 'Ngày chứng thư';
            FieldClass = FlowField;
        }
        field(290; "Actual ETA"; Date)
        {
            CalcFormula = lookup("BLTEC Import Entry"."Actual ETA Date" where("Purchase Order No." = field("Document No."),
                                                                              "Line No." = field("Line No.")));
            Caption = 'Actual ETA';
            FieldClass = FlowField;
        }
        field(300; "Receipt Date"; Date)
        {
            CalcFormula = lookup("ACC Import Plan Table"."Delivery Date" where("Source Document No." = field("Document No."),
                                                                               "Source Line No." = field("Line No.")));
            Caption = 'Ngày nhận hàng';
            FieldClass = FlowField;
        }
        field(310; "C/O Type"; Code[20])
        {
            CalcFormula = lookup(Item."BLTEC C/O Type" where("No." = field("Item No.")));
            Caption = 'C/O Type';
            FieldClass = FlowField;
        }
        field(320; "Container Type"; Code[30])
        {
            CalcFormula = lookup("BLTEC Customs Declaration"."BLTEC Container Type" where("BLTEC Customs Declaration No." = field("Customs Declaration No.")));
            Caption = 'Container Type';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; ID, "Document No.", "Item No.")
        {
            Clustered = true;
        }
        key(FK001; "Customs Declaration No.")
        {
            Clustered = false;
        }
    }
}
