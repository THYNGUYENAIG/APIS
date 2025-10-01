page 51029 "ACC Excel Sales Balance"
{
    ApplicationArea = All;
    Caption = 'Sales Balance';
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Option)
            {
                Caption = 'Options';
                field("Select Statistics Group"; SelectStatisticsGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Select Statistics Group';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        StatisticsGroup: Page "BLACC Statistics Group List";
                    begin
                        Clear(Text);
                        Clear(SelectStatisticsGroup);
                        StatisticsGroup.LookupMode(true);
                        if StatisticsGroup.RunModal() = Action::LookupOK then begin
                            Text += StatisticsGroup.GetSelection();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Select Posting Date"; SelectPostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Select Posting Date';
                }
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(ACCConsolidate)
            {
                ApplicationArea = All;
                Image = Excel;
                Caption = 'Export';
                trigger OnAction()
                var
                    SalesBalance: Codeunit "ACC AR Sales Balance";
                begin
                    SalesBalance.ExportExcelSPO(SelectStatisticsGroup, SelectPostingDate);
                end;
            }
        }
    }
    var
        SelectStatisticsGroup: Text;
        SelectPostingDate: Date;
}
