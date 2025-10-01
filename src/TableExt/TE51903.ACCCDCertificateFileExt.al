tableextension 51903 "ACC CD Certificate File Ext" extends "BLACC CD Certificate Files"
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
    }
}
