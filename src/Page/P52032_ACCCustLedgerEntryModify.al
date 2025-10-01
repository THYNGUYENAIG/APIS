page 52032 "ACC CustLedger Entry Modify"
{
    Caption = 'ACC Cust Ledger Entry Modify - P52032';
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("BLTI eInvoice No."; Rec."BLTI eInvoice No.")
                {
                    ToolTip = 'Specifies the value of the BLTI eInvoice No. field.', Comment = '%';
                }

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        tUSerID: Text;
    begin
        tUSerID := UserId;
        if not (tUSerID in ['APPLICATION']) then begin
            Message('You don''t have permission');
            CurrPage.Close();
        end;
    end;

    var
        iEntryNo: Integer;
}
