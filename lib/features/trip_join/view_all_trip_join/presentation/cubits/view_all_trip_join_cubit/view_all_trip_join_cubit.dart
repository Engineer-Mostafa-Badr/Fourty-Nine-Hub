// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/view_all_trip_join_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../../RideFeature/domain/entities/ride_brand_entity.dart';
import '../../../../../RideFeature/domain/entities/ride_model_entity.dart';
import '../../../../../ride/RideRequest/domain/entity/expected_price_entity.dart';
import '../../../domain/entities/available_trip_join_entity.dart';
import '../../../domain/entities/delete_my_trip_join_entity.dart';
import '../../../domain/entities/expected_price_entity.dart';
import '../../../domain/entities/get_request_count_entity.dart';
import '../../../domain/entities/my_ads_trip_join_entity.dart';
import '../../../domain/entities/request_trip_join_entity.dart';
import '../../../domain/usecases/apply_read_request_trip_join_use_case.dart';
import '../../../domain/usecases/apply_view_trip_join_use_case.dart';
import '../../../domain/usecases/create_trip_join_offer_use_case.dart';
import '../../../domain/usecases/delete_my_trip_join_use_case.dart';
import '../../../domain/usecases/get_available_trip_join_use_case.dart';
import '../../../domain/usecases/get_car_brand_use_case.dart';
import '../../../domain/usecases/get_car_model_use_case.dart';
import '../../../domain/usecases/get_expected_price_use_case.dart';
import '../../../domain/usecases/get_my_ads_trip_join_use_case.dart';
import '../../../domain/usecases/get_request_count_trip_join_use_case.dart';
import '../../../domain/usecases/get_request_trip_join_use_case.dart';

part 'view_all_trip_join_state.dart';

class ViewAllTripJoinCubit extends Cubit<ViewAllTripJoinState> {
  final ViewAllTripJoinUseCase viewAllTripJoinUseCase;
  final GetCarBrandUseCase getCarBrandUseCase;
  final GetCarModelUseCase getCarModelUseCase;
  final GetExpectedPriceTripUseCase getExpectedPriceUseCase;
  final GetAvailableTripJoinUseCase getAvailableTripJoinUseCase;
  final GetRequestTripJoinUseCase getRequestTripJoinUseCase;
  final GetMyAdsTripJoinUseCase getMyAdsTripJoinUseCase;
  final DeleteMyTripJoinUseCase deleteMyTripJoinUseCase;
  final ApplyViewTripJoinUseCase applyViewTripJoinUseCase;
  final ApplyReadRequestTripJoinUseCase applyReadRequestTripJoinUseCase;
  final CreateTripJoinOfferUseCase createTripJoinOfferUseCase;
  final GetRequestCountTripJoinUseCase getRequestCountTripJoinUseCase;
  ViewAllTripJoinCubit(this.getCarBrandUseCase,this.viewAllTripJoinUseCase, this.getCarModelUseCase, this.getExpectedPriceUseCase, this.getAvailableTripJoinUseCase, this.getRequestTripJoinUseCase, this.getMyAdsTripJoinUseCase, this.deleteMyTripJoinUseCase, this.applyViewTripJoinUseCase, this.applyReadRequestTripJoinUseCase, this.createTripJoinOfferUseCase, this.getRequestCountTripJoinUseCase): super(ViewAllTripJoinState());

  Future<void> createTripJoinOffer(CreateTripJoinParams params,BuildContext context) async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await createTripJoinOfferUseCase(params);
    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
      },
          (tripData) {
        emit(state.copyWith(
          deleteMyTripJoinEntity: tripData,
          status: ViewAllTripJoinStatus.success,
        ));
        showSuccessMessage(context, tripData.message ?? "Success");

          },
    );
  }



  Future<void> getRequestCount() async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getRequestCountTripJoinUseCase(NoParams());

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
      },
          (tripData) async {
        emit(state.copyWith(
          requestCountData: tripData,
          status: ViewAllTripJoinStatus.success,
        ));
      },
    );
  }

  Future<void> applyReadRequestTrip(String tripId) async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await applyReadRequestTripJoinUseCase(
      DeleteMyTripParams(tripId: tripId),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
      },
          (tripData) async {
        emit(state.copyWith(
          deleteMyTripJoinEntity: tripData,
          status: ViewAllTripJoinStatus.success,
        ));

        // ✅ Refresh the request trip join list after successful apply
        await getRequestCount();
        await loadInitialRequestTripJoin();
      },
    );
  }


  Future<void> applyViewTrip(String tripId,) async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await applyViewTripJoinUseCase(
      DeleteMyTripParams(tripId: tripId ),
    );
    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
      },
          (tripData) {
        emit(state.copyWith(
          deleteMyTripJoinEntity: tripData,
          status: ViewAllTripJoinStatus.success,

        ));
      },
    );
  }


  Future<void> deleteMyAdsTrip(String tripId, BuildContext context) async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await deleteMyTripJoinUseCase(
      DeleteMyTripParams(tripId: tripId),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
      },
          (tripData) {
        // ✅ Remove from list
        myAdsData.removeWhere((trip) => trip.id == tripId);

        emit(state.copyWith(
          deleteMyTripJoinEntity: tripData,
          myAdsTripJoinData: List.from(myAdsData), // emit new list
          status: ViewAllTripJoinStatus.success,
        ));

        // ✅ Check if context is still mounted before using it
        if (context.mounted) {
          showSuccessMessage(context, tripData.message ?? "Success");
        }
      },
    );
  }
  // Future<void> deleteMyAdsTrip(String tripId,BuildContext context) async {
  //   emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
  //
  //   final response = await deleteMyTripJoinUseCase(
  //     DeleteMyTripParams(tripId: tripId),
  //   );
  //
  //   response.fold(
  //         (failure) {
  //       emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
  //     },
  //         (tripData) {
  //       // ✅ Remove from list
  //       myAdsData.removeWhere((trip) => trip.id == tripId);
  //
  //       emit(state.copyWith(
  //         deleteMyTripJoinEntity: tripData,
  //         myAdsTripJoinData: List.from(myAdsData), // emit new list
  //         status: ViewAllTripJoinStatus.success,
  //       ));
  //       showSuccessMessage(context, tripData.message ?? "Success");
  //     },
  //   );
  // }


  List<MyAdsTripDocEntity> myAdsData = [];
  bool hasMoreMyAds = true;
  int currentPageMyAds = 1;
  bool isLoadingMoreMyAds = false;
  bool isLoadingMyAds = false;

  Future<void> loadInitialMyAds() async {
    isLoadingMyAds = true;
    myAdsData.clear();
    currentPageMyAds = 1;
    hasMoreMyAds = true;
    await getMyAds();
    isLoadingMyAds = false;
    emit(state.copyWith(status: ViewAllTripJoinStatus.success));
  }

  Future<void> getMyAds() async {
    if (!hasMoreMyAds || isLoadingMoreMyAds) return;

    isLoadingMoreMyAds = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getMyAdsTripJoinUseCase(
      CarBrandParams(
        page: currentPageMyAds,
        limit: 15,
      ),
    );

    response.fold(
          (failure) {
        isLoadingMoreMyAds = false;
        emit(state.copyWith(
          failure: failure,
          status: ViewAllTripJoinStatus.failure,
        ));
      },
          (data) {
        final trips = data.offers ?? [];
        myAdsData.addAll(trips);

        if (trips.length < 15) {
          hasMoreMyAds = false;
        } else {
          currentPageMyAds++;
        }

        isLoadingMoreMyAds = false;
        emit(state.copyWith(
          myAdsTripJoinData: myAdsData,
        ));
      },
    );
  }

/*
  List<TripJoinEntity> tripJoinData = [];
  bool hasMoreClientPastTrips = true;
  int currentPageClientPastTrips = 1;
  bool isLoadingMoreClientPastTrips = false;

  void loadInitialClientPastTrips() async {
    tripJoinData.clear();
    currentPageClientPastTrips = 1;
    hasMoreClientPastTrips = true;
    isLoadingMoreClientPastTrips = false;
    await getClientPastTrips();
    emit(state.copyWith(status: ViewAllTripJoinStatus.success));
  }

  Future<void> getClientPastTrips() async {
    print("hasMoreClientPastTrips $hasMoreClientPastTrips");
    print("isLoadingMoreClientPastTrips $isLoadingMoreClientPastTrips");

    if (!hasMoreClientPastTrips || isLoadingMoreClientPastTrips) return;

    isLoadingMoreClientPastTrips = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getAvailableTripJoinUseCase(
      CarBrandParams(page: currentPageClientPastTrips, limit: 10),
    );

    response.fold(
          (failure) {
        isLoadingMoreClientPastTrips = false;
        emit(state.copyWith(
          failure: failure,
          status: ViewAllTripJoinStatus.failure,
        ));
      },
          (data) {
        tripJoinData.addAll(data ?? []);

        // Updated pagination logic
        if ((data?.length ?? 0) < 10) {
          hasMoreClientPastTrips = false;
        } else {
          currentPageClientPastTrips++;
        }

        isLoadingMoreClientPastTrips = false;
        emit(state.copyWith(availableTripJoinEntity: data));
      },
    );
  }

 */


  List<GetRequestTripJoinEntity > requestTripJoinData = [];
  bool hasMoreRequestTripJoin = true;
  int currentPageRequestTripJoin = 1;
  bool isLoadingMoreRequestTripJoin = false;
  bool isLoadingRequestTripJoin = false;

  Future<void> loadInitialRequestTripJoin() async {
    isLoadingRequestTripJoin = true;
    requestTripJoinData.clear();
    currentPageRequestTripJoin = 1;
    hasMoreRequestTripJoin = true;
    await getRequestTripJoin();
    isLoadingRequestTripJoin = false;
    emit(state.copyWith(status: ViewAllTripJoinStatus.success));
  }

// pagination method
  Future<void> getRequestTripJoin() async {
    if (!hasMoreRequestTripJoin || isLoadingMoreRequestTripJoin) return;

    isLoadingMoreRequestTripJoin = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getRequestTripJoinUseCase(
      CarBrandParams(
        page: currentPageRequestTripJoin,
        limit: 15,
      ),
    );

    response.fold(
          (failure) {
        isLoadingMoreRequestTripJoin = false;
        emit(state.copyWith(
          failure: failure,
          status: ViewAllTripJoinStatus.failure,
        ));
      },
          (data) {
        // you will receive AvailableRequestTripJoinEntity from usecase
        final trips = data ?? [];
        // final trips = data.requests.docs ?? [];
        requestTripJoinData.addAll(trips);

        if (trips.length < 5) {
          hasMoreRequestTripJoin = false;
          emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
        } else {
          currentPageRequestTripJoin++;
        }

        isLoadingMoreRequestTripJoin = false;
        emit(state.copyWith(
          requestTripJoinEntity: requestTripJoinData,
        ));
      },
    );
  }


  List<AvailableTripJoinEntity > tripJoinData = [];
  bool hasMoreTripJoin = true;
  int currentPageTripJoin = 1;
  bool isLoadingMoreTripJoin = false;
  bool isLoadingTripJoin = false;

  Future<void> loadInitialTripJoin() async {
    isLoadingTripJoin = true;
    tripJoinData.clear();
    currentPageTripJoin = 1;
    hasMoreTripJoin = true;
    await getTripJoin();
    isLoadingTripJoin = false;
    emit(state.copyWith(status: ViewAllTripJoinStatus.success));
  }

// pagination method
  Future<void> getTripJoin() async {
    if (!hasMoreTripJoin || isLoadingMoreTripJoin) return;

    isLoadingMoreTripJoin = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getAvailableTripJoinUseCase(
      CarBrandParams(
        page: currentPageTripJoin,
        limit: 15,
      ),
    );

    response.fold(
          (failure) {
        isLoadingMoreTripJoin = false;
        emit(state.copyWith(
          failure: failure,
          status: ViewAllTripJoinStatus.failure,
        ));
      },
          (data) {
        final trips = data ?? [];
        tripJoinData.addAll(trips);

        if (trips.length < 15) {
          hasMoreTripJoin = false;
        } else {
          currentPageTripJoin++;
        }

        isLoadingMoreTripJoin = false;
        emit(state.copyWith(
          availableTripJoinEntity: tripJoinData,
          status: ViewAllTripJoinStatus.success,
        ));
      },
    );
  }

  Future<void> getTripJoin1() async {
    if (!hasMoreTripJoin || isLoadingMoreTripJoin) return;

    isLoadingMoreTripJoin = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getAvailableTripJoinUseCase(
      CarBrandParams(
        page: currentPageTripJoin,
        limit: 15,
      ),
    );

    response.fold(
          (failure) {
        isLoadingMoreTripJoin = false;
        emit(state.copyWith(
          failure: failure,
          status: ViewAllTripJoinStatus.failure,
        ));
      },
          (data) {
        // you will receive AvailableTripJoinEntity from usecase
        final trips = data ?? [];
        tripJoinData.addAll(trips);

        if (trips.length < 5) {
          hasMoreTripJoin = false;
          emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
        } else {
          currentPageTripJoin++;
        }

        isLoadingMoreTripJoin = false;
        emit(state.copyWith(
          availableTripJoinEntity: tripJoinData,
        ));
      },
    );
  }

  Future<void> getExpectedPrice({required ExpectedPriceTripParams params}) async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));

    final response = await getExpectedPriceUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ViewAllTripJoinStatus.failure));
      },
          (expectedData) {
        emit(state.copyWith(
            expectedPriceEntity: expectedData,
            status: ViewAllTripJoinStatus.success,
        ));
      },
    );
  }

  List<RideModelEntity> carModelData = [];


  bool hasMoreCarModelLoading = true;
  int currentPageCarModelLoading = 1;
  bool isLoadingMoreCarModelLoading = false;
  bool isLoadingCarModelLoading = false;

  Future<void> loadInitialCarModelLoading({required String brandId}) async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    isLoadingCarModelLoading = true;
    carModelData.clear();
    currentPageCarModelLoading = 1;
    hasMoreCarModelLoading = true;
    await getCarModelLoading(brandId: brandId);
    isLoadingCarModelLoading = false;
    emit(state.copyWith(status: ViewAllTripJoinStatus.success));
  }

  Future<void> getCarModelLoading({required String brandId}) async {
    if (!hasMoreCarModelLoading || isLoadingMoreCarModelLoading)
      return;
    isLoadingMoreCarModelLoading = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
    final response = await getCarModelUseCase(
        CarBrandParams(
            page: currentPageCarModelLoading, limit: 15,id: brandId));
    response.fold(
          (failure) {
        isLoadingMoreCarModelLoading = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ViewAllTripJoinStatus.failure));
      },
          (data) {
        carModelData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreCarModelLoading = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
        } else {
          currentPageCarModelLoading++;
        }

        isLoadingMoreCarModelLoading = false;
        emit(state.copyWith(
          rideModelEntity: data,
        ));
      },
    );
  }





  List<RideBrandEntity> carBrandData = [];


  bool hasMoreCarBrandLoading = true;
  int currentPageCarBrandLoading = 1;
  bool isLoadingMoreCarBrandLoading = false;
  bool isLoadingCarBrandLoading = false;

  void loadInitialCarBrandLoading() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    isLoadingCarBrandLoading = true;
    carBrandData.clear();
    currentPageCarBrandLoading = 1;
    hasMoreCarBrandLoading = true;
    await getCarBrandLoading();
    isLoadingCarBrandLoading = false;
    emit(state.copyWith(status: ViewAllTripJoinStatus.success));
  }

  Future<void> getCarBrandLoading() async {
    if (!hasMoreCarBrandLoading || isLoadingMoreCarBrandLoading)
      return;
    isLoadingMoreCarBrandLoading = true;
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
    final response = await getCarBrandUseCase(
        CarBrandParams(
            page: currentPageCarBrandLoading, limit: 15));
    response.fold(
          (failure) {
        isLoadingMoreCarBrandLoading = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ViewAllTripJoinStatus.failure));
      },
          (data) {
        carBrandData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreCarBrandLoading = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
        } else {
          currentPageCarBrandLoading++;
        }

        isLoadingMoreCarBrandLoading = false;
        emit(state.copyWith(
          rideBrandEntity: data,
        ));
      },
    );
  }




  PaginationParams paginationParams = PaginationParams(page: 1, limit: 10);
  List<TripJoinCardEntity> tripJoinCards = [];
  bool noMoreDataInDatabase = false;

  Future<void> viewAllTripJoin() async {
    emit(state.copyWith(status: ViewAllTripJoinStatus.loading));
    final response = await viewAllTripJoinUseCase.call(
      paginationParams: paginationParams,
      subCategory: UIConst.tripJoinCategoryId,
    );
    response.fold(
      (Failure failure) {
      //   emit(
      //   // ViewAllTripJoinFailed(Labels.errorHappened),
      // );
      },
      (List<TripJoinCardEntity> models) {
        // print(' ============  inside cubit $models');
        noMoreDataInDatabase = models.isEmpty;
        // print(' ============= noMoreDataInDatabase = $noMoreDataInDatabase ');
        // print(' ============= paginationParams = ${paginationParams.page} ');
        tripJoinCards.addAll(models);
        print(response);
        emit(state.copyWith(status: ViewAllTripJoinStatus.success,allCards: tripJoinCards));
        // emit(
        //   ViewAllTripJoinSuccess(tripJoinCards),
        // );
      },
    );
  }


}
