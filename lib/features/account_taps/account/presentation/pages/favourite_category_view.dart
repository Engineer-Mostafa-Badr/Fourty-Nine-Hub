import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import 'package:fourtyninehub/features/account_taps/account/presentation/pages/widgets/favourite_main_category_banner.dart';
import '../cubit/managers/favourite_categories_cubit.dart';

class FavouriteCategoryView extends StatefulWidget {
  const FavouriteCategoryView({super.key});

  @override
  State<FavouriteCategoryView> createState() => _FavouriteCategoryViewState();
}

class _FavouriteCategoryViewState extends State<FavouriteCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.favouriteCategories.localize,
        ),
        body: BlocBuilder<FavouriteCategoryCubit, FavouriteCategoryState>(
            builder: (context, state) {
          final controller = context.read<FavouriteCategoryCubit>();
          return state.status == StateStatus.loading
              ? const Center(
                  // ignore: unnecessary_const
                  child: const CircularProgressIndicator(),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(8.w),
                  itemCount: state.data?.length ?? 0,
                  separatorBuilder: (context, i) => Sizer(
                    height: 0.h,
                  ),
                  itemBuilder: (context, i) => state.data![i].id.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: FavouriteMainCategoryBanner(
                            category: state.data![i],
                            canRegister: false,
                            onFavorite: () async {
                              var result = await controller
                                  .removeFavorite(state.data![i].id);
                              if (result == true) {
                                state.data?.removeWhere((element) =>
                                    element.id == state.data![i].id);
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                );
        }));
  }
}
