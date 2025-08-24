# Chat Feature

This is a complete chat feature implementation for the 49-app Flutter project, following clean architecture principles.

## Structure

```
chat_feature/
├── data/
│   └── chat_repository.dart
├── domain/
│   └── models/
│       ├── chat_model.dart
│       └── story_model.dart
├── presentation/
│   ├── controllers/
│   │   ├── chat_cubit.dart
│   │   └── chat_state.dart
│   ├── pages/
│   │   ├── chat_home_page.dart
│   │   └── pages.dart
│   └── widgets/
│       ├── chat_item_widget.dart
│       ├── category_tabs_widget.dart
│       ├── privacy_message_widget.dart
│       ├── stories_section_widget.dart
│       ├── story_item_widget.dart
│       └── widgets.dart
└── chat_feature.dart
```

## Features

### 1. Stories Section
- Horizontal scrollable stories with profile pictures
- "My Story" with add button
- Unviewed stories with red border
- Viewed stories with gray border

### 2. Category Tabs
- Social, Services, Unread, Call tabs
- Active tab highlighting
- Tab switching functionality

### 3. Chat List
- Individual chat items with profile pictures
- Contact names with verification badges
- Last message preview with status indicators
- Time stamps
- Unread message counts
- Mute and pin indicators
- Typing indicators

### 4. Privacy Message
- Bottom privacy message with lock icon
- Privacy features information

## Usage

### Access the Chat Home Page

Navigate to the chat home page using:

```dart
context.push(Routes.CHAT_HOME);
```

### Using the ChatCubit

```dart
// In your widget
BlocProvider<ChatCubit>(
  create: (_) => serviceLocator(),
  child: ChatHomePage(),
)

// Load chats
context.read<ChatCubit>().loadChats();

// Listen to state changes
BlocBuilder<ChatCubit, ChatState>(
  builder: (context, state) {
    if (state is ChatLoaded) {
      return ListView.builder(
        itemCount: state.chats.length,
        itemBuilder: (context, index) {
          return ChatItemWidget(chat: state.chats[index]);
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

## Components

### ChatItemWidget
Displays individual chat entries with:
- Profile picture
- Contact name and verification badge
- Last message with status
- Time and unread count
- Action icons (mute, pin, etc.)

### StoriesSectionWidget
Horizontal scrollable list of stories with:
- Story profile pictures
- Border styling for viewed/unviewed
- Add button for "My Story"

### CategoryTabsWidget
Tab navigation with:
- Social, Services, Unread, Call options
- Active state highlighting
- Callback for tab changes

### PrivacyMessageWidget
Bottom privacy message with:
- Lock icon
- Privacy features text

## State Management

The feature uses BLoC pattern with:
- `ChatCubit`: Main state management
- `ChatState`: State classes (Initial, Loading, Loaded, Error)
- Mock data for demonstration

## Customization

### Colors
Update colors in `app_colors.dart`:
- `AppColors.PRIMARY_COLOR`: Main theme color
- `AppColors.SECONDARY_COLOR`: Secondary theme color

### Styling
Modify widget styles using:
- `flutter_screenutil` for responsive design
- Custom text styles and themes

### Data
Replace mock data in `ChatCubit` with real API calls:
- Implement `ChatRepository`
- Add real data sources
- Connect to backend services

## Dependencies

- `flutter_bloc`: State management
- `equatable`: State comparison
- `flutter_screenutil`: Responsive design
- `go_router`: Navigation

## Integration

The feature is integrated with:
- `CustomScaffold`: App scaffold
- `HomeAppBar`: App bar component
- Service locator for dependency injection
- Existing routing system
