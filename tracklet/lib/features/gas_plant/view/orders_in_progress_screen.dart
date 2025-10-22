import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'dart:async';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class OrdersInProgressScreen extends StatelessWidget {
  const OrdersInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    // Debug information
    if (kDebugMode) {
      print('OrdersInProgressScreen - User ID: ${user?.id}');
      print('OrdersInProgressScreen - User name: ${user?.name}');
    }

    // Common color palette
    final Color navy = Color(0xFF0C2340);
    final Color yellow = Color(0xFFFCE8BE);
    final Color lightCard = Color(0xFFF8F6F3);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: navy),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Orders in progress',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: user == null
          ? Center(child: Text('User not logged in'))
          : _OrdersInProgressContent(
              orderProvider: orderProvider,
              user: user,
              navy: navy,
              yellow: yellow,
              lightCard: lightCard,
            ),
    );
  }
}

class _OrdersInProgressContent extends StatefulWidget {
  final OrderProvider orderProvider;
  final dynamic user;
  final Color navy;
  final Color yellow;
  final Color lightCard;

  const _OrdersInProgressContent({
    required this.orderProvider,
    required this.user,
    required this.navy,
    required this.yellow,
    required this.lightCard,
  });

  @override
  _OrdersInProgressContentState createState() => _OrdersInProgressContentState();
}

class _OrdersInProgressContentState extends State<_OrdersInProgressContent> {
  late Stream<List<OrderModel>> _ordersStream;
  bool _streamInitialized = false;
  bool _timeoutOccurred = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    if (kDebugMode) {
      print('🔄 Initializing orders stream for user: ${widget.user.id}');
    }
    
    _ordersStream = widget.orderProvider.getOrdersStreamForPlant(widget.user.id);
    _streamInitialized = true;
    
    // Set a timeout to detect if stream is not emitting
    _timeoutTimer = Timer(Duration(seconds: 10), () {
      // Use mounted check to ensure widget is still active
      if (mounted) {
        setState(() {
          _timeoutOccurred = true;
        });
        if (kDebugMode) {
          print('⏰ Stream timeout - no data received within 10 seconds');
        }
      }
    });
  }

  @override
  void dispose() {
    // Cancel timer without accessing context
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_streamInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<OrderModel>>(
      stream: _ordersStream,
      builder: (context, snapshot) {
        // Cancel timeout if we receive any data or error
        if (snapshot.connectionState != ConnectionState.waiting || snapshot.hasData || snapshot.hasError) {
          _timeoutTimer?.cancel();
        }
        
        if (kDebugMode) {
          print('=== StreamBuilder Debug Info ===');
          print('User ID: ${widget.user.id}');
          print('StreamBuilder connection state: ${snapshot.connectionState}');
          print('StreamBuilder has error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            print('StreamBuilder error: ${snapshot.error}');
            print('StreamBuilder stack trace: ${snapshot.stackTrace}');
          }
          print('StreamBuilder has data: ${snapshot.hasData}');
          if (snapshot.hasData) {
            print('StreamBuilder data length: ${snapshot.data?.length}');
          }
          print('Timeout occurred: $_timeoutOccurred');
          print('===============================');
        }
        
        // Handle timeout case
        if (_timeoutOccurred && snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'Taking too long to load orders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The connection might be slow or there might be an issue with the data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Try to reload the orders
                    if (mounted) {
                      setState(() {
                        _timeoutOccurred = false;
                        _initializeStream();
                      });
                    }
                  },
                  child: Text('Retry Loading'),
                ),
              ],
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error loading orders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Try to reload the orders
                    if (mounted) {
                      setState(() {
                        _initializeStream();
                      });
                    }
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Handle different connection states with more detailed messages
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading orders...'),
              ],
            ),
          );
        }
        
        if (snapshot.connectionState == ConnectionState.active && !snapshot.hasData) {
          // Stream is active but hasn't emitted data yet
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Waiting for orders data...'),
              ],
            ),
          );
        }

        final allOrders = snapshot.data ?? [];
        
        // Debug information
        if (kDebugMode) {
          print('=== Orders Processing Debug ===');
          print('Total orders loaded: ${allOrders.length}');
          for (var i = 0; i < allOrders.length; i++) {
            var order = allOrders[i];
            print('Order #$i:');
            print('  ID: ${order.id}');
            print('  Status Text: ${order.statusText}');
            print('  Status Enum: ${order.status}');
            print('  Status Runtime Type: ${order.status.runtimeType}');
            print('  Plant ID: ${order.plantId}');
            print('  Status comparison (order.status == OrderStatus.inProgress): ${order.status == OrderStatus.inProgress}');
          }
          
          // Test the status enum values
          print('OrderStatus.inProgress value: ${OrderStatus.inProgress}');
          print('OrderStatus.inProgress runtime type: ${OrderStatus.inProgress.runtimeType}');
          print('===============================');
        }
        
        final inProgressOrders = allOrders
            .where((order) => order.status == OrderStatus.inProgress)
            .toList();
        
        if (kDebugMode) {
          print('=== Filtered Results ===');
          print('Filtered in progress orders: ${inProgressOrders.length}');
          for (var i = 0; i < inProgressOrders.length; i++) {
            var order = inProgressOrders[i];
            print('InProgress Order #$i: ${order.id}');
          }
          print('========================');
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RefreshIndicator(
            onRefresh: () async {
              // This won't actually refresh the stream, but we can add a manual refresh
              if (mounted) {
                setState(() {
                  _initializeStream();
                });
              }
            },
            child: ListView(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Active Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: widget.navy,
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: widget.navy,
                      child: Text(
                        '${inProgressOrders.length}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Display actual orders instead of dummy data
                if (inProgressOrders.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No orders in progress',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Approved orders will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Try to reload the orders
                            if (mounted) {
                              setState(() {
                                _initializeStream();
                              });
                            }
                          },
                          child: Text('Refresh Orders'),
                        ),
                      ],
                    ),
                  )
                else
                  ...inProgressOrders.map((order) => OrderCard(
                        order: order,
                        navy: widget.navy,
                        yellow: widget.yellow,
                        lightCard: widget.lightCard,
                      ))
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Color navy;
  final Color yellow;
  final Color lightCard;
  
  const OrderCard({
    required this.order,
    required this.navy,
    required this.yellow,
    required this.lightCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Title and Status
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.statusText,
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Time/date row
          Row(
            children: [
              Icon(Icons.access_time_filled, color: navy, size: 16),
              SizedBox(width: 4),
              Text(
                _formatTime(order.updatedAt ?? order.createdAt),
                style: TextStyle(fontSize: 13, color: navy),
              ),
              SizedBox(width: 10),
              Icon(Icons.calendar_month, color: navy, size: 16),
              SizedBox(width: 4),
              Text(
                _formatDate(order.updatedAt ?? order.createdAt),
                style: TextStyle(fontSize: 13, color: navy),
              ),
            ],
          ),
          SizedBox(height: 7),
          // Driver section - Show driver name when assigned
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Driver Name: ',
                  style: TextStyle(fontSize: 14, color: navy, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: order.driverName != null && order.driverName!.isNotEmpty
                      ? order.driverName!
                      : 'Not yet assigned by distributor',
                  style: TextStyle(
                    fontSize: 14,
                    color: order.driverName != null && order.driverName!.isNotEmpty
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty) ...[
            Text(
              'Special Instructions:',
              style: TextStyle(fontSize: 13, color: navy, fontWeight: FontWeight.w500),
            ),
            Text(
              order.specialInstructions!,
              style: TextStyle(fontSize: 12, color: navy),
            ),
            SizedBox(height: 8),
          ],
          // Requested items row
          Text(
            'Requested Items',
            style: TextStyle(fontWeight: FontWeight.w500, color: navy, fontSize: 13),
          ),
          Wrap(
            spacing: 7,
            children: order.formattedQuantities.map((item) => ItemTag(label: item, navy: navy)).toList(),
          ),
          SizedBox(height: 5),
          // Total KG
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Total Kg: ',
                  style: TextStyle(fontSize: 15, color: navy, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: '${order.totalKg.toInt()} KG',
                  style: TextStyle(fontSize: 15, color: navy, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Assign Driver Button - Only show if no driver is assigned yet
          if (order.driverName == null || order.driverName!.isEmpty) ...[
            SizedBox(height: 8),
            CustomButton(
              text: 'Assign Driver',
              onPressed: () => _showDriverAssignmentDialog(context, order),
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
              height: 40,
              borderRadius: 8,
            ),
            SizedBox(height: 8),
          ],
          // Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Cancel order functionality
                    _showCancelDialog(context, order);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: navy, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Mark order as completed
                    _markOrderCompleted(context, order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Order Completed',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDriverAssignmentDialog(BuildContext context, OrderModel order) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final TextEditingController driverController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assign Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the name of the driver for this order:'),
              SizedBox(height: 16),
              TextField(
                controller: driverController,
                decoration: InputDecoration(
                  hintText: 'Driver Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (driverController.text.trim().isNotEmpty) {
                  // Get the ScaffoldMessenger before closing the dialog
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context); // Close dialog first
                  
                  final success = await orderProvider.updateOrderStatus(
                    order.id,
                    OrderStatus.inProgress,
                    driverName: driverController.text.trim(),
                  );
                  
                  // Show snackbar after dialog is closed
                  if (context.mounted) {
                    if (success) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Driver assigned successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Failed to assign driver'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, OrderModel order) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Text('Are you sure you want to cancel this order from ${order.distributorName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Get the ScaffoldMessenger before closing the dialog
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context); // Close dialog first
                
                final success = await orderProvider.updateOrderStatus(
                  order.id,
                  OrderStatus.cancelled,
                );
                
                // Show snackbar after dialog is closed
                if (context.mounted) {
                  if (success) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Order cancelled successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Failed to cancel order'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _markOrderCompleted(BuildContext context, OrderModel order) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete Order'),
          content: Text('Mark this order as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Get the ScaffoldMessenger before closing the dialog
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context); // Close dialog first
                
                final success = await orderProvider.updateOrderStatus(
                  order.id,
                  OrderStatus.completed,
                );
                
                // Show snackbar after dialog is closed
                if (context.mounted) {
                  if (success) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Order marked as completed'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Failed to complete order'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class ItemTag extends StatelessWidget {
  final String label;
  final Color navy;
  const ItemTag({required this.label, required this.navy, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}