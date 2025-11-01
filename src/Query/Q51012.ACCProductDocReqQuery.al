query 51012 "ACC Product Doc. Req. Query"
{
    Caption = 'APIS Product Doc. Req. Query - Q51012';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            column(DocumentNo; "Document No.") { }
            dataitem(ItemVendorVoucher; "BLACC Item Vendor Voucher")
            {
                DataItemLink = "BLACC Item No." = PurchaseLine."No.";
                dataitem(VendorVoucher; "BLACC Vendor Voucher")
                {
                    DataItemLink = "BLACC Code" = ItemVendorVoucher."BLACC Code";

                    column(Count)
                    {
                        Method = Count;
                    }
                    column(VoucherCode; "BLACC Code") { }
                    column(VoucherDescription; "BLACC Description") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
