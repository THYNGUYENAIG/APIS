page 52024 "ACC Purchase Price Line"
{
    ApplicationArea = All;
    Caption = 'ACC Purchase Price Line';
    PageType = List;
    Editable = false;
    UsageCategory = Lists;
    SourceTable = "Price List Line";
    SourceTableView = sorting("Price List Code", "Line No.") where("Price Type" = filter("Price Type"::Purchase));

    layout
    {
        area(Content)
        {
            repeater(View_Content)
            {
                field("Price List Code"; Rec."Price List Code")
                {
                    ToolTip = 'Specifies the unique identifier of the price list.';
                }
                field("ACC Header Description"; Rec."ACC Header Description")
                {
                    ToolTip = 'Specifies the value of the ACC Header Description field.', Comment = '%';
                    Caption = 'Header Description';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the type of the entity that offers the price or the line discount on the product.';
                    Caption = 'Assign-to Type';
                }
                field("Assign-to No."; Rec."Assign-to No.")
                {
                    ToolTip = 'Specifies the entity to which the prices are assigned. The options depend on the selection in the Assign-to Type field. If you choose an entity, the price list will be used only for that entity.';
                }
                field("Assign-to Parent No."; Rec."Assign-to Parent No.")
                {
                    ToolTip = 'Specifies the project to which the prices are assigned. If you choose an entity, the price list will be used only for that entity.';
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ToolTip = 'Specifies the type of the product.';
                    Caption = 'Product Type';
                }
                field("Product No."; Rec."Product No.")
                {
                    ToolTip = 'Specifies the identifier of the product. If no product is selected, the price and discount values will apply to all products of the selected product type for which those values are not specified. For example, if you choose Item as the product type but do not specify a specific item, the price will apply to all items for which a price is not specified.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency that is used for the prices on the price list. The currency can be the same for all prices on the price list, or you can specify a currency for individual lines.';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ToolTip = 'Specifies the work type code for the resource.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the date from which the price is valid.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the last date that the price is valid.';
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ToolTip = 'Specifies the minimum quantity of the product.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the unit of measure for the product.';
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ToolTip = 'Specifies whether the price list line defines prices, discounts, or both.';
                    Caption = 'Defines';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price of one unit of the selected product.';
                }
                field("Cost Factor"; Rec."Cost Factor")
                {
                    ToolTip = 'Specifies the unit cost factor for project-related prices, if you have agreed with your customer that he should pay certain item usage by cost value plus a certain percent value to cover your overhead expenses.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the unit cost of the resource.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the line discount percentage for the product.';
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ToolTip = 'Specifies if a line discount will be calculated when the price is offered.';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ToolTip = 'Specifies if an invoice discount will be calculated when the price is offered.';
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ToolTip = 'Specifies the if prices include VAT.';
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ToolTip = 'Specifies the default VAT business posting group code.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.', Comment = '%';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                }
                field("Price Type"; Rec."Price Type")
                {
                    ToolTip = 'Specifies the price type: sale or purchase price.';
                }
                field(Description; Rec."ACC Item Description")
                {
                    ToolTip = 'Specifies the description of the product.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether the price list line is in Draft status and can be edited, Inactive and cannot be edited or used, or Active and used for price calculations.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ToolTip = 'Specifies the direct unit cost of the product.';
                }
                field("Source Group"; Rec."Source Group")
                {
                    ToolTip = 'Specifies the value of the Source Group field.', Comment = '%';
                }
                field("BLACC Global Dimension 1 Code"; Rec."BLACC Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("BLACC Global Dimension 2 Code"; Rec."BLACC Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("BLACC Maximum Quantity"; Rec."BLACC Maximum Quantity")
                {
                    ToolTip = 'Specifies the maximum quantity of the product.';
                }
                field("BLACC Shipment Method"; Rec."BLACC Shipment Method")
                {
                    ToolTip = 'Specifies the value of the Shipment Method (Delivery Term) field.';
                }
                field("BLACC Transport Method"; Rec."BLACC Transport Method")
                {
                    ToolTip = 'Specifies the value of the Transport Method (Mode Of Delivery) field.';
                }
                field("BLACC VSG Code"; Rec."BLACC VSG Code")
                {
                    ToolTip = 'Specifies the value of the VSG Code field.';
                }
                field("BLACC Time Type"; Rec."BLACC Time Type")
                {
                    ToolTip = 'Specifies the value of the Time Type field.';
                }
                field("BLACC Assign-Customer Type"; Rec."BLACC Assign-Customer Type")
                {
                    ToolTip = 'Specifies the value of the Assign-Customer Type field.';
                }
                field("BLACC Assign-Customer No."; Rec."BLACC Assign-Customer No.")
                {
                    ToolTip = 'Specifies the value of the Assign-Customer No. field.';
                }
            }
        }
    }
}