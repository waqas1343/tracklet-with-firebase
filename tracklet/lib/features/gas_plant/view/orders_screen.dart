import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  final String? highlightedOrderId; // Add this parameter

  const OrdersScreen({Key? key, this.highlightedOrderId}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _initialLoadCompleted = false;

  final Color navy = const Color(0xFF0C2340);
  final Color tabGrey = const Color(0xFFF0F0F0);
  final Color green = const Color(0xFF23AF53);
  final Color red = const Color(0xFFE53935);
  final Color cardBg = const Color(0xFFF8F6F3);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    if (widget.highlightedOrderId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order highlighted - scroll to find it'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: const [
                SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: Consumer2<OrderProvider, ProfileProvider>(
        builder: (context, orderProvider, profileProvider, _) {
          final user = profileProvider.currentUser;
          
          // Load orders only once when the screen is first displayed
          if (user != null && !_initialLoadCompleted && !orderProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              orderProvider.loadOrdersForPlant(user.id).then((_) {
                if (mounted) {
                  setState(() {
                    _initialLoadCompleted = true;
                  });
                }
              });
            });
          }
          
          final completedOrders = orderProvider.orders
              .where((order) => order.status == OrderStatus.completed)
              .toList();
          
          final cancelledOrders = orderProvider.orders
              .where((order) => order.status == OrderStatus.cancelled)
              .toList();
          
          // Sort by updated date, newest first
          completedOrders.sort((a, b) => 
              (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));
          cancelledOrders.sort((a, b) => 
              (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Orders History",
                      style: TextStyle(
                        fontSize: 20,
                        color: navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tabGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      ),
                      onPressed: () {
                      },
                      icon: Icon(Icons.file_download, size: 20, color: navy),
                      label: Text(
                        "Download Report",
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                /// ✅ TabBar (Completed / Cancelled)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: navy,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 18, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              "Completed",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _tabController.index == 0
                                    ? Colors.white
                                    : navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cancel_outlined,
                                size: 18, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              "Cancelled",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _tabController.index == 1
                                    ? Colors.white
                                    : navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// 🧾 TabBarView
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      /// ✅ Completed Orders
                      user == null
                          ? const Center(child: Text('User not logged in'))
                          : orderProvider.isLoading && !_initialLoadCompleted
                              ? const Center(child: CircularProgressIndicator())
                              : completedOrders.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                                          SizedBox(height: 16),
                                          Text(
                                            'No completed orders',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Completed orders will appear here',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: completedOrders.length,
                                      itemBuilder: (context, index) => OrderHistoryCard(
                                        order: completedOrders[index],
                                        navy: navy,
                                        statusColor: green,
                                        cardBg: cardBg,
                                        isHighlighted: widget.highlightedOrderId == completedOrders[index].id, // Pass highlight status
                                      ),
                                    ),

                      /// ❌ Cancelled Orders
                      user == null
                          ? const Center(child: Text('User not logged in'))
                          : orderProvider.isLoading && !_initialLoadCompleted
                              ? const Center(child: CircularProgressIndicator())
                              : cancelledOrders.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                                          SizedBox(height: 16),
                                          Text(
                                            'No cancelled orders',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Cancelled orders will appear here',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: cancelledOrders.length,
                                      itemBuilder: (context, index) => OrderHistoryCard(
                                        order: cancelledOrders[index],
                                        navy: navy,
                                        statusColor: red,
                                        cardBg: cardBg,
                                        isHighlighted: widget.highlightedOrderId == cancelledOrders[index].id, // Pass highlight status
                                      ),
                                    ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 📦 Order History Card
class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final Color navy;
  final Color statusColor;
  final Color cardBg;
  final bool isHighlighted; // Add this parameter for highlighting
  
  const OrderHistoryCard({
    required this.order,
    required this.navy,
    required this.statusColor,
    required this.cardBg,
    this.isHighlighted = false, // Default to false
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? Colors.orange : Colors.grey.shade200,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.distributorName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: navy,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// ⏰ Time and Date
          Row(
            children: [
              Icon(Icons.access_time_filled, color: navy, size: 16),
              const SizedBox(width: 4),
              Text(
                _formatTime(order.updatedAt ?? order.createdAt),
                style: TextStyle(fontSize: 13, color: navy),
              ),
              const SizedBox(width: 10),
              Icon(Icons.calendar_month, color: navy, size: 16),
              const SizedBox(width: 4),
              Text(
                _formatDate(order.updatedAt ?? order.createdAt),
                style: TextStyle(fontSize: 13, color: navy),
              ),
            ],
          ),
          const SizedBox(height: 7),

          /// 👨‍✈️ Driver Info
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Driver Name: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: navy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: order.driverName ?? 'Not assigned',
                  style: TextStyle(
                    fontSize: 14,
                    color: navy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          /// 📋 Instructions
          if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty) ...[
            Text(
              'Special Instructions:',
              style: TextStyle(
                fontSize: 13,
                color: navy,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              order.specialInstructions!,
              style: TextStyle(fontSize: 12, color: navy),
            ),
            const SizedBox(height: 8),
          ],

          /// 🎯 Requested Items
          Text(
            'Requested Items',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: navy,
              fontSize: 13,
            ),
          ),
          Wrap(
            spacing: 7,
            children: order.formattedQuantities.map((item) => ItemTag(label: item, navy: navy)).toList(),
          ),
          const SizedBox(height: 5),

          /// ⚖️ Total Kg
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Total Kg: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: navy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '${order.totalKg.toInt()} KG',
                  style: TextStyle(
                    fontSize: 15,
                    color: navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dateTime.day}-${months[dateTime.month - 1]}-${dateTime.year}';
  }
}

/// 🏷️ Item Tag Widget
class ItemTag extends StatelessWidget {
  final String label;
  final Color navy;
  const ItemTag({
    required this.label,
    required this.navy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}