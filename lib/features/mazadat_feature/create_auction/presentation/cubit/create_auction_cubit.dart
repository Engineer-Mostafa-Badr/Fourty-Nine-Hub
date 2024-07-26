import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/states/basic_state.dart';
import '../../domain/usecases/create_auction_usecase.dart';

class CreateAuctionCubit extends Cubit<BasicState<bool>> {
  final formState = GlobalKey<FormState>();
  String? startPrice, minimumIncrease, description;

  final CreateAuctionUseCase _createAuctionUseCase;
  CreateAuctionCubit(this._createAuctionUseCase) : super(const BasicState());

  void createAuction({required String adId}) async {
    if (formState.currentState?.validate() ?? false) {
      final response = await _createAuctionUseCase(CreateAuctionParams(
          adId: adId,
          startPrice: startPrice ?? '',
          minimumIncrease: minimumIncrease ?? '',
          description: description ?? ''));
      response.fold(
          (l) => emit(state.copyWith(status: StateStatus.error, failure: l)),
          (r) => emit(state.copyWith(status: StateStatus.success, )));
    }
  }
}
