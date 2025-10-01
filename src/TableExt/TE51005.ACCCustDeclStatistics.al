tableextension 51005 "ACC Cust. Decl. Statistics" extends "BLTEC Customs Declaration"
{
    fields
    {
        field(51001; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51002; "Import Tax"; Decimal)
        {
            Caption = 'Thuế nhập khẩu';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51003; "Value Added Tax"; Decimal)
        {
            Caption = 'Thuế giá trị gia tăng';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51004; "Anti-dumping Tax"; Decimal)
        {
            Caption = 'Thuế phá giá';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51005; "Self-defense Tax"; Decimal)
        {
            Caption = 'Thuế tự vệ';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51006; "Import Tax (GL)"; Decimal)
        {
            Caption = 'Thuế nhập khẩu (Payment)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51007; "Value Added Tax (GL)"; Decimal)
        {
            Caption = 'Thuế giá trị gia tăng (Payment)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51008; "Anti-dumping Tax (GL)"; Decimal)
        {
            Caption = 'Thuế phá giá (Payment)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51009; "Self-defense Tax (GL)"; Decimal)
        {
            Caption = 'Thuế tự vệ (Payment)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51010; "Customs Tax Amount"; Decimal)
        {
            Caption = 'Tổng cộng thuế tờ khai';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51011; "Ledger Tax Amount"; Decimal)
        {
            Caption = 'Tổng cộng thanh toán';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51012; "Total Tax Amount"; Decimal)
        {
            Caption = 'Tổng cộng';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51013; "Payment State"; Enum "ACC Customs Payment State")
        {
            Caption = 'Tình trạng thanh toán';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51014; Note; Text[150])
        {
            Caption = 'Note';
            DataClassification = ToBeClassified;
        }
        field(51015; "GL Import Tax"; Decimal)
        {
            Caption = 'Thuế nhập khẩu (GL)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51016; "GL Value Added Tax"; Decimal)
        {
            Caption = 'Thuế giá trị gia tăng (GL)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51017; "GL Anti-dumping Tax"; Decimal)
        {
            Caption = 'Thuế phá giá (GL)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(51018; "Customs Office"; Text[50])
        {
            Caption = 'Customs Office';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."BLTEC Customs Office" where("BLTEC Customs Declaration No." = field("BLTEC Customs Declaration No.")));
        }
        field(51019; "Customs Office Name"; Text[250])
        {
            Caption = 'Customs Office Name';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Office"."BLTEC Description" where("BLTEC Code" = field("Customs Office")));
        }
    }
}
