import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_pref.dart';

part 'floating_navigator_state.dart';

class FloatingNavigatorCubit extends Cubit<FloatingNavigatorState> {
  FloatingNavigatorCubit() : super(InitFloatNavigatorStatusState());

  static FloatingNavigatorCubit get(context) => BlocProvider.of(context);

  bool floatingNavigatorStatus = false;
  bool floatingNavigatorEnable = true;


  Future<void> getEnableFloatingNavigatorStatus() async {
    floatingNavigatorEnable = await CacheManager.getFloatingNavigatorEnable();
    emit(GetEnableFloatNavigatorState());
  }

  Future<void> getFloatingNavigatorStatus() async {
    await CacheManager.isFloatingNavigatorOpen(false);
    // floatingNavigatorStatus = await CacheManager.getFloatingNavigator();
    floatingNavigatorStatus = false;
    emit(GetFloatNavigatorStatusState());
  }

  Future<void> changeFloatingNavigator({bool? forceValue}) async {
    floatingNavigatorStatus = !floatingNavigatorStatus;
    await CacheManager.isFloatingNavigatorOpen(floatingNavigatorStatus);
    if (state is ActiveFloatNavigatorStatusState) {
      emit(UnActiveFloatNavigatorStatusState());
    } else {
      emit(ActiveFloatNavigatorStatusState());
    }
    print(floatingNavigatorStatus);
    print(
        'getFloatingNavigator saved to ${await CacheManager
            .getFloatingNavigator()}');
  }

  Future<void> changeFloatingNavigatorEnable({bool? forceValue}) async {
    floatingNavigatorEnable = !floatingNavigatorEnable;
    await CacheManager.isFloatingNavigatorEnabledOpen(floatingNavigatorEnable);
    if (state is EnableFloatNavigatorState) {
      emit(DisAbleFloatNavigatorState());
    } else {
      emit(EnableFloatNavigatorState());
    }
    print(floatingNavigatorEnable);
    print(
        'getFloatingNavigator saved to ${await CacheManager
            .getFloatingNavigatorEnable()}');
  }
}
