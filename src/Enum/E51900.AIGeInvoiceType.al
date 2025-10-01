enum 51900 "AIG eInvoice Type"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; "None") { Caption = ''; }
    value(1; "VAT Domestic") { Caption = 'VAT Domestic'; } // Tổng thuế < - 50000
    value(2; "VAT Oversea") { Caption = 'VAT Oversea'; } // Tổng thuế > 50000
    value(3; "Shipment Internal") { Caption = 'Shipment Internal'; } // Tổng thuế # 0
}
