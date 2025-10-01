report 51015 "ACC Whse. Ship. Order Report"
{
    ApplicationArea = All;
    Caption = 'ACC Shipment Detail Report - R51015';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51015.ACCWhseShipmentOrderReport.rdl';
    dataset
    {
        dataitem(WhseShipmentOrderTable; "ACC Whse. Shipment Order Table")
        {
            column(SalesOrder; "Sales Order") { }
            column(SalesName; "Sales Name") { }
            column(OrderDate; "Order Date") { }
            column(RequestedShipDate; "Requested Ship Date") { }
            column(ShipmentDate; "Shipment Date") { }
            column(ActualShipmentDate; "Actual Shipment Date") { }
            column(Open; Open) { }
            column(Picked; Picked) { }
            column(Shipped; Shipped) { }
            column(Status; Status) { }
            column(Note; Note) { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }
            column(LocationCode; "Location Code") { }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(DateFrom; DateFrom)
                    {
                        ApplicationArea = All;
                        Caption = 'Date From';
                        ShowMandatory = true;
                    }

                    field(DateTo; DateTo)
                    {
                        ApplicationArea = All;
                        Caption = 'Date To';
                        ShowMandatory = true;
                    }
                    /*
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        TableRelation = Location.Code;
                        Caption = 'Location';
                        //ShowMandatory = true;
                    }
                    */
                }
            }
        }
        trigger OnOpenPage()
        begin
            DateFrom := Today();
            DateTo := CalcDate('+1D', TODAY);
        end;
    }

    trigger OnPreReport()
    var
        BCHelper: Codeunit "BC Helper";
        WhseRegistered: Query "ACC Whse. Registered Qry";
        PostedShipment: Query "ACC Posted Sales Shipment Qry";
        WhseShipment: Query "ACC Posted Whse. Shipment Qry";
        SalesShipment: Query "ACC Posted Sales Order Qry";
        SalesWarehouse: Query "ACC Whse. Sales Order Qry";
        QuantityShipped: Decimal;
        ForInsert: Boolean;
        PostingDate: Date;
        LocationCode: Text;
    begin
        LocationCode := BCHelper.GetWhseByCurUserId();
        WhseShipmentOrderTable.Reset();
        WhseShipmentOrderTable.DeleteAll();
        SalesWarehouse.SetRange(PostingDate, DateFrom, DateTo);
        SalesWarehouse.SetFilter(LocationCode, LocationCode);

        if SalesWarehouse.Open() then begin
            while SalesWarehouse.Read() do begin
                WhseShipmentOrderTable.Init();
                WhseShipmentOrderTable."From Date" := DateFrom;
                WhseShipmentOrderTable."To Date" := DateTo;
                WhseShipmentOrderTable."Sales Open" := true;
                WhseShipmentOrderTable."Sales Order" := SalesWarehouse.No;
                WhseShipmentOrderTable."Location Code" := SalesWarehouse.LocationCode;
                WhseShipmentOrderTable."Sales Name" := SalesWarehouse.CustomerName;
                WhseShipmentOrderTable."Order Date" := SalesWarehouse.OrderDate;
                WhseShipmentOrderTable."Requested Ship Date" := SalesWarehouse.PostingDate;
                WhseShipmentOrderTable.Open := SalesWarehouse.Quantity;
                //WhseShipmentOrderTable.Note := SalesWarehouse.DeliveryNote;
                QuantityShipped := 0;
                WhseShipment.SetRange(SourceNo, SalesWarehouse.No);
                WhseShipment.SetRange(LocationCode, SalesWarehouse.LocationCode);
                WhseShipment.SetRange(SourceDocument, "Warehouse Activity Source Document"::"Sales Order");
                if WhseShipment.Open() then begin
                    while WhseShipment.Read() do begin
                        QuantityShipped := QuantityShipped + WhseShipment.Quantity;
                    end;
                    WhseShipment.Close();
                end;
                WhseShipmentOrderTable.Shipped := QuantityShipped;

                WhseRegistered.SetRange(SourceNo, SalesWarehouse.No);
                WhseRegistered.SetRange(SourceDocument, "Warehouse Activity Source Document"::"Sales Order");
                if WhseRegistered.Open() then begin
                    while WhseRegistered.Read() do begin
                        WhseShipmentOrderTable.Picked := WhseRegistered.Quantity;
                    end;
                    WhseRegistered.Close();
                end;

                if WhseShipmentOrderTable.Shipped = 0 then begin
                    if WhseShipmentOrderTable.Picked <> 0 then begin
                        if WhseShipmentOrderTable.Open = WhseShipmentOrderTable.Picked then begin
                            WhseShipmentOrderTable.Status := 'Picked';
                        end else begin
                            WhseShipmentOrderTable.Status := 'Part Picked';
                        end;
                    end else begin
                        WhseShipmentOrderTable.Status := 'Open';
                    end;
                end else begin
                    if WhseShipmentOrderTable.Picked <> 0 then begin
                        if WhseShipmentOrderTable.Picked <> WhseShipmentOrderTable.Shipped then begin
                            WhseShipmentOrderTable.Status := 'Part Shipped';
                        end else begin
                            WhseShipmentOrderTable.Status := 'Shipped';
                        end;
                    end else begin
                        WhseShipmentOrderTable.Status := 'Shipped';
                    end;
                end;
                WhseShipmentOrderTable.Insert();
            end;
            SalesWarehouse.Close();
        end;

        SalesShipment.SetRange(PostingDate, DateFrom, DateTo);
        SalesShipment.SetFilter(LocationCode, LocationCode);
        if SalesShipment.Open() then begin
            while SalesShipment.Read() do begin
                WhseShipmentOrderTable.Init();
                WhseShipmentOrderTable."Sales Open" := false;
                WhseShipmentOrderTable."Sales Order" := SalesShipment.No;
                WhseShipmentOrderTable."Location Code" := SalesShipment.LocationCode;
                WhseShipmentOrderTable."Sales Name" := SalesShipment.CustomerName;
                WhseShipmentOrderTable."Order Date" := SalesShipment.OrderDate;
                WhseShipmentOrderTable."Requested Ship Date" := SalesShipment.PostingDate;
                WhseShipmentOrderTable.Open := SalesShipment.Quantity;
                WhseShipmentOrderTable."From Date" := DateFrom;
                WhseShipmentOrderTable."To Date" := DateTo;
                if not WhseShipmentOrderTable.Get(SalesShipment.No, SalesShipment.PostingDate, SalesShipment.LocationCode) then begin
                    WhseShipment.SetRange(SourceNo, SalesShipment.No);
                    WhseShipment.SetRange(LocationCode, SalesShipment.LocationCode);
                    WhseShipment.SetRange(SourceDocument, "Warehouse Activity Source Document"::"Sales Order");
                    if WhseShipment.Open() then begin
                        while WhseShipment.Read() do begin
                            WhseShipmentOrderTable."Actual Shipment Date" := WhseShipment.SystemCreatedAt;
                            WhseShipmentOrderTable.Shipped := WhseShipment.Quantity;
                            WhseShipmentOrderTable.Status := 'Shipped';
                            WhseShipmentOrderTable.Insert();
                        end;
                        WhseShipment.Close();
                    end;
                end;
            end;
            SalesWarehouse.Close();
        end;
    end;

    var
        DateFrom: Date;
        DateTo: Date;
}
