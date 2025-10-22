import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color navy = const Color(0xFF0C2340);
  final Color tabGrey = const Color(0xFFF0F0F0);
  final Color green = const Color(0xFF23AF53);
  final Color cardBg = const Color(0xFFF8F6F3);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: Padding(
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
                  onPressed: () {},
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
                color: tabGrey,
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
                  ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) => OrderHistoryCard(
                      navy: navy,
                      green: green,
                      cardBg: cardBg,
                    ),
                  ),

                  /// ❌ Cancelled Orders
                  Center(
                    child: Text(
                      "No cancelled orders.",
                      style: TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 📦 Order History Card
class OrderHistoryCard extends StatelessWidget {
  final Color navy;
  final Color green;
  final Color cardBg;
  const OrderHistoryCard({
    required this.navy,
    required this.green,
    required this.cardBg,
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Arham Traders',
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
                  color: green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
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
                '03:45 PM',
                style: TextStyle(fontSize: 13, color: navy),
              ),
              const SizedBox(width: 10),
              Icon(Icons.calendar_month, color: navy, size: 16),
              const SizedBox(width: 4),
              Text(
                '08-Oct-2025',
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
                  text: 'Romail Ahmed',
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
          Text(
            'Special Instructions:',
            style: TextStyle(
              fontSize: 13,
              color: navy,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Please deliver after 2 PM. Handle cylinders carefully.',
            style: TextStyle(fontSize: 12, color: navy),
          ),
          const SizedBox(height: 8),

          /// 🎯 Requested Items
          Text(
            'Requested Items',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: navy,
              fontSize: 13,
            ),
          ),
          Row(
            children: [
              ItemTag(label: '45.4 KG (13)', navy: navy),
              const SizedBox(width: 7),
              ItemTag(label: '15 KG (5)', navy: navy),
            ],
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
                  text: '225 KG',
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
