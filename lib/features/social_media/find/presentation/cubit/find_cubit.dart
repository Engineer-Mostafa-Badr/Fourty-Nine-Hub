import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/add_dis_like_tinder_use_case.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/add_like_tinder_use_case.dart';
import 'package:fourtyninehub/features/social_media/find/domain/usecase/add_love_tinder_use_case.dart';


import '../../domain/entity/find_entity.dart';
import '../../domain/usecase/get_find_use_case.dart';
import 'find_state.dart';
class FindCubit extends Cubit<FindState> {
  final AddLikeFindUseCase addLikeFindUseCase;
  final AddDisLikeFindUseCase addDisLikeFindUseCase;
  final AddLoveFindUseCase addLoveFindUseCase;
  final GetFindUseCase getFindUseCase;

  FindCubit(this.addLikeFindUseCase,
      this.addDisLikeFindUseCase,
      this.addLoveFindUseCase,
      this.getFindUseCase)
      : super(FindState());
  Future<void> addLoveFind({required String id}) async {
    emit(state.copyWith(status: FindStates.loading));

    final response = await addLoveFindUseCase(AddLikeParams(id: id));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
          tinderLikeData: null,
          addedLove: false,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          tinderLikeData: updatedRestaurant,
          status: FindStates.success,
          addedLove: true,
        ));

        // 🔁 Reset addedLove so BlocListener can trigger again next time
        Future.delayed(const Duration(milliseconds: 300), () {
          emit(state.copyWith(addedLove: false));
        });
      },
    );
  }

  // Future<void> addLoveFind({required String id}) async {
  //   emit(state.copyWith(status: FindStates.loading));
  //
  //   final response = await addLoveFindUseCase(AddLikeParams(id: id));
  //
  //   response.fold(
  //         (failure) {
  //       emit(state.copyWith(
  //         failure: failure,
  //         status: FindStates.failure,
  //         tinderLikeData: null,
  //       ));
  //     },
  //         (updatedRestaurant) {
  //       emit(state.copyWith(
  //         tinderLikeData: updatedRestaurant,
  //         status: FindStates.success,
  //         addedLove: true
  //       ));
  //     },
  //   );
  // }

  Future<void> addLikeFind({required String id}) async {
    emit(state.copyWith(status: FindStates.loading));

    final response = await addLikeFindUseCase(AddLikeParams(id: id));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
          tinderLikeData: null,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          tinderLikeData: updatedRestaurant,
          status: FindStates.success,
        ));
      },
    );
  }

  Future<void> addDisLikeFind({required String id}) async {
    emit(state.copyWith(status: FindStates.loading));

    final response = await addDisLikeFindUseCase(AddLikeParams(id: id));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
          tinderLikeData: null,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          tinderLikeData: updatedRestaurant,
          status: FindStates.success,
        ));
      },
    );
  }

  String? selectedGender;

  // 📌 Your Cubit fields
  List<FindEntity> findData = [];

  bool hasMoreFindData = true; // whether API has more pages
  int currentPageFindData = 1; // current page index
  bool isFindDataLoadingMore = false; // prevents multiple parallel API calls
  bool isFindDataInitialLoading = false; // separate flag for first load

  final int pageSize = 5; // how many items per page

  // 📌 Initial load (with gender)
  void loadInitialFindData(BuildContext context,
      {required String gender}) async {
    print("🚀 CUBIT: loadInitialFindData() called with gender=$gender");

    selectedGender = gender;
    isFindDataInitialLoading = true;
    findData.clear();
    currentPageFindData = 1;
    hasMoreFindData = true;

    emit(state.copyWith(
      status: FindStates.loading,
      findData: [],
    ));

    await getFindData(context);

    isFindDataInitialLoading = false;
  }

  // 📌 Pagination (uses stored gender)
  Future<void> getFindData(BuildContext context) async {
    print("🚀 CUBIT: getFindData() called");
    print(
        "📊 State: hasMore=$hasMoreFindData, isLoading=$isFindDataLoadingMore, page=$currentPageFindData, gender=$selectedGender");

    if (!hasMoreFindData || isFindDataLoadingMore) {
      print("⚠️ Skipping API call - no more data or already loading");
      return;
    }

    isFindDataLoadingMore = true;

    if (currentPageFindData == 1) {
      emit(state.copyWith(status: FindStates.loading));
    }

    final response = await getFindUseCase(
      GetFindParams(
        page: currentPageFindData,
        limit: pageSize,
        gender: selectedGender ?? "",
      ),
    );

    response.fold(
          (failure) {
        print("❌ API call failed: $failure");
        isFindDataLoadingMore = false;

        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
        ));
      },
          (data) {
        print("✅ API call success, received ${data.length} items");

        if (currentPageFindData == 1) {
          findData = List.from(data);
        } else {
          findData.addAll(data);
        }

        // ✅ FIXED: Only stop if we get an EMPTY response, not just less than pageSize
        // Sometimes the API returns fewer items on a page but still has more data
        if (data.isEmpty) {
          hasMoreFindData = false;
          print("🛑 No more pages available (empty response)");
        } else {
          currentPageFindData++;
          print("➡️ Next page: $currentPageFindData (received ${data
              .length} items)");
        }

        isFindDataLoadingMore = false;

        emit(state.copyWith(
          status: FindStates.success,
          findData: findData,
        ));

        print("📦 Total items in findData: ${findData.length}");
      },
    );
  }
}
/*
class FindCubit extends Cubit<FindState> {


  final AddLikeFindUseCase addLikeFindUseCase;
  final AddDisLikeFindUseCase addDisLikeFindUseCase;
  final AddLoveFindUseCase addLoveFindUseCase;
  final GetFindUseCase getFindUseCase;

  FindCubit(
     this.addLikeFindUseCase, this.addDisLikeFindUseCase, this.addLoveFindUseCase, this.getFindUseCase)
      : super(FindState());

  Future<void> addLoveFind({required String id}) async {
    emit(state.copyWith(status: FindStates.loading));

    final response = await addLoveFindUseCase(AddLikeParams(id: id));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
          tinderLikeData: null,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          tinderLikeData: updatedRestaurant,
          status: FindStates.success,
        ));
      },
    );
  }
  Future<void> addLikeFind({required String id}) async {
    emit(state.copyWith(status: FindStates.loading));

    final response = await addLikeFindUseCase(AddLikeParams(id: id));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
          tinderLikeData: null,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          tinderLikeData: updatedRestaurant,
          status: FindStates.success,
        ));
      },
    );
  }
  Future<void> addDisLikeFind({required String id}) async {
    emit(state.copyWith(status: FindStates.loading));

    final response = await addDisLikeFindUseCase(AddLikeParams(id: id));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
          tinderLikeData: null,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          tinderLikeData: updatedRestaurant,
          status: FindStates.success,
        ));
      },
    );
  }

  String? selectedGender;

// 📌 Your Cubit fields
  List<FindEntity> findData = [];

  bool hasMoreFindData = true;          // whether API has more pages
  int currentPageFindData = 1;          // current page index
  bool isFindDataLoadingMore = false;   // prevents multiple parallel API calls
  bool isFindDataInitialLoading = false;// separate flag for first load (optional)

  final int pageSize = 5; // how many items per page
// 📌 Initial load (with gender)
  void loadInitialFindData(BuildContext context, {required String gender}) async {
    print("🚀 CUBIT: loadInitialFindData() called with gender=$gender");

    selectedGender = gender;
    isFindDataInitialLoading = true;
    findData.clear();
    currentPageFindData = 1;
    hasMoreFindData = true;

    emit(state.copyWith(
      status: FindStates.loading,
      findData: [],
    ));

    await getFindData(context);

    isFindDataInitialLoading = false;
  }

// 📌 Pagination (uses stored gender)
  Future<void> getFindData(BuildContext context) async {
    print("🚀 CUBIT: getFindData() called");
    print("📊 State: hasMore=$hasMoreFindData, isLoading=$isFindDataLoadingMore, page=$currentPageFindData, gender=$selectedGender");

    if (!hasMoreFindData || isFindDataLoadingMore) {
      print("⚠️ Skipping API call - no more data or already loading");
      return;
    }

    isFindDataLoadingMore = true;

    if (currentPageFindData == 1) {
      emit(state.copyWith(status: FindStates.loading));
    }

    final response = await getFindUseCase(
      GetFindParams(
        page: currentPageFindData,
        limit: pageSize,
        gender: selectedGender ?? "",
      ),
    );

    response.fold(
          (failure) {
        print("❌ API call failed: $failure");
        isFindDataLoadingMore = false;

        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
        ));
      },
          (data) {
        print("✅ API call success, received ${data.length} items");

        if (currentPageFindData == 1) {
          findData = List.from(data);
        } else {
          findData.addAll(data);
        }

        if (data.length < pageSize) {
          hasMoreFindData = false;
          print("🛑 No more pages available");
        } else {
          currentPageFindData++;
          print("➡️ Next page: $currentPageFindData");
        }

        isFindDataLoadingMore = false;

        emit(state.copyWith(
          status: FindStates.success,
          findData: findData,
        ));
      },
    );
  }



}
*/