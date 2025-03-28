import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../domain/usecases/end_auction_usecase.dart';
import '../../domain/usecases/follow_users_auction_usecase.dart';
import '../../domain/usecases/get_auction_details_usecase.dart';
import '../../domain/usecases/get_auction_requests_usecase.dart';
import '../../domain/usecases/send_bidding_usecase.dart';
import '../widgets/Biddings.dart';

part 'auction_details_state.dart';

class AuctionDetailsCubit extends Cubit<AuctionDetailsState> {
  final FollowUsersAuctionUseCase _followUsersAuctionUseCase;
  final GetAuctionDetailsUseCase _getAuctionDetailsUseCase;
  final SendBiddingUseCase _sendBiddingUseCase;
  final EndAuctionUsecase _endAuctionUsecase;
  final GetAuctionRequestsUseCase _getAuctionRequestsUseCase;
  AuctionDetailsCubit(
      this._followUsersAuctionUseCase,
      this._getAuctionDetailsUseCase,
      this._sendBiddingUseCase,
      this._getAuctionRequestsUseCase,
      this._endAuctionUsecase)
      : super(const AuctionDetailsState());

  void loadData({required String id}) async {
    await getAuctionDetails(id: id);
  }

  Future<void> getAuctionDetails({required String id}) async {
    emit(state.copyWith(status: AuctionDetailsStates.loading));
    final response = await _getAuctionDetailsUseCase(id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: AuctionDetailsStates.error)),
        (data) => emit(state.copyWith(
            auction: data, status: AuctionDetailsStates.initState)));
  }

  Future<void> sendBidding({required SendBiddingParams params}) async {
    final response = await _sendBiddingUseCase(params);
    response.fold(
        (failure) => emit(state.copyWith(
            status: AuctionDetailsStates.error, failure: failure)),
        (done) => emit(state.copyWith(
            status: AuctionDetailsStates.success,
            successMessage: Labels.biddingPlacedSuccess)));
  }

  Future<void> followUser({required String userId}) async {
    final response = await _followUsersAuctionUseCase(userId);
    response.fold(
        (failure) => emit(state.copyWith(
            status: AuctionDetailsStates.error, failure: failure)),
        (done) => emit(state.copyWith(
            status: AuctionDetailsStates.success,
            successMessage: Labels.followedSuccess)));
  }

  Future<void> endAuction({required String id}) async {
    final response = await _endAuctionUsecase(id);
    response.fold(
        (failure) => emit(state.copyWith(
            status: AuctionDetailsStates.error, failure: failure)), (done) {
      emit(state.copyWith(
          status: AuctionDetailsStates.success,
          successMessage: Labels.success));
      getAuctionDetails(id: id);
    });
  }

  void showAuctionRequests(
      {required String id, required BuildContext context}) async {
    final response = await _getAuctionRequestsUseCase(id);
    response.fold(
        (failure) => emit(state.copyWith(
            status: AuctionDetailsStates.error, failure: failure)), (data) {
      bottomSheet(
          context: context,
          widget: Biddings(
            biddingsList: data,
          ));
    });
  }
}
