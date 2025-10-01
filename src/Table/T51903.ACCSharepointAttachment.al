table 51903 "ACC Sharepoint Attachment"
{
    Caption = 'ACC Sharepoint Attachment';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(14; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Attached Date"; Date)
        {
            Caption = 'Attached Date';
        }
        field(5; "File Name"; Text[250])
        {
            Caption = 'File Name';
            NotBlank = true;
            // Check Empty or Duplicate file    
            trigger OnValidate()
            var

            begin

            end;
        }
        field(6; "File Type"; Enum "Document Attachment File Type")
        {
            Caption = 'File Type';
        }
        field(7; "File Extension"; Text[30])
        {
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
        field(8; "File No."; Text[50])
        {
            Caption = 'File No.';
        }
        field(9; "Attached By"; Guid)
        {
            Caption = 'Attached By';
            Editable = false;
            TableRelation = User."User Security ID" where("License Type" = const("Full User"));
        }
        field(10; User; Code[50])
        {
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("Attached By"),
                                                         "License Type" = const("Full User")));
            Caption = 'User';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Document URL"; Text[2024])
        {
            Caption = 'Document URL';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "Line No.", ID)
        {
            Clustered = true;
        }
    }
}
