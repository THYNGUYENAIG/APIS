query 51008 "ACC Warehouse Transport Line"
{
    Caption = 'ACC Warehouse Transport Line';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    QueryCategory = 'Item List';
    elements
    {
        dataitem(TransportInformation; "BLACC Transport Information")
        {
            column(Type; Type) { }
            column(LocationCode; "BLACC Location") { }
            column(TruckNumber; "Truck Number") { }
            column(ContainerNo; "Container No.") { }
            column(SealNo; "Seal No.") { }
            column(NoofTrips; "BLACC No. of Trips") { }
            column(SupplierName; "Supplier Name") { }
            column(LotNo; "BLACC Lot No.") { }
            column(LotQuantity; "BLACC Lot Quantity") { }
            column(PurchNo; "BLACC Source No.") { }
            column(ItemNo; "BLACC Item No.") { }
            column(Description; "BLACC Item Description") { }
            column(PostingDate; "BLACC Requested Date") { }
            column(DocumentNo; "Document No.") { }
            column(DocumentLineNo; "Document Line No.") { }
        }
    }


    trigger OnBeforeOpen()
    begin

    end;
}
