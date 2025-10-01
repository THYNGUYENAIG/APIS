enum 51003 "ACC Customs Payment State"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; "None") { Caption = 'Chưa đóng thuế'; }
    value(1; "Partial") { Caption = 'Trả thuế một phần'; } // Tổng thuế > 50000
    value(2; "Paymore") { Caption = 'Trả thuế hơn'; } // Tổng thuế < - 50000
    value(3; "Ledger") { Caption = 'Không đối chứng'; } // Tổng thuế # 0
    value(4; "Payoff") { Caption = 'Thuế trả xong'; } // Tổng thuế = 0
    value(5; "Adjust") { Caption = 'Điều chỉnh'; } // -50000 <= Tổng thuế <= 50000
}
