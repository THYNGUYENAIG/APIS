query 51909 "ACC Import Entry Qry"
{
    Caption = 'ACC Import Entry Qry';
    DataAccessIntent = ReadOnly;
    OrderBy = Ascending(PurchaseOrderNo);
    
    elements
    {
        dataitem(ImportEntry; "BLTEC Import Entry")
        {
            column(PurchaseOrderNo; "Purchase Order No.") { }
            column(LineNo; "Line No.") { }
            column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
            column(ExpectedReceiptDate; "Expected Receipt Date") { }
            dataitem(ImportPlan; "ACC Import Plan Table")
            {
                DataItemLink = "Source Document No." = ImportEntry."Purchase Order No.",
                               "Source Line No." = ImportEntry."Line No.";
                SqlJoinType = FullOuterJoin;
                column(SourceDocumentNo; "Source Document No.") { }
                column(DeclarationNo; "Declaration No.") { }
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
