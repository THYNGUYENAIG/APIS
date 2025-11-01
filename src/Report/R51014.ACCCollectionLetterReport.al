report 51014 "ACC Collection Letter Report"
{
    ApplicationArea = All;
    Caption = 'APIS Collection Letter Report - R51014';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51014.ACCCollectionLetterReport.rdl';
    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Customer No.";
            DataItemTableView = where(Open = filter(1));
            column(CustomerNo; "Customer No.") { }
            column(CustomerName; "Customer Name") { }
            column(DocumentNo; "Document No.") { }
            column(DocumentDate; "Document Date") { }
            column(DueDate; "Due Date") { }
            column(PostingDate; "Posting Date") { }
            column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
            column(EInvoiceNo; "BLTI eInvoice No.") { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    local procedure GetCompanyInfo()
    var
    begin
        if CompanyInfo.Get() then begin
            CompanyInfo.CalcFields(Picture);
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
}
