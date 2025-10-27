import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/custom_flushbar.dart';
import '../widgets/driver_order_card.dart';

class DriverOrdersScreen extends StatefulWidget {
  final String? highlightedOrderId; // Add highlighted order ID parameter

  const DriverOrdersScreen({super.key, this.highlightedOrderId});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen> {
  bool _initialLoadCompleted = false;
  bool _isHighlighting = false;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();

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
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeaderWidget(title: 'My Orders', onSeeAllPressed: () {}),
              const SizedBox(height: 16),
              Expanded(child: _buildOrdersList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        // Load orders when screen is first displayed
        if (!orderProvider.isLoading && !_initialLoadCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadDriverOrders(orderProvider);
          });
        }

        if (orderProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Get orders assigned to this driver
        final profileProvider = Provider.of<ProfileProvider>(
          context,
          listen: false,
        );
        final user = profileProvider.currentUser;

        if (user == null) {
          return const EmptyStateWidget(
            icon: Icons.person_off,
            message: 'User Not Found\nPlease log in again',
          );
        }

        final assignedOrders = orderProvider.orders
            .where((order) => order.driverName == user.name)
            .toList();

        if (assignedOrders.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.local_shipping,
            message:
                'No Assigned Orders\nYou don\'t have any assigned orders yet',
          );
        }

        return ListView.builder(
          itemCount: assignedOrders.length,
          itemBuilder: (context, index) {
            final order = assignedOrders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DriverOrderCard(
                order: order,
                onCompletePressed: null, // Drivers cannot complete orders
                onTap: () {
                  // Navigate to order details if needed
                },
                isHighlighted:
                    _isHighlighting &&
                    widget.highlightedOrderId ==
                        order.id, // Pass highlight status
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _loadDriverOrders(OrderProvider orderProvider) async {
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
        await orderProvider.loadOrdersForDriver(user.name);
      }
    } catch (e) {}
  }
}
