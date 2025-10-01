enum 51004 "ACC Import Reason Type"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; "None") { Caption = ''; }
    value(1; "Waiting for Documents") { Caption = 'Chờ chứng từ'; }
    value(2; "Waiting for Delivery") { Caption = 'Chờ điện giao hàng'; }
    value(3; "Incorrect Document") { Caption = 'Sai chứng từ chờ chỉnh sửa'; }
    value(4; "Waiting for Container") { Caption = 'Chờ cont. lên bãi'; }
    value(5; "Goods about Cai Mep") { Caption = 'Hàng về Cái Mép'; }
    value(6; "Waiting for Sample") { Caption = 'Chờ lấy mẫu'; }
    value(7; "Other (if any)") { Caption = 'Khác (nếu có)'; }
}
