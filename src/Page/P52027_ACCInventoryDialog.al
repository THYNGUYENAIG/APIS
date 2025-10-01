page 52007 "ACC Inventory Dialog"
{
    Caption = 'ACC Inventory Dialog';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(dT; dT)
            {
                ApplicationArea = All;
                Caption = 'Posting Date';
            }
        }
    }

    procedure GetPostingDate(): Date
    begin
        exit(dT);
    end;

    var
        dT: Date;
}