import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_pref.dart';

part 'choice_ruler_state.dart';

class ChoiceRulerCubit extends Cubit<ChoiceRulerState> {
  ChoiceRulerCubit() : super(InitChoiceRulerStatusState());

  static ChoiceRulerCubit get(context) => BlocProvider.of(context);

  bool choiceRulerStatus = true;
  bool choiceRulerEnabled = true;

  Future<void> getChoiceRulerEnabledStatus() async {
    choiceRulerEnabled = await CacheManager.getEnabledChoiceRuler();
    changeChoiceRulerStatus(forceValue: choiceRulerEnabled);
    emit(GetEnableChoiceRulerStatusState());
  }

  Future<void> getChoiceRulerStatus() async {
    choiceRulerStatus = await CacheManager.getChoiceRuler();
    emit(GetChoiceRulerStatusState());
  }

  Future<void> changeChoiceRulerEnabled({bool? forceValue}) async {
    choiceRulerEnabled = forceValue ?? !choiceRulerEnabled;
    await CacheManager.isChoiceRulerEnabledOpen(choiceRulerEnabled);
    await changeChoiceRulerStatus(forceValue: choiceRulerEnabled);
    if (state is ActiveChoiceRulerStatusState) {
      emit(DisAbleChoiceRulerStatusState());
    } else {
      emit(EnableChoiceRulerStatusState());
    }
  }

  Future<void> changeChoiceRulerStatus({bool? forceValue}) async {
    choiceRulerStatus = forceValue ?? !choiceRulerStatus;
    await CacheManager.isChoiceRulerOpen(choiceRulerStatus);
    if (state is ActiveChoiceRulerStatusState) {
      emit(UnActiveChoiceRulerStatusState());
    } else {
      emit(ActiveChoiceRulerStatusState());
    }
  }

// Future<void> unActiveChoiceRuler() async {
//     choiceRulerStatus = true;
//     await CacheManager.isChoiceRulerOpen(choiceRulerStatus);
//     emit(UnActiveChoiceRulerStatusState());
//     print(choiceRulerStatus);
//     print('getChoiceRuler saved to ${await CacheManager.getChoiceRuler()}');
//
// }

// Future<void> disAbleChoiceRuler() async {
//   choiceRulerEnabled = true;
//   await CacheManager.isChoiceRulerEnabledOpen(choiceRulerEnabled);
//   await unActiveChoiceRuler();
//
//   emit(DisAbleChoiceRulerStatusState());
//   print(choiceRulerEnabled);
//   print(
//       'getEnabledChoiceRuler saved to ${await CacheManager.getEnabledChoiceRuler()}');
// }
}
