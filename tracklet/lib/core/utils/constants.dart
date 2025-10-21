class AppConstants {
  // App Info
  static const String appName = 'Tracklet';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = 'https://api.example.com';
  static const int apiTimeout = 30;

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;
  static const int maxPhoneLength = 20;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Currency
  static const String currencySymbol = 'PKR';
  static const String currencyFormat = '###,###,##0.00';

  // Units
  static const String gasUnit = 'kg';
  static const String distanceUnit = 'km';

  // Splash Screen Duration
  static const Duration splashDuration = Duration(seconds: 3);

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Debounce Duration
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // Snackbar Duration
  static const Duration snackbarDuration = Duration(seconds: 3);

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);

  // Regex Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9+\-\s()]+$';
  static const String numberPattern = r'^[0-9]+$';
  static const String decimalPattern = r'^[0-9]+\.?[0-9]*$';

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String sessionExpired = 'Session expired. Please login again.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logout successful!';
  static const String updateSuccess = 'Updated successfully!';
  static const String deleteSuccess = 'Deleted successfully!';
  static const String createSuccess = 'Created successfully!';

  // Field Labels
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String nameLabel = 'Name';
  static const String phoneLabel = 'Phone';
  static const String addressLabel = 'Address';
  static const String companyNameLabel = 'Company Name';

  // Button Labels
  static const String loginButton = 'Login';
  static const String logoutButton = 'Logout';
  static const String signupButton = 'Sign Up';
  static const String submitButton = 'Submit';
  static const String cancelButton = 'Cancel';
  static const String saveButton = 'Save';
  static const String deleteButton = 'Delete';
  static const String editButton = 'Edit';
  static const String viewButton = 'View';

  // Navigation Labels
  static const String dashboardLabel = 'Dashboard';
  static const String ordersLabel = 'Orders';
  static const String settingsLabel = 'Settings';
  static const String gasRateLabel = 'Gas Rate';
  static const String expensesLabel = 'Expenses';
  static const String driversLabel = 'Drivers';
  static const String profileLabel = 'Profile';

  // Empty State Messages
  static const String noOrdersMessage = 'No orders found.';
  static const String noExpensesMessage = 'No expenses found.';
  static const String noDriversMessage = 'No drivers found.';
  static const String noDataMessage = 'No data available.';
}
