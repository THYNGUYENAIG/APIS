page 52031 "ACC Sales Quotation Statistic"
{
    Caption = 'APIS Sales Quotation Statistic - P52031';
    PageType = List;
    SourceTable = "ACC Sales Line Tmp";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ToolTip = 'Specifies the value of the Ship-to Address field.', Comment = '%';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the value of the Ship-to Name field.', Comment = '%';
                }
                field(MOQ; Rec.MOQ)
                {
                    ToolTip = 'Specifies the value of the MOQ field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field(No; Rec.No)
                {
                    Caption = 'Quotation';
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                }
                field("Sales Pool Code"; Rec."Sales Pool Code")
                {
                    ToolTip = 'Specifies the value of the Sales Pool Code field.', Comment = '%';
                }
                field("Bill-to Customer No"; Rec."Bill-to Customer No")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No field.', Comment = '%';
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer Name field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.', Comment = '%';
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies the value of the Payment Method field.', Comment = '%';
                }
                field("Payment Term"; Rec."Payment Term")
                {
                    ToolTip = 'Specifies the value of the Payment Term field.', Comment = '%';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field("Sell-to Customer No"; Rec."Sell-to Customer No")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No field.', Comment = '%';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer Name field.', Comment = '%';
                }
                field("BU Code"; Rec."BU Code")
                {
                    ToolTip = 'Specifies the value of the BU Code field.', Comment = '%';
                }
                field("BU Name"; Rec."BU Name")
                {
                    ToolTip = 'Specifies the value of the BU Name field.', Comment = '%';
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Item No"; Rec."Item No")
                {
                    ToolTip = 'Specifies the value of the Item No field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Exch Rate"; Rec."Exch Rate")
                {
                    ToolTip = 'Specifies the value of the Exch Rate field.', Comment = '%';
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ToolTip = 'Specifies the value of the Quantity Shipped field.', Comment = '%';
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ToolTip = 'Specifies the value of the Quantity Invoiced field.', Comment = '%';
                }
                field("OutStanding Quantity"; Rec."OutStanding Quantity")
                {
                    ToolTip = 'Specifies the value of the OutStanding Quantity field.', Comment = '%';
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ToolTip = 'Specifies the value of the Reserved Quantity field.', Comment = '%';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.', Comment = '%';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        recSH: Record "Sales Header";
        recSL: Record "Sales Line";
        cuACCGP: Codeunit "ACC General Process";
    begin
        recSH.SetRange("Document Type", "Sales Document Type"::Quote);
        if recSH.FindSet() then
            repeat
                recSL.Reset();
                recSL.SetRange("Document No.", recSH."No.");
                if recSL.FindSet() then
                    repeat
                        iEntryNo += 1;

                        Rec.Init();
                        Rec."Entry No" := iEntryNo;
                        Rec."Ship-to Address" := recSH."Ship-to Address" + ' ' + recSH."Ship-to Address 2";
                        Rec."Ship-to Name" := recSH."Ship-to Name";
                        Rec.MOQ := recSL."BLACC MOQ";
                        Rec."From Date" := recSL."BLACC Agreement StartDate";
                        Rec."Expiration Date" := recSH."Quote Valid Until Date";
                        Rec.No := recSH."No.";
                        Rec."Sales Pool Code" := recSH."BLACC Sales Pool Code";
                        Rec."Bill-to Customer No" := recSH."Bill-to Customer No.";
                        Rec."Bill-to Customer Name" := recSH."Bill-to Name" + ' ' + recSH."Bill-to Name 2";
                        Rec."To Date" := recSL."BLACC Agreement EndDate";
                        Rec."Payment Method" := recSH."Payment Method Code";
                        Rec."Payment Term" := recSH."Payment Terms Code";
                        Rec."Currency Code" := recSH."Currency Code";
                        Rec."Sell-to Customer No" := recSH."Sell-to Customer No.";
                        Rec."Sell-to Customer Name" := recSH."Sell-to Customer Name" + ' ' + recSH."Sell-to Customer Name 2";
                        Rec.Status := recSH.Status;
                        Rec."Dimension Set ID" := recSL."Dimension Set ID";
                        Rec."Item No" := recSL."No.";
                        Rec."Item Description" := recSL.Description;
                        Rec."Exch Rate" := cuACCGP.Divider(1, recSH."Currency Factor");
                        Rec.UOM := recSL."Unit of Measure Code";
                        Rec.Quantity := recSL.Quantity;
                        Rec."Quantity Shipped" := recSL."Quantity Shipped";
                        Rec."Quantity Invoiced" := recSL."Quantity Invoiced";
                        Rec."OutStanding Quantity" := recSL."OutStanding Quantity";
                        Rec."Reserved Quantity" := recSL."Reserved Quantity";
                        Rec."Unit Price" := recSL."Unit Price";
                        Rec."Line Amount" := recSL."Line Amount";
                        Rec.Insert();
                    until recSL.Next() < 1;
            until recSH.Next() < 1;
    end;

    var
        iEntryNo: Integer;
}
