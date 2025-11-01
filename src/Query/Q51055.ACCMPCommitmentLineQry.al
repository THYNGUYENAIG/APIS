query 51055 "ACC MP Commitment Line Qry"
{
    Caption = 'APIS MP Commitment Line Qry';
    DataAccessIntent = ReadOnly;
    QueryType = Normal;

    elements
    {
        dataitem(ACCMPCommitmentLine; "ACC MP Commitment Line")
        {
            column(SiteNo; "Site No.") { }
            column(ItemNo; "Item No.") { }
            column(UnitNo; "Unit No.") { }
            column(Quantity; Quantity) { Method = Sum; }
            column(LotNo; "Lot No.") { }
            column(ManufacturingDate; "Manufacturing Date") { }
            column(ExpirationDate; "Expiration Date") { }
            column(Status; Status) { }
            column(TransportMethod; "Transport Method") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
