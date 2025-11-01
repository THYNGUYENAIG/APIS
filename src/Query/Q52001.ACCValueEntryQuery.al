query 52001 "ACC Value Entry Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;
    
    elements
    {
        dataitem(VLE; "Value Entry")
        {
            //Filter
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Item_Ledger_Entry_Type_Filter; "Item Ledger Entry Type") { }
            filter(Document_Type_Filter; "Document Type") { }
            filter(Document_No_Filter; "Document No.") { }
            filter(Item_No_Filter; "Item No.") { }
            filter(Source_No_Filter; "Source No.") { }
            filter(Gen_Bus_Posting_Group_Filter; "Gen. Bus. Posting Group") { }
            filter(Item_Charge_No_Filter; "Item Charge No.") { }
            filter(Adjustment_Filter; Adjustment) { }

            //Field
            column(Posting_Date; "Posting Date") { }
            column(Document_Type; "Document Type") { }
            column(Document_No; "Document No.") { }
            column(Document_Line_No; "Document Line No.") { }
            column(Item_No; "Item No.") { }
            column(Item_Ledger_Entry_No; "Item Ledger Entry No.") { }
            column(Dimension_Set_ID; "Dimension Set ID") { }
            // column(BLTI_eInvoice_No; "BLTI eInvoice No.") { }

            //Calculate
            column(SalesAmtSum; "Sales Amount (Actual)")
            {
                Method = Sum;
            }
            column(CostAmtActSum; "Cost Amount (Actual)")
            {
                Method = Sum;
            }
            column(CostPostedToGLSum; "Cost Posted to G/L")
            {
                Method = Sum;
            }
            column(InvQtySum; "Invoiced Quantity")
            {
                Method = Sum;
            }
        }
    }
}