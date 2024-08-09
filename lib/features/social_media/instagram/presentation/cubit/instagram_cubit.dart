import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'instagram_state.dart';

class InstagramCubit extends Cubit<InstagramState> {
  final GetInstagramFeedUseCase _getFeedUseCase;
  final FaceAdvertisementUseCase _advertisementUseCase;
  final PostReactUseCase _postReactUseCase;

  InstagramCubit(this._getFeedUseCase, this._advertisementUseCase, this._postReactUseCase) : super(const InstagramState());


  void loadData() async {
    await getFeed(1);
    feedPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
  }


  void onRefresh()async{
    emit(state.copyWith(advertisementsPage:0));
    feedPagingController.refresh();
  }


  final PagingController<int, PostEntity> feedPagingController =
  PagingController(firstPageKey: 1);


// get feed posts
  Future<void> getFeed(int page) async {
    final response = await _getFeedUseCase(TwitterFeedParams(limit: 5, page: page));
    List<PostEntity> advertisements=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) async{
          if(data.isNotEmpty){
            advertisements = await getAdvertisements();
          }
          List<PostEntity> totalPosts=[];
          totalPosts.addAll(data);
          totalPosts.addAll(advertisements);
          final isLastPage = totalPosts.length < (4);
          if (page == 1) {
            print("page == 1 $page");
            feedPagingController.itemList = [];
          }
          if (isLastPage) {
            print("isLastPage = $isLastPage");
            feedPagingController.appendLastPage(totalPosts);
          } else {
            print("isNotLastPage = $isLastPage");
            final nextPageKey = page + 1;
            feedPagingController.appendPage(totalPosts, nextPageKey);
          }
          emit(state.copyWith(posts: totalPosts, status: StateStatus.initial));
        });
  }

  // get advertisements
  Future<List<PostEntity>> getAdvertisements() async {
    final response =
    await _advertisementUseCase(TwitterFeedParams(limit: 1, page: state.advertisementsPage!+1));
    List<PostEntity> advertisements=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
          advertisements.addAll(data);
          int? page = state.advertisementsPage!+1;
          emit(state.copyWith(advertisementsPage: page,posts: data, status: StateStatus.success));
        });
    print("advertisements:${advertisements.length}");
    return advertisements;
  }


  void changeIndex(int index){
    emit(state.copyWith(pageIndex: index));
  }


// react on a post
  Future<bool> onReact({required PostReactParams params}) async {
    var response =await _postReactUseCase(params);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (r){
          value=r;
        }
    );
    return value;

  }


}
