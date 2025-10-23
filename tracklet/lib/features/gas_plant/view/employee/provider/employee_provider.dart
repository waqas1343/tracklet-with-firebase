// SECTION: Provider Logic - Employee attendance source of truth
import 'package:flutter/material.dart';
import '../model/employee_model.dart';

enum AttendanceTab { total, present, absent }

class EmployeeProvider with ChangeNotifier {
  final List<EmployeeModel> _employees = [];

  List<EmployeeModel> get employees => _employees;

  int get totalEmployees => _employees.length;
  int get presentCount => _employees.where((e) => e.status == 'present').length;
  int get absentCount => _employees.where((e) => e.status == 'absent').length;
  int get lateCount => _employees.where((e) => e.status == 'late').length;

  // SECTION: Search State
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  void setSearchQuery(String q) {
    final nq = q.trim();
    if (_searchQuery == nq) return;
    _searchQuery = nq;
    notifyListeners();
  }

  // SECTION: Tab State
  AttendanceTab _selectedTab = AttendanceTab.present;
  AttendanceTab get selectedTab => _selectedTab;
  void setSelectedTab(AttendanceTab tab) {
    if (_selectedTab == tab) return;
    _selectedTab = tab;
    notifyListeners();
  }

  // SECTION: Derived Lists
  List<EmployeeModel> get filteredEmployees {
    Iterable<EmployeeModel> base;
    switch (_selectedTab) {
      case AttendanceTab.total:
        base = _employees;
        break;
      case AttendanceTab.present:
        base = _employees.where((e) => e.isPresent == true);
        break;
      case AttendanceTab.absent:
        base = _employees.where((e) => e.isPresent == false);
        break;
    }
    if (_searchQuery.isEmpty) return base.toList();
    final q = _searchQuery.toLowerCase();
    return base
        .where((e) => e.id.toLowerCase().contains(q) || e.name.toLowerCase().contains(q))
        .toList();
  }

  // SECTION: Attendance Mutations
  void toggleAttendance(String id, bool present) {
    final index = _employees.indexWhere((e) => e.id == id);
    if (index != -1) {
      present ? _employees[index].setPresent() : _employees[index].setAbsent();
      notifyListeners();
    }
  }

  void markLate(String id, DateTime time) {
    final index = _employees.indexWhere((e) => e.id == id);
    if (index != -1) {
      _employees[index].setLate(time);
      notifyListeners();
    }
  }

  // SECTION: UI Pressed State (optional visual feedback)
  String? _pressedSummaryKey;
  String? get pressedSummaryKey => _pressedSummaryKey;
  void setPressedSummaryKey(String? key) {
    if (_pressedSummaryKey == key) return;
    _pressedSummaryKey = key;
    notifyListeners();
  }

  // SECTION: CRUD
  void addEmployee(String name, String designation) {
    int maxNum = 0;
    for (final e in _employees) {
      final match = RegExp(r'^EMP-(\d+)$').firstMatch(e.id);
      if (match != null) {
        final n = int.tryParse(match.group(1)!) ?? 0;
        if (n > maxNum) maxNum = n;
      }
    }
    final nextId = 'EMP-${(maxNum + 1).toString().padLeft(3, '0')}';

    _employees.add(EmployeeModel(id: nextId, name: name, designation: designation));
    notifyListeners();
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void renameEmployee(String id, String newName) {
    final idx = _employees.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _employees[idx] = EmployeeModel(
        id: _employees[idx].id,
        name: newName,
        designation: _employees[idx].designation,
        isPresent: _employees[idx].isPresent,
        status: _employees[idx].status,
        lateTime: _employees[idx].lateTime,
      );
      notifyListeners();
    }
  }
}
