pageextension 52022 "ACC Custom Declare Subform Ext" extends "BLTEC Customs Decl. Card"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(ACCICF_Factbox; "ACC Cus.Decl Item Cert FactBox")
            {
                ApplicationArea = Suite;
                Provider = DeclarationLine;
                SubPageLink = "No." = field("Item No.");
            }
        }
    }

    actions
    {
        modify("BLTEC Released Status")
        {
            trigger OnAfterAction()
            var
                recBTECCD: Record "BLTEC Customs Declaration";
                recBTECCDL: Record "BLTEC Customs Decl. Line";
                recI: Record Item;
                tPO: Text;
                tItemName: Text;
                tCO: Text;
                tVend: Text;
                iPos: Integer;
            begin
                if Rec.Status = "BLTEC Doc. Status"::Released then begin
                    tPO := '';
                    tItemName := '';
                    tCO := '';
                    recBTECCDL.Reset();
                    recBTECCDL.SetRange("Document No.", Rec."Document No.");
                    if recBTECCDL.FindFirst() then begin
                        tPO := recBTECCDL."Source Document No.";
                        // tItemName := recBTECCDL."BLTEC Item Name";
                        tCO := recBTECCDL."BLTEC C/O No.";

                        recI.Reset();
                        recI.SetRange("No.", recBTECCDL."Item No.");
                        if recI.FindFirst() then tItemName := recI.Description;
                    end;

                    tVend := Rec."Vendor Name";
                    iPos := tVend.IndexOf(' ');
                    if iPos <> 0 then begin
                        tVend := Rec."Vendor Name".Substring(1, iPos - 1);
                    end;

                    Rec."ACC Title" := StrSubstNo('NCC# %1 - TK# %2 BL# %3 PO# %4 - %5 FORM# %6'
                                                            , tVend, Rec."BLTEC Customs Declaration No."
                                                            , Rec."BL No.", tPO, tItemName, tCO);
                    Rec.Modify(true);
                end;
            end;
        }
        modify("BLTEC Reopen Status")
        {
            trigger OnAfterAction()
            var
            begin
                if Rec.Status <> "BLTEC Doc. Status"::Released then begin
                    Rec."ACC Title" := '';
                    Rec.Modify(true);
                end;
            end;
        }
    }
}