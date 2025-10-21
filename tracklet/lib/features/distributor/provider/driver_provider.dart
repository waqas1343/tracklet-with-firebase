import 'package:flutter/foundation.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/services/api_service.dart';

class DriverProvider extends ChangeNotifier {
  final ApiService _apiService;

  DriverProvider({required ApiService apiService}) : _apiService = apiService;

  List<DriverModel> _drivers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DriverModel> get drivers => _drivers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<DriverModel> get availableDrivers => _drivers
      .where(
        (driver) => driver.status == DriverStatus.available && driver.isActive,
      )
      .toList();

  List<DriverModel> get busyDrivers =>
      _drivers.where((driver) => driver.status == DriverStatus.busy).toList();

  List<DriverModel> get offlineDrivers => _drivers
      .where((driver) => driver.status == DriverStatus.offline)
      .toList();

  Future<void> fetchDrivers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/drivers');
      final driversData = response['drivers'] as List;
      _drivers = driversData.map((json) => DriverModel.fromJson(json)).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch drivers: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDriver(DriverModel driver) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/drivers', driver.toJson());
      final newDriver = DriverModel.fromJson(response['driver']);
      _drivers.insert(0, newDriver);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create driver: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDriver(DriverModel driver) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.put(
        '/drivers/${driver.id}',
        driver.toJson(),
      );
      final updatedDriver = DriverModel.fromJson(response['driver']);
      final index = _drivers.indexWhere((d) => d.id == driver.id);
      if (index != -1) {
        _drivers[index] = updatedDriver;
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update driver: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteDriver(String driverId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.delete('/drivers/$driverId');
      _drivers.removeWhere((driver) => driver.id == driverId);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete driver: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDriverStatus(String driverId, DriverStatus status) async {
    final driver = _drivers.firstWhere((d) => d.id == driverId);
    return await updateDriver(driver.copyWith(status: status));
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
