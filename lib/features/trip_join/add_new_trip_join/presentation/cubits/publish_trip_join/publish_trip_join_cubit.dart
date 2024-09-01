// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_join_publish_param.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/publish_trip_join_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'publish_trip_join_state.dart';

class PublishTripJoinCubit extends Cubit<PublishTripJoinState> {
  PublishTripJoinUseCase publishTripJoinUseCase;
  TripJoinPublishParam tripJoinPublishParam = TripJoinPublishParam();
  PublishTripJoinCubit({
    required this.publishTripJoinUseCase,
  }) : super(PublishTripJoinInitial());
  Future<void> publishTripJoin() async {
    emit(PublishTripJoinLoading());
    final response = await publishTripJoinUseCase.call(
      tripJoinPublishParam: tripJoinPublishParam,
    );
    response.fold(
      (Failure failure) => emit(
        PublishTripJoinFailed(Labels.errorHappened),
      ),
      (_) {
        emit(PublishTripJoinSuccess());
      },
    );
  }

  void emitFailure(String errorMessage) {
    emit(PublishTripJoinFailed(errorMessage));
  }
}
