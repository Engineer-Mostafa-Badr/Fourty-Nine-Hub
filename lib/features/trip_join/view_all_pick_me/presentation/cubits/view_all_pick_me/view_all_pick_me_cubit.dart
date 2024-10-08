import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/usecases/view_all_pick_me_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'view_all_pick_me_state.dart';

class ViewAllPickMeCubit extends Cubit<ViewAllPickMeState> {
  final ViewAllPickMeUseCase viewAllPickMeUseCase;
  ViewAllPickMeCubit({required this.viewAllPickMeUseCase})
      : super(ViewAllPickMeInitial());
  List<PickMeCardEntity> cards = [];
  int page = 1;
  Future<void> getAllPickMe() async {
    emit(ViewAllPickMeLoading());
    final response = await viewAllPickMeUseCase.call(page: page);
    response.fold(
      (Failure failure) {
        emit(ViewAllPickMeFailed(Labels.errorHappened));
      },
      (data) {
        cards.addAll(data);
        pr(data, 'ViewAllPickMeCubit - getAllPickMe');
        emit(ViewAllPickMeSuccess(data));
      },
    );
  }
}
