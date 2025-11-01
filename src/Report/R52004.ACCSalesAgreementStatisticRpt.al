report 52004 "ACC SA Statistic Report"
{
    Caption = 'APIS Sales Agreement Statistic Report - R52004';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/R52004_ACCSalesAgreementStatisticRpt.rdl';

    dataset
    {
        //Main
        dataitem(SH; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const("Sales Document Type"::"BLACC Agreement"));

            column(No; "No.") { }
            column(Sales_Quote; "BLACC Sales Quotation No.") { }
            column(Cust_No; "Sell-to Customer No.") { }
            column(Cust_Name; "Sell-to Customer Name") { }
            column(Cust_Inv_No; "Bill-to Customer No.") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(Status; Status) { }
            column(Due_Date; "Due Date") { }
            column(Sales_Pool; "BLACC Sales Pool Code") { }
            column(Order_Date; "Order Date") { }
            // column(Work_Description; "Work Description") { }
            column(Your_Reference; "Your Reference") { }
            column(BLACC_Agreement_StartDate; "BLACC Agreement StartDate") { }
            column(BLACC_Contract_Delivery_Date; "BLACC Contract Delivery Date") { }
            column(BLACC_Contract_Return_Date; "BLACC Contract Return Date") { }

            column(Salesperson_Name; tfSPName) { }
            column(Cust_Group_Name; tfCustGroupName) { }
            column(Cust_Inv_Name; tfCustInvName) { }
            column(Currency; tfCurrency) { }
            column(BU; tfBu) { }
            column(Cust_Pool; tfCustPool) { }
            column(Work_Description; tfWorkDesc) { }
            column(Shared_Cust; tfSharedCust) { }
            column(DF_Parm; dsF) { }
            column(DT_Parm; dsT) { }
            column(Cust_No_Parm; tsCustNo) { }

            dataitem(SL; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SH;
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const("Sales Line Type"::Item), Quantity = filter('<> 0'));

                column(Item_No; "No.") { }
                column(Item_Desc; Description) { }
                column(UOM; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(Quantity_Shipped; "Quantity Shipped") { }
                column(Quantity_Invoiced; "Quantity Invoiced") { }
                column(Quantity_Remaining; Quantity - "Quantity Invoiced") { }
                column(Unit_Price; "Unit Price") { }
                column(Purch_Amt; (Quantity - "Quantity Invoiced") * "Unit Price") { }
                column(Line_No; "Line No.") { }

                trigger OnAfterGetRecord()
                begin
                    tfBU := '';
                    tfBU := cuACCGP.GetDimensionCodeValue("Dimension Set ID", 'BUSINESSUNIT');
                end;
            }

            trigger OnAfterGetRecord()
            var
                tLine: Text;
            begin
                tfSharedCust := 'No';
                if SH."Salesperson Code" = '0120011001_0002' then tfSharedCust := 'Yes';

                tfSPName := '';
                recSP.Reset();
                recSP.SetRange(Code, "Salesperson Code");
                if recSP.FindFirst() then tfSPName := recSP.Name;

                tfCustInvName := '';
                tfCustGroupName := '';
                tfCustPool := '';
                recC.Reset();
                recC.SetRange("No.", "Bill-to Customer No.");
                if recC.FindFirst() then begin
                    tfCustInvName := recC.Name;
                    tfCustGroupName := recC."BLACC Customer Group";
                    tfCustPool := recC."BLACC Sales Pool";
                end;

                tfCurrency := 'VND';
                if SH."Currency Code" <> '' then tfCurrency := SH."Currency Code";

                Clear(instreamfWorkDesc);
                tfWorkDesc := '';
                CalcFields(SH."Work Description");
                SH."Work Description".CreateInStream(instreamfWorkDesc, TEXTENCODING::UTF8);
                tfWorkDesc := cuACCGP.ConvertBlobDataToText(instreamfWorkDesc);
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

                        trigger OnValidate()
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
            // dsT := DMY2Date(27, 11, 2024);
            // tsCustNo := '131TN00235';
        end;
    }

    //GLobal
    var
        dsF: Date;
        dsT: Date;
        tsCustNo: Text;
        recSP: Record "Salesperson/Purchaser";
        tfSPName: Text;
        tfCustGroupName: Text;
        recC: Record Customer;
        tfCurrency: Text;
        tfCustInvName: Text;
        tfBU: Text;
        cuACCGP: Codeunit "ACC General Process";
        tfCustPool: Text;
        tfWorkDesc: Text;
        instreamfWorkDesc: Instream;
        tfSharedCust: Text;
}