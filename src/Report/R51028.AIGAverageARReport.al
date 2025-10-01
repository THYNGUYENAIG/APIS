report 51028 "AIG Average AR Report"
{
    Caption = 'AIG Average AR Report';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    RDLCLayout = 'src/Layout/R51028.AIGAverageARReport.rdl';


    dataset
    {
        dataitem(LookupData; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1 .. 2));
            dataitem(PaymentCustLedEntry; "Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code") order(ascending);
                RequestFilterFields = "Customer No.", "Posting Date", "Global Dimension 2 Code", "Global Dimension 1 Code", "Shortcut Dimension 7 Code";
                CalcFields = "Amount (LCY)", "Remaining Amt. (LCY)";

                column(IsDetail; 1)
                {
                }
                column(PaymentEntry; PaymentCustLedEntry."Entry No.")
                {
                }
                column(PaymentDocumentType; PaymentCustLedEntry."Document Type")
                {
                }
                column(CustomerNo; "Customer No.")
                {
                }
                column(CustomerName; "Customer Name")
                {
                }
                column(StartDate; StartDate)
                {
                }
                column(EndDate; EndDate)
                {
                }

                column(DueDate; DueDate)
                {
                }
                column(PostingDate; PostingDate)
                {
                }

                column(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code; "Global Dimension 2 Code") //Department
                {
                }
                column(GlobalDimension2Name; DimValue2.Name)
                {
                }
                column(ShortcutDimension7Code; "Shortcut Dimension 7 Code") //FIN
                {
                }
                column(ShortcutDimension7Name; DimValue7.Name)
                {
                }
                column(RemainingAmtLCY; RemainingAmt)
                {
                }
                column(NumOfDatePaymentTerm; NumOfDatePaymentTerm) //HanThanhToan
                {
                }
                column(NumOfDateRepay; NumOfDateRepay) //So lan thanh toan
                {
                }
                column(TotalNumOfDateRepay; TotalNumOfDateRepay)
                {
                }
                column(NumOfPay; NumOfPay)
                {
                }
                dataitem(DetailCustLedEntry; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLinkReference = PaymentCustLedEntry;
                    DataItemTableView = sorting("Entry No.");

                    column(DetailEntry; DetailCustLedEntry."Entry No.")
                    {
                    }
                    //column(DateOfPayment; DetailCustLedEntry."Posting Date")
                    column(DateOfPayment; DateOfPayment)
                    {
                    }

                    dataitem(InvoiceCustLedEntry; "Cust. Ledger Entry")
                    {
                        DataItemLinkReference = DetailCustLedEntry;
                        DataItemLink = "Entry No." = field("Cust. Ledger Entry No.");
                        DataItemTableView = sorting("Entry No.");

                        column(InvoiceEntry; InvoiceCustLedEntry."Entry No.")
                        {
                        }
                        column(eInvoiceNo; eInvoiceNo)
                        {
                        }
                        column(Document_Date; "Document Date")
                        {
                        }
                        trigger OnAfterGetRecord() //InvoiceCustLedEntry
                        begin
                            CalNumOfDate(InvoiceCustLedEntry);
                            NumOfPay += 1;

                            if "Global Dimension 2 Code" <> DimValue2.Code then
                                if not DimValue2.Get(GenLedSetup."Shortcut Dimension 2 Code", "Global Dimension 2 Code") then
                                    Clear(DimValue2);
                            if "Shortcut Dimension 7 Code" <> DimValue7.Code then
                                if not DimValue7.Get(GenLedSetup."Shortcut Dimension 7 Code", "Shortcut Dimension 7 Code") then
                                    Clear(DimValue7);

                            //eInvoiceNo := "NWV EI Invoice No.";
                            PostingDate := "Posting Date";
                            if eInvoiceNo = '' then begin
                                eInvoiceNo := "External Document No.";
                                PostingDate := "Pmt. Discount Date";
                            end;
                            DueDate := "Due Date";
                        end;
                    }
                    trigger OnPreDataItem() //DetailCustLedEntry
                    var
                        PaymentCustLedEntry_: Integer;
                    begin
                        case LookupData.Number of
                            1: //CustLegEntry: Payment - Debug: 1619
                                begin
                                    DetailCustLedEntry.SetRange("Entry Type", DetailCustLedEntry."Entry Type"::Application);
                                    DetailCustLedEntry.SetRange("Document Type", DetailCustLedEntry."Document Type"::Payment);
                                    DetailCustLedEntry.SetRange(Unapplied, false);
                                    DetailCustLedEntry.SetRange("Initial Document Type", DetailCustLedEntry."Initial Document Type"::Invoice);
                                    DetailCustLedEntry.SetRange("Applied Cust. Ledger Entry No.", PaymentCustLedEntry."Entry No.");
                                    DetailCustLedEntry.SetRange("Document No.", PaymentCustLedEntry."Document No.");
                                    DetailCustLedEntry.SetRange("Posting Date", PaymentCustLedEntry."Posting Date");
                                    DetailCustLedEntry.SetRange("Customer No.", PaymentCustLedEntry."Customer No.");
                                    DetailCustLedEntry.SetFilter("Cust. Ledger Entry No.", '<>%1', PaymentCustLedEntry."Entry No.");
                                    if DetailCustLedEntry.IsEmpty then
                                        CurrReport.Skip();
                                end;
                            2: //CustLegEntry: Invoice dc apply bởi payment khác tháng - Debug: 8447|28085
                                begin
                                    DetailCustLedEntry.SetRange("Entry Type", DetailCustLedEntry."Entry Type"::Application);
                                    DetailCustLedEntry.SetRange("Document Type", DetailCustLedEntry."Document Type"::Payment);
                                    DetailCustLedEntry.SetRange(Unapplied, false);
                                    DetailCustLedEntry.SetRange("Initial Document Type", DetailCustLedEntry."Initial Document Type"::Invoice);
                                    // DetailCustLedEntry.SetRange("Applied Cust. Ledger Entry No.", PaymentCustLedEntry."Entry No.");
                                    // DetailCustLedEntry.SetRange("Document No.", PaymentCustLedEntry."Document No.");
                                    DetailCustLedEntry.SetFilter("Posting Date", PaymentCustLedEntry.GetFilter("Posting Date"));
                                    DetailCustLedEntry.SetRange("Customer No.", PaymentCustLedEntry."Customer No.");
                                    DetailCustLedEntry.SetRange("Cust. Ledger Entry No.", PaymentCustLedEntry."Entry No.");
                                    if DetailCustLedEntry.IsEmpty then
                                        CurrReport.Skip();
                                end;
                        end;
                    end;

                    trigger OnAfterGetRecord() //DetailCustLedEntry
                    begin
                        case LookupData.Number of
                            1:
                                AddDetailCustLedEntry(DetailCustLedEntry);
                            2:
                                begin
                                    Clear(DetailCustLedEntryTMP);
                                    if DetailCustLedEntryTMP.Get("Entry No.") then
                                        CurrReport.Skip();
                                end;
                        end;

                        RemainingAmt := DetailCustLedEntry."Amount (LCY)" * -1;
                    end;
                }

                trigger OnAfterGetRecord() //PaymentCustLedEntry
                var
                    CustDueDate: Record "Cust. Ledger Entry";
                    DetailedDueDate: Record "Detailed Cust. Ledg. Entry";
                begin
                    NumOfPay := 0;
                    RemainingAmt := 0;
                    if "Remaining Amt. (LCY)" = "Amount (LCY)" then begin
                        CurrReport.Skip();
                    end else begin
                        DateOfPayment := PaymentCustLedEntry."Document Date";
                    end;
                    /*
                    DetailedDueDate.Reset();
                    DetailedDueDate.SetRange("Cust. Ledger Entry No.", PaymentCustLedEntry."Entry No.");
                    DetailedDueDate.SetRange("Entry Type", "Detailed CV Ledger Entry Type"::Application);
                    DetailedDueDate.SetRange("Document Type", "Gen. Journal Document Type"::Invoice);
                    DetailedDueDate.SetFilter("Applied Cust. Ledger Entry No.", '<>0');
                    if DetailedDueDate.FindFirst() then begin
                        if CustDueDate.Get(DetailedDueDate."Applied Cust. Ledger Entry No.") then
                            DueDate := CustDueDate."Due Date";
                    end else
                        DueDate := PaymentCustLedEntry."Due Date";
                    */
                end;

                trigger OnPreDataItem() //PaymentCustLedEntry
                begin
                    if GetFilter("Posting Date") = '' then
                        Error('Posting Date must be not blank.');
                    if TryGetRangeMax(EndDate) then;
                    if TryGetRangeMin(StartDate) then;
                    if StartDate = EndDate then
                        StartDate := 0D;

                    case LookupData.Number of
                        1:
                            begin
                                SetRange(Reversed, false);
                                SetRange("Document Type", "Document Type"::Payment);
                            end;
                        2:
                            begin
                                SetRange("Document Type", "Document Type"::Invoice);
                            end;
                    end;
                    SetRange("Posting Date", StartDate, EndDate);
                    // SetRange("Entry No.", 1407);
                    SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
                    TotalRow := Count;
                end;
            }
        }

        dataitem(CompanyInfo; "Company Information")
        {
            CalcFields = Picture;
            DataItemTableView = sorting("Primary Key");
            column(FormatNumber; '#,0.##;-#,0.##;')
            {
            }
            column(Name; Name)
            {
            }
            column(CompanyAdd; Address + ' ' + "Address 2")
            {
            }
            column(CompanyPhone; "Phone No.")
            {
            }
            column(CompanyFax; "Fax No.")
            {
            }
            column(Picture; Picture)
            {
            }
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {

            }
        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnInit()
        begin
            EndDate := Today;
        end;
    }

    trigger OnPreReport()
    begin
        GenLedSetup.Get();
    end;

    var
        DetailCustLedEntryTMP: Record "Detailed Cust. Ledg. Entry" temporary;
        StartDate, EndDate : Date;
        GenLedSetup: Record "General Ledger Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        SalesInvHdr: Record "Sales Invoice Header";
        DimValue7, DimValue2 : Record "Dimension Value";
        CustLedEntryTMPCount: Record "Cust. Ledger Entry" temporary;
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        NumOfDatePaymentTerm, NumOfDateRepay, TotalNumOfDateRepay, NumOfPay : Integer;
        TotalRow: Integer;
        AtmInWords: Text;
        //AICMgt: Codeunit "AIC Management";
        //AICAtmInWords: Codeunit "AIC Amount In Words";
        eInvoiceNo: Text;
        DueDate, PostingDate, DateOfPayment : Date;
        RemainingAmt: Decimal;

    local procedure CalNumOfDate(_CustLedEntry: Record "Cust. Ledger Entry")
    var
        DateTable_: Record Date;
        lTotalNumOfDate: Integer;
    begin
        DateTable_.Reset();
        DateTable_.SetRange("Period Type", DateTable_."Period Type"::Date);
        DateTable_.SetRange("Period Start", _CustLedEntry."Document Date", _CustLedEntry."Due Date");
        NumOfDatePaymentTerm := DateTable_.Count();
        NumOfDatePaymentTerm := NumOfDatePaymentTerm - 1;

        DateTable_.SetRange("Period Start", _CustLedEntry."Document Date", DateOfPayment);
        NumOfDateRepay := DateTable_.Count(); //Ngay 
    end;

    [TryFunction]
    local procedure TryGetRangeMax(var ReturnDate: Date)
    begin
        ReturnDate := Today();
        ReturnDate := PaymentCustLedEntry.GetRangeMax("Posting Date");
    end;

    [TryFunction]
    local procedure TryGetRangeMin(var ReturnDate: Date)
    begin
        ReturnDate := 0D;
        ReturnDate := PaymentCustLedEntry.GetRangeMin("Posting Date");
    end;

    local procedure FindApplnEntriesDtldtLedgEntry(var _CustLedgEntry: Record "Cust. Ledger Entry"): Boolean
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                   DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                then begin
                    DtldCustLedgEntry2.Init();
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                               DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            then begin
                                _CustLedgEntry.SetCurrentKey("Entry No.");
                                _CustLedgEntry.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if _CustLedgEntry.Find('-') then begin
                                    _CustLedgEntry.Mark(true);
                                    exit(true);
                                end;

                            end;
                        until DtldCustLedgEntry2.Next() = 0;
                end else begin
                    _CustLedgEntry.SetCurrentKey("Entry No.");
                    _CustLedgEntry.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if _CustLedgEntry.Find('-') then begin
                        _CustLedgEntry.Mark(true);
                        exit(true);
                    end;

                end;
            until DtldCustLedgEntry1.Next() = 0;
    end;

    local procedure GetDateApplyEntry(var _CustLedgEntry: Record "Cust. Ledger Entry") ReturnDate: Date
    var
        CustLedgEntry_: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry_ := _CustLedgEntry;
        // CustLedgEntry_.SetRecFilter();
        CreateCustLedgEntry := CustLedgEntry_;
        if FindApplnEntriesDtldtLedgEntry(CustLedgEntry_) then begin
            ReturnDate := CustLedgEntry_."Posting Date";
            exit;
        end;

        CustLedgEntry_.SetCurrentKey("Entry No.");
        CustLedgEntry_.SetRange("Entry No.");

        if CreateCustLedgEntry."Closed by Entry No." <> 0 then begin
            CustLedgEntry_."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
            CustLedgEntry_.Mark(true);
            ReturnDate := CustLedgEntry_."Posting Date";
            exit;
        end;

        CustLedgEntry_.SetCurrentKey("Closed by Entry No.");
        CustLedgEntry_.SetRange("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
        if CustLedgEntry_.Find('-') then
            repeat
                CustLedgEntry_.Mark(true);
                ReturnDate := CustLedgEntry_."Posting Date";
                exit;
            until CustLedgEntry_.Next() = 0;

        CustLedgEntry_.SetCurrentKey("Entry No.");
        CustLedgEntry_.SetRange("Closed by Entry No.");
        if CustLedgEntry_.Find('-') then begin
            ReturnDate := CustLedgEntry_."Posting Date";
            exit;
        end;
    end;

    local procedure GetDateApplyFromPaymentEntry(_CustLedgEntry: Record "Cust. Ledger Entry"; var _CustLedgEntryTMP: Record "Cust. Ledger Entry" temporary)
    var
        CustLedgEntry_: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry_ := _CustLedgEntry;
        // CustLedgEntry_.SetRecFilter();
        CreateCustLedgEntry := CustLedgEntry_;
        FindApplnEntriesDtldtLedgEntry(CustLedgEntry_);

        CustLedgEntry_.SetCurrentKey("Entry No.");
        CustLedgEntry_.SetRange("Entry No.");

        if CreateCustLedgEntry."Closed by Entry No." <> 0 then begin
            CustLedgEntry_."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
            CustLedgEntry_.Mark(true);
        end;

        CustLedgEntry_.SetCurrentKey("Closed by Entry No.");
        CustLedgEntry_.SetRange("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
        if CustLedgEntry_.Find('-') then
            repeat
                CustLedgEntry_.Mark(true);
            until CustLedgEntry_.Next() = 0;

        CustLedgEntry_.SetCurrentKey("Entry No.");
        CustLedgEntry_.SetRange("Closed by Entry No.");
        CustLedgEntry_.MarkedOnly(true);
        CustLedgEntry_.SetRange("Document Type", CustLedgEntry_."Document Type"::Invoice);
        if CustLedgEntry_.FindSet() then
            repeat
                if not _CustLedgEntryTMP.Get(CustLedgEntry_."Entry No.") then begin
                    Clear(_CustLedgEntryTMP);
                    _CustLedgEntryTMP := CustLedgEntry_;
                    CalNumOfDate(_CustLedgEntryTMP);
                    _CustLedgEntryTMP."Closed by Amount" := NumOfDateRepay; //Số ngày trả nợ
                    _CustLedgEntryTMP."Closed by Amount (LCY)" := NumOfDatePaymentTerm; //Hạn thanh toán
                    _CustLedgEntryTMP."Closed at Date" := _CustLedgEntry."Due Date"; //Ngày thanh toán
                    //_CustLedgEntryTMP."Closed at Date" := _CustLedgEntry."Posting Date"; //Ngày thanh toán
                    _CustLedgEntryTMP."Profit (LCY)" := _CustLedgEntry."Entry No."; //Cust Led Entry of Payment Entry
                    _CustLedgEntryTMP.Insert();
                end;
            until CustLedgEntry_.Next() = 0;
    end;

    local procedure AddDetailCustLedEntry(_DetailCustLedEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        if not DetailCustLedEntryTMP.IsTemporary then
            Error('DetailCustLedEntryTMP must be temporary.');

        if DetailCustLedEntryTMP.Get(_DetailCustLedEntry."Entry No.") then
            exit;

        Clear(DetailCustLedEntryTMP);
        DetailCustLedEntryTMP.Init();
        DetailCustLedEntryTMP."Entry No." := _DetailCustLedEntry."Entry No.";
        DetailCustLedEntryTMP.Insert();
    end;
}
