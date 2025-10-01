table 51004 "ACC Payment Declaration Table"
{
    Caption = 'ACC Payment Declaration Table';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Số chứng từ';
        }
        field(20; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Vendor Account';
        }
        field(30; "Buy-from Vendor Name"; Text[150])
        {
            Caption = 'Vendor Name';
        }
        field(40; "Financial Date"; Date)
        {
            Caption = 'Ngày_Financial date';
        }
        field(50; "Due Date"; Date)
        {
            Caption = 'Ngày đến hạn thanh toán';
        }
        field(60; "Terms Of Payment"; Code[20])
        {
            Caption = 'Terms Of Payment';
        }
        field(70; "Payment Terms Name"; Text[150])
        {
            Caption = 'Phương thức thanh toán';
        }
        field(80; "Invoice Description"; Text[150])
        {
            Caption = 'Diễn giải';
        }
        field(90; "Bank Name"; Text[150])
        {
            Caption = 'Ngân hàng thanh toán';
        }
        field(100; "Payment Status"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Tình trạng';
        }
        field(110; "Customs Declaration No."; Code[20])
        {
            Caption = 'Số tờ khai';
        }
        field(120; "Customs Declaration Date"; Date)
        {
            Caption = 'Ngày tờ khai';
        }
        field(130; "Customs Area"; Text[100])
        {
            Caption = 'Khu vực hải quan';
        }
        field(140; "Invoice"; Code[35])
        {
            Caption = 'Invoice';
        }
        field(150; "Amount"; Decimal)
        {
            Caption = 'Tiền nguyên tệ';
        }
        field(160; "Amount (GL)"; Decimal)
        {
            Caption = 'Tiền VNĐ';
        }
        field(170; "Balance"; Decimal)
        {
            Caption = 'Số dư';
        }
        field(180; "Currency Code"; Code[10])
        {
            Caption = 'Loại tiền';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(FK; "Document No.", "Financial Date")
        { }
        key(FK001; "Customs Declaration No.")
        {
            Clustered = false;
        }
    }
}
