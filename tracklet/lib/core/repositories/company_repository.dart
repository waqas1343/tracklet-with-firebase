import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company_model.dart';

/// CompanyRepository - Handles all Firestore operations for companies/gas plants
class CompanyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _companiesCollection = 'company';

  /// Get all companies from Firestore
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final querySnapshot = await _firestore
          .collection(_companiesCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CompanyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }

  /// Get a single company by ID
  Future<CompanyModel?> getCompanyById(String companyId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_companiesCollection)
          .doc(companyId)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return CompanyModel.fromJson({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });
    } catch (e) {
      throw Exception('Failed to fetch company: $e');
    }
  }

  /// Get companies stream for real-time updates
  Stream<List<CompanyModel>> getCompaniesStream() {
    return _firestore
        .collection(_companiesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => CompanyModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList();
        });
  }

  /// Create or update a company
  Future<bool> saveCompany(CompanyModel company) async {
    try {
      await _firestore
          .collection(_companiesCollection)
          .doc(company.id)
          .set(company.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      throw Exception('Failed to save company: $e');
    }
  }

  /// Delete a company
  Future<bool> deleteCompany(String companyId) async {
    try {
      await _firestore.collection(_companiesCollection).doc(companyId).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete company: $e');
    }
  }

  /// Search companies by name
  Future<List<CompanyModel>> searchCompaniesByName(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_companiesCollection)
          .orderBy('companyName')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();

      return querySnapshot.docs
          .map((doc) => CompanyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to search companies: $e');
    }
  }

  /// Get companies by owner ID
  Future<List<CompanyModel>> getCompaniesByOwner(String ownerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_companiesCollection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CompanyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch companies by owner: $e');
    }
  }
}
