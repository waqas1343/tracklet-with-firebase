import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

/// OrderViewModel - Handles order-related business logic
/// Follows MVVM pattern for separation of concerns
class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;

  List<OrderModel> _orders = [];
  List<OrderModel> _newOrders = [];
  List<OrderModel> _distributorOrders = [];
  bool _isLoading = false;
  String? _error;
  int _pendingOrdersCount = 0;

  OrderViewModel(this._repository);

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

      final orderId = await _repository.createOrder(order);
      if (orderId.isNotEmpty) {
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

      _orders = await _repository.getOrdersForPlant(plantId);
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

      _distributorOrders = await _repository.getOrdersForDistributor(distributorId);

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
      _orders = orders;
      _updateNewOrders();
      notifyListeners();
      return orders;
    });
  }

  /// Listen to real-time order updates for a distributor
  Stream<List<OrderModel>> getOrdersStreamForDistributor(String distributorId) {
    return _repository.getOrdersStreamForDistributor(distributorId).map((orders) {
      _distributorOrders = orders;
      notifyListeners();
      return orders;
    });
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status, {String? driverName}) async {
    try {
      _setLoading(true);
      _clearError();

      final success = await _repository.updateOrderStatus(orderId, status, driverName: driverName);

      if (success) {
        // Update local order
        final orderIndex = _orders.indexWhere((order) => order.id == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex] = _orders[orderIndex].copyWith(
            status: status,
            driverName: driverName,
            updatedAt: DateTime.now(),
          );
          _updateNewOrders();
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      _setError('Failed to update order status: ${e.toString()}');
      if (kDebugMode) {
        print('Error updating order status: $e');
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
  Future<List<OrderModel>> getOrdersByStatus(String plantId, OrderStatus status) async {
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
    _newOrders = _orders.where((order) => 
      order.status == OrderStatus.pending || 
      order.status == OrderStatus.confirmed
    ).toList();
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
