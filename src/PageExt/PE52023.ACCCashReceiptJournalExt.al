pageextension 52023 "ACC Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field(ACC_Statistics_Group; Rec."ACC Statistic Group")
            {
                ApplicationArea = All;
                Caption = 'Statistics Group';
                Editable = false;
            }
        }

        modify("Bal. Account No.")
        {
            trigger OnAfterValidate()
            begin
                GetStatisticGroup();
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetStatisticGroup();
    end;

    local procedure GetStatisticGroup()
    begin
        recC.Reset();
        recC.SetRange("No.", Rec."Bal. Account No.");
        if recC.FindFirst() then Rec."ACC Statistic Group" := recC."Statistics Group";
    end;

    //Global
    var
        recC: Record Customer;
}