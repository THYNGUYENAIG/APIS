tableextension 52009 "ACC Customs Declaration Ext" extends "BLTEC Customs Declaration"
{
    DataCaptionFields = "Document No.", "ACC Title";

    fields
    {
        field(52005; "ACC Title"; Text[1000])
        {
            Caption = 'Title';
            Editable = false;
        }
    }
}