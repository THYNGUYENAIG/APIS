table 51916 "AIG Transfer Document"
{
    Caption = 'APIS Transfer Document';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "SPO No."; Integer)
        {
            Caption = 'SPO No.';
            Editable = false;
        }
        field(20; "File No."; Code[50])
        {
            Caption = 'File No.';
            Editable = false;
        }
        field(30; "Transfer Order No."; Code[20])
        {
            Caption = 'Transfer Order No.';
            Editable = false;
        }
        field(40; "Transfer Shipment No."; Code[20])
        {
            Caption = 'Transfer Shipment No.';
            TableRelation = "Transfer Shipment Header"."No.";
            trigger OnValidate()
            var
                TransferShipment: Record "Transfer Shipment Header";
            begin
                if TransferShipment.Get("Transfer Shipment No.") then begin
                    "Transfer Order No." := TransferShipment."Transfer Order No.";
                    "Posting Date" := TransferShipment."Posting Date";
                    "eInvoice No." := TransferShipment."BLTI eInvoice No.";
                    "From Location Code" := TransferShipment."Transfer-from Code";
                    "To Location Code" := TransferShipment."Transfer-to Code";
                end;
            end;
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(60; "eInvoice No."; Code[20])
        {
            Caption = 'eInvoice No.';
            Editable = false;
        }
        field(70; "From Location Code"; Code[10])
        {
            Caption = 'From Location Code';
            Editable = false;
        }
        field(80; "To Location Code"; Code[10])
        {
            Caption = 'To Location Code';
            Editable = false;
        }
        field(90; "Doc URL"; Text[400])
        {
            Caption = 'Doc URL';
            Editable = false;
        }
        field(100; "File Name"; Text[255])
        {
            Caption = 'File Name';
            Editable = false;
        }
        field(110; "Document Type"; Enum "AIG TO Doc. Type")
        {
            Caption = 'Document Type';
        }
    }
    keys
    {
        key(PK; "SPO No.")
        {
            Clustered = true;
        }
        key(FK; "Document Type", "Transfer Shipment No.")
        {
            Clustered = false;
        }
    }

    trigger OnInsert()
    var
    begin
        "SPO No." := InsertSPOID();
    end;

    local procedure InsertSPOID(): Integer
    var
        TransferDoc: Record "AIG Transfer Document";
        SPOID: Integer;
    begin
        SPOID := Random(10);
        if not TransferDoc.Get(SPOID) then begin
            exit(SPOID);
        end else begin
            InsertSPOID();
        end;
    end;
}
