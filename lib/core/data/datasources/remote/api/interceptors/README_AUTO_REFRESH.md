# AutoRefreshMixin Usage Guide

## Overview
The `AutoRefreshMixin` automatically refreshes cubit data when authentication tokens are refreshed. This ensures that your UI stays up-to-date after token refresh operations.

## How It Works
1. When a request fails with 401 (unauthorized), the `AuthInterceptor` automatically refreshes the token
2. After successful token refresh, the interceptor notifies all active cubits via `DataRefreshEvent`
3. Cubits using `AutoRefreshMixin` automatically refresh their data
4. The UI updates with fresh data without manual intervention

## Implementation Steps

### 1. Import the Mixin
```dart
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/auth_interceptor.dart';
```

### 2. Add Mixin to Your Cubit
```dart
class YourCubit extends Cubit<YourState> with AutoRefreshMixin {
  // Your cubit implementation
}
```

### 3. Initialize in Constructor
```dart
YourCubit() : super(YourInitialState()) {
  // Initialize auto-refresh functionality
  initializeAutoRefresh();
}
```

### 4. Implement onTokenRefreshed Method
```dart
@override
void onTokenRefreshed() {
  print('🔄 YourCubit: Token refreshed, refreshing data...');
  // Refresh your data here
  loadData();
  // or any other method that fetches fresh data
}
```

### 5. Clean Up in Dispose
```dart
@override
Future<void> close() {
  disposeAutoRefresh();
  return super.close();
}
```

## Complete Example

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/auth_interceptor.dart';

class HomeCubit extends Cubit<HomeState> with AutoRefreshMixin {
  HomeCubit() : super(HomeInitial()) {
    // Initialize auto-refresh functionality
    initializeAutoRefresh();
  }

  @override
  void onTokenRefreshed() {
    print('🔄 HomeCubit: Token refreshed, refreshing home data...');
    // Refresh home screen data
    loadHomeData();
    loadUserProfile();
    loadNotifications();
  }

  @override
  Future<void> close() {
    disposeAutoRefresh();
    return super.close();
  }

  // Your other methods...
  void loadHomeData() {
    // Implementation
  }
}
```

## Benefits
- **Automatic Data Refresh**: No need to manually handle token refresh scenarios
- **Consistent UI State**: All screens stay synchronized after token refresh
- **Better User Experience**: Users see fresh data immediately after authentication issues
- **Reduced Code Duplication**: Centralized token refresh handling

## When to Use
- **Home Screen Cubits**: Refresh user-specific data
- **Profile Cubits**: Update user information
- **Feed Cubits**: Refresh content lists
- **Any Cubit with User-Specific Data**: That needs to be updated after token refresh

## Notes
- The mixin automatically handles subscription management
- Multiple cubits can listen to the same refresh event
- The refresh event is fired only after successful token refresh
- Failed token refresh attempts don't trigger data refresh

