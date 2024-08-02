class Expense {
  final int prNo;
  final String name;
  final String department;
  final String empPosition;
  final DateTime DOB;
  final String payset;
  final DateTime joinDate;
  final String deptCode;
  final String profileImage;
  final String mobileNo;

  Expense({
    required this.prNo,
    required this.name,
    required this.department,
    required this.empPosition,
    required this.DOB,
    required this.payset,
    required this.joinDate,
    required this.deptCode,
    required this.profileImage,
    required this.mobileNo,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    print('Expense JSON: $json'); // Debug print
    return Expense(
      prNo: json['h01_EMP_NUM'] ?? 0,
      name: json['h01_First_Name'] ?? '',
      department: json['c02_Function_Desc'] ?? '',
      empPosition: json['c12_Positioncode'] ?? '',
      DOB: json['h01_birth_date'] != null
          ? DateTime.parse(json['h01_birth_date'])
          : DateTime.now(),
      payset: json['p08_Payset_code'] ?? '',
      joinDate: json['h01_join_date'] != null
          ? DateTime.parse(json['h01_join_date'])
          : DateTime.now(),
      deptCode: json['c02_Function_Code'] ?? '',
      profileImage: json['profileImage'] ?? 'default.png',
      mobileNo:
          json['telephone'] != null && json['telephone']['mobile_no'] != null
              ? json['telephone']['mobile_no'].toString()
              : 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'h01_EMP_NUM': prNo,
      'h01_First_Name': name,
      'c02_Function_Desc': department,
      'c12_Positioncode': empPosition,
      'h01_birth_date': DOB.toIso8601String(),
      'p08_Payset_code': payset,
      'h01_join_date': joinDate.toIso8601String(),
      'c02_Function_Code': deptCode,
      'profileImage': profileImage,
      'telephone': {
        'mobile_no': mobileNo,
      },
    };
  }
}
