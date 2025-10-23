import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_flushbar.dart';

class OrderAnalyticsScreen extends StatefulWidget {
  const OrderAnalyticsScreen({super.key});

  @override
  State<OrderAnalyticsScreen> createState() => _OrderAnalyticsScreenState();
}

class _OrderAnalyticsScreenState extends State<OrderAnalyticsScreen> {
  final Color primaryColor = const Color(0xFF0C2340);
  final Color successColor = const Color(0xFF23AF53);
  final Color errorColor = const Color(0xFFE53935);
  final Color warningColor = const Color(0xFFFF9800);
  final Color infoColor = const Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: true),
      body: Consumer2<OrderProvider, ProfileProvider>(
        builder: (context, orderProvider, profileProvider, _) {
          final user = profileProvider.currentUser;

          if (user == null) {
            return const Center(child: Text('User not logged in'));
          }

          // Load orders for distributor
          if (orderProvider.distributorOrders.isEmpty &&
              !orderProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              orderProvider.loadOrdersForDistributor(user.id);
            });
          }

          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = orderProvider.distributorOrders;
          final analytics = _calculateAnalytics(orders);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Summary Cards
                _buildSummaryCards(analytics),
                const SizedBox(height: 24),

                // Charts Section
                _buildChartsSection(analytics),
                const SizedBox(height: 24),

                // Recent Orders Table
                _buildRecentOrdersTable(orders),
                const SizedBox(height: 24),

                // Export Button
                _buildExportButton(analytics),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Analytics',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Comprehensive analysis of your order performance',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(OrderAnalytics analytics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Total Orders',
          analytics.totalOrders.toString(),
          Icons.shopping_cart,
          primaryColor,
        ),
        _buildSummaryCard(
          'Completed',
          analytics.completedOrders.toString(),
          Icons.check_circle,
          successColor,
        ),
        _buildSummaryCard(
          'Pending',
          analytics.pendingOrders.toString(),
          Icons.pending,
          warningColor,
        ),
        _buildSummaryCard(
          'Cancelled',
          analytics.cancelledOrders.toString(),
          Icons.cancel,
          errorColor,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(OrderAnalytics analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Charts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),

        // Order Status Pie Chart
        _buildPieChart(analytics),
        const SizedBox(height: 24),

        // Monthly Trends Line Chart
        _buildLineChart(analytics),
      ],
    );
  }

  Widget _buildPieChart(OrderAnalytics analytics) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Order Status Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: analytics.completedOrders.toDouble(),
                    title: 'Completed',
                    color: successColor,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: analytics.pendingOrders.toDouble(),
                    title: 'Pending',
                    color: warningColor,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: analytics.cancelledOrders.toDouble(),
                    title: 'Cancelled',
                    color: errorColor,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(OrderAnalytics analytics) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Monthly Order Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: analytics.monthlyData
                        .map(
                          (data) => FlSpot(
                            data.month.toDouble(),
                            data.orders.toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersTable(List<OrderModel> orders) {
    final recentOrders = orders.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Order ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Table Rows
              ...recentOrders.map((order) => _buildTableRow(order)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              order.id.substring(0, 8),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(order.status),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(order.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.visibility, size: 16),
              onPressed: () {
                // Navigate to order details
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(OrderAnalytics analytics) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _exportReport(analytics),
        icon: const Icon(Icons.download),
        label: const Text('Export Analytics Report'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  OrderAnalytics _calculateAnalytics(List<OrderModel> orders) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Calculate basic metrics
    final totalOrders = orders.length;
    final completedOrders = orders
        .where((o) => o.status == OrderStatus.completed)
        .length;
    final pendingOrders = orders
        .where((o) => o.status == OrderStatus.pending)
        .length;
    final cancelledOrders = orders
        .where((o) => o.status == OrderStatus.cancelled)
        .length;

    // Calculate monthly data for the last 6 months
    final monthlyData = <MonthlyData>[];
    for (int i = 5; i >= 0; i--) {
      final month = currentMonth - i;
      final year = month <= 0 ? currentYear - 1 : currentYear;
      final adjustedMonth = month <= 0 ? month + 12 : month;

      final monthOrders = orders.where((order) {
        final orderDate = order.createdAt;
        return orderDate.month == adjustedMonth && orderDate.year == year;
      }).length;

      monthlyData.add(MonthlyData(adjustedMonth, monthOrders));
    }

    return OrderAnalytics(
      totalOrders: totalOrders,
      completedOrders: completedOrders,
      pendingOrders: pendingOrders,
      cancelledOrders: cancelledOrders,
      monthlyData: monthlyData,
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return successColor;
      case OrderStatus.pending:
        return warningColor;
      case OrderStatus.cancelled:
        return errorColor;
      case OrderStatus.inProgress:
        return infoColor;
      case OrderStatus.confirmed:
        return primaryColor;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _exportReport(OrderAnalytics analytics) {
    // TODO: Implement PDF export functionality
    CustomFlushbar.showInfo(
      context,
      message: 'Analytics report export feature coming soon!',
    );
  }
}

class OrderAnalytics {
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int cancelledOrders;
  final List<MonthlyData> monthlyData;

  OrderAnalytics({
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.cancelledOrders,
    required this.monthlyData,
  });
}

class MonthlyData {
  final int month;
  final int orders;

  MonthlyData(this.month, this.orders);
}
