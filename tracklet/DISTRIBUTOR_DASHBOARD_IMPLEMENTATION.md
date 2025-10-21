# Distributor Dashboard Implementation

## Overview
This document describes the implementation of the Distributor Dashboard with Plant Request Order functionality.

## Folder Structure

```
tracklet/lib/
├── core/
│   ├── models/
│   │   └── plant_request_model.dart          # Model for plant cylinder requests
│   └── providers/
│       └── app_provider.dart                  # Updated with PlantRequestProvider
├── features/
│   └── distributor/
│       ├── dashboard/                         # NEW FOLDER
│       │   ├── distributor_request_dashboard.dart   # Main request dashboard
│       │   ├── create_plant_request_screen.dart     # Create new request screen
│       │   └── widgets/
│       │       ├── request_summary_card.dart        # Summary card widget
│       │       └── plant_request_card.dart          # Request card widget
│       ├── provider/
│       │   └── plant_request_provider.dart    # Provider for managing requests
│       └── view/
│           └── distributor_dashboard_screen.dart    # Updated with request button
```

## Features Implemented

### 1. Plant Request Model (`plant_request_model.dart`)
- **Enums:**
  - `PlantRequestStatus`: pending, approved, rejected, completed
  - `CylinderType`: small (5kg), medium (11kg), large (45kg)
  
- **Properties:**
  - Request ID and distributor information
  - Cylinder type and quantity
  - Request status and timestamps
  - Notes and rejection reason
  - Plant admin details

### 2. Plant Request Provider (`plant_request_provider.dart`)
- **State Management:**
  - Fetches requests from API
  - Creates new requests
  - Updates existing requests
  - Cancels requests
  
- **Getters:**
  - `pendingRequests`: Filters pending requests
  - `approvedRequests`: Filters approved requests
  - `completedRequests`: Filters completed requests
  - `rejectedRequests`: Filters rejected requests
  
- **Features:**
  - Error handling
  - Loading states
  - Sample data for demo purposes

### 3. Distributor Request Dashboard (`distributor_request_dashboard.dart`)
- **Main Features:**
  - Summary cards showing pending, approved, and completed counts
  - Pending requests section
  - Approved requests section
  - Recent requests section
  - Pull-to-refresh functionality
  - Floating action button to create new requests
  
- **UI Components:**
  - Clean, modern design
  - Color-coded status indicators
  - Empty state when no requests exist

### 4. Create Plant Request Screen (`create_plant_request_screen.dart`)
- **Form Fields:**
  - Cylinder type selector (visual cards)
  - Quantity input
  - Notes (optional)
  
- **Features:**
  - Form validation
  - Loading states during submission
  - Success/error feedback
  - Auto-navigation back after success

### 5. Widgets

#### Request Summary Card (`request_summary_card.dart`)
- Displays request statistics
- Customizable colors and icons
- Clean, card-based design

#### Plant Request Card (`plant_request_card.dart`)
- Shows request details:
  - Cylinder type and quantity
  - Request date and time
  - Status with color-coded chips
  - Notes (if available)
  - Plant admin name (if assigned)
- Tappable for navigation to details

### 6. Updated Distributor Dashboard Screen
- **New Features:**
  - Prominent "Request Cylinders" button
  - Gradient design with shadow
  - Direct navigation to request dashboard
  
- **Button Design:**
  - Eye-catching gradient background
  - Icon and descriptive text
  - Arrow indicator for navigation

## How to Use

### For Distributors:

1. **Access the Dashboard:**
   - Open the distributor dashboard
   - See the "Request Cylinders" button prominently displayed

2. **Create a Request:**
   - Click "Request Cylinders" button
   - OR use the floating action button in the request dashboard
   - Select cylinder type (Small/Medium/Large)
   - Enter quantity
   - Add notes (optional)
   - Submit the request

3. **View Requests:**
   - See summary of pending, approved, and completed requests
   - View detailed list of all requests
   - Pull down to refresh data
   - Check status updates from the plant

4. **Request Statuses:**
   - **Pending**: Waiting for plant approval (Orange)
   - **Approved**: Approved by plant admin (Green)
   - **Completed**: Cylinders delivered (Blue)
   - **Rejected**: Request declined (Red)

## Technical Details

### State Management
- Uses Provider pattern for state management
- Integrated with existing app provider structure
- Follows MVVM architecture

### API Integration
- Designed to work with REST API
- Endpoints:
  - `GET /distributor/plant-requests` - Fetch requests
  - `POST /distributor/plant-requests` - Create request
  - `PUT /distributor/plant-requests/:id` - Update request
  - `DELETE /distributor/plant-requests/:id` - Cancel request

### Error Handling
- Network errors handled gracefully
- Fallback to sample data for demo
- User-friendly error messages

## Color Scheme

- **Primary**: `#1A2B4C` (Dark Blue)
- **Pending**: `#FF9800` (Orange)
- **Approved**: `#4CAF50` (Green)
- **Rejected**: `#F44336` (Red)
- **Completed**: `#1A2B4C` (Blue)

## Next Steps (Future Enhancements)

1. **Request Details Screen:**
   - View full request details
   - Track request history
   - Cancel pending requests

2. **Notifications:**
   - Push notifications for status updates
   - In-app notification center

3. **Analytics:**
   - Request history charts
   - Cylinder usage trends
   - Delivery time analytics

4. **Filters and Search:**
   - Filter by status, date range
   - Search by request ID
   - Sort by various criteria

## Dependencies

The implementation uses the following packages:
- `provider`: State management
- `flutter/material.dart`: UI components
- `intl`: Date formatting

All dependencies are already included in the project's `pubspec.yaml`.

