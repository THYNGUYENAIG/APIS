page 52025 "ACC Cus.Decl Item Cert FactBox"
{
    Caption = 'Item Certificate Details';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            field("BLACC Quality Declaration Rq"; Rec."BLACC Quality Declaration Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Quality Declaration is required.';
            }
            field("BLACC Quality Declaration"; Rec."BLACC Quality Declaration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Declaration field.';
            }
            field("BLACC Visa Rq"; Rec."BLACC Visa Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Visa is required.';
            }
            field("BLACC Visa"; Rec."BLACC Visa")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Visa field.';
            }
            field("BLACC Quota Rq"; Rec."BLACC Quota Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Quota is required.';
            }
            field("BLACC Quota"; Rec."BLACC Quota")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quota field.';
            }
            field("BLACC SA Rq"; Rec."BLACC SA Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the SA is required.';
            }
            field("BLACC SA"; Rec."BLACC SA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SA field.';
            }
            field("BLACC LOA Rq"; Rec."BLACC LOA Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the LOA is required.';
            }
            field("BLACC LOA"; Rec."BLACC LOA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the LOA field.';
            }
            field("BLACC MA Rq"; Rec."BLACC MA Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the MA is required.';
            }
            field("BLACC MA"; Rec."BLACC MA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MA field.';
            }
            field("BLACC Medical Checkup Rq"; Rec."BLACC Medical Checkup Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Medical Checkup is required.';
            }
            field("BLACC Plant Quarantine Rq"; Rec."BLACC Plant Quarantine Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BNNPTNT field.';
            }
            field("BLACC Plant Quar. (BNNPTNT) Rq"; Rec."BLACC Plant Quar. (BNNPTNT) Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Plant Quarantine (BNNPTNT) field.';
            }
            field("BLACC Animal Quarantine Rq"; Rec."BLACC Animal Quarantine Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the Animal Quarantine is required.';
            }
            field("BLACC Ani. Quar. (BNNPTNT) Rq"; Rec."BLACC Ani. Quar. (BNNPTNT) Rq")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Animal Quarantine (BNNPTNT) field.';
            }
        }
    }
}