table 51905 "ACC DMS Library"
{
    Caption = 'APIS DMS Library';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Content Type"; Enum "ACC DOC Content Type")
        {
            Caption = 'Content Type';
            //Editable = false;
        }
        field(10; "SPO No"; Integer)
        {
            Caption = 'SPO No';
            Editable = false;
        }
        field(11; SPOSync; Boolean)
        {
            Caption = 'Synchronized';
            Editable = false;
        }
        field(20; "File No"; Text[100])
        {
            Caption = 'File No';
            Editable = false;
        }
        field(30; "File Name"; Text[255])
        {
            Caption = 'File Name';
            Editable = false;
        }
        field(31; "Original File Name"; Text[255])
        {
            Caption = 'Original File Name';
            Editable = false;
        }
        field(32; "Document Name"; Text[1024])
        {
            Caption = 'Document Name';
            Editable = false;
        }
        field(40; "URL"; Text[1000])
        {
            Caption = 'URL';
            Editable = false;
        }
        field(50; "AX Vendor Code"; Code[20])
        {
            Caption = 'AX Vendor Code';
            Editable = false;
        }
        field(60; "AX Item Code"; Code[20])
        {
            Caption = 'AX Item Code';
            Editable = false;
        }
        field(70; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                VendTbl: Record Vendor;
                Purchas: Record "Salesperson/Purchaser";
            begin
                if VendTbl.Get("Vendor Code") then begin
                    if Purchas.Get(VendTbl."BLACC Supplier Mgt. Code") then
                        "SPO Email No." := Purchas."SPO Email No.";
                end;
                if "Item Code" = '' then begin
                    "Purchase Name" := '';
                    "Sales Name" := '';
                end;
            end;
        }
        field(71; "Vendor Name"; Text[255])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor Code")));
        }
        field(72; "Vendor Group"; Code[20])
        {
            Caption = 'Vendor Group';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."BLACC Vendor Group" where("No." = field("Vendor Code")));
        }
        field(73; "Supplier Management Code"; Code[20])
        {
            Caption = 'Supplier Mngt. Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."BLACC Supplier Mgt. Code" where("No." = field("Vendor Code")));
        }
        field(75; "SPO Email No."; Integer)
        {
            Caption = 'SPO Email No.';
            Editable = false;
        }
        field(76; "Supplier Management Name"; Text[255])
        {
            Caption = 'Supplier Mngt. Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Supplier Management Code")));
        }
        field(80; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                ItemTbl: Record Item;
                VendTbl: Record Vendor;
                Purchas: Record "Salesperson/Purchaser";
            begin
                if ItemTbl.Get("Item Code") then begin
                    "Purchase Name" := '[' + "Item Code" + '] ' + ItemTbl."BLACC Purchase Name";
                    "Sales Name" := '[' + "Item Code" + '] ' + ItemTbl."BLTEC Item Name";
                    if "Vendor Code" = '' then begin
                        "Vendor Code" := ItemTbl."Vendor No.";
                        if VendTbl.Get("Vendor Code") then begin
                            if Purchas.Get(VendTbl."BLACC Supplier Mgt. Code") then
                                "SPO Email No." := Purchas."SPO Email No.";
                        end;
                    end;
                end else begin
                    "Purchase Name" := '';
                    "Sales Name" := '';
                end;
            end;
        }
        field(81; "Description"; Text[255])
        {
            Caption = 'Description';
            //Editable = false;
        }
        field(85; "Item Ingredient Group"; Code[20])
        {
            Caption = 'Item Ingredient Group';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Item Ingredient Group" where("No." = field("Item Code")));
        }
        field(90; "Sales Name"; Text[500])
        {
            Caption = 'Sales Name';
            Editable = false;
        }
        field(100; "Purchase Name"; Text[500])
        {
            Caption = 'Purchase Name';
            Editable = false;
        }
        field(110; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            //Editable = false;
        }
        field(120; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            //Editable = false;
        }

        field(130; "ISO Type"; Text[100])
        {
            Caption = 'ISO Type';
            //Editable = false;
        }

        field(140; "Note"; Text[255])
        {
            Caption = 'Note';
            //Editable = false;
        }

        field(150; "Statement Name"; Text[255])
        {
            Caption = 'Statement Type';
            //Editable = false;
        }

        field(200; "Item Name"; Text[500])
        {
            Caption = 'Purchase Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Purchase Name" where("No." = field("Item Code")));
        }
        field(210; "ECUS Name"; Text[2048])
        {
            Caption = 'Sales Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLTEC Item Name" where("No." = field("Item Code")));
        }
        field(220; "Out Date"; Boolean)
        {
            Caption = 'Lỗi thời';
        }
        field(230; "DMS ISO Type"; Code[50])
        {
            Caption = 'ISO Type';
            TableRelation = "ACC DMS ISO Type".Code;
            //Editable = false;
        }
        field(240; "DMS Report Type"; Code[50])
        {
            Caption = 'Report Type';
            TableRelation = "ACC DMS Report Type".Code;
            //Editable = false;
        }
        field(250; "DMS Statement Type"; Code[50])
        {
            Caption = 'Statement Type';
            TableRelation = "ACC DMS Statement".Code;
            //Editable = false;
        }
    }
    keys
    {
        key(PK; "SPO No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
    begin
        "SPO No" := InsertSPOID();
        "Effective Date" := Today();
    end;

    local procedure InsertSPOID(): Integer
    var
        DMSLibrary: Record "ACC DMS Library";
        SPOID: Integer;
    begin
        SPOID := Random(200);
        if not DMSLibrary.Get(SPOID) then begin
            exit(SPOID);
        end else begin
            InsertSPOID();
        end;
    end;
}
