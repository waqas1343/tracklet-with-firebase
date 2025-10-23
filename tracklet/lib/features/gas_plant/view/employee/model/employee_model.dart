// SECTION: Model - Employee
class EmployeeModel {
  final String id;
  final String name;
  final String designation;
  bool? isPresent;
  String status;
  DateTime? lateTime;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.designation,
    this.isPresent,
    String? status,
    this.lateTime,
  }) : status = status ?? (isPresent == true ? 'present' : isPresent == false ? 'absent' : 'unmarked');

  void setPresent() {
    isPresent = true;
    status = 'present';
    lateTime = null;
  }

  void setAbsent() {
    isPresent = false;
    status = 'absent';
    lateTime = null;
  }

  bool get isAttendanceMarked => isPresent != null;

  void setLate(DateTime time) {
    isPresent = false;
    status = 'late';
    lateTime = time;
  }
}
