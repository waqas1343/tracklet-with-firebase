// SECTION: Provider Logic - Employee attendance source of truth
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../model/employee_model.dart';
import '../../../../../core/services/firebase_service.dart';

enum AttendanceTab { total, present, absent }

class EmployeeProvider with ChangeNotifier {
  final List<EmployeeModel> _employees = [];
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  bool _isLoading = false;

  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;

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
        .where(
          (e) =>
              e.id.toLowerCase().contains(q) ||
              e.name.toLowerCase().contains(q),
        )
        .toList();
  }

  // SECTION: UI Pressed State (optional visual feedback)
  String? _pressedSummaryKey;
  String? get pressedSummaryKey => _pressedSummaryKey;
  void setPressedSummaryKey(String? key) {
    if (_pressedSummaryKey == key) return;
    _pressedSummaryKey = key;
    notifyListeners();
  }

  // SECTION: Firebase Operations
  Future<void> loadEmployees() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('employees').get();
      _employees.clear();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        _employees.add(
          EmployeeModel(
            id: doc.id,
            name: data['name'] ?? '',
            designation: data['designation'] ?? '',
            isPresent: data['isPresent'],
            status: data['status'] ?? 'unmarked',
            lateTime: data['lateTime'] != null
                ? (data['lateTime'] as Timestamp).toDate()
                : null,
          ),
        );
      }
    } catch (e) {
      // print('Error loading employees: $e'); // Removed to avoid avoid_print warning
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // SECTION: CRUD
  Future<void> addEmployee(String name, String designation) async {
    try {
      int maxNum = 0;
      for (final e in _employees) {
        final match = RegExp(r'^EMP-(\d+)$').firstMatch(e.id);
        if (match != null) {
          final n = int.tryParse(match.group(1)!) ?? 0;
          if (n > maxNum) maxNum = n;
        }
      }
      final nextId = 'EMP-${(maxNum + 1).toString().padLeft(3, '0')}';

      final employee = EmployeeModel(
        id: nextId,
        name: name,
        designation: designation,
      );

      // Save to Firebase
      await _firestore.collection('employees').doc(nextId).set({
        'id': nextId,
        'name': name,
        'designation': designation,
        'isPresent': null,
        'status': 'unmarked',
        'lateTime': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _employees.add(employee);
      notifyListeners();
    } catch (e) {
      // print('Error adding employee: $e'); // Removed to avoid avoid_print warning
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      // Delete from Firebase
      await _firestore.collection('employees').doc(id).delete();

      _employees.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      // print('Error deleting employee: $e'); // Removed to avoid avoid_print warning
    }
  }

  Future<void> renameEmployee(String id, String newName) async {
    try {
      // Update in Firebase
      await _firestore.collection('employees').doc(id).update({
        'name': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

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
    } catch (e) {
      // print('Error renaming employee: $e'); // Removed to avoid avoid_print warning
    }
  }

  // SECTION: Attendance Firebase Operations
  Future<void> toggleAttendance(String id, bool present) async {
    try {
      final index = _employees.indexWhere((e) => e.id == id);
      if (index != -1) {
        present
            ? _employees[index].setPresent()
            : _employees[index].setAbsent();

        // Save attendance to Firebase
        await _firestore.collection('attendance').add({
          'employeeId': id,
          'employeeName': _employees[index].name,
          'isPresent': present,
          'status': present ? 'present' : 'absent',
          'timestamp': FieldValue.serverTimestamp(),
          'date': DateTime.now().toIso8601String().split(
            'T',
          )[0], // YYYY-MM-DD format
        });

        // Update employee status in Firebase
        await _firestore.collection('employees').doc(id).update({
          'isPresent': present,
          'status': present ? 'present' : 'absent',
          'lastAttendanceUpdate': FieldValue.serverTimestamp(),
        });

        notifyListeners();
      }
    } catch (e) {
      // print('Error updating attendance: $e'); // Removed to avoid avoid_print warning
    }
  }

  Future<void> markLate(String id, DateTime time) async {
    try {
      final index = _employees.indexWhere((e) => e.id == id);
      if (index != -1) {
        _employees[index].setLate(time);

        // Save late attendance to Firebase
        await _firestore.collection('attendance').add({
          'employeeId': id,
          'employeeName': _employees[index].name,
          'isPresent': false,
          'status': 'late',
          'lateTime': Timestamp.fromDate(time),
          'timestamp': FieldValue.serverTimestamp(),
          'date': DateTime.now().toIso8601String().split('T')[0],
        });

        // Update employee status in Firebase
        await _firestore.collection('employees').doc(id).update({
          'isPresent': false,
          'status': 'late',
          'lateTime': Timestamp.fromDate(time),
          'lastAttendanceUpdate': FieldValue.serverTimestamp(),
        });

        notifyListeners();
      }
    } catch (e) {
      // print('Error marking late: $e'); // Removed to avoid avoid_print warning
    }
  }

  // SECTION: PDF Generation
  Future<void> downloadAttendancePDF() async {
    try {
      final pdf = pw.Document();

      // Get current date
      final now = DateTime.now();
      final dateStr = '${now.day}/${now.month}/${now.year}';

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Employee Attendance Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Date: $dateStr', style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),

                // Summary
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Employees: $totalEmployees'),
                    pw.Text('Present: $presentCount'),
                    pw.Text('Absent: $absentCount'),
                    pw.Text('Late: $lateCount'),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Table header
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'ID',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Name',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Designation',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Status',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Time',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    // Employee rows
                    ..._employees.map(
                      (employee) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(employee.id),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(employee.name),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(employee.designation),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(employee.status.toUpperCase()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              employee.lateTime != null
                                  ? '${employee.lateTime!.hour}:${employee.lateTime!.minute.toString().padLeft(2, '0')}'
                                  : '-',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Save PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Attendance_Report_${now.day}_${now.month}_${now.year}.pdf',
      );
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}
