import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../repositories/notification_repository.dart';
import '../services/fcm_service.dart';
import '../services/notification_service.dart';

/// OrderViewModel - Handles order-related business logic
/// Follows MVVM pattern for separation of concerns
class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;
  final NotificationRepository _notificationRepository;
  final FCMService _fcmService = FCMService.instance;

  List<OrderModel> _orders = [];
  List<OrderModel> _newOrders = [];
  List<OrderModel> _distributorOrders = [];
  bool _isLoading = false;
  bool _isInitialLoadCompleted = false;
  String? _error;
  int _pendingOrdersCount = 0;

  OrderViewModel(this._repository)
    : _notificationRepository = NotificationRepository();

  // Getters
  List<OrderModel> get orders => _orders;
  List<OrderModel> get newOrders => _newOrders;
  List<OrderModel> get distributorOrders => _distributorOrders;
  bool get isLoading => _isLoading;
  bool get isInitialLoadCompleted => _isInitialLoadCompleted;
  String? get error => _error;
  int get pendingOrdersCount => _pendingOrdersCount;
  bool get hasOrders => _orders.isNotEmpty;

  // Additional getters for specific order types
  List<OrderModel> get pendingOrders =>
      _orders.where((order) => order.status == OrderStatus.pending).toList();

  List<OrderModel> get processingOrders =>
      _orders.where((order) => order.status == OrderStatus.inProgress).toList();

  List<OrderModel> get confirmedOrders =>
      _orders.where((order) => order.status == OrderStatus.confirmed).toList();

  List<OrderModel> get completedOrders =>
      _orders.where((order) => order.status == OrderStatus.completed).toList();

  List<OrderModel> get cancelledOrders =>
      _orders.where((order) => order.status == OrderStatus.cancelled).toList();

  /// Create a new order
  Future<bool> createOrder(OrderModel order) async {
    try {
      _setLoading(true);
      _clearError();

      // Removed kDebugMode print statements

      final orderId = await _repository.createOrder(order);
      if (orderId.isNotEmpty) {
        // Removed kDebugMode print statement

        // Create notification for gas plant
        await _notificationRepository.createOrderNotification(
          plantId: order.plantId,
          distributorName: order.distributorName,
          orderId: orderId,
        );

        // Removed kDebugMode print statement

        // Send push notification
        try {
          await _fcmService.sendNotificationToUser(
            userId: order.plantId,
            title: 'New Order Request',
            body:
                '${order.distributorName} has requested cylinders from your plant',
            data: {
              'type': 'order',
              'orderId': orderId,
              'plantId': order.plantId,
            },
          );

          // Removed kDebugMode print statement
        } catch (e) {
          // Removed kDebugMode print statement
        }

        // Reload orders to include the new one
        await loadOrdersForPlant(order.plantId);
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to create order: ${e.toString()}');
      // Removed kDebugMode print statement
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Load orders for a specific plant
  Future<void> loadOrdersForPlant(String plantId) async {
    try {
      _setLoading(true);
      _clearError();

      // Removed kDebugMode print statement

      _orders = await _repository.getOrdersForPlant(plantId);

      // Removed kDebugMode print statements

      _updateNewOrders();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load plant orders: ${e.toString()}');
      // Removed kDebugMode print statement
    } finally {
      _setLoading(false);
      _isInitialLoadCompleted = true;
    }
  }

  /// Load orders for a specific distributor
  Future<void> loadOrdersForDistributor(String distributorId) async {
    try {
      _setLoading(true);
      _clearError();

      _distributorOrders = await _repository.getOrdersForDistributor(
        distributorId,
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to load distributor orders: ${e.toString()}');
      // Removed kDebugMode print statement
    } finally {
      _setLoading(false);
      _isInitialLoadCompleted = true;
    }
  }

  /// Load orders for a specific driver
  Future<void> loadOrdersForDriver(String driverName) async {
    try {
      _setLoading(true);
      _clearError();

      // Removed kDebugMode print statement

      _orders = await _repository.getOrdersForDriver(driverName);

      // Removed kDebugMode print statements

      notifyListeners();
    } catch (e) {
      _setError('Failed to load driver orders: ${e.toString()}');
      // Removed kDebugMode print statement
    } finally {
      _setLoading(false);
      _isInitialLoadCompleted = true;
    }
  }

  /// Listen to real-time order updates for a plant
  Stream<List<OrderModel>> getOrdersStreamForPlant(String plantId) {
    return _repository.getOrdersStreamForPlant(plantId).map((orders) {
      // Removed kDebugMode print statements

      _orders = orders;
      _updateNewOrders();
      // Don't set loading to false here as this is a real-time stream update
      notifyListeners();
      return orders;
    });
  }

  /// Listen to real-time order updates for a distributor
  Stream<List<OrderModel>> getOrdersStreamForDistributor(String distributorId) {
    return _repository.getOrdersStreamForDistributor(distributorId).map((
      orders,
    ) {
      _distributorOrders = orders;
      // Don't set loading to false here as this is a real-time stream update
      notifyListeners();
      return orders;
    });
  }

  /// Update order status
  Future<bool> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? driverName,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Removed kDebugMode print statements

      final success = await _repository.updateOrderStatus(
        orderId,
        status,
        driverName: driverName,
      );

      if (success) {
        // Removed kDebugMode print statement

        // Send notification to distributor when order is approved (status changed to inProgress)
        if (status == OrderStatus.inProgress) {
          final orderIndex = _orders.indexWhere((order) => order.id == orderId);
          if (orderIndex != -1) {
            final order = _orders[orderIndex];
            // Removed kDebugMode print statements

            // Use the new notification service for order approval
            try {
              await NotificationService.instance
                  .createOrderApprovalNotification(
                    distributorId: order.distributorId,
                    plantName: order.plantName,
                    orderId: orderId,
                  );

            } catch (e) {
              // Removed kDebugMode print statement
            }

            // Also try FCM notification as backup
            try {
              // Removed kDebugMode print statement
              
              await _fcmService.sendNotificationToUser(
                userId: order.distributorId,
                title: 'Order Approved',
                body: 'Your order is approved, please assign a driver.',
                data: {
                  'type': 'order_approved',
                  'orderId': orderId,
                  'distributorId': order.distributorId,
                },
              );

              // Removed kDebugMode print statement
            } catch (e) {
              // Removed kDebugMode print statement
            }
          } else {
            // Removed kDebugMode print statement
          }
        }

        // Update local order data
        final orderIndex = _orders.indexWhere((order) => order.id == orderId);
        if (orderIndex != -1) {
          final order = _orders[orderIndex];
          // Removed kDebugMode print statement

          _orders[orderIndex] = order.copyWith(
            status: status,
            driverName: driverName,
            updatedAt: DateTime.now(),
          );

          // Removed kDebugMode print statements
        } else {
          // Removed kDebugMode print statements
        }

        // Always refresh all order lists to ensure UI consistency
        // This fixes the issue where orders weren't appearing in the right sections
        _updateNewOrders();
        notifyListeners();

        // Removed kDebugMode print statements
      } else {
        // Removed kDebugMode print statement
      }

      return success;
    } catch (e, stackTrace) {
      _setError('Failed to update order status: ${e.toString()}');
      // Removed kDebugMode print statements
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get pending orders count for a plant
  Future<void> loadPendingOrdersCount(String plantId) async {
    try {
      _pendingOrdersCount = await _repository.getPendingOrdersCount(plantId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load pending orders count: ${e.toString()}');
      // Removed kDebugMode print statement
    }
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(
    String plantId,
    OrderStatus status,
  ) async {
    try {
      return await _repository.getOrdersByStatus(plantId, status);
    } catch (e) {
      _setError('Failed to fetch orders by status: ${e.toString()}');
      // Removed kDebugMode print statement
      return [];
    }
  }

  /// Get a specific order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    // Removed kDebugMode print statement
    try {
      return await _repository.getOrderById(orderId);
    } catch (e) {
      _setError('Failed to fetch order: ${e.toString()}');
      // Removed kDebugMode print statement
      return null;
    }
  }

  /// Delete an order
  Future<bool> deleteOrder(String orderId) async {
    try {
      _setLoading(true);
      _clearError();

      final success = await _repository.deleteOrder(orderId);

      if (success) {
        _orders.removeWhere((order) => order.id == orderId);
        _updateNewOrders();
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to delete order: ${e.toString()}');
      // Removed kDebugMode print statement
      return false;
    }
    finally {
      _setLoading(false);
    }
  }

  /// Refresh orders
  Future<void> refreshOrders(String plantId) async {
    await loadOrdersForPlant(plantId);
  }

  /// Update new orders (pending and confirmed orders)
  void _updateNewOrders() {
    _newOrders = _orders
        .where(
          (order) =>
              order.status == OrderStatus.pending ||
              order.status == OrderStatus.confirmed,
        )
        .toList();

    // Removed kDebugMode print statements
  }

  /// Clear all data
  void clearData() {
    _orders = [];
    _newOrders = [];
    _distributorOrders = [];
    _pendingOrdersCount = 0;
    _error = null;
    _isLoading = false;
    _isInitialLoadCompleted = false;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}