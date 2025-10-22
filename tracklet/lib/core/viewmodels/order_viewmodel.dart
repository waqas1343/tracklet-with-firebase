import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../repositories/notification_repository.dart';
import '../services/fcm_service.dart';

/// OrderViewModel - Handles order-related business logic
/// Follows MVVM pattern for separation of concerns
class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;
  final NotificationRepository _notificationRepository;

  List<OrderModel> _orders = [];
  List<OrderModel> _newOrders = [];
  List<OrderModel> _distributorOrders = [];
  bool _isLoading = false;
  String? _error;
  int _pendingOrdersCount = 0;

  OrderViewModel(this._repository)
    : _notificationRepository = NotificationRepository();

  // Getters
  List<OrderModel> get orders => _orders;
  List<OrderModel> get newOrders => _newOrders;
  List<OrderModel> get distributorOrders => _distributorOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get pendingOrdersCount => _pendingOrdersCount;
  bool get hasOrders => _orders.isNotEmpty;

  /// Create a new order
  Future<bool> createOrder(OrderModel order) async {
    try {
      _setLoading(true);
      _clearError();

      if (kDebugMode) {
        print('Creating order for plant: ${order.plantId}');
        print('Order details: ${order.toJson()}');
      }

      final orderId = await _repository.createOrder(order);
      if (orderId.isNotEmpty) {
        if (kDebugMode) {
          print('Order created with ID: $orderId');
        }

        // Create notification for gas plant
        await _notificationRepository.createOrderNotification(
          plantId: order.plantId,
          distributorName: order.distributorName,
          orderId: orderId,
        );

        if (kDebugMode) {
          print('Notification created for plant: ${order.plantId}');
        }

        // Send push notification
        try {
          final fcmService = FCMService.instance;
          await fcmService.sendNotificationToUser(
            userId: order.plantId,
            title: 'New Order Request',
            body: '${order.distributorName} has requested cylinders from your plant',
            data: {
              'type': 'order',
              'orderId': orderId,
              'plantId': order.plantId,
            },
          );
          
          if (kDebugMode) {
            print('✅ Push notification sent to plant: ${order.plantId}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Failed to send push notification: $e');
          }
        }

        // Reload orders to include the new one
        await loadOrdersForPlant(order.plantId);
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to create order: ${e.toString()}');
      if (kDebugMode) {
        print('Error creating order: $e');
      }
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

      if (kDebugMode) {
        print('Loading orders for plant: $plantId');
      }

      _orders = await _repository.getOrdersForPlant(plantId);

      if (kDebugMode) {
        print('Loaded ${_orders.length} orders for plant: $plantId');
        for (var order in _orders) {
          print('Order: ${order.id} - Status: ${order.statusText} - Plant ID: ${order.plantId}');
        }
      }

      _updateNewOrders();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load plant orders: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading plant orders: $e');
      }
    } finally {
      _setLoading(false);
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
      if (kDebugMode) {
        print('Error loading distributor orders: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Listen to real-time order updates for a plant
  Stream<List<OrderModel>> getOrdersStreamForPlant(String plantId) {
    return _repository.getOrdersStreamForPlant(plantId).map((orders) {
      if (kDebugMode) {
        print('OrderViewModel - Orders updated for plant $plantId, count: ${orders.length}');
        for (var order in orders) {
          print('  Order ID: ${order.id}, Status: ${order.statusText} (${order.status}), Plant ID: ${order.plantId}');
        }
      }
      
      _orders = orders;
      _updateNewOrders();
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

      if (kDebugMode) {
        print('🔄 ViewModel updating order $orderId status to: ${status.toString().split('.').last}');
        print('   OrderStatus enum: $status');
        print('   Driver name: $driverName');
      }

      final success = await _repository.updateOrderStatus(
        orderId,
        status,
        driverName: driverName,
      );

      if (success) {
        if (kDebugMode) {
          print('✅ Repository update successful for order $orderId');
        }
        
        // Create notification for distributor about status update
        final orderIndex = _orders.indexWhere((order) => order.id == orderId);
        if (orderIndex != -1) {
          final order = _orders[orderIndex];
          if (kDebugMode) {
            print('   Found order in local list, updating local copy');
          }
          
          await _notificationRepository.createOrderStatusNotification(
            distributorId: order.distributorId,
            plantName: order.plantName,
            orderId: orderId,
            status: status.toString().split('.').last,
          );

          _orders[orderIndex] = order.copyWith(
            status: status,
            driverName: driverName,
            updatedAt: DateTime.now(),
          );
          
          if (kDebugMode) {
            print('   Updated local order ${order.id} status to: ${status.toString().split('.').last}');
            print('   Updated order driver name: $driverName');
            print('   Updated order status enum: ${_orders[orderIndex].status}');
          }
        } else {
          if (kDebugMode) {
            print('   ⚠️ Order $orderId not found in local list, but update was successful in Firestore');
            print('   Local orders count: ${_orders.length}');
            for (var i = 0; i < _orders.length; i++) {
              print('     Order $i: ${_orders[i].id} - Status: ${_orders[i].statusText}');
            }
          }
        }
        
        // Always refresh all order lists to ensure UI consistency
        // This fixes the issue where orders weren't appearing in the right sections
        _updateNewOrders();
        notifyListeners();
        
        if (kDebugMode) {
          print('   Notified listeners of changes');
          print('   New orders count after update: ${_newOrders.length}');
          for (var i = 0; i < _newOrders.length; i++) {
            print('     New Order $i: ${_newOrders[i].id} - Status: ${_newOrders[i].statusText}');
          }
          // Also log the total orders to verify all lists are updated
          print('   Total orders count: ${_orders.length}');
        }
      } else {
        if (kDebugMode) {
          print('❌ Repository update failed for order $orderId');
        }
      }

      return success;
    } catch (e, stackTrace) {
      _setError('Failed to update order status: ${e.toString()}');
      if (kDebugMode) {
        print('❌ Error updating order status: $e');
        print('   Stack trace: $stackTrace');
      }
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
      if (kDebugMode) {
        print('Error loading pending orders count: $e');
      }
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
      if (kDebugMode) {
        print('Error fetching orders by status: $e');
      }
      return [];
    }
  }

  /// Get a specific order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      return await _repository.getOrderById(orderId);
    } catch (e) {
      _setError('Failed to fetch order: ${e.toString()}');
      if (kDebugMode) {
        print('Error fetching order: $e');
      }
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
      if (kDebugMode) {
        print('Error deleting order: $e');
      }
      return false;
    } finally {
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
        
    if (kDebugMode) {
      print('Updated new orders list with ${_newOrders.length} items');
      for (var order in _newOrders) {
        print('New Order: ${order.id} - Status: ${order.statusText}');
      }
    }
  }

  /// Clear all data
  void clearData() {
    _orders = [];
    _newOrders = [];
    _distributorOrders = [];
    _pendingOrdersCount = 0;
    _error = null;
    _isLoading = false;
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