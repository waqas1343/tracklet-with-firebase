import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/plant_summary_card.dart';
import '../widgets/completed_order_card.dart';
import '../widgets/new_order_card.dart';

class GasPlantDashboardScreen extends StatefulWidget {
  const GasPlantDashboardScreen({super.key});

  @override
  State<GasPlantDashboardScreen> createState() => _GasPlantDashboardScreenState();
}

class _GasPlantDashboardScreenState extends State<GasPlantDashboardScreen> {
  bool _initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlantSummarySection(context),
              const SizedBox(height: 14),
              _buildNewOrdersSection(context),
              const SizedBox(height: 24),
              _buildPreviousOrdersSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Plant Summary',
          onSeeAllPressed: () {
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PlantSummaryCard(
                title: 'Total',
                subtitle: "card",
                value: '12.5 Tons',
                icon: Icons.local_drink,
                backgroundColor: const Color(0xFF1A2B4C),
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.pushNamed(context, '/gas-plant/total-stock');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PlantSummaryCard(
                title: 'Active',
                subtitle: "Employees",   
                value: '20',
                icon: Icons.person,
                iconColor: const Color(0xFF1A2B4C),
                onTap: () {
                  Navigator.pushNamed(context, '/gas-plant/active-employees');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PlantSummaryCard(
                title: 'Orders',  
                subtitle: "in progress",

                value: '07',
                icon: Icons.shopping_cart,
                iconColor: const Color(0xFF1A2B4C),
                onTap: () {
                  Navigator.pushNamed(context, '/gas-plant/orders-in-progress');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewOrdersSection(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'New Orders',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, '/gas-plant/new-orders');
          },
        ),
        const SizedBox(height: 16),
        if (user == null)
          const Center(child: Text('User not logged in'))
        else if (orderProvider.isLoading && !_initialLoadCompleted)
          // Show loading state only during initial load
          _buildLoadingState()
        else if (orderProvider.newOrders.isEmpty)
          // Show empty state when no orders exist
          Center(
            child: EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              message: 'No orders yet',
              actionText: 'New orders are coming',
            ),
          )
        else ...[
          // Debug information
          if (kDebugMode) ...[
            Builder(
              builder: (context) {
                print('Dashboard - New orders count: ${orderProvider.newOrders.length}');
                for (var order in orderProvider.newOrders) {
                  print('New Order ID: ${order.id}, Status: ${order.statusText} (${order.status}), Plant ID: ${order.plantId}');
                }
                return const SizedBox.shrink();
              }
            )
          ],
          ...orderProvider.newOrders.take(3).map((order) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: NewOrderCard(
              companyName: order.distributorName,
              description: '${order.distributorName} placed a request for mentioned cylinders',
              time: _formatTime(order.createdAt),
              date: _formatDate(order.createdAt),
              specialInstructions: order.specialInstructions ?? '',
              requestedItems: order.formattedQuantities,
              totalWeight: '${order.totalKg.toInt()} KG',
              customerImage: 'assets/images/customer.png',
              onApprovePressed: () {
                // Update the order status to inProgress and send notification for driver assignment
                if (kDebugMode) {
                  print('=== Approving Order ===');
                  print('Order ID: ${order.id}');
                  print('Current status: ${order.statusText} (${order.status})');
                  print('Updating to: ${OrderStatus.inProgress} (${OrderStatus.inProgress.toString().split('.').last})');
                }
                
                orderProvider.updateOrderStatus(
                  order.id, 
                  OrderStatus.inProgress, // Changed to inProgress to match user requirements
                ).then((success) {
                  if (kDebugMode) {
                    print('Order update result: $success');
                    if (success) {
                      print('✅ Order approved successfully!');
                      print('   Order ID: ${order.id}');
                      print('   New status should be: inProgress');
                    } else {
                      print('❌ Order approval failed');
                    }
                  }
                  
                  if (success) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order approved successfully! Please assign a driver.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(orderProvider.error ?? 'Failed to approve order'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }).catchError((error) {
                  if (kDebugMode) {
                    print('❌ Error approving order: $error');
                    print('   Stack trace: ${error is Error ? error.stackTrace : 'N/A'}');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error approving order: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              onCancelPressed: () {
                // Update the order status to cancelled
                orderProvider.updateOrderStatus(
                  order.id, 
                  OrderStatus.cancelled
                ).then((success) {
                  if (success) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order cancelled successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(orderProvider.error ?? 'Failed to cancel order'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              },
              onTap: () {
                // Navigate to order details if needed
              },
            ),
          ))
        ]
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please wait while we fetch your new orders',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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

  Widget _buildPreviousOrdersSection() {
    return _PreviousOrdersSection();
  }
}

class _PreviousOrdersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;
    
    // Debug information
    if (kDebugMode) {
      print('PreviousOrdersSection - User ID: ${user?.id}');
      print('PreviousOrdersSection - Is loading: ${orderProvider.isLoading}');
      print('PreviousOrdersSection - Total orders: ${orderProvider.orders.length}');
      print('PreviousOrdersSection - Orders data: ${orderProvider.orders.map((o) => '${o.id}:${o.statusText}').toList()}');
    }
    
    // Trigger initial load if needed
    if (user != null &&
        !orderProvider.isLoading && 
        !orderProvider.isInitialLoadCompleted) {  // Check if initial load is completed
      if (kDebugMode) {
        print('PreviousOrdersSection - Triggering load for user: ${user.id}');
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.loadOrdersForPlant(user.id);
      });
    }
    
    // Get completed and cancelled orders
    final previousOrders = orderProvider.orders
        .where((order) => 
            order.status == OrderStatus.completed || 
            order.status == OrderStatus.cancelled)
        .toList();
    
    // Sort by updated date, newest first
    previousOrders.sort((a, b) => 
        (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));
    
    if (kDebugMode) {
      print('PreviousOrdersSection - Previous orders count: ${previousOrders.length}');
      for (var order in previousOrders) {
        print('Previous Order: ${order.id} - Status: ${order.statusText} - Updated: ${order.updatedAt ?? order.createdAt}');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Previous Orders',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, '/gas-plant/orders-history');
          },
        ),
        const SizedBox(height: 16),
        if (user == null)
          const Center(child: Text('User not logged in'))
        else if (orderProvider.isLoading && !orderProvider.isInitialLoadCompleted)
          const Center(child: CircularProgressIndicator())
        else if (previousOrders.isEmpty)
          Center(
            child: EmptyStateWidget(
              icon: Icons.history_outlined,
              message: 'No previous orders',
              actionText: 'Completed and cancelled orders will appear here',
            ),
          )
        else ...[
          // Show only the first 3 previous orders
          ...previousOrders.take(3).map((order) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CompletedOrderCard(
              companyName: order.distributorName,
              time: _PreviousOrdersSection._formatTime(order.updatedAt ?? order.createdAt),
              date: _PreviousOrdersSection._formatDate(order.updatedAt ?? order.createdAt),
              driverName: order.driverName ?? 'Not assigned',
              specialInstructions: order.specialInstructions ?? 'No special instructions',
              requestedItems: order.formattedQuantities,
              totalWeight: '${order.totalKg.toInt()} KG',
              status: order.statusText, // Pass the actual status text
              onTap: () {
                // Navigate to order details if needed
              },
            ),
          ))
        ]
      ],
    );
  }

  static String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDate(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dateTime.day}-${months[dateTime.month - 1]}-${dateTime.year}';
  }
}