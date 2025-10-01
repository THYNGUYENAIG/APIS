tableextension 51001 "ACC Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(51001; "Truck Number"; Text[100])
        {
            Caption = 'Truck Number';
            DataClassification = ToBeClassified;
        }
        field(51002; "Posted Sales Invoice"; Text[100])
        {
            Caption = 'Posted Sales Invoice';
            DataClassification = ToBeClassified;
        }
        field(51003; "eInvoice"; Text[100])
        {
            Caption = 'eInvoice';
            DataClassification = ToBeClassified;
        }
        field(51004; "Transport Code"; Text[100])
        {
            Caption = 'Transport Code';
            DataClassification = ToBeClassified;
        }
        field(51005; "Sales Quantity"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line".Quantity where("Document No." = field("No."),
                                                                    Type = filter("Sales Line Type"::Item)));
            Caption = 'Sales Quantity';
            FieldClass = FlowField;
        }
        field(51006; "Last Message"; Text[1024])
        {
            CalcFormula = lookup("BLTI eInvoice Log Entry".Description where("Reference No." = field("Posted Sales Invoice"),
                                                                              IsError = filter(true),
                                                                              Description = filter(<> '')));
            Caption = 'Last Message';
            FieldClass = FlowField;
        }
        field(51007; "Tax authority number"; Text[255])
        {
            Caption = 'Tax authority number';
        }
        field(51008; "External Document"; Text[50])
        {
            Caption = 'External Document';
        }
    }
}
