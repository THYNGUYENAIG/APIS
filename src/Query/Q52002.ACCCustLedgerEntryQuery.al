query 52002 "ACC Cust Ledger Entry Query"
{
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(CLE; "Cust. Ledger Entry")
        {
            //Filter
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Document_Type_Filter; "Document Type") { }
            filter(Document_No_Filter; "Document No.") { }
            filter(Customer_No_Filter; "Customer No.") { }
            // filter(Receivable_Acc_No_Filter; "NWV Receivables Account No.") { }
            filter(Debit_Amount_LCY_Filter; "Debit Amount (LCY)") { }
            filter(Credit_Amount_LCY_Filter; "Credit Amount (LCY)") { }
            filter(Remaining_Amount_LCY_Filter; "Remaining Amt. (LCY)") { }

            //Field
            column(Customer_No; "Customer No.") { }

            //Calculate
            column(AmtSum; Amount)
            {
                Method = Sum;
            }
            column(AmtLCYSum; "Amount (LCY)")
            {
                Method = Sum;
            }
            column(RemainingAmtSum; "Remaining Amount")
            {
                Method = Sum;
            }
            column(RemainingAmtLCYSum; "Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}