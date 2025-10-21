# New Project Structure

## Overview
The project has been restructured to follow a feature-based architecture with dedicated folders for views, widgets, and providers within each feature. This approach provides better maintainability, scalability, and separation of concerns.

## Directory Structure

```
lib/
├── core/                           # Core functionality shared across features
│   ├── models/                     # Data models
│   │   ├── user_model.dart
│   │   ├── order_model.dart
│   │   ├── gas_rate_model.dart
│   │   ├── expense_model.dart
│   │   └── driver_model.dart
│   ├── services/                   # Business logic services
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
│   ├── routes/                     # Application routing
│   │   └── app_routes.dart
│   └── utils/                      # Utility functions
│       ├── app_colors.dart
│       ├── app_theme.dart
│       ├── constants.dart
│       ├── responsive_utils.dart
│       └── validators.dart
├── features/                       # Feature-based modules
│   ├── common/                     # Shared features
│   │   ├── view/                   # Common view screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── language_selection_screen.dart
│   │   │   └── login_screen.dart
│   │   ├── widgets/                # Common widgets
│   │   └── provider/               # Common providers
│   │       ├── auth_provider.dart
│   │       ├── language_provider.dart
│   │       └── theme_provider.dart
│   ├── gas_plant/                  # Gas Plant feature
│   │   ├── view/                   # Gas Plant view screens
│   │   │   ├── gas_plant_dashboard_view.dart
│   │   │   ├── gas_rate_screen.dart
│   │   │   ├── orders_screen.dart
│   │   │   ├── expenses_screen.dart
│   │   │   └── settings_screen.dart
│   │   ├── widgets/                # Gas Plant specific widgets
│   │   │   ├── custom_appbar.dart
│   │   │   ├── top_section.dart
│   │   │   ├── bottom_section.dart
│   │   │   ├── section_header_widget.dart
│   │   │   ├── stats_grid.dart
│   │   │   └── tabs/               # Tab-specific widgets
│   │   │       ├── pending_orders_tab.dart
│   │   │       ├── processing_orders_tab.dart
│   │   │       └── completed_orders_tab.dart
│   │   └── provider/               # Gas Plant providers
│   │       ├── order_provider.dart
│   │       ├── gas_rate_provider.dart
│   │       └── expense_provider.dart
│   └── distributor/                # Distributor feature
│       ├── view/                   # Distributor view screens
│       │   ├── distributor_dashboard_screen.dart
│       │   ├── distributor_orders_screen.dart
│       │   ├── drivers_screen.dart
│       │   └── distributor_settings_screen.dart
│       ├── widgets/                # Distributor specific widgets
│       │   ├── custom_appbar.dart
│       │   ├── driver_card.dart
│       │   └── tabs/               # Tab-specific widgets
│       │       ├── available_drivers_tab.dart
│       │       ├── busy_drivers_tab.dart
│       │       └── offline_drivers_tab.dart
│       └── provider/               # Distributor providers
│           └── driver_provider.dart
└── shared/                         # Shared widgets across features
    └── widgets/
        ├── custom_button.dart
        ├── custom_text_field.dart
        ├── custom_card.dart
        ├── loading_widget.dart
        ├── empty_state_widget.dart
        └── error_widget.dart
```

## Key Benefits

### 1. **Feature-Based Organization**
- Each feature is self-contained with its own views, widgets, and providers
- Easy to locate and modify feature-specific code
- Clear separation of concerns

### 2. **Reusable Components**
- Widgets are organized by feature and can be easily reused
- Tab components provide modular functionality
- Shared widgets are available across all features

### 3. **Scalability**
- Easy to add new features following the same structure
- New screens can be added to existing features
- Widgets can be extended and customized per feature

### 4. **Maintainability**
- Clear file organization makes code easier to maintain
- Related functionality is grouped together
- Easy to refactor individual features without affecting others

## Widget Components Created

### Gas Plant Widgets
- **CustomAppBar**: Reusable app bar component
- **TopSection**: Welcome section with user info
- **BottomSection**: Quick actions grid
- **SectionHeaderWidget**: Reusable section headers
- **StatsGrid**: Statistics display grid
- **Tab Components**: Pending, Processing, and Completed orders tabs

### Distributor Widgets
- **DistributorCustomAppBar**: Distributor-specific app bar
- **DriverCard**: Driver information display card
- **Tab Components**: Available, Busy, and Offline drivers tabs

## Updated Files
- `main.dart`: Updated provider imports
- `app_routes.dart`: Updated view imports
- All provider files moved to appropriate feature folders
- New dashboard view created using widget components

## Usage Example
The new structure allows for clean, modular code:

```dart
// Gas Plant Dashboard using widget components
class GasPlantDashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard'),
      body: Column(
        children: [
          TopSection(),
          StatsGrid(stats: stats),
          BottomSection(actions: quickActions),
        ],
      ),
    );
  }
}
```

This structure follows Flutter best practices and makes the codebase more maintainable and scalable for future development.
