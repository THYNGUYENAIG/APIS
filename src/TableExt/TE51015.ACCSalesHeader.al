tableextension 51015 "ACC Sales Header" extends "Sales Header"
{
    fields
    {
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                SalesSetup: Record "Manufacturing Setup";
                Sample: Text;
                PostingDescription: Text;
            begin
                SalesSetup.Get();
                Sample := ' ' + SalesSetup."Posting Description";
                PostingDescription := "Posting Description";
                if ("Document Type" = "Sales Document Type"::Order) OR
                   ("Document Type" = "Sales Document Type"::Invoice) then begin
                    if "Payment Method Code" = SalesSetup."Payment Method Code" then begin
                        "Posting Description" := PostingDescription.Replace(Sample, '');
                        "Posting Description" += Sample;
                    end else
                        "Posting Description" := PostingDescription.Replace(Sample, '');
                end;
            end;
        }
        /*
        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            var
                SalesTime: Codeunit "ACC Sales Worktime";
            begin
                if SalesTime.SalesTimeInday(Rec."Requested Delivery Date", Rec."ACC Reason Code") then
                    Error(StrSubstNo('Hóa đơn phát sinh trong ngày.'));
                if SalesTime.SalesTimeSubmit(Rec."Shortcut Dimension 1 Code", Rec."Requested Delivery Date", Rec."ACC Reason Code") then
                    Error(StrSubstNo('Hóa đơn phát sinh sau giờ quy định.'));
            end;
        }
        */
        field(50001; "Sales Type"; Enum "ACC Sales Type")
        {
            Caption = 'Sales Type';
            DataClassification = ToBeClassified;
        }
        field(50002; "Unset Packing"; Boolean)
        {
            Caption = 'Unset Packing';
            DataClassification = ToBeClassified;
        }
        field(50003; "Agreement Start Date"; Date)
        {
            Caption = 'Agreement Start Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                if ("Agreement Start Date" <> 0D) AND ("Agreement End Date" <> 0D) AND ("Agreement End Date" < "Agreement Start Date") then begin
                    Error(StrSubstNo('Agreement End Date must be greater than equal Agreement Start Date.'));
                end else begin
                    if "Agreement Start Date" <> 0D then begin
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        if SalesLine.FindSet() then
                            repeat
                                SalesLine."BLACC Agreement StartDate" := "Agreement Start Date";
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                    end;
                end;
            end;
        }
        field(50004; "Agreement End Date"; Date)
        {
            Caption = 'Agreement End Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                if ("Agreement End Date" <> 0D) AND ("Agreement End Date" < "Agreement Start Date") then begin
                    Error(StrSubstNo('Agreement End Date must be greater than equal Agreement Start Date.'));
                end else begin
                    if "Agreement End Date" <> 0D then begin
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        if SalesLine.FindSet() then
                            repeat
                                SalesLine."BLACC Agreement EndDate" := "Agreement End Date";
                                SalesLine.Modify();
                            until SalesLine.Next() = 0;
                    end;
                end;
            end;
        }
        field(50005; "ACC Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "ACC Sales Reason".Code;
        }
        field(50006; "ACC Reason Comment"; Text[512])
        {
            Caption = 'Reason Comment';
            DataClassification = ToBeClassified;
        }
    }
}
