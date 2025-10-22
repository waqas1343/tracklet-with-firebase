import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/providers/order_provider.dart';
import '../../distributor/provider/driver_provider.dart';
import '../../../core/utils/app_colors.dart';

class DriverAssignmentDialog extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onAssignmentComplete;

  const DriverAssignmentDialog({
    Key? key,
    required this.order,
    required this.onAssignmentComplete,
  }) : super(key: key);

  @override
  State<DriverAssignmentDialog> createState() => _DriverAssignmentDialogState();
}

class _DriverAssignmentDialogState extends State<DriverAssignmentDialog> {
  DriverModel? _selectedDriver;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign Driver'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Consumer<DriverProvider>(
          builder: (context, driverProvider, child) {
            // Load drivers when dialog is first displayed
            if (!driverProvider.isLoading && driverProvider.drivers.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                driverProvider.fetchDrivers();
              });
            }

            // Get available drivers
            final availableDrivers = driverProvider.availableDrivers;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a driver to assign to order #${widget.order.id.substring(0, 8)}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (driverProvider.errorMessage != null)
                  Text(
                    driverProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                else if (availableDrivers.isEmpty)
                  const Text('No available drivers found')
                else ...[
                  const Text(
                    'Available Drivers:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: availableDrivers.length,
                      itemBuilder: (context, index) {
                        final driver = availableDrivers[index];
                        return RadioListTile<DriverModel?>(
                          title: Text(driver.name),
                          subtitle: Text(
                            '${driver.licenseNumber} • ${driver.vehicleNumber}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: driver,
                          groupValue: _selectedDriver,
                          onChanged: (DriverModel? value) {
                            setState(() {
                              _selectedDriver = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedDriver == null || _isLoading
              ? null
              : () async {
                  await _assignDriver();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Assign Driver'),
        ),
      ],
    );
  }

  Future<void> _assignDriver() async {
    if (_selectedDriver == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      
      // Update the order with the selected driver and keep status as inProgress
      final success = await orderProvider.updateOrderStatus(
        widget.order.id,
        OrderStatus.inProgress, // Keep the same status
        driverName: _selectedDriver!.name,
      );

      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          widget.onAssignmentComplete();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Driver ${_selectedDriver!.name} assigned successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to assign driver. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}