codeunit 51008 "ACC CD Certificate File Event"
{
    Permissions = TableData "BLACC CD Certificate Files" = rimd;
    TableNo = "BLACC CD Certificate Files";

    trigger OnRun()
    var
    begin
        Clear(CDCertificate);
        CDCertificate := Rec;
        CDCertificate.Modify(true);
    end;

    var
        CDCertificate: Record "BLACC CD Certificate Files";
}
