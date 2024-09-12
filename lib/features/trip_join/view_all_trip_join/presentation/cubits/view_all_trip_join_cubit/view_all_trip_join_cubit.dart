// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/view_all_trip_join_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/const.dart';

part 'view_all_trip_join_state.dart';

class ViewAllTripJoinCubit extends Cubit<ViewAllTripJoinState> {
  final ViewAllTripJoinUseCase viewAllTripJoinUseCase;
  ViewAllTripJoinCubit({
    required this.viewAllTripJoinUseCase,
  }) : super(ViewAllTripJoinInitial());

  PaginationParams paginationParams = PaginationParams(page: 1, limit: 10);
  List<TripJoinCardEntity> tripJoinCards = [];
  bool noMoreDataInDatabase = false;

  Future<void> viewAllTripJoin() async {
    emit(ViewAllTripJoinLoading());
    final response = await viewAllTripJoinUseCase.call(
      paginationParams: paginationParams,
      subCategory: UIConst.addTripJoinCategoryId,
    );
    response.fold(
      (Failure failure) => emit(
        ViewAllTripJoinFailed(Labels.errorHappened),
      ),
      (List<TripJoinCardEntity> models) {
        // print(' ============  inside cubit $models');
        noMoreDataInDatabase = models.isEmpty;
        // print(' ============= noMoreDataInDatabase = $noMoreDataInDatabase ');
        // print(' ============= paginationParams = ${paginationParams.page} ');
        tripJoinCards.addAll(models);
        emit(
          ViewAllTripJoinSuccess(tripJoinCards),
        );
      },
    );
  }
}
