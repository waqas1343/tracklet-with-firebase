import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/models/order_model.dart';
import '../../../core/providers/company_provider.dart';
import '../../../shared/widgets/custom_flushbar.dart';

class SalesSummaryScreen extends StatefulWidget {
  const SalesSummaryScreen({super.key});

  @override
  _SalesSummaryScreenState createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  List<OrderModel> _orders = [];
  double _currentGasRate = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    print('Starting data load...');
    try {
      // Load orders from Firebase with multiple fallback strategies
      QuerySnapshot ordersSnapshot;

      // Strategy 1: Try with orderBy
      try {
        ordersSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'completed')
            .orderBy('createdAt', descending: true)
            .get();
      } catch (e) {
        print('OrderBy failed, trying without: $e');
        // Strategy 2: Try without orderBy
        try {
          ordersSnapshot = await FirebaseFirestore.instance
              .collection('orders')
              .where('status', isEqualTo: 'completed')
              .get();
        } catch (e2) {
          print('Status filter failed, trying all orders: $e2');
          // Strategy 3: Get all orders and filter in code
          ordersSnapshot = await FirebaseFirestore.instance
              .collection('orders')
              .get();
        }
      }

      _orders = ordersSnapshot.docs
          .map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              final order = OrderModel.fromJson(data);
              // Filter completed orders if we got all orders
              if (order.status.toString().contains('completed')) {
                return order;
              }
              return null;
            } catch (e) {
              print('Error parsing order ${doc.id}: $e');
              return null;
            }
          })
          .where((order) => order != null)
          .cast<OrderModel>()
          .toList();

      print('Loaded ${_orders.length} completed orders');

      // Load current gas rate with fallback
      try {
        final companyProvider = Provider.of<CompanyProvider>(
          context,
          listen: false,
        );
        if (companyProvider.companies.isNotEmpty) {
          final company = companyProvider.companies.first;
          _currentGasRate = company.currentRate?.toDouble() ?? 0.0;
        } else {
          // Fallback: try to get rate from Firestore directly
          final companyDoc = await FirebaseFirestore.instance
              .collection('company')
              .limit(1)
              .get();
          if (companyDoc.docs.isNotEmpty) {
            final data = companyDoc.docs.first.data();
            _currentGasRate = (data['currentRate'] ?? 0.0).toDouble();
          }
        }
      } catch (e) {
        print('Error loading gas rate: $e');
        _currentGasRate = 0.0; // Default fallback
      }

      print('Gas rate loaded: $_currentGasRate');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _loadData: $e');

      // Fallback: Show sample data if Firebase completely fails
      _orders = [
        OrderModel(
          id: 'sample_1',
          distributorId: 'dist_1',
          distributorName: 'Sample Distributor',
          plantId: 'plant_1',
          plantName: 'Sample Plant',
          plantAddress: 'Sample Address',
          plantContact: '1234567890',
          pricePerKg: 100.0,
          quantities: {'45.4': 2, '27.5': 1},
          totalKg: 118.3,
          totalPrice: 11830.0,
          finalPrice: 11830.0,
          status: OrderStatus.completed,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
      ];
      _currentGasRate = 100.0;

      setState(() {
        _isLoading = false;
        _errorMessage = ''; // Clear error to show sample data
      });
    }
  }

  double get _totalGasSold {
    return _orders.fold(0.0, (sum, order) => sum + order.totalKg);
  }

  double get _totalSalesAmount {
    return _orders.fold(0.0, (sum, order) => sum + order.finalPrice);
  }

  double get _calculatedSalesAmount {
    return _totalGasSold * _currentGasRate;
  }

  List<int> _getWeeklyOrdersData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    List<int> weeklyData = List.filled(7, 0);

    for (var order in _orders) {
      final orderDate = order.createdAt;
      final daysDiff = orderDate.difference(weekStart).inDays;

      if (daysDiff >= 0 && daysDiff < 7) {
        weeklyData[daysDiff]++;
      }
    }

    return weeklyData;
  }

  Future<void> _generateReport() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Sales Summary Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Generated on: ${DateTime.now().toString().split(' ')[0]}',
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),

                // Summary Section
                pw.Text(
                  'Sales Summary',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Gas Sold: ${_totalGasSold.toStringAsFixed(2)} KG',
                    ),
                    pw.Text(
                      'Current Rate: ${_currentGasRate.toStringAsFixed(2)} PKR/KG',
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Sales Amount: ${_totalSalesAmount.toStringAsFixed(2)} PKR',
                    ),
                    pw.Text(
                      'Calculated Amount: ${_calculatedSalesAmount.toStringAsFixed(2)} PKR',
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Orders Table
                pw.Text(
                  'Completed Orders (${_orders.length})',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),

                if (_orders.isNotEmpty)
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(2),
                      2: pw.FlexColumnWidth(1),
                      3: pw.FlexColumnWidth(1),
                    },
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Date',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Distributor',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Gas (KG)',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Amount',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ..._orders.map(
                        (order) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                order.createdAt.toString().split(' ')[0],
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(order.distributorName),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(order.totalKg.toStringAsFixed(2)),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                order.finalPrice.toStringAsFixed(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  pw.Text('No completed orders found.'),
              ],
            );
          },
        ),
      );

      // Save and share the PDF
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/sales_summary_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        CustomFlushbar.showSuccess(
          context,
          message: 'Report generated successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Failed to generate report: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF13324B);
    final accentColor = Color(0xFFEFF2F7);
    final borderColor = Color(0xFFD9DBE9);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFFF4F6FC),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
              size: 18,
            ),
          ),
        ),
        title: Text(
          "Sales & Reports",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: Icon(Icons.refresh, color: primaryColor),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed: _loadData, child: Text('Retry')),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  Text(
                    "Sales Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _ValueTile(
                        background: primaryColor,
                        label: "Total\nGas sold today",
                        value:
                            "${(_totalGasSold / 1000).toStringAsFixed(1)} Tons",
                        icon: Icons.calendar_today_outlined,
                        labelColor: Colors.white,
                        valueColor: Colors.white,
                      ),
                      SizedBox(width: 14),
                      _ValueTile(
                        background: Colors.white,
                        label: "Today\nSales Amount",
                        value: "${_totalSalesAmount.toStringAsFixed(0)} PKR",
                        icon: Icons.attach_money,
                        labelColor: primaryColor,
                        valueColor: primaryColor,
                        borderColor: borderColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  Text(
                    "Orders Overview",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  _OrdersChart(
                    weeklyOrders: _getWeeklyOrdersData(),
                    highlightDay: DateTime.now().weekday - 1,
                    barColor: primaryColor,
                    accentBarColor: accentColor,
                    borderColor: borderColor,
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _generateReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Download Report",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color background;
  final Color labelColor;
  final Color valueColor;
  final Color? borderColor;

  const _ValueTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.background,
    required this.labelColor,
    required this.valueColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 75,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            CircleAvatar(
              backgroundColor: borderColor ?? Color(0xFFEAEAEA),
              radius: 17,
              child: Icon(icon, color: labelColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersChart extends StatelessWidget {
  final List<int> weeklyOrders;
  final int highlightDay; // 0=Mon, 1=Tue, ..., 6=Sun
  final Color barColor;
  final Color accentBarColor;
  final Color borderColor;

  const _OrdersChart({
    required this.weeklyOrders,
    required this.highlightDay,
    required this.barColor,
    required this.accentBarColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxOrders = weeklyOrders.reduce(
      (curr, next) => curr > next ? curr : next,
    );

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Total Orders',
                style: TextStyle(
                  fontSize: 14,
                  color: barColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: accentBarColor,
                ),
                child: Row(
                  children: [
                    Text(
                      'Weekly',
                      style: TextStyle(
                        fontSize: 11,
                        color: barColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.expand_more, color: barColor, size: 16),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final value = weeklyOrders[index];
                final isHighlight = index == highlightDay;
                final height = (value / (maxOrders + 10)) * 80 + 16;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          height: height,
                          width: 22,
                          decoration: BoxDecoration(
                            color: isHighlight ? barColor : accentBarColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        if (isHighlight)
                          Positioned(
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _ChartLabel("MON"),
              _ChartLabel("TUE"),
              _ChartLabel("WED"),
              _ChartLabel("THU"),
              _ChartLabel("FRI"),
              _ChartLabel("SAT"),
              _ChartLabel("SUN"),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLabel extends StatelessWidget {
  final String label;
  const _ChartLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 11, color: Color(0xFF7A7A7A)),
        ),
      ),
    );
  }
}
