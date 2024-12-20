import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';
import '../../../domain/use_case/add_chance_data.dart';
import 'chance_states.dart';

class ChanceCubit extends Cubit<ChanceState> {
  final FetchChanceUseCase _fetchChanceUseCase;
  final AddChanceUseCase _addChanceUseCase;
  final GetChanceRateUseCase _getChanceRateUseCase;
  final MainCategoryChanceUseCase _mainCategoryChanceUseCase;
  final SubCategoryChanceUseCase _SubCategoryChanceUseCase;

  ChanceCubit(
    this._fetchChanceUseCase,
    this._addChanceUseCase,
    this._getChanceRateUseCase,
    this._mainCategoryChanceUseCase,
    this._SubCategoryChanceUseCase,
  ) : super(const ChanceState());

  // Future<void> fetchChance() async {
  //   emit(state.copyWith(status: ChanceStates.loading));
  //   final result = await _fetchChanceUseCase(const NoParams());
  //
  //   result.fold(
  //     (failure) => emit(state.copyWith(status: ChanceStates.error, failure: failure)),
  //     (chance) => emit(state.copyWith(chance: chance, status: ChanceStates.success)),
  //   );
  // }

  Future<void> fetchChance() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = _fetchChanceUseCase.call(const NoParams());
    return response.then((value) {
      print('_____________________');
      print(value);
      emit(state.copyWith(chance: value, status: ChanceStates.success));
    }).catchError((error) {
      print('_____________________');
      print(error.toString());
      print('_____________________');
      emit(state.copyWith(status: ChanceStates.error));
    });
    // response.fold((l) {
    //   print(getFailureMessage(l, AppPages.router.configuration.navigatorKey.currentContext!));
    //   emit(state.copyWith(failure: l, status: ChanceStates.error));
    // }, (data) {
    //   print('*********************');
    //   print(data);
    //   emit(state.copyWith(chance: data));
    // });
  }

  Future<void> addChance(AddChanceParams params) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _addChanceUseCase(params);
    return response.fold(
      (failure) {
        print('Error');
        print(failure.toString());
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (response) {
        print('Success');
        print(response);
        emit(state.copyWith(status: ChanceStates.success));
        fetchChance();
      },
    );
  }

  Future<void> getChanceRate({required String id}) async {
    final response = await _getChanceRateUseCase(
      ChanceRateParams(chanceRateParams: id),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: ChanceStates.error));
    }, (data) {
      emit(state.copyWith(rate: data, status: ChanceStates.success));
    });
  }

  Future<List<MainCategoryDropEntity>> fetchMainCategoryChance(
      {required PaginationParams paginationParams}) async {
    List<MainCategoryDropEntity> category = [];
    final response = await _mainCategoryChanceUseCase(
      MainCategoryChanceParams(
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: ChanceStates.error));
    }, (data) {
      category = data;
    });
    return category;
  }

  Future<List<SubCategoryDropEntity>> fetchSubCategoryChance(
      {required PaginationParams paginationParams, required String id}) async {
    List<SubCategoryDropEntity> category = [];
    final response = await _SubCategoryChanceUseCase(
      SubCategoryChanceParams(
        id: id,
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: ChanceStates.error));
    }, (data) {
      category = data;
    });
    return category;
  }
}
