page 51028 "ACC Excel Consolidate"
{
    ApplicationArea = All;
    Caption = 'Excel Consolidate';
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
                field("Select Date"; SelectDate)
                {
                    ApplicationArea = All;
                    Caption = 'Select Date';
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
                Caption = 'Consolidate';
                trigger OnAction()
                var
                    MPConsolidate: Codeunit "ACC MP Excel Consolidate";
                begin
                    MPConsolidate.MergeExcelFileV2(SelectDate);
                    CurrPage.Close();
                end;
            }
        }
    }
    var
        SelectSheetName: Text;
        SelectDate: Date;

}
