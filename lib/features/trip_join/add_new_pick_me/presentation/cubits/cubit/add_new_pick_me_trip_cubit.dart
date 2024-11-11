import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/data/models/add_new_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/entities/add_new_pick_me_param.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/use_cases/add_new_pick_me_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'add_new_pick_me_trip_state.dart';

class AddNewPickMeTripCubit extends Cubit<AddNewPickMeTripState> {
  final AddNewPickMeUsecase addNewPickMeUsecase;
  AddNewPickMeModel? addNewPickMeModel;

  AddNewPickMeTripCubit({
    required this.addNewPickMeUsecase,
  }) : super(AddNewPickMeTripInitial());

  Future<void> addNewPickMeTrip(
      {required AddNewPickMeParam addNewPickMeParam}) async {
    emit(AddNewPickMeTripLoading());
    final response = await addNewPickMeUsecase.call(
      addNewPickMeParam: addNewPickMeParam,
    );
    response.fold(
        (Failure failure) => emit(
              AddNewPickMeTripFailure(errorMessage: Labels.errorHappened),
            ), (data) {
      addNewPickMeModel = data;
      print(data);
      emit(AddNewPickMeTripSuccess(addNewPickMeModel: data));
    });
  }
}
