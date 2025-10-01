table 51012 "ACC Quality Control Header"
{
    Caption = 'ACC Quality Control Header';
    DataCaptionFields = "Truck Number", "Delivery Date";
    LookupPageID = "ACC Quality Control Header";
    DataClassification = ToBeClassified;
    fields
    {
        field(10; "Truck Number"; Code[20])
        {
            Caption = 'Số Xe';
        }
        field(11; "Delivery Date"; Date)
        {
            Caption = 'Ngày giao hàng';
        }
        field(12; "Delivery Times"; Integer)
        {
            Caption = 'Số lần giao';
            InitValue = 1;
        }
        field(20; "Container No."; Code[20])
        {
            Caption = 'Container No.';
        }
        field(30; "Seal No."; Code[20])
        {
            Caption = 'Số Seal';
        }
        field(40; Dock; Text[100])
        {
            Caption = 'Dock';
        }
        field(50; TGBD; Text[100])
        {
            Caption = 'TGBD';
        }
        field(60; TGKT; Text[100])
        {
            Caption = 'TGKT';
        }
        field(70; Floor; Boolean)
        {
            Caption = 'Sàn';
        }
        field(80; Wall; Boolean)
        {
            Caption = 'Vách';
        }
        field(90; Ceiling; Boolean)
        {
            Caption = 'Trần';
        }
        field(100; "No Strange Smell"; Boolean)
        {
            Caption = 'Không mùi lạ';
        }
        field(110; "No Insects"; Boolean)
        {
            Caption = 'Không côn trùng';
        }
        field(120; "Vehicle Temperature"; Boolean)
        {
            Caption = 'Nhiệt độ xe';
        }
        field(130; "Type"; Enum "ACC Classification Type")
        {
            Caption = 'Type';
        }
        field(140; "Handle (If Any)"; Text[250])
        {
            Caption = 'Xử lý (nếu có)';
        }
        field(150; "Line Handle (If Any)"; Text[250])
        {
            Caption = 'Xử lý (nếu có)';
        }
        field(160; "Printed"; Boolean)
        {
            Caption = 'Printed';
        }
        field(170; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(180; "Has Line"; Boolean)
        {
            Caption = 'Has Line';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Location Code", "Truck Number", "Delivery Date", "Delivery Times")
        {
            Clustered = true;
        }
        key(FK01; "Truck Number", "Container No.", "Delivery Date", "Delivery Times")
        {
            Clustered = false;
        }
    }
    trigger OnDelete()
    var
        QualityLine: Record "ACC Quality Control Line";
    begin
        QualityLine.SetRange("Location Code", "Location Code");
        QualityLine.SetRange("Truck Number", "Truck Number");
        QualityLine.SetRange("Delivery Date", "Delivery Date");
        QualityLine.SetRange("Delivery Times", "Delivery Times");
        if QualityLine.FindSet() then
            repeat
                QualityLine.Delete(true);
            until QualityLine.Next() = 0;
    end;
}
