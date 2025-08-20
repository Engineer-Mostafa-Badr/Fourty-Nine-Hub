import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../domain/usecases/get_auction_list_usecase.dart';

part 'auction_list_state.dart';

class AuctionListCubit extends Cubit<AuctionListState> {
  final GetAuctionListUseCase _getAuctionListUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  AuctionListCubit(this._getAuctionListUseCase, this._getSubCategoriesUseCase)
      : super(AuctionListState());

  void loadData() async {
    emit(state.copyWith(status: AuctionListStates.loading));
    await getAuctionList();
    // await getSubCategories();
  }

  Future<void> getSubCategories() async {
    final user = UserCubit.to.state.data?.id;
    final response = await _getSubCategoriesUseCase.call(GetSubCategoriesParams(
        mainCategoryId: '',
        paginationParams: PaginationParams.basic(),
        userId: user ?? ''));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: AuctionListStates.error)),
        (data) => emit(state.copyWith(
            subCategories: data, status: AuctionListStates.initState)));
  }

  Future<void> getAuctionList() async {
    final response =
        await _getAuctionListUseCase.call(LocationParams(lat: 0, lng: 0));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: AuctionListStates.error)),
        (data) => emit(state.copyWith(
            auctionList: data, status: AuctionListStates.initState)));
  }

  void changeSubCategory({required SubCategoryEntity v}) {
    emit(state.copyWith(selectedSubCategory: v));
  }

  void changeView({required bool isGrid}) {
    emit(state.copyWith(isGrid: isGrid));
  }
}
