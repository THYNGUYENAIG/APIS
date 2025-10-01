codeunit 51007 "ACC Shipment Print Event"
{
    Permissions = TableData "Sales Shipment Header" = rimd;
    TableNo = "Sales Shipment Header";

    trigger OnRun()
    var
    begin
        Clear(SalesShipment);
        if SalesShipment.Get(Rec."No.") then begin
            SalesShipment."No. Printed" := SalesShipment."No. Printed" + 1;
            SalesShipment.Modify();
        end;
    end;

    var
        SalesShipment: Record "Sales Shipment Header";
}
