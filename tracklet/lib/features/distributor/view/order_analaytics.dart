import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet/core/providers/order_provider.dart';
import 'package:tracklet/core/providers/profile_provider.dart';
import 'package:tracklet/core/models/order_model.dart';

class OrderAnalyticsScreen extends StatefulWidget {
  const OrderAnalyticsScreen({super.key});

  @override
  State<OrderAnalyticsScreen> createState() => _OrderAnalyticsScreenState();
}

class _OrderAnalyticsScreenState extends State<OrderAnalyticsScreen> {
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Schedule data loading for after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    try {
      if (_isDisposed) return;

      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      if (profileProvider.currentUser != null) {
        await orderProvider.loadOrdersForDistributor(
          profileProvider.currentUser!.id,
        );
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Calculate total orders delivered today
  int _getTotalOrdersDeliveredToday(List<OrderModel> orders) {
    final today = DateTime.now();
    return orders.where((order) {
      return order.status == OrderStatus.completed &&
          order.deliveryDate != null &&
          order.deliveryDate!.day == today.day &&
          order.deliveryDate!.month == today.month &&
          order.deliveryDate!.year == today.year;
    }).length;
  }

  // Calculate total gas ordered (in tons)
  double _getTotalGasOrdered(List<OrderModel> orders) {
    double totalKg = 0;
    for (var order in orders) {
      if (order.status != OrderStatus.cancelled) {
        totalKg += order.totalKg;
      }
    }
    // Convert kg to tons (1 ton = 1000 kg)
    return totalKg / 1000;
  }

  // Get top plants data
  List<Map<String, dynamic>> _getTopPlants(List<OrderModel> orders) {
    final plantOrders = <String, int>{};

    // Count orders per plant
    for (var order in orders) {
      if (plantOrders.containsKey(order.plantName)) {
        plantOrders[order.plantName] = plantOrders[order.plantName]! + 1;
      } else {
        plantOrders[order.plantName] = 1;
      }
    }

    // Convert to list and sort by order count
    final plantList = plantOrders.entries
        .map((entry) => {'name': entry.key, 'orders': entry.value})
        .toList();

    plantList.sort(
      (a, b) => (b['orders'] as int).compareTo(a['orders'] as int),
    );

    return plantList;
  }

  // Calculate percentages for top plants
  List<Map<String, dynamic>> _getTopPlantsWithPercentages(
    List<OrderModel> orders,
  ) {
    final topPlants = _getTopPlants(orders);
    final totalOrders = orders.isNotEmpty
        ? orders.length
        : 1; // Avoid division by zero

    return topPlants.map((plant) {
      final percentage = (plant['orders'] as int) / totalOrders * 100;
      return {
        'name': plant['name'],
        'orders': plant['orders'],
        'percentage': percentage,
      };
    }).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF13324B);
    final backGray = const Color(0xFFEFF2F7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<OrderProvider, ProfileProvider>(
          builder: (context, orderProvider, profileProvider, child) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final orders = orderProvider.distributorOrders;
            final totalOrdersDeliveredToday = _getTotalOrdersDeliveredToday(
              orders,
            );
            final totalGasOrdered = _getTotalGasOrdered(orders);
            final topPlantsWithPercentages = _getTopPlantsWithPercentages(
              orders,
            );
            final totalOrdersCount = orders.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 14, right: 14),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: backGray,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Order Analytics",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Orders Summary
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    'Orders Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      // Orders Delivered Card
                      Expanded(
                        child: Container(
                          height: 78,
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Orders\nDelivered Today',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '$totalOrdersDeliveredToday',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF305575),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(7),
                                  child: const Icon(
                                    Icons.local_shipping_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Gas Ordered Card
                      Expanded(
                        child: Container(
                          height: 78,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: backGray),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Gas\nOrdered',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${totalGasOrdered.toStringAsFixed(1)} Tons',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(7),
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Top Plant Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    'Top Plant This Month',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Card and donut chart + details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: backGray),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Most Ordered',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'View Details ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: darkBlue,
                                ),
                              ),
                              Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: darkBlue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Donut chart + Center text
                          SizedBox(
                            height: 135,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: CustomPaint(
                                    painter: _DonutChartPainter(),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Orders',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$totalOrdersCount',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: darkBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Orders Table
                          Table(
                            columnWidths: {
                              0: const FlexColumnWidth(4),
                              1: const FlexColumnWidth(2),
                              2: const FlexColumnWidth(2),
                            },
                            children: [
                              const TableRow(
                                children: [
                                  SizedBox(),
                                  Center(
                                    child: Text(
                                      "Orders",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (topPlantsWithPercentages.isNotEmpty) ...[
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF13324B),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          topPlantsWithPercentages.isNotEmpty
                                              ? topPlantsWithPercentages[0]['name']
                                                    as String
                                              : "Tracklet.CO",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Text(
                                        topPlantsWithPercentages.isNotEmpty
                                            ? '${topPlantsWithPercentages[0]['orders']}'
                                            : "0",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        topPlantsWithPercentages.isNotEmpty
                                            ? '${(topPlantsWithPercentages[0]['percentage'] as double).toStringAsFixed(1)}%'
                                            : "0%",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                const TableRow(
                                  children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                if (topPlantsWithPercentages.length > 1)
                                  TableRow(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFB6D2F5),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            topPlantsWithPercentages[1]['name']
                                                as String,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Text(
                                          '${topPlantsWithPercentages[1]['orders']}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '${(topPlantsWithPercentages[1]['percentage'] as double).toStringAsFixed(1)}%',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                const TableRow(
                                  children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                if (topPlantsWithPercentages.length > 2)
                                  TableRow(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE9F1FB),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            topPlantsWithPercentages[2]['name']
                                                as String,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Text(
                                          '${topPlantsWithPercentages[2]['orders']}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '${(topPlantsWithPercentages[2]['percentage'] as double).toStringAsFixed(1)}%',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                              ] else
                                TableRow(
                                  children: [
                                    const Text(
                                      "No data available",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(),
                                    const SizedBox(),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Donut chart for top plants
class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 20.0;
    Rect rect = Offset.zero & size;

    Paint trackletPaint = Paint()
      ..color = const Color(0xFF13324B)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint blueFlamePaint = Paint()
      ..color = const Color(0xFFB6D2F5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint pureGasPaint = Paint()
      ..color = const Color(0xFFE9F1FB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startRadian = -1.55;
    double trackletSweep = 3.93; // 62.5%
    double blueSweep = 1.57; // 25%
    double pureSweep = 0.785; // 12.5%

    canvas.drawArc(rect, startRadian, trackletSweep, false, trackletPaint);
    canvas.drawArc(
      rect,
      startRadian + trackletSweep,
      blueSweep,
      false,
      blueFlamePaint,
    );
    canvas.drawArc(
      rect,
      startRadian + trackletSweep + blueSweep,
      pureSweep,
      false,
      pureGasPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
