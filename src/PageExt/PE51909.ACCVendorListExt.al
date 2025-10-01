pageextension 51909 "ACC Vendor List Ext" extends "Vendor List"
{
    layout
    {
        addafter("BLACC Supplier Mgt. Name")
        {
            field("ACC Planner Name"; Rec."ACC Planner Name")
            {
                ApplicationArea = All;
            }
            field("ACC Accounting Name"; Rec."ACC Accounting Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Attached Documents List")
        {
            part("SP. Attachment Factbox"; "ACC SP. Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Sharepoint';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Vendor),
                              "No." = field("No.");
            }
        }
    }
    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast(processing)
        {
            action(ImportVendorCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor Code';
                Scope = Repeater;
                trigger OnAction();
                var
                begin
                    ImportVendorCode();
                end;
            }
        }
    }
    procedure ImportVendorCode()
    var
        Vend: Record Vendor;
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        VendNo: Text;
        VendCode: Text;
        FileName: Text;
        SheetName: Text;
        Instream: InStream;
    begin
        if UploadIntoStream('Select Excel File', '', '', FileName, InStream) then begin
            // Ask the user to select the Excel file
            TmpExcelBuffer.Reset();
            TmpExcelBuffer.DeleteAll();
            // Load Excel contents into Excel Buffer
            SheetName := TmpExcelBuffer.SelectSheetsNameStream(InStream);
            TmpExcelBuffer.OpenBookStream(InStream, SheetName);
            TmpExcelBuffer.ReadSheet(); // Clear previous data

            // Now process the Excel rows
            //TmpExcelBuffer.Reset();
            TmpExcelBuffer.SetFilter("Row No.", '>1');
            if TmpExcelBuffer.FindSet() then
                repeat
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 1, VendCode);
                    GetCellValue(TmpExcelBuffer, TmpExcelBuffer."Row No.", 2, VendNo);
                    if Vend.Get(VendNo) then begin
                        if VendCode <> '' then begin
                            Vend."ACC Vendor Code" := VendCode;
                            Vend.Modify();
                        end;
                    end;
                until TmpExcelBuffer.Next() = 0;
        end;
    end;

    local procedure GetCellValue(var TempExcelBuffer: Record "Excel Buffer"; Row: Integer; Col: Integer; var Value: Text): Boolean
    begin
        if TempExcelBuffer.Get(Row, Col) then begin
            Value := TempExcelBuffer."Cell Value as Text";
            exit(Value <> '');
        end;
        exit(false);
    end;
}
