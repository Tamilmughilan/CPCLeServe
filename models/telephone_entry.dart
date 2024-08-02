// telephone_entry.dart
class TelephoneEntry {
  final int employeeId;
  final int prno;
  final String name;
  final String designation;
  final String department;
  final int intercomNo;
  final int ptExtn;
  final int ptDirect;
  final String residence;
  final int mobileNo;
  final String emailId;
  final DateTime modifiedDate;
  final int grade;

  TelephoneEntry({
    required this.employeeId,
    required this.prno,
    required this.name,
    required this.designation,
    required this.department,
    required this.intercomNo,
    required this.ptExtn,
    required this.ptDirect,
    required this.residence,
    required this.mobileNo,
    required this.emailId,
    required this.modifiedDate,
    required this.grade,
  });

  factory TelephoneEntry.fromJson(Map<String, dynamic> json) {
    return TelephoneEntry(
      employeeId: json['employeeId'],
      prno: json['prno'],
      name: json['name'],
      designation: json['designation'],
      department: json['department'],
      intercomNo: json['intercom_no'],
      ptExtn: json['pT_Extn'],
      ptDirect: json['pT_Direct'],
      residence: json['residence'],
      mobileNo: json['mobile_no'],
      emailId: json['email_id'],
      modifiedDate: DateTime.parse(json['modified_date']),
      grade: json['grade'],
    );
  }
}
