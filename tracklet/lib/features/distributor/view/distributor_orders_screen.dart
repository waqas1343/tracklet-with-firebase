import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Add this import for Timer
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/order_card.dart';
import '../../../shared/widgets/custom_flushbar.dart';

class DistributorOrdersScreen extends StatefulWidget {
  final String? highlightedOrderId; // Add highlighted order ID parameter

  const DistributorOrdersScreen({super.key, this.highlightedOrderId});

  @override
  State<DistributorOrdersScreen> createState() =>
      _DistributorOrdersScreenState();
}

class _DistributorOrdersScreenState extends State<DistributorOrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _initialLoadCompleted = false;
  bool _isHighlighting = false;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Start highlighting if we have a highlighted order ID
    if (widget.highlightedOrderId != null) {
      _startHighlighting();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          CustomFlushbar.showInfo(
            context,
            message: 'Order highlighted - scroll to find it',
          );
        }
      });
    }
  }
  
  void _startHighlighting() {
    setState(() {
      _isHighlighting = true;
    });

    // Stop highlighting after 1 second
    _highlightTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isHighlighting = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(OrderStatus.pending, 'Pending'),
                  _buildOrdersList(OrderStatus.inProgress, 'Active'),
                  _buildOrdersList(OrderStatus.completed, 'Completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(OrderStatus status, String statusName) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        // Load orders when screen is first displayed
        if (!orderProvider.isLoading && !_initialLoadCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadOrders(orderProvider);
          });
        }

        if (orderProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Get orders for current user
        final profileProvider = Provider.of<ProfileProvider>(
          context,
          listen: false,
        );
        final user = profileProvider.currentUser;

        if (user == null) {
          return const EmptyStateWidget(
            icon: Icons.person_off,
            message: 'User not logged in',
          );
        }

        // Filter orders by status
        final orders = orderProvider.distributorOrders
            .where((order) => order.status == status)
            .toList();

        if (orders.isEmpty) {
          return EmptyStateWidget(
            icon: _getStatusIcon(status),
            message: 'No $statusName orders found',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: order,
              onTap: () => _showOrderDetails(order),
              isHighlighted: _isHighlighting && widget.highlightedOrderId == order.id, // Pass highlight status
            );
          },
        );
      },
    );
  }

  Future<void> _loadOrders(OrderProvider orderProvider) async {
    if (_initialLoadCompleted) return;

    setState(() {
      _initialLoadCompleted = true;
    });

    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final user = profileProvider.currentUser;

      if (user != null) {
        await orderProvider.loadOrdersForDistributor(user.id);
      }
    } catch (e) {
      // Handle error
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.inProgress:
        return Icons.local_shipping;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order Details',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Order details
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: OrderCard(
                    order: order,
                    onTap: null, // Disable tap in modal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
