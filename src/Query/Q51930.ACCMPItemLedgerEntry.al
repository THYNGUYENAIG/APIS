query 51930 "ACC MP Item Ledger Entry"
{
    Caption = 'ACC MP Item Ledger Entry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Remaining Quantity" = filter(> 0);
            column(ItemNo; "Item No.") { }
            column(LocationCode; "Location Code") { }
            column(RemainingQuantity; "Remaining Quantity")
            {
                Method = Sum;
            }
            dataitem(TransferShipmentHeader; "Transfer Shipment Header")
            {
                DataItemLink = "No." = ItemLedgerEntry."Document No.";
                column(TransferToCode; "Transfer-to Code") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
