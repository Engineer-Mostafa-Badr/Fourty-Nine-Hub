import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_pref.dart';

part 'floating_navigator_state.dart';

class FloatingNavigatorCubit extends Cubit<FloatingNavigatorState> {
  FloatingNavigatorCubit() : super(UnActiveFloatNavigatorStatusState());

  static FloatingNavigatorCubit get(context) => BlocProvider.of(context);

  bool floatingNavigatorStatus = false;

  Future<void> activeFloatingNavigator() async {
    floatingNavigatorStatus = false;
    await CacheManager.isFloatingNavigatorOpen(floatingNavigatorStatus);
    emit(ActiveFloatNavigatorStatusState());
    print(floatingNavigatorStatus);
    print('getFloatingNavigator saved to ${await CacheManager.getFloatingNavigator()}');
  }

  Future<void> unActiveFloatingNavigator() async {
    floatingNavigatorStatus = true;
    await CacheManager.isFloatingNavigatorOpen(floatingNavigatorStatus);
    emit(UnActiveFloatNavigatorStatusState());
    print(floatingNavigatorStatus);
    print('getFloatingNavigator saved to ${await CacheManager.getFloatingNavigator()}');
  }

}
