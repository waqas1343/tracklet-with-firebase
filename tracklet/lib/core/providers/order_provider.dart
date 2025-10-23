import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../viewmodels/order_viewmodel.dart';

/// OrderProvider - Manages order data using MVVM pattern
/// Acts as a bridge between UI and OrderViewModel
class OrderProvider extends ChangeNotifier {
  final OrderViewModel _viewModel;

  OrderProvider() : _viewModel = OrderViewModel(OrderRepository()) {
    _viewModel.addListener(_onViewModelChanged);
  }

  // Getters - Delegate to ViewModel
  List<OrderModel> get orders => _viewModel.orders;
  List<OrderModel> get newOrders => _viewModel.newOrders;
  List<OrderModel> get distributorOrders => _viewModel.distributorOrders;
  bool get isLoading => _viewModel.isLoading;
  bool get isInitialLoadCompleted => _viewModel.isInitialLoadCompleted;
  String? get error => _viewModel.error;
  int get pendingOrdersCount => _viewModel.pendingOrdersCount;
  bool get hasOrders => _viewModel.hasOrders;

  // Additional getters for specific order types
  List<OrderModel> get pendingOrders => _viewModel.pendingOrders;
  List<OrderModel> get processingOrders => _viewModel.processingOrders;
  List<OrderModel> get confirmedOrders => _viewModel.confirmedOrders;
  List<OrderModel> get completedOrders => _viewModel.completedOrders;
  List<OrderModel> get cancelledOrders => _viewModel.cancelledOrders;

  /// Create a new order
  Future<bool> createOrder(OrderModel order) async {
    return await _viewModel.createOrder(order);
  }

  /// Load orders for a specific plant
  Future<void> loadOrdersForPlant(String plantId) async {
    await _viewModel.loadOrdersForPlant(plantId);
  }

  /// Load orders for a specific distributor
  Future<void> loadOrdersForDistributor(String distributorId) async {
    await _viewModel.loadOrdersForDistributor(distributorId);
  }

  /// Load orders for a specific driver
  Future<void> loadOrdersForDriver(String driverName) async {
    await _viewModel.loadOrdersForDriver(driverName);
  }

  /// Listen to real-time order updates for a plant
  Stream<List<OrderModel>> getOrdersStreamForPlant(String plantId) {
    return _viewModel.getOrdersStreamForPlant(plantId);
  }

  /// Listen to real-time order updates for a distributor
  Stream<List<OrderModel>> getOrdersStreamForDistributor(String distributorId) {
    return _viewModel.getOrdersStreamForDistributor(distributorId);
  }

  /// Update order status
  Future<bool> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? driverName,
  }) async {
    return await _viewModel.updateOrderStatus(
      orderId,
      status,
      driverName: driverName,
    );
  }

  /// Load pending orders count for a plant
  Future<void> loadPendingOrdersCount(String plantId) async {
    await _viewModel.loadPendingOrdersCount(plantId);
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(
    String plantId,
    OrderStatus status,
  ) async {
    return await _viewModel.getOrdersByStatus(plantId, status);
  }

  /// Get a specific order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    return await _viewModel.getOrderById(orderId);
  }

  /// Delete an order
  Future<bool> deleteOrder(String orderId) async {
    return await _viewModel.deleteOrder(orderId);
  }

  /// Refresh orders
  Future<void> refreshOrders(String plantId) async {
    await _viewModel.refreshOrders(plantId);
  }

  /// Search orders by various criteria
  Future<List<OrderModel>> searchOrders(String query) async {
    return await _viewModel.searchOrders(query);
  }

  /// Get filtered orders based on search query
  List<OrderModel> getFilteredOrders(String query) {
    if (query.isEmpty) return orders;

    final lowerQuery = query.toLowerCase();
    return orders.where((order) {
      return order.id.toLowerCase().contains(lowerQuery) ||
          order.distributorName.toLowerCase().contains(lowerQuery) ||
          order.driverName?.toLowerCase().contains(lowerQuery) == true ||
          order.status.toString().toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear all data
  void clearData() {
    _viewModel.clearData();
  }

  /// Handle ViewModel changes
  void _onViewModelChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }
}
