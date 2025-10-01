tableextension 51016 "ACC Production Forecast Entry" extends "Production Forecast Entry"
{
    fields
    {
        modify("BLACC Qty. to Ship")
        {
            trigger OnAfterValidate()
            var
                Number01: Decimal;
                Number02: Decimal;
            begin
                Rec.SetAutoCalcFields("ACC Packing Size");
                if Rec."ACC Packing Size" > 0 then begin
                    Number01 := Rec."BLACC Qty. to Ship" / Rec."ACC Packing Size";
                    Number02 := Round(Rec."BLACC Qty. to Ship" / Rec."ACC Packing Size", 1);
                    if (Number01 - Number02) <> 0 then
                        Message(StrSubstNo('Số lượng trên packing size không hợp lệ %1', Number01));
                end;
            end;
        }
        field(50001; "ACC Packing Size"; Decimal)
        {
            Caption = 'Packing Size';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Net Weight" where("No." = field("Item No.")));
        }
    }
}
