import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_suggest_follow_instagram_use_case.dart';

part 'suggest_follow_state.dart';

class SuggestFollowCubit extends Cubit<SuggestFollowState> {
  SuggestFollowCubit(this._getSuggestFollowUC) : super(SuggestFollowState());

  final GetSuggestFollowInstagramUseCase _getSuggestFollowUC;

  final int suggestFollowLimit = 10;

  // تحميل اقتراحات المتابعة فقط
  Future<void> fetchSuggestFollow() async {
    emit(state.copyWith(status: SuggestFollowStatus.loading));

    final res = await _getSuggestFollowUC(
      GetSuggestFollowInstagramParams(
        limit: suggestFollowLimit,
        page: state.suggestFollowPage,
      ),
    );

    res.fold(
      (f) {
        emit(state.copyWith(
          status: SuggestFollowStatus.failure,
          failure: f,
        ));
      },
      (data) {
        emit(state.copyWith(
          status: SuggestFollowStatus.success,
          suggestFollowsData: data,
          suggestFollowPage: state.suggestFollowPage + 1,
        ));
      },
    );
  }
}
