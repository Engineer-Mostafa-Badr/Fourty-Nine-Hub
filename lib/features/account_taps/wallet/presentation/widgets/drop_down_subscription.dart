import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../cubit/wallet_cubit.dart';

class DropDownSubscription extends StatefulWidget {
  @override
  _DropDownSubscriptionState createState() => _DropDownSubscriptionState();
}

class _DropDownSubscriptionState extends State<DropDownSubscription> {
  String? selectedCategory;
  String? selectedSubCategory;
  int? selectedIndex; // Track the selected index

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showCategoryDialog();
        },
        child: Container(
          padding:  EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              LocaleKeys.addSubcategoryToSubscribe.localize,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.selectCategory.localize),
          content: ConstrainedBox(
            constraints:  BoxConstraints(
              maxHeight: 300.0.h, // Limits height to show only 4 items
            ),
            child: SizedBox(
              height: 200.h,
              child: PaginationView<MainCategoryWalletEntity>(
                build: (ScrollController scrollController,
                    List<MainCategoryWalletEntity> data) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: data.isNotEmpty
                          ? data.map((category) {
                              String categoryName =
                                  context.locale == Locales.english
                                      ? category.nameEn
                                      : category.nameAr;
                              return ListTile(
                                title: Text(categoryName),
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  ); // Close category dialog
                                  _showSubCategoryDialog(category.id);
                                },
                              );
                            }).toList()
                          : [Text(LocaleKeys.noCategoriesAvailable.localize)],
                    ),
                  );
                },
                fetchData: (PaginationParams paginationParams) {
                  return context.read<WalletCubit>().fetchMainCategoryWallet(
                      paginationParams: paginationParams);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSubCategoryDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.selecteSubcategory.localize),
          content: ConstrainedBox(
            constraints:  BoxConstraints(
              maxHeight: 300.0.h, // Limits height to show only 4 items
            ),
            child: SizedBox(
              height: 200.h,
              child: PaginationView<MainCategoryWalletEntity>(
                build: (ScrollController scrollController,
                    List<MainCategoryWalletEntity> data) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: data.isNotEmpty
                          ? data.map((category) {
                              String categoryName =
                                  context.locale == Locales.english
                                      ? category.nameEn
                                      : category.nameAr;
                              return ListTile(
                                title: Text(categoryName),
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  ); // Close category dialog
                                  serviceLocator<SubscriptionController>()
                                      .showSubscriptionPlans(
                                    subCategoryId: category.id,
                                    wallets: [],
                                  );
                                },
                              );
                            }).toList()
                          : [Text(LocaleKeys.noCategoriesAvailable.localize)],
                    ),
                  );
                },
                fetchData: (PaginationParams paginationParams) {
                  return context.read<WalletCubit>().fetchSubCategoryWallet(
                      id: id, paginationParams: paginationParams);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
