import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_posts_use_case.dart';

part 'posts_instagram_state.dart';

class PostsInstagramCubit extends Cubit<PostsInstagramState> {
  PostsInstagramCubit(this._getPostsUseCase) : super(PostsInstagramState());

  final GetPostsUseCase _getPostsUseCase;

  int _currentPage = 1;
  static const int _postsPerPage = 10;

  Future<void> loadPosts(context, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      emit(state.copyWith(status: PostsInstagramStatus.loading));
    } else {
      // التحقق من ما إذا كنا في حالة التحميل بالفعل أو إذا لم تكن هناك مزيد من المنشورات
      final currentState = state;
      if (currentState.status.isLoading) return;
      if (currentState.status.isSuccess && !currentState.hasMorePosts) return;
    }

    // emit(state.copyWith(
    //   status: PostsInstagramStatus.loading,
    // ));
    var response = await _getPostsUseCase.call(PaginationParams(
      page: _currentPage,
      limit: _postsPerPage,
    ));
    response.fold(
      (l) {
        emit(state.copyWith(
          status: PostsInstagramStatus.failure,
          errMessage: getFailureMessage(l, context),
        ));
      },
      (posts) {
        if (state.status.isSuccess && !refresh) {
          // إضافة المنشورات الجديدة إلى القائمة الحالية
          final currentPosts = state.posts; // (state as InstagramLoaded).posts;
          final updatedPosts = [...currentPosts, ...posts.posts];
          _currentPage++;
          emit(state.copyWith(
            status: PostsInstagramStatus.success,
            posts: updatedPosts,
            hasMorePosts: posts.posts.length == _postsPerPage,
          ));
        } else {
          // الحالة الأولية أو تحديث
          _currentPage = 2; // للتحميل التالي
          emit(state.copyWith(
            status: PostsInstagramStatus.success,
            posts: posts.posts,
            hasMorePosts: posts.posts.length == _postsPerPage,
          ));
        }
        // emit(state.copyWith(
        //   status: PostsInstagramStatus.success,
        //   posts: posts,
        // ));
      },
    );
  }
}
