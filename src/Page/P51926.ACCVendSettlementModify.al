page 51926 "ACC Vendor Settlement Modify"
{
    ApplicationArea = All;
    Caption = 'Vendor Settlement Modify';
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
                field(LedgerEntryNo; LedgerEntryNo)
                {
                    ApplicationArea = All;
                    Caption = 'Ledger Entry No.';
                    Editable = false;
                }
                field(DetailedEntryNo; DetailedEntryNo)
                {
                    ApplicationArea = All;
                    Caption = 'Detailed Entry No.';
                    Editable = false;
                }
                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }
                field(OffsetDocumentNo; OffsetDocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Offset Document No.';
                }
                field(DateOfSettlement; DateOfSettlement)
                {
                    ApplicationArea = All;
                    Caption = 'Date Of Settlement';
                }
                field(AmountSettled; AmountSettled)
                {
                    ApplicationArea = All;
                    Caption = 'Amount Settled';
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
                Image = Change;
                Caption = 'Change';
                trigger OnAction()
                var
                begin

                end;
            }
        }
    }

    procedure SetInvoiceValue(_DetailedEntryNo: Integer; _LedgerEntryNo: Integer)
    var
        VendSettlement: Record "ACC Vendor Ledger Settlement";
    begin
        DetailedEntryNo := _DetailedEntryNo;
        LedgerEntryNo := _LedgerEntryNo;
        if VendSettlement.Get(DetailedEntryNo, LedgerEntryNo) then begin
            DocumentNo := VendSettlement."Document No.";
            OffsetDocumentNo := VendSettlement."Offset Document No.";
            DateOfSettlement := VendSettlement."Date Of Settlement";
            AmountSettled := VendSettlement."Amount Settled";
        end;
    end;

    var
        DetailedEntryNo: Integer;
        LedgerEntryNo: Integer;
        DocumentNo: Text;
        OffsetDocumentNo: Text;
        DateOfSettlement: Date;
        AmountSettled: Decimal;
}
