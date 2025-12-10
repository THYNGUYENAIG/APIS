pageextension 52015 "ACC WH Receipts Ext" extends "Warehouse Receipts"
{
    layout
    {
        addlast(Control1)
        {
            field(ACC_Source_Doc; arrCellText[1])
            {
                ApplicationArea = All;
                Caption = 'Source Document';
                // Editable = false;
            }
            field(ACC_Source_No; Rec."ACC Source No.")
            {
                ApplicationArea = All;
                Caption = 'Source No';
                // Editable = false;
            }
            field("ACC Vendor No"; Rec."ACC Vendor No")
            {
                ApplicationArea = All;
                Caption = 'Vendor/Customer No';
                // Editable = false;
            }
            field("ACC Vendor Name"; Rec."ACC Vendor Name")
            {
                ApplicationArea = All;
                Caption = 'Vendor/Customer Name';
                // Editable = false;
            }
            field(ACC_Total_Qty; arrCellValue[1])
            {
                ApplicationArea = All;
                Caption = 'Total Qty';
                DecimalPlaces = 0 : 5;
                // Editable = false;
            }
            field(ACC_Total_Qty_OutStanding; arrCellValue[2])
            {
                ApplicationArea = All;
                Caption = 'Total Qty Out Standing';
                DecimalPlaces = 0 : 5;
                // Editable = false;
            }
            field("Printed No."; Rec."Printed No.")
            {
                ApplicationArea = All;
                Caption = 'Printed No.';
                Editable = false;
            }
        }

        modify("Posting Date")
        {
            Visible = true;
        }

        modify("Document Status")
        {
            Visible = true;
        }
    }

    trigger OnOpenPage()
    begin
        recWRH.Reset();
        recWRH.SetRange("ACC Source No.", '');
        if recWRH.FindSet() then
            repeat
                recWRL.Reset();
                recWRL.SetRange("No.", recWRH."No.");
                recWRL.SetFilter("Source No.", '<> %1', '');
                recWRL.SetFilter("Source Document", '%1 | %2 | %3', "Warehouse Activity Source Document"::"Purchase Order", "Warehouse Activity Source Document"::"Sales Return Order", "Warehouse Activity Source Document"::"Inbound Transfer");
                if recWRL.FindFirst() then begin
                    case recWRL."Source Document" of
                        "Warehouse Activity Source Document"::"Purchase Order":
                            begin
                                recPH.Reset();
                                recPH.SetRange("No.", recWRL."Source No.");
                                if recPH.FindFirst() then begin
                                    recWRH."ACC Vendor No" := recPH."Buy-from Vendor No.";
                                    recWRH."ACC Vendor Name" := recPH."Buy-from Vendor Name";
                                    recWRH."ACC Source No." := recWRL."Source No.";
                                    recWRH.Modify()
                                end;
                            end;
                        "Warehouse Activity Source Document"::"Sales Return Order":
                            begin
                                recSH.Reset();
                                recSH.SetRange("No.", recWRL."Source No.");
                                if recSH.FindFirst() then begin
                                    recWRH."ACC Vendor No" := recSH."Sell-to Customer No.";
                                    recWRH."ACC Vendor Name" := recSH."Sell-to Customer Name";
                                    recWRH."ACC Source No." := recWRL."Source No.";
                                    recWRH.Modify()
                                end;
                            end;
                        else begin
                            recWRH."ACC Source No." := recWRL."Source No.";
                            recWRH.Modify()
                        end;
                    end;

                end;
            until recWRH.Next() < 1;
    end;

    trigger OnAfterGetRecord()
    begin
        arrCellText[1] := '';
        arrCellText[2] := '';
        arrCellText[3] := '';
        arrCellValue[1] := 0;
        arrCellValue[2] := 0;
        // tfSourceNo := '';

        recWRL.Reset();
        recWRL.SetRange("No.", Rec."No.");
        if recWRL.FindSet() then
            repeat
                if StrPos(arrCellText[1], StrSubstNo('%1', recWRL."Source Document")) = 0 then begin
                    cuACCGP.AddString(arrCellText[1], StrSubstNo('%1', recWRL."Source Document"), ' | ');
                end;

                // if StrPos(tfSourceNo, StrSubstNo('%1', recWRL."Source No.")) = 0 then begin
                //     cuACCGP.AddString(tfSourceNo, recWRL."Source No.", ' | ');
                // end;

                case recWRL."Source Document" of
                    "Warehouse Activity Source Document"::"Sales Return Order":
                        begin
                            recSH.Reset();
                            recSH.SetRange("No.", recWRL."Source No.");
                            if recSH.FindFirst() then begin
                                if StrPos(arrCellText[2], StrSubstNo('%1', recSH."Sell-to Customer No.")) = 0 then begin
                                    cuACCGP.AddString(arrCellText[2], recSH."Sell-to Customer No.", ' | ');
                                end;
                                if StrPos(arrCellText[3], StrSubstNo('%1', recSH."Sell-to Customer Name")) = 0 then begin
                                    cuACCGP.AddString(arrCellText[3], recSH."Sell-to Customer Name", ' | ');
                                end;
                            end;
                        end;

                    "Warehouse Activity Source Document"::"Purchase Order":
                        begin
                            recPH.Reset();
                            recPH.SetRange("No.", recWRL."Source No.");
                            if recPH.FindFirst() then begin
                                if StrPos(arrCellText[2], StrSubstNo('%1', recPH."Buy-from Vendor No.")) = 0 then begin
                                    cuACCGP.AddString(arrCellText[2], recPH."Buy-from Vendor No.", ' | ');
                                end;
                                if StrPos(arrCellText[3], StrSubstNo('%1', recPH."Buy-from Vendor Name")) = 0 then begin
                                    cuACCGP.AddString(arrCellText[3], recPH."Buy-from Vendor Name", ' | ');
                                end;
                            end;
                        end;
                end;

                arrCellValue[1] += recWRL.Quantity;
                arrCellValue[2] += recWRL."Qty. Outstanding";

            until recWRL.Next() < 1;
        // Rec."ACC Source No." := tfSourceNo;
    end;

    //Global
    var
        arrCellText: array[5] of Text;
        arrCellValue: array[5] of Decimal;
        recWRL: Record "Warehouse Receipt Line";
        recSH: Record "Sales Header";
        recPH: Record "Purchase Header";
        // tfSourceNo: Text;
        cuACCGP: Codeunit "ACC General Process";
        recWRH: Record "Warehouse Receipt Header";
}