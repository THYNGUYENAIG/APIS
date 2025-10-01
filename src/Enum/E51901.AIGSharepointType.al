enum 51901 "AIG Sharepoint Type"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; "None") { Caption = ''; }
    value(1; "Sales") { Caption = 'Sales Order'; } // Tổng thuế < - 50000
    value(2; "Shipment") { Caption = 'Sales Shipment'; } // Tổng thuế > 50000
    value(3; "Invocie") { Caption = 'Sales Invoice'; } // Tổng thuế # 0
    value(4; "WarehouseReceipt") { Caption = 'Warehouse Receipt'; } // Tổng thuế = 0
    value(5; "PostedWarehouseReceipt") { Caption = 'Posted Warehouse Receipt'; } // -50000 <= Tổng thuế <= 50000
}
