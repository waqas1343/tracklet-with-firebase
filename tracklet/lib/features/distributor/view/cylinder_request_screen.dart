import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/company_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/utils/app_text_theme.dart';
import '../../../core/utils/app_colors.dart';

class CylinderRequestScreen extends StatefulWidget {
  final CompanyModel company;

  const CylinderRequestScreen({super.key, required this.company});

  @override
  State<CylinderRequestScreen> createState() => _CylinderRequestScreenState();
}

class _CylinderRequestScreenState extends State<CylinderRequestScreen> {
  final Map<String, int> _quantities = {
    '45.4': 0,
    '27.5': 0,
    '15.0': 0,
    '11.8': 0,
  };

  final double _pricePerKg = 250.0;
  final double _discountPerKg = 2.0;
  final TextEditingController _specialInstructionsController =
      TextEditingController(
        text: 'Please deliver after 2 PM. Handle cylinders carefully.',
      );

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = profileProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            // Plant Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child:
                    widget.company.imageUrl != null &&
                        widget.company.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.company.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant Name
                    Text(
                      widget.company.companyName,
                      style: AppTextTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),

                    // Price
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Per KG Price: ',
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextSpan(
                            text: 'Rs. ${_pricePerKg.toInt()}',
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quantity Selection
                    Text(
                      'Select Quantity:',
                      style: AppTextTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quantity Items
                    ..._quantities.keys.map((size) => _buildQuantityItem(size)),

                    const SizedBox(height: 16),

                    // Divider
                    const Divider(),
                    const SizedBox(height: 16),

                    // Total Summary
                    _buildSummarySection(),

                    const SizedBox(height: 16),

                    // Divider
                    const Divider(),
                    const SizedBox(height: 16),

                    // Special Instructions
                    Text(
                      'Special Instructions:',
                      style: AppTextTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _specialInstructionsController,
                        maxLines: 3,
                        maxLength: 100,
                        decoration: InputDecoration(
                          hintText: 'Enter special instructions...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Request Cylinder Button
                    CustomButton(
                      text: orderProvider.isLoading
                          ? 'Sending Request...'
                          : 'Request Cylinder',
                      onPressed: orderProvider.isLoading || !_hasSelectedQuantity()
                          ? null
                          : () => _requestCylinder(context, user, orderProvider),
                      width: double.infinity,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.white,
                      height: 50,
                      borderRadius: 12,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Center(
        child: Icon(Icons.landscape, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _buildQuantityItem(String size) {
    final quantity = _quantities[size]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$size KG', style: AppTextTheme.titleMedium),
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: quantity > 0
                    ? () => _updateQuantity(size, quantity - 1)
                    : null,
              ),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  quantity.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  style: AppTextTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: () => _updateQuantity(size, quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: onPressed != null ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: onPressed != null ? AppColors.white : Colors.grey.shade600,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSummarySection() {
    final totalKg = _calculateTotalKg();
    final finalPrice = _calculateFinalPrice();

    return Column(
      children: [
        // Total KG
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Kg:', style: AppTextTheme.titleMedium),
            Text(
              '${totalKg.toInt()} KG',
              style: AppTextTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Discount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Request Discount:', style: AppTextTheme.titleMedium),
            Row(
              children: [
                Text(
                  '${_discountPerKg.toInt()} pkr Per Kg',
                  style: AppTextTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Total Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Price:', style: AppTextTheme.titleMedium),
            Text(
              '${finalPrice.toInt()} PKR',
              style: AppTextTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _updateQuantity(String size, int newQuantity) {
    setState(() {
      _quantities[size] = newQuantity.clamp(0, 99);
    });
  }

  double _calculateTotalKg() {
    return _quantities.entries.fold(0.0, (sum, entry) {
      return sum + (double.parse(entry.key) * entry.value);
    });
  }

  double _calculateTotalPrice() {
    return _calculateTotalKg() * _pricePerKg;
  }

  double _calculateFinalPrice() {
    final totalKg = _calculateTotalKg();
    final discount = totalKg * _discountPerKg;
    return _calculateTotalPrice() - discount;
  }

  bool _hasSelectedQuantity() {
    return _quantities.values.any((quantity) => quantity > 0);
  }

  Future<void> _requestCylinder(
    BuildContext context,
    user,
    OrderProvider orderProvider,
  ) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final totalKg = _calculateTotalKg();
    final totalPrice = _calculateTotalPrice();
    final finalPrice = _calculateFinalPrice();

    final order = OrderModel(
      id: '', // Will be generated by Firestore
      distributorId: user.id,
      distributorName: user.name,
      plantId: widget.company.id,
      plantName: widget.company.companyName,
      plantAddress: widget.company.address,
      plantContact: widget.company.contactNumber,
      pricePerKg: _pricePerKg,
      quantities: Map.from(_quantities)
        ..removeWhere((key, value) => value == 0),
      totalKg: totalKg,
      totalPrice: totalPrice,
      discountPerKg: _discountPerKg,
      finalPrice: finalPrice,
      specialInstructions: _specialInstructionsController.text.trim(),
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    if (kDebugMode) {
      print('Creating order for plant:');
      print('Plant ID: ${widget.company.id}');
      print('Plant Name: ${widget.company.companyName}');
      print('Distributor ID: ${user.id}');
      print('Distributor Name: ${user.name}');
      print('Order details: ${order.toJson()}');
    }

    final success = await orderProvider.createOrder(order);

    if (success) {
      if (kDebugMode) {
        print('Order created successfully');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cylinder request sent successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Pop back to the previous screen
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      if (kDebugMode) {
        print('Failed to create order: ${orderProvider.error}');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orderProvider.error ?? 'Failed to send cylinder request',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}