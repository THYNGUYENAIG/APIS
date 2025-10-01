query 51006 "ACC Warehouse Transport"
{
    Caption = 'ACC Warehouse Transport';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;
    
    elements
    {
        dataitem(TransportInformation; "BLACC Transport Information")
        {
            column(Count)
            {
                Method = Count;
            }
            column(LocationCode; "BLACC Location") { }
            column(TruckNumber; "Truck Number") { }
            column(ContainerNo; "Container No.") { }
            column(SealNo; "Seal No.") { }
            column(BLACCNoofTrips; "BLACC No. of Trips") { }
            column(PostingDate; "BLACC Requested Date") { }
            column(Type; Type) { }
        }
    }


    trigger OnBeforeOpen()
    begin

    end;
}
