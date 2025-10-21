# Order & Notification System - Complete Implementation Guide

## Overview
This document describes the complete order management and notification system implemented for the Tracklet application. The system enables distributors to request cylinders from gas plants, and gas plant operators to manage orders with real-time notifications.

## Architecture

### 1. Order System Components

#### Order Model (`lib/core/models/order_model.dart`)
**Properties:**
- `id`: Unique order identifier
- `distributorId/distributorName`: Distributor information
- `plantId/plantName/plantAddress/plantContact`: Gas plant information
- `pricePerKg`: Price per kilogram of gas
- `quantities`: Map of cylinder sizes and quantities (e.g., {"45.4": 3, "27.5": 2})
- `totalKg`: Total weight of all cylinders
- `totalPrice`: Price before discount
- `discountPerKg`: Discount amount per kilogram
- `finalPrice`: Final price after discount
- `specialInstructions`: Customer instructions
- `status`: Order status (pending, confirmed, inProgress, completed, cancelled)
- `driverName`: Assigned driver
- `createdAt/updatedAt`: Timestamps
- `deliveryDate`: Delivery completion date

**Key Methods:**
- `fromJson()`: Parse Firestore document
- `toJson()`: Convert to Firestore document
- `copyWith()`: Create copy with updated fields
- `formattedQuantities`: Get formatted quantity strings for display
- `statusColor`: Get color for UI status display
- `statusText`: Get formatted status text

#### Order Repository (`lib/core/repositories/order_repository.dart`)
**Key Methods:**
- `createOrder(OrderModel)`: Create new order
- `getOrdersForPlant(String plantId)`: Get all orders for a plant
- `getOrdersForDistributor(String distributorId)`: Get all orders for a distributor
- `getOrdersStreamForPlant(String plantId)`: Real-time orders stream for plant
- `getOrdersStreamForDistributor(String distributorId)`: Real-time orders stream for distributor
- `updateOrderStatus(String orderId, OrderStatus status, {String? driverName})`: Update order status
- `getPendingOrdersCount(String plantId)`: Get count of pending orders
- `getOrdersByStatus(String plantId, OrderStatus status)`: Filter orders by status

#### Order ViewModel (`lib/core/viewmodels/order_viewmodel.dart`)
**State Management:**
- `_orders`: List of all orders
- `_newOrders`: Filtered list of pending/confirmed orders
- `_distributorOrders`: Orders for distributor view
- `_isLoading`: Loading state
- `_error`: Error messages
- `_pendingOrdersCount`: Count of pending orders

**Key Methods:**
- `createOrder(OrderModel)`: Create order with notification
- `loadOrdersForPlant(String plantId)`: Load plant orders
- `loadOrdersForDistributor(String distributorId)`: Load distributor orders
- `updateOrderStatus(String orderId, OrderStatus status, {String? driverName})`: Update status with notification
- `getOrdersByStatus(String plantId, OrderStatus status)`: Filter orders

#### Order Provider (`lib/core/providers/order_provider.dart`)
Acts as bridge between UI and OrderViewModel, providing clean interface for widgets.

### 2. Notification System Components

#### Notification Model (`lib/core/models/notification_model.dart`)
**Properties:**
- `id`: Unique notification identifier
- `title`: Notification title
- `message`: Notification message
- `type`: Notification type (order, system, reminder, alert)
- `relatedId`: Related entity ID (order ID, etc.)
- `recipientId`: User ID who receives notification
- `senderId`: User ID who sent notification (optional)
- `isRead`: Read status
- `createdAt`: Creation timestamp

**Key Methods:**
- `fromJson()`: Parse Firestore document
- `toJson()`: Convert to Firestore document
- `copyWith()`: Create copy with updated fields
- `icon`: Get appropriate icon for notification type
- `color`: Get color for notification type
- `formattedTime`: Get human-readable time

#### Notification Repository (`lib/core/repositories/notification_repository.dart`)
**Key Methods:**
- `createNotification(NotificationModel)`: Create new notification
- `getNotificationsForUser(String userId)`: Get user notifications
- `getNotificationsStreamForUser(String userId)`: Real-time notifications stream
- `markAsRead(String notificationId)`: Mark single notification as read
- `markAllAsRead(String userId)`: Mark all user notifications as read
- `getUnreadCount(String userId)`: Get unread notifications count
- `createOrderNotification()`: Create order notification for gas plant
- `createOrderStatusNotification()`: Create status update notification for distributor

#### Notification ViewModel (`lib/core/viewmodels/notification_viewmodel.dart`)
**State Management:**
- `_notifications`: List of all notifications
- `_isLoading`: Loading state
- `_error`: Error messages
- `_unreadCount`: Count of unread notifications

**Key Methods:**
- `loadNotificationsForUser(String userId)`: Load user notifications
- `markAsRead(String notificationId)`: Mark notification as read
- `markAllAsRead(String userId)`: Mark all as read
- `deleteNotification(String notificationId)`: Delete notification
- `loadUnreadCount(String userId)`: Load unread count

#### Notification Provider (`lib/core/providers/notification_provider.dart`)
Acts as bridge between UI and NotificationViewModel.

## UI Screens

### 1. Cylinder Request Screen (`lib/features/distributor/view/cylinder_request_screen.dart`)

**Features:**
- Plant image display (with fallback icon)
- Plant name and price per KG
- Quantity selection for different cylinder sizes (45.4 KG, 27.5 KG, 15.0 KG, 11.8 KG)
- Quantity controls with +/- buttons
- Real-time total calculation (weight and price)
- Discount display (2 PKR per KG)
- Special instructions text field (100 character limit)
- Request Cylinder button (disabled if no quantities selected)

**UI Components:**
- `_buildPlaceholderImage()`: Plant image with fallback
- `_buildQuantityItem(String size)`: Quantity selector for each cylinder size
- `_buildQuantityButton()`: +/- buttons for quantity control
- `_buildSummarySection()`: Total weight, discount, and price display
- `_requestCylinder()`: Create order and navigate back

**Calculation Logic:**
- Total KG = Sum of (cylinder size × quantity) for all selected sizes
- Total Price = Total KG × Price per KG
- Final Price = Total Price - (Total KG × Discount per KG)

### 2. New Orders Screen (`lib/features/gas_plant/view/new_orders_screen.dart`)

**Features:**
- List of new orders (pending and confirmed)
- Order cards with distributor information
- Order details (weight, price, requested items)
- Special instructions display
- Action buttons based on order status:
  - Pending: Confirm/Reject buttons
  - Confirmed: Start Processing/Complete buttons
  - In Progress: Mark as Delivered button
- Order timestamp display
- Pull-to-refresh functionality
- Empty state when no orders

**Order Status Flow:**
1. **Pending**: Initial state when order is created
2. **Confirmed**: Gas plant accepts the order
3. **In Progress**: Order is being processed/prepared
4. **Completed**: Order has been delivered
5. **Cancelled**: Order is rejected or cancelled

**UI Components:**
- `_buildEmptyState()`: Empty state display
- `_buildOrderCard(OrderModel order)`: Order card with all details
- `_buildOrderDetailRow(String label, String value)`: Detail row display
- `_updateOrderStatus()`: Update order status with notifications

### 3. Notification Screen (`lib/features/common/view/notification_screen.dart`)

**Features:**
- List of all notifications for the user
- Unread notifications highlighted
- Notification type icons and colors
- Mark all as read button (when unread notifications exist)
- Pull-to-refresh functionality
- Empty state when no notifications
- Tap to mark individual notifications as read

**Notification Types:**
- **Order**: Blue color, shopping cart icon
- **System**: Green color, system update icon
- **Reminder**: Orange color, notifications icon
- **Alert**: Red color, warning icon

**UI Components:**
- `_buildEmptyState()`: Empty state display
- `_buildNotificationCard(NotificationModel notification)`: Notification card
- `_onNotificationTap()`: Handle notification tap
- `_markAllAsRead()`: Mark all notifications as read

### 4. Custom App Bar (`lib/core/widgets/custom_appbar.dart`)

**Enhanced Features:**
- Notification icon with unread count badge
- Real-time unread count updates
- Navigate to notification screen on tap
- Badge shows count (99+ for counts over 99)
- Red badge color for visibility

**Components:**
- `_buildNotificationButton()`: Notification button with badge
- `_navigateToNotifications()`: Navigate to notification screen

## Data Flow

### 1. Order Creation Flow (Distributor → Gas Plant)

1. **Distributor** opens distributor dashboard
2. **Distributor** taps "Request Cylinder" on a plant card
3. **CylinderRequestScreen** opens with plant details
4. **Distributor** selects quantities for different cylinder sizes
5. **Distributor** enters special instructions
6. **Distributor** taps "Request Cylinder"
7. **Order** is created in Firestore `orders` collection
8. **Notification** is created for the gas plant owner
9. **Gas plant** receives notification in app bar badge
10. **Gas plant** can view order in "New Orders" screen

### 2. Order Processing Flow (Gas Plant)

1. **Gas plant** opens "New Orders" screen
2. **Gas plant** sees pending order with distributor details
3. **Gas plant** can:
   - **Confirm**: Order status becomes "confirmed", distributor gets notification
   - **Reject**: Order status becomes "cancelled", distributor gets notification
4. **Confirmed orders** can be:
   - **Start Processing**: Status becomes "in_progress", distributor gets notification
   - **Complete**: Status becomes "completed", distributor gets notification
5. **In Progress orders** can be:
   - **Mark as Delivered**: Status becomes "completed", distributor gets notification

### 3. Notification Flow

1. **Order created** → Notification sent to gas plant
2. **Order status updated** → Notification sent to distributor
3. **User opens app** → Unread count loaded in app bar
4. **User taps notification icon** → Navigate to notification screen
5. **User taps notification** → Mark as read, navigate to related content
6. **User taps "Mark all as read"** → All notifications marked as read

## Firestore Collections

### Orders Collection (`orders`)
```javascript
{
  "id": "order_id=[generated]",
  "distributorId": "distributor_user_id",
  "distributorName": "Distributor Name",
  "plantId": "plant_user_id",
  "plantName": "Plant Name",
  "plantAddress": "Plant Address",
  "plantContact": "Plant Contact",
  "pricePerKg": 250.0,
  "quantities": {
    "45.4": 3,
    "27.5": 2,
    "15.0": 0,
    "11.8": 0
  },
  "totalKg": 210.0,
  "totalPrice": 52500.0,
  "discountPerKg": 2.0,
  "finalPrice": 51990.0,
  "specialInstructions": "Please deliver after 2 PM...",
  "status": "pending",
  "driverName": "Romail Ahmed",
  "createdAt": "2024-01-01T10:00:00Z",
  "updatedAt": "2024-01-01T11:00:00Z",
  "deliveryDate": "2024-01-01T15:00:00Z"
}
```

### Notifications Collection (`notifications`)
```javascript
{
  "id": "notification_id=[generated]",
  "title": "New Order Request",
  "message": "John Doe has requested cylinders from your plant",
  "type": "order",
  "relatedId": "order_id",
  "recipientId": "plant_user_id",
  "senderId": null,
  "isRead": false,
  "createdAt": "2024-01-01T10:00:00Z"
}
```

## Integration Points

### 1. Gas Plant Settings Screen
Added "New Orders" tile that navigates to the NewOrdersScreen.

### 2. Distributor Dashboard Screen
Updated plant cards to navigate to CylinderRequestScreen instead of showing dialog.

### 3. App Provider Registration
All new providers registered in AppProvider:
- `OrderProvider`
- `NotificationProvider`

### 4. Custom App Bar
Enhanced with notification functionality and real-time unread count.

## Testing Scenarios

### Test Case 1: Complete Order Flow
1. Login as Distributor
2. Open Dashboard → Tap "Request Cylinder" on any plant
3. Select quantities (e.g., 45.4 KG: 3, 27.5 KG: 2)
4. Add special instructions
5. Tap "Request Cylinder"
6. Verify success message and navigation back
7. Login as Gas Plant owner
8. Check notification badge in app bar
9. Open "New Orders" screen
10. Verify order appears with correct details
11. Tap "Confirm" on the order
12. Login back as Distributor
13. Check notification for order confirmation

### Test Case 2: Order Status Updates
1. As Gas Plant: Confirm order
2. As Distributor: Check notification
3. As Gas Plant: Start Processing order
4. As Distributor: Check notification
5. As Gas Plant: Complete order
6. As Distributor: Check final notification

### Test Case 3: Notification Management
1. Create multiple orders to generate notifications
2. Check unread count in app bar badge
3. Open notification screen
4. Verify all notifications appear
5. Tap individual notifications to mark as read
6. Tap "Mark all as read" button
7. Verify badge count becomes 0

## Performance Considerations

1. **Real-time Updates**: Using Firestore streams for live data
2. **Pagination**: Orders limited to recent items (can be extended)
3. **Caching**: Local state management with Provider
4. **Error Handling**: Comprehensive try-catch blocks
5. **Loading States**: Visual feedback during operations

## Security Considerations

1. **Firestore Rules**: Ensure proper read/write permissions
2. **User Authentication**: All operations require authenticated users
3. **Data Validation**: Input validation on all forms
4. **Error Messages**: User-friendly error handling

## Future Enhancements

1. **Push Notifications**: Firebase Cloud Messaging integration
2. **Order History**: Extended order history with filtering
3. **Driver Assignment**: Driver management system
4. **Delivery Tracking**: Real-time delivery tracking
5. **Payment Integration**: Payment processing for orders
6. **Order Templates**: Save common order configurations
7. **Bulk Operations**: Process multiple orders at once
8. **Analytics**: Order and notification analytics

## Conclusion

This implementation provides a complete order management and notification system that enables seamless communication between distributors and gas plants. The MVVM architecture ensures maintainability, while the real-time features provide immediate feedback to users. The system is designed to be scalable and can be extended with additional features as needed.
