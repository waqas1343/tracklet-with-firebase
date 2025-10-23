import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/driver_model.dart';
import '../../../shared/widgets/custom_flushbar.dart';
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

            // Get all active drivers (not just available ones)
            final allDrivers = driverProvider.drivers
                .where((driver) => driver.isActive)
                .toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a driver to assign to order #${widget.order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Order: ${widget.order.distributorName} → ${widget.order.plantName}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (driverProvider.errorMessage != null)
                  Text(
                    driverProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                else if (allDrivers.isEmpty)
                  const Text('No drivers found')
                else ...[
                  const Text(
                    'All Drivers:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: allDrivers.length,
                      itemBuilder: (context, index) {
                        final driver = allDrivers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: RadioListTile<DriverModel?>(
                            title: Text(
                              driver.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'License: ${driver.licenseNumber}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Vehicle: ${driver.vehicleNumber}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Status: ${driver.status.toString().split('.').last.toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        driver.status == DriverStatus.available
                                        ? Colors.green
                                        : driver.status == DriverStatus.busy
                                        ? Colors.orange
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Completed Deliveries: ${driver.completedDeliveries}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            value: driver,
                            groupValue: _selectedDriver,
                            onChanged: (DriverModel? value) {
                              setState(() {
                                _selectedDriver = value;
                              });
                            },
                          ),
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
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
      final driverProvider = Provider.of<DriverProvider>(
        context,
        listen: false,
      );

      // Update the order with the selected driver and keep status as inProgress
      final success = await orderProvider.updateOrderStatus(
        widget.order.id,
        OrderStatus.inProgress, // Keep the same status
        driverName: _selectedDriver!.name,
      );

      if (success) {
        // Update driver status to busy
        await driverProvider.updateDriverStatus(
          _selectedDriver!.id,
          DriverStatus.busy,
        );

        if (mounted) {
          Navigator.of(context).pop();
          widget.onAssignmentComplete();

          CustomFlushbar.showSuccess(
            context,
            message: 'Driver ${_selectedDriver!.name} assigned successfully',
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to assign driver. Please try again.';
        });
        if (mounted) {
          CustomFlushbar.showError(
            context,
            message: 'Failed to assign driver. Please try again.',
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
      if (mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Error: ${e.toString()}',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
