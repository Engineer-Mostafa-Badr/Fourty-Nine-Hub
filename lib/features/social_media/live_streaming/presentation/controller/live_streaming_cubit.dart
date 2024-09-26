// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';

import '../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../zoom/presentation/controller/stream_state.dart';
import '../../../tinder/data/models/gift_model.dart';

extension TiktokController on StreamCubit {
  void setTopic(String? option,String? optionId) {
    emit(state.copyWith(status: StreamsStates.changeTopic, topic: option,topicId: optionId));
  }

  Future<void> getTopics() async {
    emit(state.copyWith(status: StreamsStates.loading));
    var result = await getAllTopicsUseCase(const NoParams());
    result.fold(
        (l) => emit(state.copyWith(status: StreamsStates.failure, failure: l)),
        (r) {
      topics = r;
      emit(state.copyWith(status: StreamsStates.success));
    });
  }

  void selectGift(GiftData gift) {
    bool isGiftAlreadySelected =
        state.selectedGifts.any((selectedGift) => selectedGift.sId == gift.sId);

    // Only add the gift if it's not already in the list
    if (!isGiftAlreadySelected) {
      emit(state.copyWith(
        status: StreamsStates.success,
        selectedGifts: [...state.selectedGifts, gift],
      ));
    }
  }

  void unselectGift(GiftData gift) {
    emit(state.copyWith(
        status: StreamsStates.success,
        selectedGifts: state.selectedGifts.where((g) => g != gift).toList()));
  }

  int getGoalsValue(int index) {
    return state.selectedGifts[index].currentValue ?? 0;
  }

  String getGoalsDescription() {
    return state.goalDescription ?? "";
  }

  void setCurrentValue(int index, int currentValue) {
    // Create a copy of the selected gift
    GiftData updatedGift = state.selectedGifts[index].copyWith(
      currentValue: currentValue.toInt(),
    );

    // Create a new list with the updated gift
    List<GiftData> updatedGifts = List.from(state.selectedGifts);
    updatedGifts[index] = updatedGift;

    emit(state.copyWith(
      status: StreamsStates.success,
      selectedGifts: updatedGifts,
    ));
  }

  void setGoalDescription(String description) {
    emit(state.copyWith(
      status: StreamsStates.success,
      goalDescription: description,
    ));
  }

  void setGiftValues(String giftId, int newValue, int newGoal) {
    List<GiftData> updatedGifts = state.selectedGifts.map((gift) {
      if (gift.sId == giftId) {
        return gift.copyWith(
          currentValue: newValue,
          maximumGoal: newGoal,
        );
      }
      return gift;
    }).toList();

    emit(state.copyWith(
      status: StreamsStates.success,
      selectedGifts: updatedGifts,
    ));
  }

  void createLive({required String title}) {
    emit(state.copyWith(status: StreamsStates.loading));
    //extract data from state
    final List<GoalParams> goalParamsList = state.selectedGifts.map((gift) {
      return GoalParams(giftId: gift.sId!, amount: gift.currentValue!);
    }).toList();

    final result = createLiveUseCase(CreateLiveParams(
      title: title,
      topicId: state.topicId,
      description: state.goalDescription!,
      goals: goalParamsList,
    ));
    result
        .then((value) => emit(state.copyWith(status: StreamsStates.success)))
        .catchError((error) => emit(
            state.copyWith(status: StreamsStates.failure, failure: error)));
  }
}
