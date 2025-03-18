import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_pref.dart';

part 'choice_ruler_state.dart';

class ChoiceRulerCubit extends Cubit<ChoiceRulerState> {
  ChoiceRulerCubit() : super(InitChoiceRulerStatusState());

  static ChoiceRulerCubit get(context) => BlocProvider.of(context);

  bool choiceRulerStatus = false;
  bool choiceRulerEnabled = true;

  Future<void> getChoiceRulerEnabledStatus() async {
    choiceRulerEnabled = await CacheManager.getEnabledChoiceRuler();
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
    if (state is EnableChoiceRulerStatusState) {
      emit(DisAbleChoiceRulerStatusState());
    } else {
      emit(EnableChoiceRulerStatusState());
    }
  }

  Future<void> changeChoiceRulerStatus({bool? forceValue}) async {
    if (choiceRulerEnabled) {
      choiceRulerStatus = forceValue ?? !choiceRulerStatus;
    } else {
      choiceRulerStatus = false;
    }
    await CacheManager.isChoiceRulerOpen(choiceRulerStatus);
    if (state is ActiveChoiceRulerStatusState) {
      emit(UnActiveChoiceRulerStatusState());
    } else {
      emit(ActiveChoiceRulerStatusState());
    }
  }
}
