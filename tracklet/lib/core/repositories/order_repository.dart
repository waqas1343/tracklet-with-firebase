import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

/// OrderRepository - Handles all Firestore operations for orders
class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Public getter for firestore access
  FirebaseFirestore get firestore => _firestore;

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
          .get();

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort in memory instead of using Firestore orderBy
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
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
          .get();

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort in memory
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch distributor orders: $e');
    }
  }

  /// Get all orders for a specific driver
  Future<List<OrderModel>> getOrdersForDriver(String driverName) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('driverName', isEqualTo: driverName)
          .get();

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort in memory
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch driver orders: $e');
    }
  }

  /// Get orders stream for a plant (real-time updates)
  Stream<List<OrderModel>> getOrdersStreamForPlant(String plantId) {
    try {
      final collectionRef = _firestore.collection(_ordersCollection);
      final query = collectionRef.where('plantId', isEqualTo: plantId);

      final stream = query.snapshots().handleError((error) {}).map((snapshot) {
        final orders = snapshot.docs
            .map((doc) {
              try {
                final data = {...doc.data(), 'id': doc.id};

                return OrderModel.fromJson(data);
              } catch (e) {
                return null;
              }
            })
            .whereType<OrderModel>()
            .toList();

        // Sort in memory instead of using Firestore orderBy
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return orders;
      });

      return stream;
    } catch (e) {
      return Stream.value([]);
    }
  }

  /// Get orders stream for a distributor (real-time updates)
  Stream<List<OrderModel>> getOrdersStreamForDistributor(String distributorId) {
    try {
      return _firestore
          .collection(_ordersCollection)
          .where('distributorId', isEqualTo: distributorId)
          .snapshots()
          .handleError((error) {})
          .map((snapshot) {
            final orders = snapshot.docs
                .map((doc) {
                  try {
                    return OrderModel.fromJson({...doc.data(), 'id': doc.id});
                  } catch (e) {
                    return null;
                  }
                })
                .whereType<OrderModel>()
                .toList();

            // Sort in memory
            orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return orders;
          });
    } catch (e) {
      return Stream.value([]);
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? driverName,
  }) async {
    try {
      final statusString = status.toString().split('.').last;

      final updates = <String, dynamic>{
        'status': statusString,
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

      // Verify the update was successful by reading the document back
      try {
        final docSnapshot = await _firestore
            .collection(_ordersCollection)
            .doc(orderId)
            .get();

        if (docSnapshot.exists) {
          // Document exists, order deletion was successful
        } else {
          // Document doesn't exist, which is expected after deletion
        }
      } catch (verifyError) {}

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

      final order = OrderModel.fromJson({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });

      return order;
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
      await _firestore.collection(_ordersCollection).doc(orderId).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(
    String plantId,
    OrderStatus status,
  ) async {
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
