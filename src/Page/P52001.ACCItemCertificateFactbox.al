page 52001 "ACC Item Cert FactBox"
{
    Caption = 'Item Certificate Details';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            field("BLACC Quality Declaration"; Rec."BLACC Quality Declaration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Declaration field.';
            }
            field("BLACC Visa"; Rec."BLACC Visa")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Visa field.';
            }
            field("BLACC Quota"; Rec."BLACC Quota")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quota field.';
            }
            field("BLACC SA"; Rec."BLACC SA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SA field.';
            }
            field("BLACC LOA"; Rec."BLACC LOA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the LOA field.';
            }
            field("BLACC MA"; Rec."BLACC MA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MA field.';
            }
            field("BLACC Medical Checkup"; Rec."BLACC Medical Checkup")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the MA field.';
            }
            field("BLACC Plant Quarantine"; Rec."BLACC Plant Quarantine")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Plant Quarantine field.';
            }
            field("BLACC Plant Quar. (BNNPTNT)"; Rec."BLACC Plant Quar. (BNNPTNT)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Plant Quarantine (BNNPTNT) field.';
            }
            field("BLACC Animal Quarantine"; Rec."BLACC Animal Quarantine")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Animal Quarantine field.';
            }
            field("BLACC Animal Quar. (BNNPTNT)"; Rec."BLACC Animal Quar. (BNNPTNT)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Animal Quarantine (BNNPTNT) field.';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}