tableextension 51902 "ACC Certificate Decla. Ext" extends "BLACC Item Certificate"
{
    fields
    {
        field(50000; "File Name"; Text[255])
        {
            Editable = false;
            Caption = 'File Name';
        }
        field(50001; "File Extension"; Text[30])
        {
            Editable = false;
            Caption = 'File Extension';
            trigger OnValidate()
            begin
                case LowerCase("File Extension") of
                    'jpg', 'jpeg', 'bmp', 'png', 'tiff', 'tif', 'gif':
                        "File Type" := "File Type"::Image;
                    'pdf':
                        "File Type" := "File Type"::PDF;
                    'docx', 'doc':
                        "File Type" := "File Type"::Word;
                    'xlsx', 'xls':
                        "File Type" := "File Type"::Excel;
                    'pptx', 'ppt':
                        "File Type" := "File Type"::PowerPoint;
                    'msg':
                        "File Type" := "File Type"::Email;
                    'xml':
                        "File Type" := "File Type"::XML;
                    else
                        "File Type" := "File Type"::Other;
                end;
            end;
        }
        field(50002; "File Type"; Enum "Document Attachment File Type")
        {
            Editable = false;
            Caption = 'File Type';
        }
        field(50003; "File No."; Code[50])
        {
            Editable = false;
            Caption = 'File No.';
        }
        field(50004; "Quality Group"; Enum "ACC Quality Group")
        {
            //Editable = false;
            Caption = 'Group';
        }
        field(50005; "Item Name"; Text[250])
        {
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Purchase Name" where("No." = field("Item No.")));
        }
        field(50006; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Vendor No." where("No." = field("Item No.")));
        }
        field(50007; "Outdated"; Boolean)
        {
            Caption = 'Lỗi Thời';
        }
        field(50008; "Storage Condition"; Code[20])
        {
            Caption = 'Storage Condition';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Storage Condition" where("No." = field("Item No.")));
        }
        field(50009; "Is Synchronize"; Boolean)
        {
            Caption = 'Is Synchronize';
            Editable = false;
        }
    }

    procedure GetLastLineNo(ItemNo: Code[20]): Integer
    var
        ItemCertificate: Record "BLACC Item Certificate";
    begin
        ItemCertificate.Reset();
        ItemCertificate.SetRange("Item No.", ItemNo);
        ItemCertificate.SetLoadFields("Line No.");
        if ItemCertificate.FindLast() then
            exit(ItemCertificate."Line No.");
    end;
}
