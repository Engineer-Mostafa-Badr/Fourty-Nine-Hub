import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/single_post_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_single_post_instagram_use_case.dart';

part 'single_post_instagram_state.dart';

class SinglePostInstagramCubit extends Cubit<SinglePostInstagramState> {
  SinglePostInstagramCubit(this._getSinglePostInstagramUseCase)
      : super(const SinglePostInstagramState());

  final GetSinglePostInstagramUseCase _getSinglePostInstagramUseCase;

  Future<void> getPost(String postId) async {
    emit(state.copyWith(status: SinglePostInstagramStatus.loading));
    final result = await _getSinglePostInstagramUseCase.call(postId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SinglePostInstagramStatus.failure,
        failure: failure,
      )),
      (postData) => emit(state.copyWith(
        status: SinglePostInstagramStatus.success,
        postData: postData,
      )),
    );
  }
}
