# Company Module - MVVM Implementation Guide

## Overview
This document describes the complete MVVM architecture implementation for managing gas plant companies in the Tracklet application. The module enables Gas Plant users to manage their company information and Distributor users to view all available plants.

## Architecture

### 1. Model Layer
**File**: `lib/core/models/company_model.dart`

The `CompanyModel` represents a gas plant company with the following properties:
- `id`: Unique identifier (uses user's UID)
- `companyName`: Name of the gas plant
- `contactNumber`: Contact phone number
- `address`: Physical address
- `operatingHours`: Business hours (e.g., "8:00 AM - 6:00 PM")
- `imageUrl`: Optional company logo/image URL
- `ownerId`: User ID of the company owner
- `createdAt`: Timestamp of creation
- `updatedAt`: Timestamp of last update

**Key Methods**:
- `fromJson()`: Parse Firestore document to model
- `toJson()`: Convert model to Firestore document
- `copyWith()`: Create a copy with updated fields

### 2. Repository Layer
**File**: `lib/core/repositories/company_repository.dart`

The `CompanyRepository` handles all Firestore operations for the `company` collection.

**Key Methods**:
- `getAllCompanies()`: Fetch all companies ordered by creation date
- `getCompanyById(String companyId)`: Get a specific company
- `getCompaniesStream()`: Real-time stream of companies
- `saveCompany(CompanyModel company)`: Create or update a company
- `deleteCompany(String companyId)`: Remove a company
- `searchCompaniesByName(String query)`: Search companies by name
- `getCompaniesByOwner(String ownerId)`: Get companies owned by a specific user

**Firestore Collection Structure**:
```
company/
  ├── {userId}/
  │   ├── id: string
  │   ├── companyName: string
  │   ├── contactNumber: string
  │   ├── address: string
  │   ├── operatingHours: string
  │   ├── imageUrl: string (optional)
  │   ├── ownerId: string
  │   ├── createdAt: timestamp
  │   └── updatedAt: timestamp
```

### 3. ViewModel Layer
**File**: `lib/core/viewmodels/company_viewmodel.dart`

The `CompanyViewModel` contains business logic and state management.

**State Properties**:
- `companies`: List of all companies
- `topPlants`: Limited list for dashboard (first 10)
- `isLoading`: Loading state indicator
- `error`: Error message if any
- `hasCompanies`: Boolean indicating if companies exist

**Key Methods**:
- `loadAllCompanies()`: Load all companies from Firestore
- `loadCompanyById(String companyId)`: Load specific company
- `companiesStream`: Real-time updates stream
- `searchCompanies(String query)`: Search functionality
- `saveCompany(CompanyModel company)`: Save or update company
- `deleteCompany(String companyId)`: Remove company
- `refreshCompanies()`: Refresh company list
- `clearData()`: Clear all data (on logout)

### 4. Provider Layer
**File**: `lib/core/providers/company_provider.dart`

The `CompanyProvider` acts as a bridge between UI and ViewModel, following the MVVM pattern.

**Public Interface**:
All methods delegate to the underlying `CompanyViewModel` and notify listeners on state changes.

### 5. App Provider Registration
**File**: `lib/core/providers/app_provider.dart`

The `CompanyProvider` is registered in the app-wide `MultiProvider`:
```dart
ChangeNotifierProvider<CompanyProvider>(
  create: (_) => CompanyProvider(),
),
```

## Data Flow

### Gas Plant User Flow (Creating/Updating Company)
1. User opens **Manage Plant Screen**
2. User enters/edits company information:
   - Plant Name
   - Contact Number
   - Address
   - Operating Hours
   - Plant Image (optional)
3. User taps **Save Changes**
4. Data is saved to:
   - User's profile in `users` collection (via ProfileProvider)
   - Company document in `company` collection (via CompanyProvider)
5. Success/error message displayed

**Code Implementation** (`manage_plant_screen.dart`):
```dart
final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
final companyProvider = Provider.of<CompanyProvider>(context, listen: false);

// Update user profile
await profileProvider.updateProfile(
  phone: contactController.text.trim(),
  companyName: plantNameController.text.trim(),
  address: addressController.text.trim(),
  operatingHours: operatingHoursController.text.trim(),
);

// Save to company collection
final company = CompanyModel(
  id: currentUser.id,
  companyName: plantNameController.text.trim(),
  contactNumber: contactController.text.trim(),
  address: addressController.text.trim(),
  operatingHours: operatingHoursController.text.trim(),
  ownerId: currentUser.id,
  createdAt: currentUser.createdAt,
  updatedAt: DateTime.now(),
);
await companyProvider.saveCompany(company);
```

### Distributor User Flow (Viewing Companies)
1. User opens **Distributor Dashboard**
2. On screen load, `CompanyProvider.loadAllCompanies()` is called
3. Companies are fetched from Firestore
4. **Top Plants** section displays companies
5. Each plant card shows:
   - Company Image (or default icon)
   - Company Name
   - Address
   - Operating Hours
   - **Request Cylinder** button
6. User can search companies using search bar

**Code Implementation** (`distributor_dashboard_screen.dart`):
```dart
final companyProvider = Provider.of<CompanyProvider>(context);

// Auto-load companies on first build
if (!companyProvider.isLoading && companyProvider.companies.isEmpty) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    companyProvider.loadAllCompanies();
  });
}

// Display companies
ListView.builder(
  itemCount: topPlants.length,
  itemBuilder: (context, index) {
    return _buildPlantCard(context, topPlants[index]);
  },
)
```

## UI Components

### Manage Plant Screen (Gas Plant)
**Location**: `lib/features/gas_plant/settings/manage_plant_screen.dart`

**Features**:
- Form fields for company information
- Image upload section (placeholder for future implementation)
- Form validation
- Save button with loading state
- Success/error feedback via SnackBar

### Distributor Dashboard - Top Plants Section
**Location**: `lib/features/distributor/view/distributor_dashboard_screen.dart`

**Features**:
- Horizontal scrollable plant cards
- Loading indicator while fetching
- Empty state when no plants available
- Search functionality
- Plant card with image, name, address, hours
- "Request Cylinder" button per plant

## State Management

### Loading States
- `isLoading`: Indicates when data is being fetched or saved
- UI shows `CircularProgressIndicator` or disables buttons

### Error Handling
- All repository operations wrapped in try-catch
- Errors propagated to ViewModel
- ViewModel sets `error` state
- UI displays error messages via SnackBar or error widgets

### Real-time Updates
The `companiesStream` provides real-time updates:
```dart
Stream<List<CompanyModel>> get companiesStream {
  return _repository.getCompaniesStream().map((companies) {
    _companies = companies;
    _updateTopPlants();
    notifyListeners();
    return companies;
  });
}
```

## Search Functionality

Users can search companies by name:
```dart
TextField(
  onChanged: (value) {
    companyProvider.searchCompanies(value);
  },
)
```

The search uses Firestore's `startAt` and `endAt` queries for prefix matching.

## Best Practices Implemented

1. **MVVM Separation**:
   - Models: Data structures
   - Repository: Data operations
   - ViewModel: Business logic
   - Provider: State management
   - View: UI only

2. **Single Responsibility**:
   - Each class has one clear purpose
   - Repository handles Firestore
   - ViewModel handles logic
   - Provider bridges UI and ViewModel

3. **StatelessWidget**:
   - All screens are StatelessWidget
   - State managed by Provider
   - No local state in widgets

4. **Error Handling**:
   - Try-catch blocks in all async operations
   - User-friendly error messages
   - Graceful fallbacks

5. **Loading States**:
   - Visual feedback during operations
   - Disabled buttons while loading
   - Progress indicators

6. **Code Reusability**:
   - Shared widgets (CustomButton, CustomTextField)
   - Consistent styling (AppTextTheme, AppColors)
   - Validators for form validation

## Testing the Implementation

### Test Case 1: Create Company (Gas Plant User)
1. Login as Gas Plant user
2. Navigate to Settings → Manage Plant
3. Fill in all fields:
   - Plant Name: "Test Gas Plant"
   - Contact: "1234567890"
   - Address: "123 Test St"
   - Operating Hours: "9 AM - 5 PM"
4. Tap Save Changes
5. Verify success message
6. Check Firestore console for document in `company` collection

### Test Case 2: View Companies (Distributor User)
1. Login as Distributor user
2. Open Dashboard
3. Verify companies load in Top Plants section
4. Check that company created in Test Case 1 appears
5. Verify company details display correctly

### Test Case 3: Search Companies
1. As Distributor, type in search bar
2. Verify filtered results appear
3. Clear search to show all companies

### Test Case 4: Update Company
1. As Gas Plant user, edit company info
2. Save changes
3. As Distributor, verify updated info appears

## Future Enhancements

1. **Image Upload**:
   - Implement Firebase Storage integration
   - Upload company logo/image
   - Display images in plant cards

2. **Filtering**:
   - Filter by location
   - Filter by operating hours
   - Sort by distance

3. **Favorites**:
   - Distributors can favorite plants
   - Quick access to favorite plants

4. **Reviews & Ratings**:
   - Distributors rate/review plants
   - Display ratings on plant cards

5. **Pagination**:
   - Implement lazy loading for large datasets
   - Load more companies on scroll

6. **Caching**:
   - Cache company data locally
   - Reduce Firestore reads
   - Offline support

## Troubleshooting

### Issue: Companies not loading
- Check Firestore rules allow read access
- Verify collection name is `company`
- Check console for error messages
- Ensure Firebase is initialized

### Issue: Company not saving
- Check Firestore rules allow write access
- Verify user is authenticated
- Check form validation
- Review console errors

### Issue: Search not working
- Verify Firestore index for `companyName` field
- Check search query formatting
- Ensure proper error handling

## Conclusion

This module demonstrates a complete MVVM implementation with Firebase integration, following Flutter best practices and maintaining clean architecture principles. The separation of concerns ensures maintainability, testability, and scalability for future enhancements.

