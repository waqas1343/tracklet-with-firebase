import 'package:flutter/foundation.dart';
import '../../../core/models/gas_rate_model.dart';
import '../../../core/services/api_service.dart';

class GasRateProvider extends ChangeNotifier {
  final ApiService _apiService;

  GasRateProvider({required ApiService apiService}) : _apiService = apiService;

  List<GasRateModel> _gasRates = [];
  GasRateModel? _activeRate;
  bool _isLoading = false;
  String? _errorMessage;

  List<GasRateModel> get gasRates => _gasRates;
  GasRateModel? get activeRate => _activeRate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchGasRates() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/gas-rates');
      final ratesData = response['rates'] as List;
      _gasRates = ratesData.map((json) => GasRateModel.fromJson(json)).toList();
      _activeRate = _gasRates.firstWhere(
        (rate) => rate.isActive,
        orElse: () => _gasRates.first,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch gas rates: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createGasRate(GasRateModel rate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/gas-rates', rate.toJson());
      final newRate = GasRateModel.fromJson(response['rate']);
      _gasRates.insert(0, newRate);

      if (newRate.isActive) {
        // Deactivate other rates
        _activeRate = newRate;
        for (var i = 0; i < _gasRates.length; i++) {
          if (_gasRates[i].id != newRate.id) {
            _gasRates[i] = _gasRates[i].copyWith(isActive: false);
          }
        }
      }

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create gas rate: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGasRate(GasRateModel rate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.put(
        '/gas-rates/${rate.id}',
        rate.toJson(),
      );
      final updatedRate = GasRateModel.fromJson(response['rate']);
      final index = _gasRates.indexWhere((r) => r.id == rate.id);

      if (index != -1) {
        _gasRates[index] = updatedRate;
      }

      if (updatedRate.isActive) {
        _activeRate = updatedRate;
        // Deactivate other rates
        for (var i = 0; i < _gasRates.length; i++) {
          if (_gasRates[i].id != updatedRate.id) {
            _gasRates[i] = _gasRates[i].copyWith(isActive: false);
          }
        }
      }

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update gas rate: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setActiveRate(String rateId) async {
    final rate = _gasRates.firstWhere((r) => r.id == rateId);
    return await updateGasRate(rate.copyWith(isActive: true));
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
