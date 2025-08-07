import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../helpers/print_helper.dart';
import '../../../domain/entities/pickme_entity.dart';
import '../../../domain/usecases/view_all_pick_me_usecase.dart';
import '../../../../../../res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
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
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
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
