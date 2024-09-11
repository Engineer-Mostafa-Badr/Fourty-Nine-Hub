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

  CreateCompanyAdCubit(
      this._getPriceUseCases,
      this._companyAddUseCases,
      this._deleteCompanyAddUseCases,
      this._getPostsCompanyAdUseCase,
      ) : super(const CreateCompanyAdState());

  num totalPrice = 0; // New variable for total price

  void loadData() async {
    await getCompanyAdPrice();
  }

  Future<void> getCompanyAdPrice() async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await _getPriceUseCases.call(const NoParams());
    response.fold(
          (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
          (data) => emit(state.copyWith(price: data)),
    );
  }

  Future<List<CompanyAdEntity>> getCompanyAdPosts(String filter, {required PaginationParams params}) async {
    List<CompanyAdEntity> company = [];
    final response = await _getPostsCompanyAdUseCase(
      FetchPostCompanyAdvertiseParams(filter: filter, paginationParams: params),
    );

    response.fold(
          (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
          (data) {
        company = data;
        _calculateTotalPrice(filter, data); // Calculate total price after fetching ads
      },
    );
    return company;
  }

  // Method to calculate total price based on advertisement type and count
  void _calculateTotalPrice(String filter, List<CompanyAdEntity> ads) {
    final pricePerAd = _getPriceForFilter(filter);
    totalPrice = ads.length * pricePerAd; // Calculate the total price
    emit(state.copyWith(totalPrice: totalPrice)); // Update the state with the new total price
  }

  // Helper method to get price for each filter type
  num _getPriceForFilter(String filter) {
    switch (filter) {
      case 'written':
        return state.price?.postPrice ?? 0;
      case 'photo':
        return state.price?.photoPrice ?? 0;
      case 'photo_written':
        return state.price?.postAndPhotoPrice ?? 0;
      case 'reel':
        return state.price?.reelPrice ?? 0;
      default:
        return 0;
    }
  }

  Future<void> addPostCompanyAdvertise({
    String? post,
    required String type,
    String? description,
    required int totalPrice,
    List<String>? mediaIds,
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
        mediaIds?.clear();
        print('Media IDs cleared after successful post.');
      },
    );
  }

  Future<void> deleteCompanyAd({required String id}) async {
    emit(state.copyWith(status: StateStatus.loading)); // Start loading state
    final response = await _deleteCompanyAddUseCases(
      DeleteCompanyAdParams(id: id),
    );

    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: StateStatus.error)),
          (success) => emit(state.copyWith(status: StateStatus.success)),
    );
  }
}



// import 'package:bloc/bloc.dart';
// import 'package:fourtyninehub/core/abstract/use_case.dart';
// import 'package:fourtyninehub/core/enums/base_status_enum.dart';
// import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/fetch_post_company_advertise_params.dart';
// import '../../../../../common/models/public/pagination_params.dart';
// import '../../../../../core/error/failure.dart';
// import '../../domain/entities/company_ad_entity.dart';
// import '../../domain/entities/company_ad_option_entity.dart';
// import '../../domain/entities/price_entity.dart';
// import '../../domain/usecases/delete_company_ad_use_case.dart';
// import '../../domain/usecases/get_company_add_use_case.dart';
// import '../../domain/usecases/get_posts_company_ad_use_case.dart';
// import '../../domain/usecases/get_price_use_case.dart';
//
// part 'create_company_ad_state.dart';
//
// class CreateCompanyAdCubit extends Cubit<CreateCompanyAdState> {
//   final GetPriceUseCases _getPriceUseCases;
//   final GetCompanyAddUseCases _companyAddUseCases;
//   final DeleteCompanyAddUseCases _deleteCompanyAddUseCases;
//   final GetPostsCompanyAdUseCase _getPostsCompanyAdUseCase;
//
//   CreateCompanyAdCubit(this._getPriceUseCases, this._companyAddUseCases, this._deleteCompanyAddUseCases, this._getPostsCompanyAdUseCase)
//       : super(const CreateCompanyAdState());
//
//   void loadData() async {
//     await getCompanyAdPrice();
//   }
//
//   Future<void> getCompanyAdPrice() async {
//     emit(state.copyWith(status: StateStatus.loading));
//     final response = await _getPriceUseCases.call(const NoParams());
//     response.fold(
//         (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
//         (data) => emit(state.copyWith(price: data)));
//   }
//
//
//   Future<List<CompanyAdEntity>> getCompanyAdPosts(String filter,{required PaginationParams params}) async {
//
//     List<CompanyAdEntity> company = [];
//     final response = await _getPostsCompanyAdUseCase(
//         FetchPostCompanyAdvertiseParams(filter: filter, paginationParams:params)
//     );
//
//     response.fold(
//             (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
//             (data) {
//               company=data;
//              // emit(state.copyWith(posts: company));
//             });
//     return company;
//   }
//
//
//   Future<void> addPostCompanyAdvertise({
//     String? post,
//     required String type,
//     String? description,
//     required int totalPrice,
//     List<String>? mediaIds, // Make sure this is used correctly
//   //  required String filter,
//   }) async {
//     var response = await _companyAddUseCases(
//       CompanyAddParams(
//         advertisementType: type,
//         totalPrice: totalPrice,
//         media: mediaIds,
//         description: description,
//         post: post,
//       ),
//     );
//     return response.fold(
//             (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
//             (data) {
//           emit(state.copyWith(advertise: data, status: StateStatus.success));
//         //  getCompanyAdPosts(filter);
//           mediaIds?.clear();
//           print('Media IDs cleared after successful post.');
//         }
//     );
//
//   }
//
//   Future<void> deleteCompanyAd({
//     required String id,
//   }) async {
//     emit(state.copyWith(status: StateStatus.loading)); // Start loading state
//
//     final response = await _deleteCompanyAddUseCases(
//       DeleteCompanyAdParams(id: id),
//     );
//
//     response.fold(
//           (failure) {
//         // If the deletion fails, show an error message
//         emit(state.copyWith(failure: failure, status: StateStatus.error));
//       },
//           (success) {
//       //  final updatedPosts = (state.posts ?? []).where((ad) => ad.sId != id).toList();
//         emit(state.copyWith(status: StateStatus.success));
//       },
//     );
//   }
//
//   // void onRefresh() async {
//   //   companyAdController.refresh();
//   // }
//   //
//   // final PagingController<int, TwitterPostEntity> companyAdController =
//   // PagingController(firstPageKey: 1);
//
// }
