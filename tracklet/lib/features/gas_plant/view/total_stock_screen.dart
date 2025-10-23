import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_flushbar.dart';

// Tank model to store tank information
class Tank {
  final String id;
  final String name;
  final double capacity;
  final double availableGas;
  final double freezeGas;
  final String lastRecordedDate;

  Tank({
    required this.id,
    required this.name,
    required this.capacity,
    required this.availableGas,
    required this.freezeGas,
    required this.lastRecordedDate,
  });
}

class TotalStockScreen extends StatefulWidget {
  const TotalStockScreen({super.key});

  @override
  State<TotalStockScreen> createState() => _TotalStockScreenState();
}

class _TotalStockScreenState extends State<TotalStockScreen> {
  // List to store tanks - initially empty
  List<Tank> _tanks = [];
  
  // Controllers for the dialog form
  final TextEditingController _tankNameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _initialGasController = TextEditingController();

  @override
  void dispose() {
    _tankNameController.dispose();
    _capacityController.dispose();
    _initialGasController.dispose();
    super.dispose();
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
  void _addTank() {
    final String name = _tankNameController.text.trim();
    final String capacityText = _capacityController.text.trim();
    final String initialGasText = _initialGasController.text.trim();
    
    // Validate inputs
    if (name.isEmpty || capacityText.isEmpty || initialGasText.isEmpty) {
      CustomFlushbar.showError(
        context,
        message: 'Please fill all fields',
      );
      return;
    }

    final double? capacity = double.tryParse(capacityText);
    final double? initialGas = double.tryParse(initialGasText);

    if (capacity == null || initialGas == null) {
      CustomFlushbar.showError(
        context,
        message: 'Please enter valid numbers for capacity and gas',
      );
      return;
    }

    if (initialGas > capacity) {
      CustomFlushbar.showError(
        context,
        message: 'Initial gas cannot exceed tank capacity',
      );
      return;
    }

    // Create new tank with unique ID
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final String date = DateTime.now().toString().split(' ')[0];

    setState(() {
      _tanks.add(
        Tank(
          id: id,
          name: name,
          capacity: capacity,
          availableGas: initialGas,
          freezeGas: 0.0,
          lastRecordedDate: date,
        ),
      );
    });

    CustomFlushbar.showSuccess(
      context,
      message: 'Tank added successfully',
    );
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
              // Tanks Status Summary Section
              _buildTanksStatusSummarySection(),
              const SizedBox(height: 24),

              // View Available Gas in Tanks Section
              _buildAvailableGasSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTanksStatusSummarySection() {
    // Calculate total stock and freeze gas
    double totalStock = 0.0;
    double freezeGas = 0.0;
    
    for (var tank in _tanks) {
      totalStock += tank.availableGas;
      freezeGas += tank.freezeGas;
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

        // Download Report Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Handle download report
            },
            icon: const Icon(Icons.cloud_download, color: Colors.white),
            label: const Text(
              'Download Report',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF87CEEB),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Summary Cards
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

        // Add Tank Button
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
        // Display tanks dynamically
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Click "Add Tank" to create a new tank',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          )
        else
          ..._tanks.map((tank) => _buildTankCard(
                tank.name,
                '${tank.availableGas.toStringAsFixed(1)} Tons',
                '${tank.freezeGas.toStringAsFixed(1)} Tons',
                '${tank.capacity.toStringAsFixed(1)} Tons',
                tank.lastRecordedDate,
              )),
      ],
    );
  }

  Widget _buildTankCard(
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
                    // TODO: Handle freeze gas
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Freeze Gas',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Add Gas',
                  onPressed: () {
                    // TODO: Handle add gas
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