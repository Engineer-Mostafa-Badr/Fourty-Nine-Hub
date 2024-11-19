import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/widgets/favourite_sub_category_card.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../res/style/styles.dart';

class FavSubCategoryView extends StatelessWidget {
  const FavSubCategoryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.favouriteSubCategories.localize,
      ),
      body: BlocBuilder<FavouriteSubCategoryCubit, FavouriteSubCategoryState>(
          builder: (context, state) {
        final controller = context.read<FavouriteSubCategoryCubit>();
        return Padding(
          padding: EdgeInsets.all(16.w),
          child:state.status == StateStatus.loading
              ? const Center(
            // ignore: unnecessary_const
            child: const CircularProgressIndicator(),
          )
              : state.data!.isNotEmpty && state.data != null
              ? GridView.builder(
            itemCount: state.data?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1),
            itemBuilder: (context, index) => FavouriteSubCategoryCard(
              item: state.data![index],
              onFav: () async {
                var result = await controller
                    .toggleSubCategoryToFavorites(state.data![index].id);
                if (result == true) {
                  state.data!.removeWhere(
                          (element) => element.id == state.data![index].id);
                }
              }, mainCategory: state.mainCategory![index],
            ),
          )
          : Center(
        child: Label(
        style: Styles.mediumText(fontSize: 60.sp),
            maxLines: 3,
            textAlign: TextAlign.center,
            text: LocaleKeys.noFavouriteSubCategory.localize))
          // child: PaginationView<SubCategoryEntity>(
          //   build: (ScrollController scrollController,
          //       List<SubCategoryEntity> data) {
          //     if (data.isNotEmpty) {
          //       return GridView.builder(
          //         itemCount: data.length,
          //         controller: scrollController,
          //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 2, childAspectRatio: 1),
          //         itemBuilder: (context, index) => FavouriteSubCategoryCard(
          //           item: data[index],
          //           onFav: () async {
          //             var result = await controller
          //                 .toggleSubCategoryToFavorites(data[index].id);
          //             if (result == true) {
          //               data.removeWhere(
          //                   (element) => element.id == data[index].id);
          //             }
          //           }, mainCategory: state.mainCategory![index],
          //         ),
          //       );
          //     } else {
          //       return Center(
          //           child: Label(
          //               style: Styles.mediumText(fontSize: 60.sp),
          //               maxLines: 3,
          //               textAlign: TextAlign.center,
          //               text: LocaleKeys.noFavouriteSubCategory.localize));
          //     }
          //   },
          //   fetchData: (PaginationParams paginationParams) => context
          //       .read<FavouriteSubCategoryCubit>()
          //       .getSubcategories(paginationParams: paginationParams),
          // ),
        );
      }),
    );
  }
}
