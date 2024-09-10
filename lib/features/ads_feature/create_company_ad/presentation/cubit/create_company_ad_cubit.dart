import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/fetch_post_company_advertise_params.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/company_ad_entity.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/entities/price_entity.dart';
import '../../domain/usecases/delete_company_ad_use_case.dart';
import '../../domain/usecases/get_company_add_use_case.dart';
import '../../domain/usecases/get_posts_company_ad_use_case.dart';
import '../../domain/usecases/get_price_use_case.dart';

part 'create_company_ad_state.dart';

class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
  final GetPriceUseCases _getPriceUseCases;
  final GetCompanyAddUseCases _companyAddUseCases;
  final DeleteCompanyAddUseCases _deleteCompanyAddUseCases;
  final GetPostsCompanyAdUseCase _getPostsCompanyAdUseCase;

  CreateCompanyAdCubit(this._getPriceUseCases, this._companyAddUseCases, this._deleteCompanyAddUseCases, this._getPostsCompanyAdUseCase)
      : super(const CreateCompanyAdState());

  void loadData() async {
    await getCompanyAdPrice();
   // await getCompanyAdPosts();
  }

  Future<void> getCompanyAdPrice() async {
    final response = await _getPriceUseCases.call(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) => emit(state.copyWith(price: data)));
  }

  List<CompanyAdEntity> company = [];
  Future<List<CompanyAdEntity>> getCompanyAdPosts(String filter) async {

    final response = await _getPostsCompanyAdUseCase(
        FetchPostCompanyAdvertiseParams(filter: filter, paginationParams: PaginationParams(page: 1,limit: 10))
    );
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
              company=data;
              emit(state.copyWith(posts: data));
            });
    return company;
  }


  Future<void> addPostCompanyAdvertise({
    String? post,
    required String type,
    String? description,
    required int totalPrice,
    List<String>? mediaIds, // Make sure this is used correctly
  //  required String filter,
  }) async {
    var response = await _companyAddUseCases(
      CompanyAddParams(
        advertisementType: type,
        totalPrice: totalPrice,
        media: mediaIds,
        description: description,
        post: post,
      ),
    );
    return response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
          emit(state.copyWith(advertise: data, status: StateStatus.success));
        //  getCompanyAdPosts(filter);
          mediaIds?.clear();
          print('Media IDs cleared after successful post.');
        }
    );

  }

  deleteCompanyAd({
    required String id,
    required String filter
  })async{
    await _deleteCompanyAddUseCases(
        DeleteCompanyAdParams(id: id)
    );
    getCompanyAdPosts(filter);
  }
}
