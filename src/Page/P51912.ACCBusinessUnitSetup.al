page 51912 "ACC Business Unit Setup"
{
    ApplicationArea = All;
    Caption = 'ACC Business Unit Setup - P51912';
    PageType = List;
    SourceTable = "ACC Business Unit Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code") { }
                field(Name; Rec.Name) { }
                field(Email; Rec.Email) { }
                field("CC Email"; Rec."CC Email") { }
                field("Parent Code"; Rec."Parent Code") { }
                field("Create File"; Rec."Create File") { }
                field(Blocked; Rec.Blocked) { }
                field(Forecast; Rec.Forecast) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCInit)
            {
                ApplicationArea = All;
                Caption = 'Init';
                Image = Import;
                trigger OnAction()
                var
                    BUISetup: Record "ACC Business Unit Setup";
                    DimValue: Record "Dimension Value";
                begin
                    DimValue.Reset();
                    DimValue.SetRange("Dimension Code", 'BUSINESSUNIT');
                    DimValue.SetRange(Blocked, false);
                    if DimValue.FindSet() then begin
                        repeat
                            BUISetup.Reset();
                            if not BUISetup.Get(DimValue.Code) then begin
                                BUISetup.Init();
                                BUISetup.Code := DimValue.Code;
                                BUISetup.Name := DimValue.Name;
                                BUISetup.Insert();
                            end;
                        until DimValue.Next() = 0;
                    end;
                end;
            }
        }
    }
}
