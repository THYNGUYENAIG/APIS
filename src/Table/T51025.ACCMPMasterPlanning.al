table 51025 "ACC MP Master Planning"
{
    Caption = 'APIS MP Master Planning';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Site No."; Code[10])
        {
            Caption = 'Site No.';
            Editable = false;
        }
        field(2; "BU Code"; Code[10])
        {
            Caption = 'BU Code';
            Editable = false;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item."No.";
        }
        field(4; "Item Name"; Text[2048])
        {
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLTEC Item Name" where("No." = field("Item No.")));
        }
        field(5; "Min Stock"; Decimal)
        {
            Caption = 'Min Stock';
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Safety Stock Quantity" where("No." = field("Item No.")));
        }
        field(6; Onhand; Decimal)
        {
            Caption = 'Onhand';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(7; "Q Onhand"; Decimal)
        {
            Caption = 'Q Onhand';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(8; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(9; "Quantity AVG Invoiced"; Decimal)
        {
            Caption = 'Quantity AVG Invoiced';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(10; "Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(11; "Requisition Worksheet 01 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 01 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(12; "Requisition Worksheet 02 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 02 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(13; "Requisition Worksheet 03 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 03 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(14; "Requisition Worksheet 04 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 04 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(15; "Requisition Worksheet 05 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 05 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(16; "Requisition Worksheet 06 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 06 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(17; "Requisition Worksheet 07 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 07 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(18; "Requisition Worksheet 08 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 08 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(19; "Requisition Worksheet 09 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 09 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(20; "Requisition Worksheet 10 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 10 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(21; "Requisition Worksheet 11 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 11 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(22; "Requisition Worksheet 12 ST"; Decimal)
        {
            Caption = 'Requisition Worksheet 12 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(23; "Open Order 01 ST"; Decimal)
        {
            Caption = 'Open Order 01 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(24; "Open Order 02 ST"; Decimal)
        {
            Caption = 'Open Order 02 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(25; "Open Order 03 ST"; Decimal)
        {
            Caption = 'Open Order 03 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(26; "Open Order 04 ST"; Decimal)
        {
            Caption = 'Open Order 04 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(27; "Open Order 05 ST"; Decimal)
        {
            Caption = 'Open Order 05 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(28; "Open Order 06 ST"; Decimal)
        {
            Caption = 'Open Order 06 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(29; "Open Order 07 ST"; Decimal)
        {
            Caption = 'Open Order 07 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(30; "Open Order 08 ST"; Decimal)
        {
            Caption = 'Open Order 08 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(31; "Open Order 09 ST"; Decimal)
        {
            Caption = 'Open Order 09 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(32; "Open Order 10 ST"; Decimal)
        {
            Caption = 'Open Order 10 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(33; "Open Order 11 ST"; Decimal)
        {
            Caption = 'Open Order 11 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(34; "Open Order 12 ST"; Decimal)
        {
            Caption = 'Open Order 12 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(35; "Demand Forecast 01 ST"; Decimal)
        {
            Caption = 'Demand Forecast 01 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(36; "Demand Forecast 02 ST"; Decimal)
        {
            Caption = 'Demand Forecast 02 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(37; "Demand Forecast 03 ST"; Decimal)
        {
            Caption = 'Demand Forecast 03 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(38; "Demand Forecast 04 ST"; Decimal)
        {
            Caption = 'Demand Forecast 04 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(39; "Demand Forecast 05 ST"; Decimal)
        {
            Caption = 'Demand Forecast 05 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(40; "Demand Forecast 06 ST"; Decimal)
        {
            Caption = 'Demand Forecast 06 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(41; "Demand Forecast 07 ST"; Decimal)
        {
            Caption = 'Demand Forecast 07 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(42; "Demand Forecast 08 ST"; Decimal)
        {
            Caption = 'Demand Forecast 08 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(43; "Demand Forecast 09 ST"; Decimal)
        {
            Caption = 'Demand Forecast 09 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(44; "Demand Forecast 10 ST"; Decimal)
        {
            Caption = 'Demand Forecast 10 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(45; "Demand Forecast 11 ST"; Decimal)
        {
            Caption = 'Demand Forecast 11 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(46; "Demand Forecast 12 ST"; Decimal)
        {
            Caption = 'Demand Forecast 12 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(47; "Onhand Forecast 01 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 01 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(48; "Onhand Forecast 02 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 02 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(49; "Onhand Forecast 03 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 03 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(50; "Onhand Forecast 04 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 04 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(51; "Onhand Forecast 05 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 05 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(52; "Onhand Forecast 06 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 06 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(53; "Onhand Forecast 07 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 07 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(54; "Onhand Forecast 08 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 08 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(55; "Onhand Forecast 09 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 09 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(56; "Onhand Forecast 10 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 10 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(57; "Onhand Forecast 11 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 11 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(58; "Onhand Forecast 12 ST"; Decimal)
        {
            Caption = 'Onhand Forecast 12 ST';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Site No.", "BU Code", "Item No.")
        {
            Clustered = true;
        }
    }
}
