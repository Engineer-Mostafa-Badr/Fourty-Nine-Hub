import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Mock/Stub implementations for Widgetbook
class MockUserCubit extends Cubit<MockUserState> {
  MockUserCubit() : super(MockUserState());
  
  bool get isLoggedIn => true; // Default to logged in for testing
  
  Future<dynamic> createNormalChat({
    required String otherId, 
    required String categoryId
  }) async {
    // Mock implementation - return a fake chat entity
    return MockChatEntity(id: 'mock_chat_id');
  }
}

class MockUserState {
  final String? id;
  final String? name;
  
  MockUserState({this.id = 'mock_user_id', this.name = 'Mock User'});
}

class MockChatEntity {
  final String id;
  MockChatEntity({required this.id});
}

class MockFloatingNavigatorCubit extends Cubit<MockFloatingNavigatorState> {
  MockFloatingNavigatorCubit() : super(MockFloatingNavigatorState());
  
  bool floatingNavigatorEnable = false;
  bool floatingNavigatorStatus = false;
  
  static MockFloatingNavigatorCubit get(context) => BlocProvider.of(context);
  
  void changeFloatingNavigator() {
    floatingNavigatorStatus = !floatingNavigatorStatus;
    emit(MockFloatingNavigatorState());
  }
}

class MockFloatingNavigatorState {}

class MockChoiceRulerCubit extends Cubit<MockChoiceRulerState> {
  MockChoiceRulerCubit() : super(MockChoiceRulerState());
  
  bool choiceRulerStatus = false;
  
  void changeChoiceRulerStatus({bool? forceValue}) {
    choiceRulerStatus = forceValue ?? !choiceRulerStatus;
    emit(MockChoiceRulerState());
  }
}

class MockChoiceRulerState {}

// Provider wrapper for Widgetbook
class WidgetbookProviderWrapper extends StatelessWidget {
  final Widget child;
  
  const WidgetbookProviderWrapper({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MockUserCubit>(
          create: (context) => MockUserCubit(),
        ),
        BlocProvider<MockFloatingNavigatorCubit>(
          create: (context) => MockFloatingNavigatorCubit(),
        ),
        BlocProvider<MockChoiceRulerCubit>(
          create: (context) => MockChoiceRulerCubit(),
        ),
      ],
      child: child,
    );
  }
}