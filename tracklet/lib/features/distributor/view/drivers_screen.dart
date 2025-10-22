import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/driver_model.dart';
import '../provider/driver_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_theme.dart';
import 'driver_details_screen.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<DriverProvider>(
          builder: (context, driverProvider, child) {
            // Load drivers when screen is first displayed
            if (!driverProvider.isLoading && driverProvider.drivers.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                driverProvider.fetchDrivers();
              });
            }

            // Filter drivers based on search query
            List<DriverModel> filteredDrivers = driverProvider.drivers;
            if (_searchQuery.isNotEmpty) {
              filteredDrivers = driverProvider.drivers.where((driver) {
                return driver.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    driver.licenseNumber.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),
                  // Search Bar
                  _buildSearchBar(),
                  // Driver List
                  _buildDriverList(driverProvider, filteredDrivers),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Drivers',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Add Driver Button
          GestureDetector(
            onTap: () => _showAddDriverDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: const Color(0xFF002455).withOpacity(0.24),
                  width: 1,
                ),
                color: const Color(0xFF002455).withOpacity(0.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF002455),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Add Driver',
                    style: TextStyle(
                      color: Color(0xFF002455),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5),
        border: Border.all(
          color: Colors.black.withOpacity(0.24),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: Colors.black.withOpacity(0.24),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search drivers...',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.24),
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDriverList(DriverProvider driverProvider, List<DriverModel> drivers) {
    if (driverProvider.isLoading && drivers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (drivers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'No drivers found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No drivers match your search'
                    : 'Add your first driver to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: drivers.map((driver) {
        return _buildDriverCard(driver);
      }).toList(),
    );
  }

  Widget _buildDriverCard(DriverModel driver) {
    return GestureDetector(
      onTap: () {
        // Navigate to driver details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverDetailsScreen(driver: driver),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withOpacity(0.24),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF002455),
              ),
              child: Center(
                child: Text(
                  driver.name.split(' ').map((e) => e[0]).join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Driver Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF090909),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.licenseNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Status and Actions
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.5),
                      color: driver.isActive
                          ? const Color(0xFF219653).withOpacity(0.2)
                          : const Color(0xFFFFB700).withOpacity(0.2),
                    ),
                    child: Text(
                      driver.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: driver.isActive
                            ? const Color(0xFF219653)
                            : const Color(0xFFFFB700),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black.withOpacity(0.24),
                      size: 20,
                    ),
                    onSelected: (String result) {
                      // Handle menu item selection
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDriverDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final licenseController = TextEditingController();
    final vehicleController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Driver'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Driver Name',
                        hintText: 'Enter driver name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: licenseController,
                      decoration: const InputDecoration(
                        labelText: 'License Number',
                        hintText: 'Enter license number',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: vehicleController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Number',
                        hintText: 'Enter vehicle number',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Active Status'),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                          activeColor: const Color(0xFF219653),
                        ),
                      ],
                    ),
                  ],
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
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty &&
                        licenseController.text.isNotEmpty &&
                        vehicleController.text.isNotEmpty) {
                      
                      // Get the driver provider
                      final driverProvider = Provider.of<DriverProvider>(context, listen: false);
                      
                      // Create a new driver model
                      final newDriver = DriverModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        licenseNumber: licenseController.text.trim(),
                        vehicleNumber: vehicleController.text.trim(),
                        status: DriverStatus.available,
                        completedDeliveries: 0,
                        joinedDate: DateTime.now(),
                        isActive: isActive,
                      );
                      
                      // Save the driver
                      final success = await driverProvider.createDriver(newDriver);
                      
                      if (success) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Driver added successfully'),
                              backgroundColor: Color(0xFF219653),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to add driver'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Add Driver'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}