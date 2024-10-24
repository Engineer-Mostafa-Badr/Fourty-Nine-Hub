import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/get_ad_requests_usecase.dart';
part 'ad_requests_state.dart';

class AdRequestsCubit extends Cubit<AdRequestsState> {
  final GetAdRequestsUseCase _getAdRequestsUseCase;

  String? phone;
  AdRequestsCubit( this._getAdRequestsUseCase,
      )
      : super(const AdRequestsState());

  void loadGlobalData(String id) async {
    emit(state.copyWith(status: AdRequestsStates.loading));
    await getRelevantAds(id,1);
    requestsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getRelevantAds(id,pageKey);
    });
    emit(state.copyWith(status: AdRequestsStates.success));
  }

  refreshUserReels() async {
    requestsPagingController.refresh();
  }



    final PagingController<int, AdRequestEntity> requestsPagingController =
  PagingController(firstPageKey: 1);
  int pageSize = 1;

  Future<void> getRelevantAds(String id, int page) async {
    final response = await _getAdRequestsUseCase(GetAdRequestsParams(id: id,page: page,limit: pageSize));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: AdRequestsStates.error)),
        (data) {
          final isLastPage = data.length < pageSize;
          if (page == 1) {
            print("page == 1 $page");
            requestsPagingController.itemList = [];
          }
          if (isLastPage) {
            print("isLastPage = $isLastPage");
            requestsPagingController.appendLastPage(data);
          } else {
            print("isNotLastPage = $isLastPage");
            final nextPageKey = page + 1;
            requestsPagingController.appendPage(data, nextPageKey);
          }
        });
  }

  void changePhone({
    required String v,
  }) =>
      phone = v;


}
