import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracklet/core/utils/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_flushbar.dart';

// Tank model to store tank information
class Tank {
  final String id;
  final String name;
  final double capacity; // in tons
  final double currentGas; // available gas in tons
  final double frozenGas; // frozen gas in tons
  final DateTime timestamp;
  final String userId; // Add userId to associate tank with user

  Tank({
    required this.id,
    required this.name,
    required this.capacity,
    required this.currentGas,
    required this.frozenGas,
    required this.timestamp,
    required this.userId, // Add userId parameter
  });

  // Get total gas (current + frozen)
  double get totalGas => currentGas + frozenGas;

  // Create a copy with updated fields
  Tank copyWith({
    String? id,
    String? name,
    double? capacity,
    double? currentGas,
    double? frozenGas,
    DateTime? timestamp,
    String? userId,
  }) {
    return Tank(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      currentGas: currentGas ?? this.currentGas,
      frozenGas: frozenGas ?? this.frozenGas,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
    );
  }
}

class TotalStockScreen extends StatefulWidget {
  const TotalStockScreen({super.key});

  @override
  State<TotalStockScreen> createState() => _TotalStockScreenState();
}

class _TotalStockScreenState extends State<TotalStockScreen> {
  // List to store tanks - initially empty
  List<Tank> _tanks = [];
  late Stream<QuerySnapshot> _tanksStream;

  // Controllers for the dialog form
  final TextEditingController _tankNameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _initialGasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTanksFromFirebase();
  }

  @override
  void dispose() {
    _tankNameController.dispose();
    _capacityController.dispose();
    _initialGasController.dispose();
    super.dispose();
  }

  void _loadTanksFromFirebase() {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    _tanksStream = FirebaseFirestore.instance
        .collection('tanks')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();

    // Listen to the stream and update the UI
    _tanksStream.listen((snapshot) {
      setState(() {
        _tanks = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Tank(
            id: doc.id,
            name: data['tankName'] ?? '',
            capacity: (data['capacity'] ?? 0).toDouble(),
            currentGas: (data['currentGas'] ?? 0).toDouble(),
            frozenGas: (data['frozenGas'] ?? 0).toDouble(),
            timestamp: (data['timestamp'] as Timestamp).toDate(),
            userId: data['userId'] ?? '', // Add this line
          );
        }).toList();
      });
    });
  }

  // Method to show add tank dialog
  void _showAddTankDialog() {
    // Clear controllers
    _tankNameController.clear();
    _capacityController.clear();
    _initialGasController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Tank'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tankNameController,
                decoration: const InputDecoration(
                  labelText: 'Tank Name',
                  hintText: 'Enter tank name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacity (Tons)',
                  hintText: 'Enter tank capacity',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _initialGasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Initial Gas (Tons)',
                  hintText: 'Enter initial gas amount',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTank();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Method to add a new tank
  void _addTank() async {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'User not authenticated');
      }
      return;
    }

    final String name = _tankNameController.text.trim();
    final String capacityText = _capacityController.text.trim();
    final String initialGasText = _initialGasController.text.trim();

    // Validate inputs
    if (name.isEmpty || capacityText.isEmpty || initialGasText.isEmpty) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Please fill all fields');
      }
      return;
    }

    final double? capacity = double.tryParse(capacityText);
    final double? initialGas = double.tryParse(initialGasText);

    if (capacity == null || initialGas == null) {
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Please enter valid numbers for capacity and gas',
        );
      }
      return;
    }

    if (initialGas > capacity) {
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Initial gas cannot exceed tank capacity',
        );
      }
      return;
    }

    try {
      // Save to Firebase with userId
      await FirebaseFirestore.instance.collection('tanks').add({
        'tankName': name,
        'capacity': capacity,
        'currentGas': initialGas,
        'frozenGas': 0.0,
        'timestamp': Timestamp.now(),
        'userId': currentUserId, // Add this line
      });

      if (mounted) {
        CustomFlushbar.showSuccess(context, message: 'Tank added successfully');
      }
    } catch (e) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Failed to add tank: $e');
      }
    }
  }

  Future<void> _addGasToTank(Tank tank, double amount) async {
    if (tank.currentGas + amount > tank.capacity) {
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Adding this amount would exceed tank capacity',
        );
      }
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('tanks').doc(tank.id).update({
        'currentGas': FieldValue.increment(amount),
      });

      if (mounted) {
        CustomFlushbar.showSuccess(context, message: 'Gas added successfully');
      }
    } catch (e) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Failed to add gas: $e');
      }
    }
  }

  Future<void> _freezeGasInTank(Tank tank, double amount) async {
    if (amount > tank.currentGas) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Not enough gas to freeze');
      }
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('tanks').doc(tank.id).update({
        'currentGas': FieldValue.increment(-amount),
        'frozenGas': FieldValue.increment(amount),
      });

      if (mounted) {
        CustomFlushbar.showSuccess(context, message: 'Gas frozen successfully');
      }
    } catch (e) {
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Failed to freeze gas: $e');
      }
    }
  }

  void _showAddGasDialog(Tank tank) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Gas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tank: ${tank.name}'),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (Tons)',
                  hintText: 'Enter amount to add',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ${tank.currentGas.toStringAsFixed(2)} Tons / '
                'Capacity: ${tank.capacity.toStringAsFixed(2)} Tons',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Available space: ${(tank.capacity - tank.currentGas).toStringAsFixed(2)} Tons',
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  Navigator.of(context).pop();
                  // Check if the parent widget is still mounted before calling async method
                  if (mounted) {
                    _addGasToTank(tank, amount);
                  }
                }
              },
              child: const Text('Add Gas'),
            ),
          ],
        );
      },
    ).then((_) => amountController.dispose());
  }

  void _showFreezeGasDialog(Tank tank) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Freeze Gas'),
          titleTextStyle: TextStyle(color: Colors.black),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tank: ${tank.name}'),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (Tons)',
                  hintText: 'Enter amount to freeze',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Gas: ${tank.currentGas.toStringAsFixed(2)} Tons',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Frozen Gas: ${tank.frozenGas.toStringAsFixed(2)} Tons',
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  if (amount > tank.currentGas) {
                    if (mounted) {
                      CustomFlushbar.showError(
                        context,
                        message: 'Not enough gas to freeze',
                      );
                    }
                    return;
                  }
                  Navigator.of(context).pop();
                  // Check if the parent widget is still mounted before calling async method
                  if (mounted) {
                    _freezeGasInTank(tank, amount);
                  }
                }
              },
              child: const Text('Freeze Gas'),
            ),
          ],
        );
      },
    ).then((_) => amountController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTanksStatusSummarySection(),
              const SizedBox(height: 24),

              _buildAvailableGasSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTanksStatusSummarySection() {
    double totalStock = 0.0;
    double freezeGas = 0.0;

    for (var tank in _tanks) {
      totalStock +=
          tank.currentGas +
          tank.frozenGas; // Total stock includes both current and frozen gas
      freezeGas += tank.frozenGas;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanks Status Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.cloud_download, color: Colors.white),
            label: const Text(
              'Download Report',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Stock',
                '${totalStock.toStringAsFixed(1)} Tons',
                Icons.local_drink,
                const Color(0xFF1A2B4C),
                Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Freeze Gas',
                '${freezeGas.toStringAsFixed(1)} Tons',
                Icons.ac_unit,
                Colors.white,
                const Color(0xFF333333),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        CustomButton(
          text: 'Add Tank',
          onPressed: _showAddTankDialog,
          width: double.infinity,
          backgroundColor: const Color(0xFF1A2B4C),
          textColor: Colors.white,
          height: 50,
          borderRadius: 12,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableGasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'View available gas in tanks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        if (_tanks.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.local_drink_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No tanks added yet',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Click "Add Tank" to create a new tank',
                  style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                ),
              ],
            ),
          )
        else
          ..._tanks.asMap().entries.map((entry) {
            final tank = entry.value;
            return _buildTankCard(
              tank,
              tank.name,
              '${tank.currentGas.toStringAsFixed(1)} Tons',
              '${tank.frozenGas.toStringAsFixed(1)} Tons',
              '${tank.capacity.toStringAsFixed(1)} Tons',
              tank.timestamp.toString(),
            );
          }),
      ],
    );
  }

  Widget _buildTankCard(
    Tank tank,
    String tankName,
    String availableGas,
    String freezeGas,
    String totalCapacity,
    String lastRecordedDate,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tank Header
          Row(
            children: [
              Icon(Icons.local_drink, color: const Color(0xFF1A2B4C), size: 24),
              const SizedBox(width: 8),
              Text(
                tankName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2B4C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tank Details
          _buildTankDetailRow('Available', availableGas, 'Freeze', freezeGas),
          const SizedBox(height: 8),
          _buildTankDetailRow(
            'Total Capacity',
            totalCapacity,
            'Last Recorded Date',
            lastRecordedDate,
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showFreezeGasDialog(tank);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Freeze Gas',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Add Gas',
                  onPressed: () {
                    _showAddGasDialog(tank);
                  },
                  backgroundColor: const Color(0xFF1A2B4C),
                  textColor: Colors.white,
                  height: 44,
                  borderRadius: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTankDetailRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 2),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 2),
              Text(
                value2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
