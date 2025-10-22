import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
      if (kDebugMode) {
        print('Fetching orders for plant: $plantId');
      }

      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('plantId', isEqualTo: plantId)
          .get();

      if (kDebugMode) {
        print('Found ${querySnapshot.docs.length} orders for plant: $plantId');
      }

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort in memory instead of using Firestore orderBy
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (kDebugMode) {
        for (var order in orders) {
          print(
            'Order ID: ${order.id}, Status: ${order.statusText}, Plant ID: ${order.plantId}',
          );
        }
      }

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

  /// Get orders stream for a plant (real-time updates)
  Stream<List<OrderModel>> getOrdersStreamForPlant(String plantId) {
    if (kDebugMode) {
      print('🔄 Creating order stream for plant: $plantId');
    }

    try {
      final collectionRef = _firestore.collection(_ordersCollection);
      final query = collectionRef.where('plantId', isEqualTo: plantId);
      
      if (kDebugMode) {
        print('   Firestore query: plantId == $plantId');
      }
      
      final stream = query
          .snapshots()
          .handleError((error) {
            if (kDebugMode) {
              print('❌ Stream error for plant $plantId: $error');
            }
          })
          .map((snapshot) {
            if (kDebugMode) {
              print(
                '✅ Order stream update - Plant: $plantId, Docs: ${snapshot.docs.length}',
              );
              // Print all document IDs to see what we're getting
              if (snapshot.docs.isEmpty) {
                print('   No documents found for plant: $plantId');
              } else {
                for (var doc in snapshot.docs) {
                  print('  Document ID: ${doc.id}');
                  final data = doc.data();
                  print('    Data: $data');
                  if (data.containsKey('status')) {
                    print('    Status: ${data['status']}');
                  } else {
                    print('    ❌ No status field found');
                  }
                  if (data.containsKey('plantId')) {
                    print('    Plant ID: ${data['plantId']}');
                  } else {
                    print('    ❌ No plantId field found');
                  }
                }
              }
            }

            final orders = snapshot.docs
                .map((doc) {
                  try {
                    final data = {...doc.data(), 'id': doc.id};
                    if (kDebugMode) {
                      print('  Processing document ID: ${doc.id}');
                      print('    Status from Firestore: ${data['status']}');
                      print('    Status type: ${data['status'].runtimeType}');
                    }
                    return OrderModel.fromJson(data);
                  } catch (e) {
                    if (kDebugMode) {
                      print('⚠️ Error parsing order ${doc.id}: $e');
                      print('    Document data: ${doc.data()}');
                    }
                    return null;
                  }
                })
                .whereType<OrderModel>()
                .toList();

            // Sort in memory instead of using Firestore orderBy
            orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (kDebugMode) {
              print('📦 Parsed ${orders.length} valid orders for plant $plantId');
              if (orders.isEmpty) {
                print('   ❌ No valid orders parsed');
              } else {
                for (var i = 0; i < orders.length; i++) {
                  var order = orders[i];
                  print(
                    '   Order #$i: ${order.id.substring(0, 8)}... | Status: ${order.statusText} (${order.status}) | Plant: ${order.plantId.substring(0, 8)}...',
                  );
                }
              }
            }

            return orders;
          });
          
      if (kDebugMode) {
        print('✅ Stream created successfully for plant: $plantId');
      }
      
      return stream;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Fatal error creating stream: $e');
        print('   Stack trace: $stackTrace');
      }
      return Stream.value([]);
    }
  }

  /// Get orders stream for a distributor (real-time updates)
  Stream<List<OrderModel>> getOrdersStreamForDistributor(String distributorId) {
    if (kDebugMode) {
      print('🔄 Creating order stream for distributor: $distributorId');
    }

    try {
      return _firestore
          .collection(_ordersCollection)
          .where('distributorId', isEqualTo: distributorId)
          .snapshots()
          .handleError((error) {
            if (kDebugMode) {
              print('❌ Stream error for distributor $distributorId: $error');
            }
          })
          .map((snapshot) {
            if (kDebugMode) {
              print(
                '✅ Distributor stream update - Docs: ${snapshot.docs.length}',
              );
            }

            final orders = snapshot.docs
                .map((doc) {
                  try {
                    return OrderModel.fromJson({...doc.data(), 'id': doc.id});
                  } catch (e) {
                    if (kDebugMode) {
                      print('⚠️ Error parsing order ${doc.id}: $e');
                    }
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
      if (kDebugMode) {
        print('❌ Fatal error creating distributor stream: $e');
      }
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
      
      if (kDebugMode) {
        print('🔄 Updating order $orderId status to: $statusString');
        print('   OrderStatus enum value: $status');
        print('   Status string for Firestore: $statusString');
      }
      
      final updates = <String, dynamic>{
        'status': statusString,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (driverName != null) {
        updates['driverName'] = driverName;
        if (kDebugMode) {
          print('   Setting driver name to: $driverName');
        }
      }

      if (status == OrderStatus.completed) {
        updates['deliveryDate'] = DateTime.now().toIso8601String();
      }

      if (kDebugMode) {
        print('   Update data: $updates');
      }

      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .update(updates);
      
      if (kDebugMode) {
        print('✅ Successfully updated order $orderId');
        print('   Updated fields: $updates');
      }
      
      // Verify the update was successful by reading the document back
      try {
        final docSnapshot = await _firestore
            .collection(_ordersCollection)
            .doc(orderId)
            .get();
            
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (kDebugMode) {
            print('   Verification - Document data after update: $data');
            if (data != null && data.containsKey('status')) {
              print('   Verification - Status in document: ${data['status']}');
            }
          }
        } else {
          if (kDebugMode) {
            print('   ❌ Verification failed - Document does not exist after update');
          }
        }
      } catch (verifyError) {
        if (kDebugMode) {
          print('   ⚠️ Verification error: $verifyError');
        }
      }
      
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error updating order status: $e');
        print('   Stack trace: $stackTrace');
      }
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
