import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/utils/shared_pref.dart';
import '../../data/model/update_custom_page_categorise_model.dart';
import '../../domain/entity/activate_entity.dart';
import '../../domain/entity/custom_page_categories_entity.dart';
import '../../domain/entity/custom_page_sub_categories_entity.dart';
import '../../domain/use_case/fetch_activate_use_case.dart';
import '../../domain/use_case/fetch_favourite_cat_use_case.dart';
import '../../domain/use_case/fetch_navigate_bar_use_case.dart';
import '../../domain/use_case/fetch_navigator_sub_cat_use_case.dart';
import '../../domain/use_case/fetch_social_page_use_case.dart';
import '../../domain/use_case/fetch_sub_tab_use_case.dart';
import '../../domain/use_case/update_activate_use_case.dart';
import '../../domain/use_case/update_favourite_cat_use_case.dart';
import '../../domain/use_case/update_navigate_bar_use_case.dart';
import '../../domain/use_case/update_social_page_use_case.dart';
import '../../domain/use_case/update_sub_tab_use_case.dart';
import 'custom_page_states.dart';

class CustomPageCubit extends Cubit<CustomPageState> {
  final FetchSocialPageUseCase _fetchSocialPageUseCase;
  final UpdateSocialPageUseCase _updateSocialPageUseCase;
  final FetchSubTabUseCase _fetchSubTabUseCase;
  final UpdateSubTabUseCase _updateSubTabUseCase;
  final FetchNavigateBarUseCase _fetchNavigateBarUseCase;
  final UpdateNavigateBarUseCase _updateNavigateBarUseCase;
  final FetchCustomPageCategoriesUseCase _customPageCategoriesUseCase;
  final FetchCustomPageSubCategoriesUseCase _customPageSubCategoriesUseCase;
  final UpdateFavouriteCatUseCase _updateFavouriteCatUseCase;
  final FetchActivateUseCase _fetchActivateUseCase;
  final UpdateActivateUseCase _updateActivateUseCase;

  int editPageCurrentIndex = 0;
  CustomPageCubit(
    this._fetchSocialPageUseCase,
    this._updateSocialPageUseCase,
    this._fetchSubTabUseCase,
    this._updateSubTabUseCase,
    this._fetchNavigateBarUseCase,
    this._updateNavigateBarUseCase,
    this._customPageCategoriesUseCase,
    this._updateFavouriteCatUseCase,
    this._fetchActivateUseCase,
    this._updateActivateUseCase,
    this._customPageSubCategoriesUseCase,
  ) : super(CustomPageState());

  // Future<void> updateFavouriteCat(
  //     List<UpdateCustomPageCategoriesModel> updateData) async {
  //   print("state.updateData ${state.updateData}");
  //   final response = await _updateFavouriteCatUseCase.call(updateData);
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: CustomPageStates.error));
  //   }, (data) {
  //     emit(state.copyWith(status: CustomPageStates.uploadSubCatSuccess));
  //   });
  // }

  // Activate ///////////////////////////////////////////////
  //
  Future<void> fetchActivate() async {
    bool? active = await CacheManager.getActivation();
    // final response = await _fetchActivateUseCase.call(const NoParams());
    // response.fold((l) {
    //   emit(state.copyWith(failure: l, status: CustomPageStates.error));
    // }, (data) {
    emit(state.copyWith(
        activate:
            ActivateEntity(id: '', userId: '', customPage: active ?? false),
        status: CustomPageStates.success));
    // });
  }

  // Favourite Category ///////////////////////////////////////////////
  // Future<void> fetchFavouriteCat() async {
  //   if (state.favourite != null) return;
  //   emit(state.copyWith(status: CustomPageStates.loading));
  //   final response = await _customPageCategoriesUseCase.call(const NoParams());
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: CustomPageStates.error));
  //   }, (data) {
  //     List<CustomPageCategoriesEntity> favourite = [];
  //     for (var item in data) {
  //       for (var sub in item.subCategories) {
  //         updateCategoryModel(sub, item.id);
  //       }
  //       favourite.add(item.copyWith(selected: item.enabled));
  //     }
  //     // print('favourite $favourite');
  //     print('state.updateData ${state.updateData}');
  //     emit(state.copyWith(
  //       favourite: favourite,
  //       status: CustomPageStates.success,
  //     ));
  //   });
  // }
  Future<void> fetchFavouriteCat(bool refresh) async {
    if (state.favourite != null) return;
    emit(state.copyWith(status: CustomPageStates.loading));

    final response = await _customPageCategoriesUseCase.call(refresh);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      List<CustomPageCategoriesEntity> favourite = [];
      List<UpdateCustomPageCategoriesModel> updatedCategories =
          List.from(state.updateData ?? []);

      for (var item in data) {
        favourite.add(item.copyWith(selected: item.enabled));
        for (var sub in item.subCategories) {
          updateCategoryModel(subCategoryId: sub, categoryId: item.id);
        }
      }

      print("🚀 Before emit: updatedCategories = ${state.updateData}");
      updatedCategories.addAll(state.updateData ?? []);

      // ✅ Emit updated state **only once** after all updates
      emit(state.copyWith(
        favourite: favourite,
        updateData: updatedCategories,
        status: CustomPageStates.success,
      ));
      print("🟢 State Updated: ${state.updateData}");

      print("🔥 After emit: state.updateData = ${state.updateData}");
    });
  }

  Future<void> fetchFavouriteSubCat(String mainCategoryId) async {
    emit(state.copyWith(status: CustomPageStates.loading));

    final response = await _customPageSubCategoriesUseCase.call(mainCategoryId);
    print(
        "🚀 Before emit: state.updateData in fetchFavouriteSubCat = ${state.updateData}");

    response.fold((failure) {
      emit(state.copyWith(failure: failure, status: CustomPageStates.error));
    }, (data) {
      List<CustomPageSubCategoriesEntity> updatedData = [];
      // List<UpdateCustomPageCategoriesModel> updatedCategories =
      //     List.from(state.updateData!);

      for (var item in data) {
        bool isSelected =
            state.updateData!.any((sub) => sub.subcategories.contains(item.id));

        // ✅ Add item to favouriteSubCat
        updatedData.add(item.copyWith(selected: item.enabled || isSelected));

        // ✅ If `item.enabled == true`, ensure it's added to `updateData`
        // if (item.enabled == true) {
        //   bool mainCategoryExists = false;
        //   for (var category in updatedCategories) {
        //     if (category.mainCategoryId == mainCategoryId) {
        //       if (!category.subcategories.contains(item.id)) {
        //         category.subcategories.add(item.id);
        //       }
        //       mainCategoryExists = true;
        //       break;
        //     }
        //   }
        //
        //   if (!mainCategoryExists) {
        //     updatedCategories.add(UpdateCustomPageCategoriesModel(
        //       mainCategoryId: mainCategoryId,
        //       subcategories: [item.id],
        //     ));
        //   }
        // }
      }
      print("🔥 After emit: state.updateData = ${state.updateData}");

      // ✅ Emit the updated states
      emit(state.copyWith(
        favouriteSubCat: updatedData,
        // updateData: updatedCategories, // Ensures enabled items are stored
        status: CustomPageStates.success,
      ));
      print("🟢 State Updated: ${state.updateData}");
    });
  }

  // Navigate To ///////////////////////////////////////////////

  Future<void> fetchNavigateBar() async {
    final response = await _fetchNavigateBarUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(navigateBar: data, status: CustomPageStates.success));
    });
  }

  // void loadData() async {
  //   await fetchCustomPageWallet();
  //   await checkRequestWithdrawCustomPage();
  //   // await fetchCustomPageHistory();
  // }

  // Social Page //////////////////////////////////////////////

  Future<void> fetchSocialPage() async {
    final response = await _fetchSocialPageUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(social: data, status: CustomPageStates.success));
    });
  }

  // SubTab ////////////////////////////////////////////////////

  Future<void> fetchSubTab() async {
    final response = await _fetchSubTabUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(subTab: data, status: CustomPageStates.success));
    });
  }

  //
  Future<void> updateActivate(bool params) async {
    print("params $params");
    // bool? active = await CacheManager.getActivation();
    CacheManager.updateActive((params));
    // final response = await _updateActivateUseCase.call(params);
    // response.fold((l) {
    //   emit(state.copyWith(failure: l, status: CustomPageStates.error));
    // }, (data) {
    //   emit(state.copyWith(status: CustomPageStates.updateSuccess));
    //   fetchActivate();
    // });
  }

  void updateCategoryModel(
      {required String subCategoryId, required String categoryId}) {
    List<UpdateCustomPageCategoriesModel> categories =
        List.from(state.updateData ?? []);
    List<CustomPageCategoriesEntity>? favourite =
        List.from(state.favourite ?? []);
    // List<CustomPageSubCategoriesEntity>? favouriteSubCat =
    //     List.from(state.favouriteSubCat ?? []);
    bool isRemoved = false;

    for (int i = 0; i < categories.length; i++) {
      if (categories[i].subcategories.contains(subCategoryId)) {
        // ✅ Remove subCategoryId if it exists
        List<String> updatedSubcategories =
            List.from(categories[i].subcategories)..remove(subCategoryId);
        // favouriteSubCat
        //     .firstWhere((element) => element.id == subCategoryId)
        //     .selected = false;
        if (updatedSubcategories.isEmpty) {
          // If no subcategories left, remove the entire category
          categories.removeAt(i);
          favourite.firstWhere((element) => element.id == categoryId).selected =
              false;
        } else {
          // Otherwise, update the category with the new list
          categories[i] = UpdateCustomPageCategoriesModel(
            mainCategoryId: categories[i].mainCategoryId,
            subcategories: updatedSubcategories,
          );
          favourite.firstWhere((element) => element.id == categoryId).selected =
              true;
          // favouriteSubCat
          //     .firstWhere((element) => element.id == subCategoryId)
          //     .selected = true;
        }
        print("❌ Removed $subCategoryId from ${categories[i].mainCategoryId}");
        isRemoved = true;
        break;
      }
    }

    // If subCategoryId was NOT removed, add it
    if (!isRemoved) {
      bool mainCategoryExists = false;

      // Find if the main category already exists
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].mainCategoryId == categoryId) {
          categories[i] = UpdateCustomPageCategoriesModel(
            mainCategoryId: categories[i].mainCategoryId,
            subcategories: [
              ...categories[i].subcategories,
              subCategoryId
            ], // Append new ID
          );
          // favouriteSubCat
          //     .firstWhere((element) => element.id == subCategoryId)
          //     .selected = true;

          mainCategoryExists = true;
          print(
              "✅ Added $subCategoryId to existing mainCategoryId: $categoryId");
          break;
        }
      }

      // If mainCategoryId is not found, create a new category
      if (!mainCategoryExists) {
        categories.add(UpdateCustomPageCategoriesModel(
          mainCategoryId: categoryId,
          subcategories: [subCategoryId],
        ));
        favourite.firstWhere((element) => element.id == categoryId, orElse: () {
          return CustomPageCategoriesEntity(
            id: categoryId,
            nameEn: "",
            nameAr: "",
            enabled: false,
            banner: "",
            selected: false,
            subCategories: [],
          );
        }).selected = true;
        print(
            "✅ Created new mainCategoryId: $categoryId and added $subCategoryId.");
      }
    }

    // ✅ Emit the updated state
    emit(state.copyWith(
      updateData: categories,
      // favourite: favourite,
      // favouriteSubCat: favouriteSubCat
    ));
    print("🔄 Updated categories inside updateCategoryModel: $categories");

    // print("🟢 State Updated: ${state.updateData}");
  }

  // void updateCategoryModelSync(
  //   String subCategoryId,
  //   String categoryId,
  //   List<UpdateCustomPageCategoriesModel> categories,
  // ) {
  //   bool isUpdated = false;
  //
  //   for (int i = 0; i < categories.length; i++) {
  //     if (categories[i].mainCategoryId == categoryId) {
  //       if (!categories[i].subcategories.contains(subCategoryId)) {
  //         categories[i] = categories[i].copyWith(
  //           subcategories: [...categories[i].subcategories, subCategoryId],
  //         );
  //         print(
  //             "✅ Added $subCategoryId to existing mainCategoryId: $categoryId");
  //         isUpdated = true;
  //       }
  //       break; // Stop searching once we find the mainCategoryId
  //     }
  //   }
  //
  //   // If main category doesn't exist, create a new one
  //   if (!isUpdated) {
  //     categories.add(UpdateCustomPageCategoriesModel(
  //       mainCategoryId: categoryId,
  //       subcategories: [subCategoryId],
  //     ));
  //     print(
  //         "✅ Created new mainCategoryId: $categoryId and added $subCategoryId.");
  //   }
  //
  //   print("🔄 Updated categories inside updateCategoryModelSync: $categories");
  // }
  Future<void> updateFavouriteCat(
      List<UpdateCustomPageCategoriesModel> updateData) async {
    final currentState = state; // Capture the current state before API call
    print("🚀 Received updateData: $updateData");
    print(
        "🔄 Current state.updateData before API call: ${currentState.updateData}");

    if (updateData.isEmpty) {
      print("❌ No data to update!");
      return;
    }

    final response = await _updateFavouriteCatUseCase.call(updateData);

    response.fold((l) {
      emit(currentState.copyWith(failure: l, status: CustomPageStates.error));
      print("❌ Emitted error state!");
    }, (data) {
      print("✅ Successfully updated favourite categories.");

      // 🔥 Force state change by making sure the reference is different
      emit(CustomPageState(
        updateData: List.from(currentState.updateData!),
        // Ensure a new list reference
        status: CustomPageStates.uploadSubCatSuccess,
      ));

      print("🟢 State Updated: ${state.updateData}");
    });
  }

  Future<void> updateNavigateBar(NavigateBarParams params) async {
    final response = await _updateNavigateBarUseCase.call(params);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(status: CustomPageStates.success));
    });
  }

  Future<void> updateSocialPage(SocialPageParams params) async {
    final response = await _updateSocialPageUseCase.call(params);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(status: CustomPageStates.success));
    });
  }

  Future<void> updateSubTab(SubTabParams params) async {
    final response = await _updateSubTabUseCase.call(params);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(status: CustomPageStates.success));
    });
  }
}
