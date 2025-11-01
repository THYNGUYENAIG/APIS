page 51016 "ACC Item Certificate"
{
    ApplicationArea = All;
    Caption = 'APIS Item Certificate';
    PageType = List;
    SourceTable = "BLACC Item Certificate";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.") { }
                field("Item Name"; Rec."Item Name") { }
                field("Vendor Code"; Rec."Vendor Code") { }
                field("Vendor Name"; VendorName) { }
                field("Supplier Management Name"; SupplierManagementName) { }
                field("Type"; Rec."Type") { }
                field("Quality Group"; Rec."Quality Group") { }
                field("No."; Rec."No.") { }
                field("Storage Condition"; Rec."Storage Condition") { }
                field("Published Date"; Rec."Published Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field(Description; Rec.Description) { }
                field("Document URL"; Rec."Document URL") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenInFileViewer)
            {
                ApplicationArea = All;
                Image = View;
                Caption = 'View';
                trigger OnAction()
                var
                begin
                    Hyperlink(Rec."Document URL");
                end;
            }
            action(DownloadInRepeater)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                trigger OnAction()
                var
                begin
                    DownloadFile();
                end;
            }

        }
    }

    local procedure DownloadFile()
    var
        BCHelper: Codeunit "BC Helper";
        SharepointConnector: Record "AIG Sharepoint Connector";
        SharepointConnectorLine: Record "AIG Sharepoint Connector Line";
        OauthenToken: SecretText;
    begin
        if SharepointConnector.Get('ITEMDOC') then begin
            OauthenToken := BCHelper.GetOAuthTokenSharepointOnline(SharepointConnector);
        end;
        if not SharepointConnectorLine.Get('ITEMDOC', 1) then begin
            exit;
        end;
        if Rec."File No." <> '' then
            BCHelper.SPODownloadFile(OauthenToken, SharepointConnectorLine."Site ID", SharepointConnectorLine."Drive ID", Rec."File No.", Rec."File Name");
    end;

    trigger OnOpenPage()
    var
    begin
        Rec.SetRange(Outdated, false);
    end;

    trigger OnAfterGetRecord()
    var
        VendTbl: Record Vendor;
        ItemTbl: Record Item;
    begin
        VendorName := '';
        SupplierManagementName := '';
        ItemTbl.Reset();
        ItemTbl.SetRange("No.", Rec."Item No.");
        ItemTbl.SetAutoCalcFields("BLACC Vendor Name");
        if ItemTbl.FindFirst() then begin
            VendorName := ItemTbl."BLACC Vendor Name";
            VendTbl.Reset();
            VendTbl.SetRange("No.", ItemTbl."Vendor No.");
            VendTbl.SetAutoCalcFields("BLACC Supplier Mgt. Name");
            if VendTbl.FindFirst() then begin
                SupplierManagementName := VendTbl."BLACC Supplier Mgt. Name";
            end;
        end;
    end;

    var
        VendorName: Text;
        SupplierManagementName: Text;
}
