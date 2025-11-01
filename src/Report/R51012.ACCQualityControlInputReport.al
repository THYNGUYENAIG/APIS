report 51012 "ACC Quality Control In Report"
{
    Caption = 'APIS Quality Control Input Report - R51012';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Layout/R51012.ACCQualityControlInputReport.rdl';

    dataset
    {
        dataitem(QualityControlHeader; "ACC Quality Control Header")
        {
            RequestFilterFields = "Location Code", "Truck Number", "Delivery Date", "Delivery Times";
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress02; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CarNumber; "Truck Number") { }
            column(DeliveryDate; "Delivery Date") { }
            column(DeliveryTimes; "Delivery Times") { }
            column(Dock; Dock) { }
            column(SealNo; "Seal No.") { }
            column(TGBD; TGBD) { }
            column(TGKT; TGKT) { }
            column(Floor; Floor) { }
            column(Wall; Wall) { }
            column(Ceiling; Ceiling) { }
            column(NoStrangeSmell; "No Strange Smell") { }
            column(NoInsects; "No Insects") { }
            column(VehicleTemperature; "Vehicle Temperature") { }
            column(ContainerNo; "Container No.") { }
            dataitem(QualityControlLine; "ACC Quality Control Line")
            {
                DataItemLink = "Location Code" = field("Location Code"), "Truck Number" = field("Truck Number"), "Delivery Date" = field("Delivery Date"), "Delivery Times" = field("Delivery Times");
                column(LineNo; "Line No.") { }
                column(ItemNo; "Item No.") { }
                column(ItemName; "Item Name") { }
                column(LotNo; "Lot No.") { }
                column(Quantity; Quantity) { }
                column(BrokenQuantity; "Broken Quantity") { }
                column(PackingNo; "Packing No.") { }
                column(RealityPackingNo; "Reality Packing No.") { }
                column(PackagingLabel; "Packaging Label") { }
                column(PackagingState; "Packaging State") { }
                column(NoInsectsLine; "No Insects") { }
                column(NoStrangeSmellLine; "No Strange Smell") { }
                column(DocumentNo; "Document No.") { }
            }

            trigger OnAfterGetRecord()
            begin
                GetCompanyInfo();
            end;
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
