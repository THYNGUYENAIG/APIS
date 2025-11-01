page 52019 "ACC Transfer Line"
{
    ApplicationArea = All;
    Caption = 'APIS Transfer Line Page';
    PageType = List;
    SourceTable = "ACC Transfer Line";
    // Editable = false;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    UsageCategory = Lists;
    Permissions = tabledata "ACC Transfer Line" = RMD;

    layout
    {
        area(Content)
        {
            repeater(View_Content)
            {
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ToolTip = 'Specifies the value of the Transfer-from Code field.', Comment = '%';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the value of the Transfer-to Code field.', Comment = '%';
                }
                field("Shipment No"; Rec."Shipment No")
                {
                    ToolTip = 'Specifies the value of the Shipment No field.', Comment = '%';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';
                }
                field("Receipt No"; Rec."Receipt No")
                {
                    ToolTip = 'Specifies the value of the Receipt No field.', Comment = '%';
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    ToolTip = 'Specifies the value of the Receipt Date field.', Comment = '%';
                }
                field("Item No"; Rec."Item No")
                {
                    ToolTip = 'Specifies the value of the Item No field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Lot No"; Rec."Lot No")
                {
                    ToolTip = 'Specifies the value of the Lot No field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                    Caption = 'Branch Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                    Caption = 'BU Code';
                }
                field("eInvoice No"; Rec."eInvoice No")
                {
                    ToolTip = 'Specifies the value of the eInvoice No field.', Comment = '%';
                }
                field("Name Of Transporter"; Rec."Name Of Transporter")
                {
                    ToolTip = 'Specifies the value of the Name Of Transporter field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetData_Act)
            {
                ApplicationArea = All;
                Caption = 'Get Data';

                trigger OnAction()
                var
                begin
                    GetData();

                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        bUpd: Boolean;
    begin
        dsT := Today();

        GetData();
    end;

    local procedure GetData()
    var
        iLine: Integer;
    begin
        if Rec.IsEmpty then
            dsF := 0D
        else begin
            dsF := dsT - 30;
            iLine := recACCTFL.Count;
        end;

        recILE.Reset();
        recILE.SetRange("Posting Date", dsF, dsT);
        recILE.SetRange("Document Type", "Item Ledger Document Type"::"Transfer Shipment");
        recILE.SetFilter("Location Code", '<> INSTRANSIT');
        if recILE.FindSet() then
            repeat
                recACCTFL.Reset();
                recACCTFL.SetRange("Document No", recILE."Order No.");
                recACCTFL.SetRange("Line No", recILE."Order Line No.");
                recACCTFL.SetRange("Item No", recILE."Item No.");
                recACCTFL.SetRange("Lot No", recILE."Lot No.");
                if recACCTFL.FindFirst() then begin
                    if recACCTFL."Receipt No" = '' then begin
                        recILE_Receipt.Reset();
                        recILE_Receipt.SetRange("Order No.", recILE."Order No.");
                        recILE_Receipt.SetRange("Order Line No.", recILE."Order Line No.");
                        recILE_Receipt.SetRange("Item No.", recILE."Item No.");
                        recILE_Receipt.SetRange("Lot No.", recILE."Lot No.");
                        recILE_Receipt.SetRange("Document Type", "Item Ledger Document Type"::"Transfer Receipt");
                        recILE_Receipt.SetFilter("Location Code", '<> INSTRANSIT');
                        if recILE_Receipt.FindFirst() then begin
                            recACCTFL."Receipt No" := recILE_Receipt."Document No.";
                            recACCTFL."Receipt Date" := recILE_Receipt."Posting Date";
                            recACCTFL.Status := 'RECEIVED';
                        end;
                        recACCTFL.Modify()
                    end;
                end else begin
                    iLine += 1;
                    recACCTFL.Init();
                    recACCTFL."Entry No" := iLine;
                    recACCTFL."Document No" := recILE."Order No.";
                    recACCTFL."Line No" := recILE."Order Line No.";
                    recACCTFL.Status := 'SHIPPED';
                    recACCTFL."Posting Date" := recILE."Posting Date";
                    recACCTFL."Shipment No" := recILE."Document No.";
                    recACCTFL."Shipment Date" := recILE."Posting Date";
                    recACCTFL."Item No" := recILE."Item No.";
                    recACCTFL."Description" := recILE."Description";
                    recACCTFL."Lot No" := recILE."Lot No.";
                    recACCTFL."Quantity" := -recILE."Quantity";
                    recACCTFL."Dimension Set ID" := recILE."Dimension Set ID";
                    recACCTFL."Posting Date" := recILE."Posting Date";
                    recACCTFL."Shortcut Dimension 2 Code" := recILE."Global Dimension 2 Code";

                    recTSH.Reset();
                    recTSH.SetRange("No.", recILE."Document No.");
                    if recTSH.FindFirst() then begin
                        recACCTFL."Transfer-from Code" := recTSH."Transfer-from Code";
                        recACCTFL."Transfer-to Code" := recTSH."Transfer-to Code";
                    end;

                    recILE_Receipt.Reset();
                    recILE_Receipt.SetRange("Order No.", recILE."Order No.");
                    recILE_Receipt.SetRange("Order Line No.", recILE."Order Line No.");
                    recILE_Receipt.SetRange("Item No.", recILE."Item No.");
                    recILE_Receipt.SetRange("Lot No.", recILE."Lot No.");
                    recILE_Receipt.SetRange("Document Type", "Item Ledger Document Type"::"Transfer Receipt");
                    recILE_Receipt.SetFilter("Location Code", '<> INSTRANSIT');
                    if recILE_Receipt.FindFirst() then begin
                        recACCTFL."Receipt No" := recILE_Receipt."Document No.";
                        recACCTFL."Receipt Date" := recILE_Receipt."Posting Date";
                        recACCTFL.Status := 'RECEIVED';
                    end;
                    recACCTFL.Insert();
                end;
            until recILE.Next() < 1;
    end;

    //Global
    var
        recACCTFL: Record "ACC Transfer Line";
        recTSH: Record "Transfer Shipment Header";
        recTRH: Record "Transfer Receipt Header";
        recILE: Record "Item Ledger Entry";
        dsF: Date;
        dsT: Date;
        recILE_Receipt: Record "Item Ledger Entry";
}