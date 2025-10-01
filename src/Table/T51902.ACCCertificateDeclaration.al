table 51902 "ACC Certificate Declaration"
{
    Caption = 'ACC Certificate Declaration';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then
                    "Item Name" := Item.Description;
            end;

        }
        field(2; "Item Name"; Text[250])
        {
            Caption = 'Item Name';
        }
        field(3; "Certificate Type"; Enum "ACC Certificate Type")
        {
            Caption = 'Certificate Type';
        }
        field(4; "Release Date"; Date)
        {
            Caption = 'Release Date';
        }
        field(5; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(6; "Certificate No."; Code[30])
        {
            Caption = 'Certificate No.';
        }
        field(7; "File Name"; Text[255])
        {
            Caption = 'File Name';
        }
        field(8; "File Name Orig."; Text[255])
        {
            Caption = 'File Name Orig.';
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(11; "File No."; Text[100])
        {
            Caption = 'File No.';
        }
    }
    keys
    {
        key(PK; "Item No.", "Line No.")
        {

        }
        key(FK01; "Item No.", "Certificate No.", "Certificate Type")
        {

        }
        key(FK02; "Item No.", "File Name")
        {

        }
    }

    procedure SetUpNewLine()
    var
        Certificate: Record "ACC Certificate Declaration";
    begin
        Certificate.SetRange("Item No.", "Item No.");
        if not Certificate.FindFirst() then
            "Release Date" := WorkDate();

        OnAfterSetUpNewLine(Rec, Certificate);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetUpNewLine(var CertificateRec: Record "ACC Certificate Declaration"; var CertificateFilter: Record "ACC Certificate Declaration")
    begin
    end;
}
