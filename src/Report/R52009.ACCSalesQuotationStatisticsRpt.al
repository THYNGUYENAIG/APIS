report 52009 "ACC SQ Statistics Report"
{
    Caption = 'APIS Sales Quotation Statistics Report - R52009';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52009_ACCSalesQuotationStatisticsRpt.rdl';

    dataset
    {
        dataitem(SH_Quote; "Sales Header")
        {
            DataItemTableView = sorting("No.") where("Document Type" = const("Sales Document Type"::Quote));

            column(No; "No.") { }
            column(Cust_No; "Sell-to Customer No.") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Status; Status) { }

            column(Cust_Name; tfCustName) { }
            column(Salesperson_Name; tfSPName) { }
            column(Sales_Taker; tfSPName) { }
            column(Sales_Reponsible; tfSPName) { }

            dataitem(SL_Quote; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SH_Quote;
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = Const("Sales Line Type"::Item));

                column(Item_No; "No.") { }
                column(Item_Desc; Description) { }
                column(UOM; "Unit of Measure Code") { }
                column(Qty; Quantity) { }

                column(Qty_SA; decfQtySA) { }
                column(Qty_SO; decfQtySO) { }
                column(Qty_Remaining; Quantity - decfQtySA) { }

                trigger OnAfterGetRecord()
                begin
                    decfQtySA := 0;
                    recSL_SA.Reset();
                    recSL_SA.SetRange("Document Type", "Sales Document Type"::"BLACC Agreement");
                    recSL_SA.SetRange("BLACC Quote No.", SH_Quote."No.");
                    recSL_SA.SetRange("BLACC Quote Line No.", SL_Quote."Line No.");
                    if recSL_SA.FindSet() then begin
                        repeat
                            recSH_SA.Reset();
                            recSH_SA.SetRange("No.", recSL_SA."Document No.");
                            recSH_SA.SetRange(Status, "Sales Document Status"::Released);
                            if recSH_SA.FindFirst() then decfQtySA += recSL_SA.Quantity;
                        until recSL_SA.Next() < 1;
                    end;

                    decfQtySO := 0;
                    recSL.Reset();
                    recSL.SetRange("Document Type", "Sales Document Type"::Order);
                    recSL.SetRange("BLACC Quote No.", SH_Quote."No.");
                    recSL.SetRange("BLACC Quote Line No.", SL_Quote."Line No.");
                    if recSL.FindSet() then begin
                        repeat
                            recSH.Reset();
                            recSH.SetRange("No.", recSL."Document No.");
                            recSH.SetRange(Status, "Sales Document Status"::Released);
                            if recSH.FindFirst() then decfQtySO += recSL.Quantity;
                        until recSL.Next() < 1;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                tfCustName := StrSubstNo('%1 %2', SH_Quote."Sell-to Customer Name", SH_Quote."Sell-to Customer Name 2");

                recSP.Reset();
                recSP.SetRange(Code, "Salesperson Code");
                if recSP.FindFirst() then tfSPName := recSP.Name;
            end;

            trigger OnPreDataItem()
            begin
                if (dsF <> 0D) and (dsT <> 0D) then begin
                    SetRange("Order Date", dsF, dsT);
                    if tsCustNo <> '' then SetRange("Sell-to Customer No.", tsCustNo);
                end else
                    CurrReport.Break();
            end;
        }
    }

    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(dsF; dsF)
                    {
                        ApplicationArea = All;
                        Caption = 'Order Date From';

                        trigger OnValidate();
                        begin
                            dsT := CalcDate('<CM>', dsF);
                        end;
                    }

                    field(dsT; dsT)
                    {
                        ApplicationArea = All;
                        Caption = 'Order Date To';
                    }

                    field(tsCustNo; tsCustNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
                        Caption = 'Customer No.';
                        // Enabled = bEdit;
                        // ShowMandatory = true;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dsT := Today();
            dsF := CalcDate('<-CM>', dsT);
            // dsF := DMY2Date(5, 10, 2022);
            // dsT := DMY2Date(5, 10, 2022);
            // dsF := DMY2Date(3, 5, 2024);
            // dsT := DMY2Date(3, 5, 2024);
        end;
    }

    //Global
    var
        dsF: Date;
        dsT: Date;
        tsCustNo: Text;
        recSP: Record "Salesperson/Purchaser";
        tfCustName: Text;
        tfSPName: Text;
        recSL_SA: Record "Sales Line";
        decfQtySA: Decimal;
        recSH_SA: Record "Sales Header";
        decfQtySO: Decimal;
        recSL: Record "Sales Line";
        recSH: Record "Sales Header";
}