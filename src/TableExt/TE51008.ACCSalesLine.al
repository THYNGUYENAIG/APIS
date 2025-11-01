tableextension 51008 "ACC Sales Line" extends "Sales Line"
{
    fields
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                Number01: Decimal;
                Number02: Decimal;
            begin
                if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    if SalesHeader."Sales Type" <> "ACC Sales Type"::Sample then begin
                        if SalesHeader."Unset Packing" = false then begin
                            Rec.SetAutoCalcFields("ACC Packing Size");
                            if Rec."ACC Packing Size" > 0 then begin
                                Number01 := Rec.Quantity / Rec."ACC Packing Size";
                                Number02 := Round(Rec.Quantity / Rec."ACC Packing Size", 1);
                                if (Number01 - Number02) <> 0 then
                                    Error(StrSubstNo('Số lượng trên packing size không hợp lệ %1', Number01));
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(50001; "ACC Delivery Address"; Text[100])
        {
            Caption = 'Delivery Address';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Ship-to Address" where("No." = field("Document No."),
                                                                        "Document Type" = field("Document Type")));
        }
        field(50002; "ACC Delivery Note"; Text[2048])
        {
            Caption = 'Delivery Note';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."BLACC Delivery Note" where("No." = field("Document No."),
                                                                        "Document Type" = field("Document Type")));
        }
        field(50003; "Warehouse Shipment No"; Code[20])
        {
            Caption = 'Warehouse Shipment No';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."No." where("Source No." = field("Document No."),
                                                                       "Source Line No." = field("Line No.")));
        }
        field(50004; "ACC Packing Size"; Decimal)
        {
            Caption = 'Packing Size';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Net Weight" where("No." = field("No.")));
        }
    }
    keys
    {
        key(Key25; "Document Type", "Document No.", Type)
        {
            SumIndexFields = "Outstanding Quantity", Quantity, "Quantity Shipped", "Quantity Invoiced";
        }
    }
}
