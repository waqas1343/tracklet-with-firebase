import 'package:flutter/foundation.dart';
import '../../../core/models/plant_request_model.dart';
import '../../../core/services/api_service.dart';

class PlantRequestProvider extends ChangeNotifier {
  final ApiService _apiService;

  PlantRequestProvider({required ApiService apiService})
    : _apiService = apiService;

  List<PlantRequestModel> _requests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PlantRequestModel> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<PlantRequestModel> get pendingRequests => _requests
      .where((request) => request.status == PlantRequestStatus.pending)
      .toList();

  List<PlantRequestModel> get approvedRequests => _requests
      .where((request) => request.status == PlantRequestStatus.approved)
      .toList();

  List<PlantRequestModel> get completedRequests => _requests
      .where((request) => request.status == PlantRequestStatus.completed)
      .toList();

  List<PlantRequestModel> get rejectedRequests => _requests
      .where((request) => request.status == PlantRequestStatus.rejected)
      .toList();

  Future<void> fetchRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/distributor/plant-requests');
      final requestsData = response['requests'] as List;
      _requests = requestsData
          .map((json) => PlantRequestModel.fromJson(json))
          .toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch requests: $e';
      // For demo purposes, use sample data
      _requests = _getSampleRequests();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRequest(PlantRequestModel request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '/distributor/plant-requests',
        request.toJson(),
      );
      final newRequest = PlantRequestModel.fromJson(response['request']);
      _requests.insert(0, newRequest);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create request: $e';
      // For demo purposes, add the request locally
      _requests.insert(0, request);
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> updateRequest(PlantRequestModel request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.put(
        '/distributor/plant-requests/${request.id}',
        request.toJson(),
      );
      final updatedRequest = PlantRequestModel.fromJson(response['request']);
      final index = _requests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _requests[index] = updatedRequest;
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update request: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelRequest(String requestId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.delete('/distributor/plant-requests/$requestId');
      _requests.removeWhere((request) => request.id == requestId);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel request: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Sample data for demo purposes
  List<PlantRequestModel> _getSampleRequests() {
    return [
      PlantRequestModel(
        id: '1',
        distributorId: 'D001',
        distributorName: 'Distributor Admin',
        cylinderType: CylinderType.medium,
        quantity: 50,
        status: PlantRequestStatus.pending,
        requestDate: DateTime.now().subtract(const Duration(hours: 2)),
        notes: 'Urgent request for medium cylinders',
      ),
      PlantRequestModel(
        id: '2',
        distributorId: 'D001',
        distributorName: 'Distributor Admin',
        cylinderType: CylinderType.large,
        quantity: 30,
        status: PlantRequestStatus.approved,
        requestDate: DateTime.now().subtract(const Duration(days: 1)),
        approvedDate: DateTime.now().subtract(const Duration(hours: 12)),
        notes: 'Regular monthly stock',
        plantAdminId: 'P001',
        plantAdminName: 'Plant Manager',
      ),
      PlantRequestModel(
        id: '3',
        distributorId: 'D001',
        distributorName: 'Distributor Admin',
        cylinderType: CylinderType.small,
        quantity: 100,
        status: PlantRequestStatus.completed,
        requestDate: DateTime.now().subtract(const Duration(days: 3)),
        approvedDate: DateTime.now().subtract(const Duration(days: 2)),
        completedDate: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Small cylinders for residential area',
        plantAdminId: 'P001',
        plantAdminName: 'Plant Manager',
      ),
    ];
  }
}
