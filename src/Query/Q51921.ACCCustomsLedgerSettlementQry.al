query 51921 "ACC Customs Ledger Settle. Qry"
{
    Caption = 'APIS Customs Ledger Settlement Qry ';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(PurchInvLine; "Purch. Inv. Line")
        {
            DataItemTableFilter = "BLTEC Customs Declaration No." = filter(<> '');
            column(Count)
            {
                Method = Count;
            }
            column(DocumentNo; "Document No.") { }
            column(PostingDate; "Posting Date") { }
            column(DeclarationNo; "BLTEC Customs Declaration No.") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
