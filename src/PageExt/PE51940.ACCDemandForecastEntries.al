pageextension 51940 "ACC Demand Forecast Entries" extends "Demand Forecast Entries"
{
    layout
    {
        addafter("Component Forecast")
        {
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
            }
            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ACCUpdate)
            {
                ApplicationArea = All;
                Caption = 'Policy';
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ProdEntry: Record "Production Forecast Entry";
                begin
                    CurrPage.SetSelectionFilter(ProdEntry);
                    if ProdEntry.FindSet() then begin
                        repeat
                            ProdEntry."BLACC Violdate Stock Policy" := true;
                            ProdEntry.Modify();
                        until ProdEntry.Next() = 0;
                    end;
                end;
            }
        }
    }
}
