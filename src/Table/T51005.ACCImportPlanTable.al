table 51005 "ACC Import Plan Table"
{
    Caption = 'APIS Import Plan Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Source Document No."; Code[20])
        {
            Editable = false;
            Caption = 'Purchase Order';
        }
        field(20; "Source Line No."; Integer)
        {
            Editable = false;
            Caption = 'Source Line No.';
        }
        field(21; "Vendor Account"; Code[20])
        {
            Editable = false;
            Caption = 'Vendor Account';
        }
        field(22; "Vendor Name"; Text[250])
        {
            Editable = false;
            Caption = 'Vendor Name';
            //FieldClass = FlowField;
            //CalcFormula = lookup(Vendor.Name where("No." = field("Vendor Account")));
        }
        field(23; "Item Number"; Code[20])
        {
            Editable = false;
            Caption = 'Item Number';
            TableRelation = Item."No.";
        }
        field(24; "Item Name"; Text[250])
        {
            Editable = false;
            Caption = 'Item Name';
        }
        field(25; "Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Editable = false;
            Caption = 'Số lượng';
        }
        field(30; "Line No."; Integer)
        {
            Editable = false;
            Caption = 'Line No.';
        }
        field(40; "Declaration No."; Code[30])
        {
            Editable = false;
            Caption = 'Số tờ khai';
        }
        field(50; "Declaration Date"; Date)
        {
            Editable = false;
            Caption = 'Ngày tờ khai';
        }
        field(60; "Bill No."; Code[20])
        {
            //Editable = false;
            Caption = 'Số B/L';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."BL No." where("BLTEC Customs Declaration No." = field("Declaration No.")));
        }
        field(70; "Actual Arrival Date"; Date)
        {
            Editable = false;
            Caption = 'Actual Arrival Date';
        }

        field(71; "Copy Docs Date"; Date)
        {
            Editable = false;
            Caption = 'Copy Docs Date';
        }
        field(72; "Cont. 20"; Decimal)
        {

            Caption = 'Cont. 20';
        }

        field(73; "Cont. 40"; Decimal)
        {

            Caption = 'Cont. 40';
        }
        field(74; "Cont. 45"; Decimal)
        {

            Caption = 'Cont. 45';
        }

        field(75; "Cont. Type"; Code[30])
        {
            Editable = false;
            Caption = 'Loại cont./khối';
        }
        field(76; "Product Type"; Code[35])
        {
            Editable = false;
            Caption = 'Loại hàng';
        }
        field(77; "Cont. Quantity"; Decimal)
        {
            Editable = false;
            Caption = 'Số lượng cont.';
        }
        field(78; "Container No."; Text[50])
        {
            Caption = 'Container No.';
        }
        field(80; "Imported Available Date"; Date)
        {
            Caption = 'Ngày có thể nhập hàng';
        }
        field(90; "Storage Date"; Date)
        {
            Editable = false;
            Caption = 'Hạn lưu bãi';
        }
        field(100; "Full Container Date"; Date)
        {
            Editable = false;
            Caption = 'Hạn lưu cont. đầy';
        }
        field(110; "Empty Container Date"; Date)
        {
            Editable = false;
            Caption = 'Hạn lưu cont. rỗng';
        }
        field(120; "Port Date"; Date)
        {
            Editable = false;
            Caption = 'Hạn lưu tại cảng';
        }
        field(130; "Date Adj. Of Port"; Date)
        {
            Editable = false;
            Caption = 'Ngày điều chỉnh hạn lưu tại cảng';
        }
        field(140; "Delivery Date"; Date)
        {
            Caption = 'Ngày nhận hàng';
            trigger OnValidate()
            begin
                if "Delivery Date" <> 0D then begin
                    if "Delivery Date" >= "Imported Available Date" then begin
                        if DET <> 0 then
                            "Empty Container Date" := "Delivery Date" + DET - 1;
                        if Combine <> 0 then begin
                            "Full Container Date" := "Delivery Date";
                            "Empty Container Date" := "Actual Arrival Date" + Combine - 1;
                        end;
                        if "Storage Date" > "Full Container Date" then begin
                            "Port Date" := "Full Container Date";
                        end else begin
                            "Port Date" := "Storage Date";
                        end;
                    end else begin
                        Error('Ngày nhận hàng lớn hơn hoặc bằng Ngày có thể nhập hàng.');
                    end;
                end else begin
                    if Combine <> 0 then begin
                        "Full Container Date" := "Actual Arrival Date" + Combine - 1;
                        "Empty Container Date" := "Full Container Date";
                    end;
                    if DEM <> 0 then begin
                        "Full Container Date" := "Actual Arrival Date" + DEM - 1;
                    end;
                    if "Storage Date" > "Full Container Date" then begin
                        "Port Date" := "Full Container Date";
                    end else begin
                        "Port Date" := "Storage Date";
                    end;
                end;
            end;
        }
        field(150; DEM; Integer)
        {
            Caption = 'DEM lưu cont. đầy';
            trigger OnValidate()
            begin
                if DEM <> 0 then begin
                    Combine := 0;
                    "Full Container Date" := "Actual Arrival Date" + DEM - 1;
                    if DET = 0 then
                        "Empty Container Date" := 0D;
                    if "Storage Date" > "Full Container Date" then begin
                        "Port Date" := "Full Container Date";
                    end else begin
                        "Port Date" := "Storage Date";
                    end;
                end;
            end;
        }
        field(160; DET; Integer)
        {
            Caption = 'DET lưu cont. rỗng';
            trigger OnValidate()
            begin
                if DET <> 0 then begin
                    Combine := 0;
                    if "Delivery Date" <> 0D then
                        "Empty Container Date" := "Delivery Date" + DET - 1;
                    if DEM = 0 then
                        "Full Container Date" := 0D;
                    if "Storage Date" > "Full Container Date" then begin
                        "Port Date" := "Full Container Date";
                    end else begin
                        "Port Date" := "Storage Date";
                    end;
                end;
            end;
        }
        field(170; Combine; Integer)
        {
            Caption = 'Combine (DEM/DET)';
            trigger OnValidate()
            begin
                if Combine <> 0 then begin
                    DEM := 0;
                    DET := 0;
                    if "Delivery Date" = 0D then begin
                        "Full Container Date" := "Actual Arrival Date" + Combine - 1;
                        "Empty Container Date" := "Full Container Date";
                    end else begin
                        "Empty Container Date" := "Actual Arrival Date" + Combine - 1;
                    end;
                    if "Storage Date" > "Full Container Date" then begin
                        "Port Date" := "Full Container Date";
                    end else begin
                        "Port Date" := "Storage Date";
                    end;
                end;
            end;
        }

        field(171; "Store lưu bãi"; Integer)
        {
            Caption = 'Store lưu bãi';
            trigger OnValidate()
            begin
                if "Store lưu bãi" <> 0 then begin
                    "Storage Date" := "Actual Arrival Date" + "Store lưu bãi" - 1;
                end;
                if "Storage Date" > "Full Container Date" then begin
                    "Port Date" := "Full Container Date";
                end else begin
                    "Port Date" := "Storage Date";
                end;
            end;
        }
        field(180; "Location Code"; Code[20])
        {
            Caption = 'Kho nhập';
            TableRelation = Location.Code;
        }
        field(190; "Actual Received Quantity"; Decimal)
        {
            Caption = 'Số lượng thực nhập';
            DecimalPlaces = 0 : 3;

            trigger OnValidate()
            var
                ImportPlan: Record "ACC Import Plan Table";
                ActualQuantity: Decimal;
            begin
                ActualQuantity := 0;
                ImportPlan.Reset();
                ImportPlan.SetRange("Source Document No.", "Source Document No.");
                ImportPlan.SetRange("Source Line No.", "Source Line No.");
                ImportPlan.CalcSums("Actual Received Quantity");
                ActualQuantity := ImportPlan."Actual Received Quantity";
                ActualQuantity := ActualQuantity - xRec."Actual Received Quantity";
                ActualQuantity := ActualQuantity + "Actual Received Quantity";

                if "Purchase Quantity" < ActualQuantity then
                    Error(StrSubstNo('Tổng số lượng thực nhập %1 lớn hơn số lượng PO %2.', ActualQuantity, "Purchase Quantity"));
            end;

        }
        field(200; "Delivery Time"; Text[50])
        {
            Caption = 'Thời gian nhận hàng';
        }
        field(210; "Storage Fee"; Decimal)
        {
            Caption = 'Phí lưu bãi / cont.';
            DecimalPlaces = 0 : 2;
        }
        field(220; "Actual Location Code"; Code[20])
        {
            Caption = 'Kho nhận thực tế';
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                WhseReceiptLine: Record "Warehouse Receipt Line";
            begin
                WhseReceiptLine.Reset();
                WhseReceiptLine.SetRange("Source No.", "Source Document No.");
                WhseReceiptLine.SetRange("Source Line No.", "Source Line No.");
                if WhseReceiptLine.FindFirst() then begin
                    Error(StrSubstNo('Kho %1 không thể chỉnh vì đang nhập hàng trên Warehouse Receipt.', "Actual Location Code"));
                end;
            end;
        }
        field(230; "Transport Code"; Code[20])
        {
            Caption = 'Mã nhà xe';
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                VendTable: Record Vendor;
            begin
                if VendTable.Get("Transport Code") then begin
                    "Transport Name" := VendTable.Name;
                end;
            end;
        }
        field(231; "Transport Name"; Text[150])
        {
            Editable = false;
            Caption = 'Tên nhà xe';
        }
        field(240; "Original Doc. Receipt Date"; Date)
        {
            Caption = 'Ngày nhận chứng từ gốc';
        }
        field(250; "Cold Running Plug Fee"; Decimal)
        {
            Caption = 'Phí cắm điện chạy lạnh';
            DecimalPlaces = 0 : 2;
        }
        field(260; "Shipping Line / Agent"; Text[50])
        {
            Caption = 'Hãng tàu / đại lý';
            Editable = false;
        }
        field(270; "Local Charge(s)"; Decimal)
        {
            Caption = 'Local Charge(s)';
            DecimalPlaces = 0 : 2;
        }
        field(280; "Cai Mep Port"; Boolean)
        {
            Caption = 'Cái Mép';
        }
        field(290; "Whse. Reason"; Text[250])
        {
            Caption = 'Lý Do (Kho)';
        }
        field(300; "Import Reason"; Enum "ACC Import Reason Type")
        {
            Caption = 'Lý Do (XNK)';
        }
        field(310; Note; Text[250])
        {
            Caption = 'Ghi chú';
        }
        field(320; "Whse. Note"; Text[250])
        {
            Caption = 'Ghi Chú (Kho)';
        }
        field(330; "Storage Fee Reason"; Text[250])
        {
            Caption = 'Lý Do Phát Sinh Phí Lưu';
        }
        field(340; "Document No."; Code[20])
        {
            Editable = false;
            Caption = 'Document No.';
        }
        field(350; "P.I.C"; Code[20])
        {
            Caption = 'P.I.C';
        }
        field(360; "P.I.C Name"; Text[150])
        {
            Caption = 'P.I.C Name';
        }
        field(370; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
        }
        field(380; "Purchaser Name"; Text[150])
        {
            Caption = 'Purchaser Name';
        }

        field(390; "Service Unit"; Code[30])
        {
            Caption = 'Service Unit';
        }
        field(400; "Service Name"; Text[250])
        {
            Caption = 'Service Name';
        }
        field(410; "Branch Code"; Code[20])
        {
            Editable = false;
            Caption = 'Branch Code';
        }
        field(420; "Item Group"; Code[20])
        {
            Caption = 'Item Group';
        }
        field(430; "Posted Warehouse Receipt"; Code[20])
        {
            CalcFormula = lookup("Posted Whse. Receipt Line"."No." where("Source No." = field("Source Document No."),
                                                                         "Source Line No." = field("Source Line No."),
                                                                         //"Location Code" = field("Actual Location Code"),
                                                                         "Source Document" = filter("Warehouse Activity Source Document"::"Purchase Order")));
            Caption = 'Posted Warehouse Receipt';
            FieldClass = FlowField;
        }
        field(440; "Receipt Date"; Date)
        {
            CalcFormula = lookup("Posted Whse. Receipt Line"."Posting Date" where("Source No." = field("Source Document No."),
                                                                                  "Source Line No." = field("Source Line No."),
                                                                                  //"Location Code" = field("Actual Location Code"),
                                                                                  "Source Document" = filter("Warehouse Activity Source Document"::"Purchase Order")));
            Caption = 'Receipt Date';
            FieldClass = FlowField;
        }
        field(450; "Posted Purchase Receipt"; Code[20])
        {
            CalcFormula = lookup("Posted Whse. Receipt Line"."Posted Source No." where("Source No." = field("Source Document No."),
                                                                                            "Source Line No." = field("Source Line No."),
                                                                                            //"Location Code" = field("Actual Location Code"),
                                                                                            "Source Document" = filter("Warehouse Activity Source Document"::"Purchase Order")));
            Caption = 'Posted Purchase Receipt';
            FieldClass = FlowField;
        }
        field(490; "Warehouse Receipt"; Code[20])
        {
            CalcFormula = lookup("Warehouse Receipt Line"."No." where("Source No." = field("Source Document No."),
                                                                      "Source Line No." = field("Source Line No."),
                                                                      //"Location Code" = field("Actual Location Code"),
                                                                      "Source Document" = filter("Warehouse Activity Source Document"::"Purchase Order")));
            Caption = 'Warehouse Receipt';
            FieldClass = FlowField;
        }
        field(500; "Entry Point"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Entry Point" where("No." = field("Source Document No.")));
            Caption = 'Entry Point';
            FieldClass = FlowField;
        }
        field(510; "Transport Method"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Transport Method" where("No." = field("Source Document No.")));
            Caption = 'Transport Method';
            FieldClass = FlowField;
        }
        field(520; "BUS GROUP"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."VAT Bus. Posting Group" where("No." = field("Source Document No.")));
            Caption = 'BUS GROUP';
            FieldClass = FlowField;
        }

        field(530; "P.I.C New"; Code[20])
        {
            Caption = 'P.I.C';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."BLTEC Person In Charge" where("BLTEC Customs Declaration No." = field("Declaration No.")));
        }
        field(540; "P.I.C Name New"; Text[150])
        {
            Caption = 'P.I.C Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("P.I.C New")));
        }
        field(550; "Purchaser Code New"; Code[20])
        {
            Caption = 'Purchaser Code';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."Purchaser Code" where("BLTEC Customs Declaration No." = field("Declaration No.")));
        }
        field(560; "Purchaser Name New"; Text[150])
        {
            Caption = 'Purchaser Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Purchaser Code New")));
        }

        field(570; "Service Unit New"; Code[30])
        {
            Caption = 'Service Unit';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."BLTEC Service Unit Code" where("BLTEC Customs Declaration No." = field("Declaration No.")));
        }
        field(580; "Service Name New"; Text[250])
        {
            Caption = 'Service Name';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Service Unit"."BLTEC Description" where("BLTEC Code" = field("Service Unit New")));
        }
        field(590; "Item Group New"; Code[20])
        {
            Caption = 'Item Group';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Item Group" where("No." = field("Item Number")));
        }
        field(600; "Whse. Rcpt. Location"; Code[20])
        {
            CalcFormula = lookup("Warehouse Receipt Line"."Location Code" where("Source No." = field("Source Document No."),
                                                                                "Source Line No." = field("Source Line No."),
                                                                                "Source Document" = filter("Warehouse Activity Source Document"::"Purchase Order")));
            Caption = 'Whse. Rcpt. Location';
            FieldClass = FlowField;
        }
        field(610; "Posted Whse. Rcpt. Quatity"; Decimal)
        {
            CalcFormula = sum("Posted Whse. Receipt Line"."Qty. (Base)" where("Source No." = field("Source Document No."),
                                                                              "Source Line No." = field("Source Line No."),
                                                                              "Location Code" = field("Actual Location Code"),
                                                                              //"Posting Date" = filter(StrSubstNo('..%1',"Delivery Date")),
                                                                              "Source Document" = filter("Warehouse Activity Source Document"::"Purchase Order")));
            Caption = 'Posted Whse. Rcpt. Quatity';
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
        }
        field(620; "Customs Office"; Text[50])
        {
            CalcFormula = lookup("BLTEC Customs Declaration"."BLTEC Customs Office" where("BLTEC Customs Declaration No." = field("Declaration No.")));
            Caption = 'Customs Office';
            FieldClass = FlowField;
        }
        field(630; "C/O Origin Criteria"; Text[50])
        {
            CalcFormula = lookup("BLTEC Customs Decl. Line"."BLTEC C/O Origin Criteria" where("Source Document No." = field("Source Document No."),
                                                                                              "Source Document Line No." = field("Source Line No.")));
            Caption = 'C/O Origin Criteria';
            FieldClass = FlowField;
        }
        field(640; "Form C/O Num"; Code[100])
        {
            CalcFormula = lookup("BLTEC Customs Decl. Line"."BLTEC C/O No." where("Source Document No." = field("Source Document No."),
                                                                                  "Source Document Line No." = field("Source Line No.")));
            Caption = 'Form C/O Num';
            FieldClass = FlowField;
        }
        field(641; "Form C/O Type"; Code[20])
        {
            CalcFormula = lookup("BLTEC Customs Decl. Line"."BLTEC C/O Type" where("Source Document No." = field("Source Document No."),
                                                                                   "Source Document Line No." = field("Source Line No.")));
            Caption = 'Form C/O Type';
            FieldClass = FlowField;
        }
        field(642; "Form C/O Date"; Date)
        {
            CalcFormula = lookup("BLTEC Customs Decl. Line"."BLTEC C/O Date" where("Source Document No." = field("Source Document No."),
                                                                                   "Source Document Line No." = field("Source Line No.")));
            Caption = 'Form C/O Date';
            FieldClass = FlowField;
        }
        field(650; "Country/Region Code"; Code[10])
        {
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("Item Number")));
            Caption = 'Xuất xứ';
            FieldClass = FlowField;
        }
        field(660; "Purchase Status"; Enum "Purchase Document Status")
        {
            CalcFormula = lookup("Purchase Header".Status where("No." = field("Source Document No.")));
            Caption = 'Purchase Status';
            FieldClass = FlowField;
        }
        field(670; "Purchase Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Editable = false;
            Caption = 'Số lượng';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line".Quantity where("Document No." = field("Source Document No."),
                                                                "Line No." = field("Source Line No.")));
        }
        field(680; "Purchase Location Code"; Code[20])
        {
            Caption = 'Kho nhập';
            //TableRelation = Location.Code;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Location Code" where("Document No." = field("Source Document No."),
                                                                       "Line No." = field("Source Line No.")));
        }
        field(690; "Purchase Item Number"; Code[20])
        {
            //Editable = false;
            Caption = 'Item Number';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."No." where("Document No." = field("Source Document No."),
                                                                       "Line No." = field("Source Line No.")));
        }
        field(700; "Purchase Item Name"; Text[250])
        {
            //Editable = false;
            Caption = 'Item Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line".Description where("Document No." = field("Source Document No."),
                                                                       "Line No." = field("Source Line No.")));
        }

        field(710; "KTCN Reason"; Text[250])
        {
            //Editable = false;
            Caption = 'Giải Trình KTCN';
        }

        field(720; "Get Sample"; Boolean)
        {
            //Editable = false;
            Caption = 'Lấy mẫu';
        }
        field(730; "Process Status"; enum "BLTEC Import Process Status")
        {
            Caption = 'Process Status';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Import Entry"."Process Status" where("Purchase Order No." = field("Source Document No."),
                                                                             "Line No." = field("Source Line No.")));
        }
        field(740; "C/O Type"; Code[20])
        {
            Caption = 'C/O Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLTEC C/O Type" where("No." = field("Item Number")));
        }
        field(750; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Outstanding Quantity" where("Document No." = field("Source Document No."),
                                                                              "Line No." = field("Source Line No.")));
        }
        field(760; "HS Code"; Text[30])
        {
            Caption = 'HS Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLTEC HS Code" where("No." = field("Item Number")));
        }
        field(770; "Customs Document No."; Code[20])
        {
            Caption = 'Customs Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."Document No." where("BLTEC Customs Declaration No." = field("Declaration No.")));
        }
        field(780; "Fee"; Decimal)
        {
            Caption = 'Fee';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration Fees".Amount where("Document No." = field("Customs Document No."),
                                                                               "Item Charge No." = filter('FEE')));
        }
        field(790; "Shipping Line Agent"; Code[20])
        {
            Caption = 'Shipping Line / Agent';
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration Fees"."Shipping Agent Fee" where("Document No." = field("Customs Document No."),
                                                                                             "Item Charge No." = filter('FEE')));
        }
        field(800; "Contract No."; Text[30])
        {
            Caption = 'Contract No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."BLTEC Contract No." where("No." = field("Source Document No.")));
        }
        field(810; "Medical Checkup"; Boolean)
        {
            Caption = 'Medical Checkup';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Medical Checkup Rq" where("No." = field("Item Number")));
        }
        field(820; "Plant Quarantine"; Boolean)
        {
            Caption = 'Plant Quarantine';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Plant Quarantine Rq" where("No." = field("Item Number")));
        }
        field(830; "Plant Quarantine (BNNPTNT)"; Boolean)
        {
            Caption = 'Plant Quarantine (BNNPTNT)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Plant Quar. (BNNPTNT) Rq" where("No." = field("Item Number")));
        }
        field(840; "Animal Quarantine"; Boolean)
        {
            Caption = 'Animal Quarantine';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Animal Quarantine Rq" where("No." = field("Item Number")));
        }
        field(850; "Animal Quarantine (BNNPTNT)"; Boolean)
        {
            Caption = 'Animal Quarantine';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."BLACC Ani. Quar. (BNNPTNT) Rq" where("No." = field("Item Number")));
        }
        field(860; "Release Of Goods"; Date)
        {
            Caption = 'Release Of Goods';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("BLTEC Customs Declaration"."Release of Goods" where("BLTEC Customs Declaration No." = field("Declaration No.")));
        }
    }
    keys
    {
        key(PK; "Source Document No.", "Source Line No.", "Line No.")
        {
            Clustered = true;
        }

        key(FK01; "Source Document No.", "Source Line No.")
        {
            SumIndexFields = "Actual Received Quantity", "Local Charge(s)";
        }
    }
}
