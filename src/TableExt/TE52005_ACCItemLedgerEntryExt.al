tableextension 52005 "ACC Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(52005; "ACC Order No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC Order No.';
        }
        field(52010; "ACC Invoice No"; Code[35])
        {
            Caption = 'Invoice No';
            // Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = lookup("Purch. Rcpt. Line"."BLACC Invoice No." where("Document No." = field("Document No."),
            //                                                         "Line No." = field("Document Line No."), "No." = field("Item No.")));
        }
        field(52015; "ACC EInvoice No"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Invoice No';
        }
        field(52020; "ACC Customer Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer/Vendor Name';
        }
        field(52025; "ACC Item Description"; Text[100])
        {
            Caption = 'ACC Item Description';
            // Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item".Description where("No." = field("Item No.")));
        }
        field(52030; "ACC ECUS Item Name"; Text[2048])
        {
            Caption = 'ACC ECUS Item Name';
            // Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."BLTEC Item Name" where("No." = field("Item No.")));
        }
        field(52035; "ACC EInvoice Type"; Enum "BLTI eInvoice Type")
        {
            Caption = 'ACC EInvoice Type';
            // Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("BLTI eInvoice Register"."eInvoice Type" where("eInvoice No." = field("ACC EInvoice No")));
        }
        field(52040; "ACC EInvoice Series"; Code[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC EInvoice Series';
        }
        field(52045; "ACC Contact No"; Code[20])
        {
            Caption = 'ACC Contact No';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Sell-to Contact No." where("No." = field("Document No.")));
        }
        field(52050; "ACC Contact Name"; Text[150])
        {
            Caption = 'ACC Contact Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Contact"."Name" where("No." = field("ACC Contact No")));
        }
        field(52055; "ACC Delivery Notes"; Text[2048])
        {
            Caption = 'ACC Delivery Notes';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."BLACC Delivery Note" where("No." = field("Document No.")));
        }
        field(52060; "ACC Delivery Address"; Text[100])
        {
            Caption = 'ACC Delivery Address';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Ship-to Address" where("No." = field("Document No.")));
        }
        field(52065; "ACC Bill To"; Code[20])
        {
            Caption = 'ACC Bill To';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Bill-to Customer No." where("No." = field("Document No.")));
        }
        field(52070; "ACC Bill To Name"; Text[150])
        {
            Caption = 'ACC Bill To Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Bill-to Name" where("No." = field("Document No.")));
        }
        field(52075; "ACC Salesperson Code"; Code[20])
        {
            Caption = 'ACC Salesperson Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Salesperson Code" where("No." = field("Document No.")));
        }
        field(52080; "ACC Base UOM"; Code[10])
        {
            Caption = 'ACC Base UOM';
            FieldClass = FlowField;
            CalcFormula = lookup("Item"."Base Unit of Measure" where("No." = field("Item No.")));
        }
        field(52085; "ACC Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'ACC Price';
            DecimalPlaces = 0 : 5;
        }
    }

    // procedure GetACCOrderNo(ivrecILE: Record "Item Ledger Entry"; var vdecPrice: Decimal) ovlstRt: List of [Text]
    procedure GetACCOrderNo(ivrecILE: Record "Item Ledger Entry") ovlstRt: List of [Text]
    var
        recSSH: Record "Sales Shipment Header";
        recRRH: Record "Return Receipt Header";
        recPRH: Record "Purch. Rcpt. Header";
        recRSH: Record "Return Shipment Header";
        recTRH: Record "Transfer Receipt Header";
        recTSH: Record "Transfer Shipment Header";
        tOrder: Text;
        tCustName: Text;
        recC: Record Customer;
        recVE: Record "Value Entry";
        recSIL: Record "Sales Invoice Line";
        recSCML: Record "Sales Cr.Memo Line";
    // recPIL: Record "Purch. Inv. Line";
    // recPCML: Record "Purch. Cr. Memo Line";
    begin
        tOrder := '';
        tCustName := '';
        case ivrecILE."Entry Type" of
            "Item Ledger Entry Type"::Sale:
                begin
                    case ivrecILE."Document Type" of
                        "Item Ledger Document Type"::"Sales Shipment":
                            begin
                                if recSSH.Get(ivrecILE."Document No.") then begin
                                    tOrder := recSSH."Order No.";
                                    tCustName := recSSH."Sell-to Customer Name";
                                end;
                                // recVE.Reset();
                                // recVE.SetRange("Item Ledger Entry No.", ivrecILE."Entry No.");
                                // recVE.SetRange("Document Type", "Item Ledger Document Type"::"Sales Invoice");
                                // if recVE.FindFirst() then begin
                                //     recSIL.Reset();
                                //     recSIL.SecurityFiltering(SecurityFilter::Ignored);
                                //     recSIL.SetRange("Document No.", recVE."Document No.");
                                //     recSIL.SetRange("No.", recVE."Item No.");
                                //     recSIL.SetRange("Line No.", recVE."Document Line No.");
                                //     if recSIL.FindFirst() then begin
                                //         vdecPrice := recSIL."Unit Price";
                                //     end;
                                // end;
                            end;
                        "Item Ledger Document Type"::"Sales Return Receipt":
                            begin
                                recRRH.Get(ivrecILE."Document No.");
                                tOrder := recRRH."Return Order No.";
                                tCustName := recRRH."Sell-to Customer Name";

                                // recVE.Reset();
                                // recVE.SetRange("Item Ledger Entry No.", ivrecILE."Entry No.");
                                // recVE.SetRange("Document Type", "Item Ledger Document Type"::"Sales Credit Memo");
                                // if recVE.FindFirst() then begin
                                //     recSCML.Reset();
                                //     recSCML.SecurityFiltering(SecurityFilter::Ignored);
                                //     recSCML.SetRange("Document No.", recVE."Document No.");
                                //     recSCML.SetRange("No.", recVE."Item No.");
                                //     recSCML.SetRange("Line No.", recVE."Document Line No.");
                                //     if recSCML.FindFirst() then begin
                                //         vdecPrice := recSCML."Unit Price";
                                //     end;
                                // end;
                            end;
                    end;
                end;
            "Item Ledger Entry Type"::Purchase:
                begin
                    case Rec."Document Type" of
                        "Item Ledger Document Type"::"Purchase Receipt":
                            begin
                                recPRH.Get(ivrecILE."Document No.");
                                tOrder := recPRH."Order No.";
                                tCustName := recPRH."Buy-from Vendor Name";
                            end;
                        "Item Ledger Document Type"::"Purchase Return Shipment":
                            begin
                                recRSH.Get(ivrecILE."Document No.");
                                tOrder := recRSH."Return Order No.";
                                tCustName := recRSH."Buy-from Vendor Name";
                            end;
                    end;
                end;
            "Item Ledger Entry Type"::Transfer:
                begin
                    case Rec."Document Type" of
                        "Item Ledger Document Type"::"Transfer Receipt":
                            begin
                                recTRH.Get(ivrecILE."Document No.");
                                tOrder := recTRH."Transfer Order No.";
                            end;
                        "Item Ledger Document Type"::"Transfer Shipment":
                            begin
                                recTSH.Get(ivrecILE."Document No.");
                                tOrder := recTSH."Transfer Order No.";
                            end;
                    end;
                end;
        end;

        ovlstRt.Add(tOrder);
        ovlstRt.Add(tCustName);
    end;

    procedure GetACCEInvoice(ivrecILE: Record "Item Ledger Entry") tOrder: Text
    var
        recVE: Record "Value Entry";
        recSIH: Record "Sales Invoice Header";
        recTSH: Record "Transfer Shipment Header";
    begin
        case ivrecILE."Entry Type" of
            "Item Ledger Entry Type"::Sale:
                begin
                    case ivrecILE."Document Type" of
                        "Item Ledger Document Type"::"Sales Shipment":
                            begin
                                recVE.Reset();
                                recVE.SetRange("Item Ledger Entry No.", ivrecILE."Entry No.");
                                recVE.SetRange("Document Type", "Item Ledger Document Type"::"Sales Invoice");
                                if recVE.FindFirst() then begin
                                    recSIH.Reset();
                                    recSIH.SetRange("No.", recVE."Document No.");
                                    if recSIH.FindFirst() then begin
                                        tOrder := recSIH."BLTI eInvoice No.";
                                    end;
                                end;
                            end;
                    end;
                end;
            "Item Ledger Entry Type"::Transfer:
                begin
                    case Rec."Document Type" of
                        "Item Ledger Document Type"::"Transfer Shipment":
                            begin
                                recTSH.Get(ivrecILE."Document No.");
                                tOrder := recTSH."BLTI eInvoice No.";
                            end;
                    end;
                end;
        end;
    end;
}