import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracklet/core/widgets/custom_appbar.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/models/company_model.dart';
import '../../../shared/widgets/custom_flushbar.dart';

class GasRateScreen extends StatefulWidget {
  final CompanyModel company; // Added company parameter
  const GasRateScreen({super.key, required this.company});

  @override
  State<GasRateScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<GasRateScreen> {
  final TextEditingController _addRateController = TextEditingController();

  List<Map<String, dynamic>> _rateHistory = [];
  late int _todayRate;

  @override
  void initState() {
    super.initState();
    // Initialize with company's current rate if available
    _todayRate = widget.company.currentRate ?? 0;
    // Load rate history from Firebase only if we have a valid company ID
    if (widget.company.id.isNotEmpty) {
      _loadRateHistory();
    }
  }

  @override
  void dispose() {
    _addRateController.dispose();
    super.dispose();
  }

  // Load rate history from Firebase
  void _loadRateHistory() async {
    // Don't try to load if company ID is empty
    if (widget.company.id.isEmpty) return;

    try {
      final rateHistorySnapshot = await FirebaseFirestore.instance
          .collection('company')
          .doc(widget.company.id)
          .collection('rateHistory')
          .orderBy('date', descending: true)
          .limit(10)
          .get();

      setState(() {
        _rateHistory = rateHistorySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            "date": data['date'] ?? '',
            "sales": data['sales'] ?? 0,
            "rate": data['rate'] ?? 0,
          };
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Failed to load rate history: $e',
        );
      }
    }
  }

  void _addNewRate() {
    if (_addRateController.text.isEmpty) return;
    final int? newRate = int.tryParse(_addRateController.text);
    if (newRate == null) return;

    // Save the new rate to Firestore
    _saveRateToFirestore(newRate);

    // Clear input field
    _addRateController.clear();
  }

  // Save the rate to Firestore
  void _saveRateToFirestore(int newRate) async {
    // Don't try to save if company ID is empty
    if (widget.company.id.isEmpty) {
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Cannot save rate: Invalid company information',
        );
      }
      return;
    }

    try {
      final companyProvider = Provider.of<CompanyProvider>(
        context,
        listen: false,
      );

      // Create updated company with new rate
      final updatedCompany = widget.company.copyWith(
        currentRate: newRate,
        updatedAt: DateTime.now(),
      );

      // Save company with new rate to Firestore
      final success = await companyProvider.saveCompany(updatedCompany);

      if (success) {
        // Add to rate history
        final now = DateTime.now();
        final dateString =
            '${now.day}-${_getMonthName(now.month)}-${now.year.toString().substring(2)}';

        await FirebaseFirestore.instance
            .collection('company')
            .doc(widget.company.id)
            .collection('rateHistory')
            .add({
              'date': dateString,
              'sales': 0,
              'rate': newRate,
              'timestamp': now,
            });

        // Update local state
        setState(() {
          _todayRate = newRate;
          // Add new entry to rate history
          _rateHistory.insert(0, {
            "date": dateString,
            "sales": 0,
            "rate": newRate,
          });
          // Keep only the latest 10 entries
          if (_rateHistory.length > 10) {
            _rateHistory = _rateHistory.take(10).toList();
          }
        });

        if (mounted) {
          CustomFlushbar.showSuccess(
            context,
            message: 'Rate updated successfully to $newRate PKR/KG',
          );
        }
      } else {
        if (mounted) {
          CustomFlushbar.showError(context, message: 'Failed to update rate');
        }
      }
    } catch (e) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Failed to update rate: $e');
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final Color navy = Color(0xFF0C2340);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Today Rate display
            Text(
              _todayRate > 0 ? "$_todayRate PKR" : "No rate set",
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.company.id.isNotEmpty
                    ? () => _showAddRateDialog(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: widget.company.id.isNotEmpty
                      ? navy
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text("Add Rate"),
              ),
            ),
            SizedBox(height: 20),
            // Rate History label and filters (static UI)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Rate history:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: navy,
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _SearchField(hintText: "Search Date")),
                SizedBox(width: 12),
                _DropdownFilterButton(title: "Month"),
                SizedBox(width: 12),
                _DropdownFilterButton(title: "Rates"),
              ],
            ),
            SizedBox(height: 18),
            // Table headers
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Total Sales (KG)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Rate per KG",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Rate history list
            Expanded(
              child: _rateHistory.isEmpty
                  ? Center(
                      child: Text(
                        widget.company.id.isNotEmpty
                            ? 'No rate history available'
                            : 'Please navigate here from Manage Plant screen',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _rateHistory.length,
                      itemBuilder: (context, index) {
                        final item = _rateHistory[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item['date'],
                                  style: TextStyle(color: navy, fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${item['sales']} KG",
                                  style: TextStyle(color: navy, fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: navy,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    item['rate'].toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to enter new rate
  void _showAddRateDialog(BuildContext context) {
    // Don't show dialog if company ID is empty
    if (widget.company.id.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Rate"),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: _addRateController,
          decoration: InputDecoration(
            hintText: "Enter new rate",
            prefixIcon: Icon(Icons.attach_money),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addRateController.clear();
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _addNewRate();
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hintText;
  const _SearchField({required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    final Color navy = Color(0xFF0C2340);
    return TextField(
      style: TextStyle(color: navy),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black26),
        suffixIcon: Icon(Icons.search, color: navy, size: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: navy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: navy),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: navy, width: 2),
        ),
      ),
    );
  }
}

class _DropdownFilterButton extends StatelessWidget {
  final String title;
  const _DropdownFilterButton({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final Color navy = Color(0xFF0C2340);
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navy),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: navy, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 5),
          Icon(Icons.arrow_drop_down, color: navy, size: 24),
        ],
      ),
    );
  }
}
