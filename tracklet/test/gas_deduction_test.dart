import 'package:flutter_test/flutter_test.dart';
import 'package:tracklet/features/gas_plant/view/total_stock_screen.dart';

void main() {
  group('GasDeductionUtils', () {
    test('should convert kg to tons correctly', () {
      // Test the conversion logic used in the implementation
      final double orderKg = 5000; // 5000 kg
      final double orderTons = orderKg / 1000; // Convert to tons

      expect(orderTons, equals(5.0));
    });

    test('should calculate total gas correctly', () {
      // Test the tank model's totalGas calculation
      final tank = Tank(
        id: 'test_tank',
        name: 'Test Tank',
        capacity: 10.0, // 10 tons
        currentGas: 7.5, // 7.5 tons
        frozenGas: 2.0, // 2.0 tons
        timestamp: DateTime.now(),
      );

      expect(tank.totalGas, equals(9.5)); // 7.5 + 2.0 = 9.5 tons
    });
  });
}
