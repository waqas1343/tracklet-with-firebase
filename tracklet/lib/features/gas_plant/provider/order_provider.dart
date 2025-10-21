import 'package:flutter/foundation.dart';
import '../../../core/models/order_model.dart';
import '../../../core/services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService _apiService;

  OrderProvider({required ApiService apiService}) : _apiService = apiService;

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<OrderModel> get pendingOrders =>
      _orders.where((order) => order.status == OrderStatus.pending).toList();

  List<OrderModel> get processingOrders =>
      _orders.where((order) => order.status == OrderStatus.processing).toList();

  List<OrderModel> get completedOrders =>
      _orders.where((order) => order.status == OrderStatus.completed).toList();

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/orders');
      final ordersData = response['orders'] as List;
      _orders = ordersData.map((json) => OrderModel.fromJson(json)).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(OrderModel order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/orders', order.toJson());
      final newOrder = OrderModel.fromJson(response['order']);
      _orders.insert(0, newOrder);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create order: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrder(OrderModel order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.put(
        '/orders/${order.id}',
        order.toJson(),
      );
      final updatedOrder = OrderModel.fromJson(response['order']);
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update order: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.delete('/orders/$orderId');
      _orders.removeWhere((order) => order.id == orderId);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete order: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    final order = _orders.firstWhere((o) => o.id == orderId);
    return await updateOrder(order.copyWith(status: status));
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
