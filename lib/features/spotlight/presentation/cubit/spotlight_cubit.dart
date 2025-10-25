import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';
import 'package:fourtyninehub/features/spotlight/domain/usecases/get_spotlight_use_case.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';


part 'spotlight_state.dart';

class SpotlightCubit extends Cubit<SpotlightState> {
  final GetSpotlightUseCase getSpotlightUseCase;
  SpotlightCubit(this.getSpotlightUseCase

  ) : super(SpotlightState());


  Future<void> fetchMyProfileSpotlight() async {
    emit(state.copyWith(status: StateStatus.loading,));
    final response = await getSpotlightUseCase(NoParams());

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          spotlightEntity: updatedRestaurant,
          status: StateStatus.success,

        ));
      },
    );
  }
}
