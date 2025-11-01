query 51016 "ACC PaymTerm Declaration Query"
{
    Caption = 'APIS PaymTerm Declaration Query';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ImportEntry; "BLTEC Import Entry")
        {
            column(Count) { Method = Count; }
            column(DeclarationNo; "BLTEC Customs Declaration No.") { }
            column(DeclarationDate; "Customs Declaration Date") { }

            dataitem(PurchInvLine; "Purch. Inv. Line")
            {
                DataItemTableFilter = "VAT Bus. Posting Group" = filter('OVERSEA'),
                                      Type = filter("Purchase Line Type"::Item);
                DataItemLink = "Order No." = ImportEntry."Purchase Order No.",
                               "Order Line No." = ImportEntry."Line No.";

                column(CustomsDeclarationNo; "BLTEC Customs Declaration No.") { }
                dataitem(PurchInvHeader; "Purch. Inv. Header")
                {
                    DataItemLink = "No." = PurchInvLine."Document No.";
                    column(PaymentTermsCode; "Payment Terms Code") { }
                    dataitem(PaymentTerms; "Payment Terms")
                    {
                        DataItemLink = Code = PurchInvHeader."Payment Terms Code";
                        column(Description; Description) { }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
