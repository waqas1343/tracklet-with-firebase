import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

/// OrderRepository - Handles all Firestore operations for orders
class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _ordersCollection = 'orders';

  /// Create a new order
  Future<String> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore
          .collection(_ordersCollection)
          .add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get all orders for a specific plant
  Future<List<OrderModel>> getOrdersForPlant(String plantId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('plantId', isEqualTo: plantId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch plant orders: $e');
    }
  }

  /// Get all orders for a specific distributor
  Future<List<OrderModel>> getOrdersForDistributor(String distributorId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('distributorId', isEqualTo: distributorId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch distributor orders: $e');
    }
  }

  /// Get orders stream for a plant (real-time updates)
  Stream<List<OrderModel>> getOrdersStreamForPlant(String plantId) {
    return _firestore
        .collection(_ordersCollection)
        .where('plantId', isEqualTo: plantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  /// Get orders stream for a distributor (real-time updates)
  Stream<List<OrderModel>> getOrdersStreamForDistributor(String distributorId) {
    return _firestore
        .collection(_ordersCollection)
        .where('distributorId', isEqualTo: distributorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status, {String? driverName}) async {
    try {
      final updates = <String, dynamic>{
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (driverName != null) {
        updates['driverName'] = driverName;
      }

      if (status == OrderStatus.completed) {
        updates['deliveryDate'] = DateTime.now().toIso8601String();
      }

      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .update(updates);
      return true;
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Get a specific order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return OrderModel.fromJson({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Get pending orders count for a plant
  Future<int> getPendingOrdersCount(String plantId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('plantId', isEqualTo: plantId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to fetch pending orders count: $e');
    }
  }

  /// Get all orders (admin view)
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all orders: $e');
    }
  }

  /// Delete an order
  Future<bool> deleteOrder(String orderId) async {
    try {
      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String plantId, OrderStatus status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('plantId', isEqualTo: plantId)
          .where('status', isEqualTo: status.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders by status: $e');
    }
  }
}
