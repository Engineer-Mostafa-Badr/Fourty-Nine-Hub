import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/shared_pref.dart';

part 'floating_navigator_state.dart';

class FloatingNavigatorCubit extends Cubit<FloatingNavigatorState> {
  FloatingNavigatorCubit() : super(UnActiveFloatNavigatorStatusState());

  static FloatingNavigatorCubit get(context) => BlocProvider.of(context);

  bool floatingNavigatorStatus = false;

  Future<void> getFloatingNavigatorStatus() async {
    floatingNavigatorStatus = await CacheManager.getFloatingNavigator();
  }

  Future<void> activeFloatingNavigator() async {
    floatingNavigatorStatus = !floatingNavigatorStatus;
    await CacheManager.isFloatingNavigatorOpen(floatingNavigatorStatus);
    emit(ActiveFloatNavigatorStatusState());
    print(floatingNavigatorStatus);
    print(
        'getFloatingNavigator saved to ${await CacheManager.getFloatingNavigator()}');
  }

  Future<void> unActiveFloatingNavigator() async {
    floatingNavigatorStatus = !floatingNavigatorStatus;
    await CacheManager.isFloatingNavigatorOpen(floatingNavigatorStatus);
    emit(UnActiveFloatNavigatorStatusState());
    print(floatingNavigatorStatus);
    print(
        'getFloatingNavigator saved to ${await CacheManager.getFloatingNavigator()}');
  }
}
