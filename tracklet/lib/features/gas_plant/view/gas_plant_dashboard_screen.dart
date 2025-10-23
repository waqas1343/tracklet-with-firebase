import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/plant_summary_card.dart';
import '../widgets/completed_order_card.dart';
import '../widgets/new_order_card.dart';
import '../../../shared/widgets/custom_flushbar.dart';
import '../utils/gas_deduction_utils.dart';

class GasPlantDashboardScreen extends StatefulWidget {
  const GasPlantDashboardScreen({super.key});

  @override
  State<GasPlantDashboardScreen> createState() =>
      _GasPlantDashboardScreenState();
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
        SectionHeaderWidget(title: 'Plant Summary', onSeeAllPressed: () {}),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('tanks').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return PlantSummaryCard(
                      title: 'Total',
                      subtitle: "card",
                      value: '0.00 Tons',
                      icon: Icons.local_drink,
                      backgroundColor: const Color(0xFF1A2B4C),
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, '/gas-plant/total-stock');
                      },
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return PlantSummaryCard(
                      title: 'Total',
                      subtitle: "card",
                      value: '0.00 Tons',
                      icon: Icons.local_drink,
                      backgroundColor: const Color(0xFF1A2B4C),
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, '/gas-plant/total-stock');
                      },
                    );
                  }
                  
                  // Calculate total gas from all tanks and convert to tons
                  // Assuming 1 ton = 1000 liters
                  double totalGasInLiters = 0;
                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final currentGas = (data['currentGas'] ?? 0).toDouble();
                      final frozenGas = (data['frozenGas'] ?? 0).toDouble();
                      totalGasInLiters += currentGas + frozenGas;
                    }
                  }
                  
                  // Convert liters to tons
                  double totalGasInTons = totalGasInLiters / 1000;
                  
                  return PlantSummaryCard(
                    title: 'Total',
                    subtitle: "card",
                    value: '${totalGasInTons.toStringAsFixed(2)} Tons',
                    icon: Icons.local_drink,
                    backgroundColor: const Color(0xFF1A2B4C),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    onTap: () {
                      Navigator.pushNamed(context, '/gas-plant/total-stock');
                    },
                  );
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
                  Navigator.pushNamed(context, '/gas-plant/employees' );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', isEqualTo: 'inProgress')
                    .snapshots(),
                builder: (context, snapshot) {
                  int orderCount = 0;
                  if (snapshot.hasData) {
                    orderCount = snapshot.data!.docs.length;
                  }
                  
                  return PlantSummaryCard(
                    title: 'Orders',
                    subtitle: "in progress",
                    value: orderCount.toString().padLeft(2, '0'),
                    icon: Icons.shopping_cart,
                    iconColor: const Color(0xFF1A2B4C),
                    onTap: () {
                      Navigator.pushNamed(context, '/gas-plant/orders-in-progress');
                    },
                  );
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
          ...orderProvider.newOrders
              .take(3)
              .map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NewOrderCard(
                    companyName: order.distributorName,
                    description:
                        '${order.distributorName} placed a request for mentioned cylinders',
                    time: _formatTime(order.createdAt),
                    date: _formatDate(order.createdAt),
                    specialInstructions: order.specialInstructions ?? '',
                    requestedItems: order.formattedQuantities,
                    totalWeight: '${order.totalKg.toInt()} KG',
                    customerImage: 'assets/images/customer.png',
                    onApprovePressed: () {
                      // Check if we have enough gas before approving the order
                      GasDeductionUtils.hasEnoughGasForOrder(order.totalKg / 1000)
                          .then((hasEnoughGas) {
                        if (!hasEnoughGas) {
                          // Not enough gas, show error and don't approve the order
                          CustomFlushbar.showError(
                            context,
                            message: 'Not enough gas available to fulfill this order. Required: ${(order.totalKg / 1000).toStringAsFixed(2)} tons',
                          );
                          return;
                        }
                        
                        // Update the order status to inProgress and send notification for driver assignment
                        orderProvider
                            .updateOrderStatus(
                              order.id,
                              OrderStatus
                                  .inProgress, // Changed to inProgress to match user requirements
                            )
                            .then((success) {
                              if (success) {
                                // Deduct gas from tanks after successful approval
                                GasDeductionUtils.deductGasFromTanks(
                                  context: context,
                                  amountInTons: order.totalKg / 1000, // Convert kg to tons
                                  orderId: order.id,
                                ).then((deductionSuccess) {
                                  if (deductionSuccess) {
                                    // Show success message
                                    CustomFlushbar.showSuccess(
                                      context,
                                      message: 'Order approved successfully! Please assign a driver.',
                                    );
                                  } else {
                                    // Show error message about gas deduction failure
                                    CustomFlushbar.showError(
                                      context,
                                      message: 'Order approved but failed to deduct gas from tanks',
                                    );
                                  }
                                });
                              } else {
                                // Show error message
                                CustomFlushbar.showError(
                                  context,
                                  message: orderProvider.error ?? 'Failed to approve order',
                                );
                              }
                            })
                            .catchError((error) {
                              CustomFlushbar.showError(
                                context,
                                message: 'Error approving order: $error',
                              );
                            });
                      });
                    },
                    onCancelPressed: () {
                      // Update the order status to cancelled
                      orderProvider
                          .updateOrderStatus(order.id, OrderStatus.cancelled)
                          .then((success) {
                            if (success) {
                              // Show success message
                              CustomFlushbar.showSuccess(
                                context,
                                message: 'Order cancelled successfully!',
                              );
                            } else {
                              // Show error message
                              CustomFlushbar.showError(
                                context,
                                message: orderProvider.error ?? 'Failed to cancel order',
                              );
                            }
                          });
                    },
                    onTap: () {
                      // Navigate to order details if needed
                    },
                  ),
                ),
              ),
        ],
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
              style: TextStyle(fontSize: 14, color: Colors.grey),
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

    // Trigger initial load if needed
    if (user != null &&
        !orderProvider.isLoading &&
        !orderProvider.isInitialLoadCompleted) {
      // Check if initial load is completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.loadOrdersForPlant(user.id);
      });
    }

    // Get completed and cancelled orders
    final previousOrders = orderProvider.orders
        .where(
          (order) =>
              order.status == OrderStatus.completed ||
              order.status == OrderStatus.cancelled,
        )
        .toList();

    // Sort by updated date, newest first
    previousOrders.sort(
      (a, b) =>
          (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt),
    );

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
        else if (orderProvider.isLoading &&
            !orderProvider.isInitialLoadCompleted)
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
          ...previousOrders
              .take(3)
              .map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CompletedOrderCard(
                    companyName: order.distributorName,
                    time: _PreviousOrdersSection._formatTime(
                      order.updatedAt ?? order.createdAt,
                    ),
                    date: _PreviousOrdersSection._formatDate(
                      order.updatedAt ?? order.createdAt,
                    ),
                    driverName: order.driverName ?? 'Not assigned',
                    specialInstructions:
                        order.specialInstructions ?? 'No special instructions',
                    requestedItems: order.formattedQuantities,
                    totalWeight: '${order.totalKg.toInt()} KG',
                    status: order.statusText, // Pass the actual status text
                    onTap: () {
                      // Navigate to order details if needed
                    },
                  ),
                ),
              ),
        ],
      ],
    );
  }

  static String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDate(DateTime dateTime) {
    final months = [
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
    return '${dateTime.day}-${months[dateTime.month - 1]}-${dateTime.year}';
  }
}
