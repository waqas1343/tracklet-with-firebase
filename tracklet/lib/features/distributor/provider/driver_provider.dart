import 'package:flutter/foundation.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/repositories/driver_repository.dart';

class DriverProvider extends ChangeNotifier {
  final DriverRepository _repository;

  DriverProvider() : _repository = DriverRepository();

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
      _drivers = await _repository.getAllDrivers();
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
      final success = await _repository.saveDriver(driver);
      if (success) {
        _drivers.insert(0, driver);
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return success;
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
      final success = await _repository.saveDriver(driver);
      if (success) {
        final index = _drivers.indexWhere((d) => d.id == driver.id);
        if (index != -1) {
          _drivers[index] = driver;
        }
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return success;
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
      final success = await _repository.deleteDriver(driverId);
      if (success) {
        _drivers.removeWhere((driver) => driver.id == driverId);
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Failed to delete driver: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDriverStatus(String driverId, DriverStatus status) async {
    final driverIndex = _drivers.indexWhere((d) => d.id == driverId);
    if (driverIndex == -1) return false;
    
    final updatedDriver = _drivers[driverIndex].copyWith(status: status);
    return await updateDriver(updatedDriver);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}