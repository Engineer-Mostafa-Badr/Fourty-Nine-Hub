import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_gift_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_winners_gift_use_case.dart';

part 'winners_gift_state.dart';

class WinnersGiftCubit extends Cubit<WinnersGiftState> {
  WinnersGiftCubit(this._getWinnersGiftUseCase)
      : super(const WinnersGiftState(status: WinnersGiftStates.initial));

  final GetWinnersGiftUseCase _getWinnersGiftUseCase;

  Future<void> getWinners(context) async {
    if (state.page == 1) {
      emit(state.copyWith(status: WinnersGiftStates.loading));
    }

    final response = await _getWinnersGiftUseCase.call(
      PaginationParams(page: state.page),
    );

    response.fold(
      (f) {
        emit(state.copyWith(
          status: WinnersGiftStates.failure,
          errMessage: getFailureMessage(f, context),
        ));
      },
      (newData) {
        final isLastPage =
            newData.winnersGift.length < newData.pagination.limit;

        emit(state.copyWith(
          status: WinnersGiftStates.success,
          winnersGift: state.winnersGift == null
              ? newData
              : DataWinnersGiftEntity(
                  winnersGift: [
                    ...state.winnersGift!.winnersGift,
                    ...newData.winnersGift,
                  ],
                  pagination: state.winnersGift!.pagination,
                ),
          hasReachedMax: isLastPage,
          page: isLastPage ? state.page : state.page + 1,
        ));
      },
    );
  }
}
