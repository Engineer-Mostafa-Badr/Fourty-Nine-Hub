import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class SubCategorySearchView extends StatefulWidget {
  const SubCategorySearchView({super.key});

  @override
  State<SubCategorySearchView> createState() => _SubCategorySearchViewState();
}

class _SubCategorySearchViewState extends State<SubCategorySearchView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (BuildContext context, state) {
          if(state.status ==SearchStates.loading){
            return const Center(child: CircularProgressIndicator());
          }
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return PagedGridView<int, SubCategoryEntity>(
              pagingController: controller.searchPagingSubCategoryController,
              builderDelegate: PagedChildBuilderDelegate<SubCategoryEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      LocaleKeys.noData.localize,
                      style: Styles.mediumText(),
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  return InkWell(
                    onTap: () {
                      context.push(Routes.SUBCATEGORIES,
                          extra: state.search![index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: buildItem(item, () async {
                        var result = await controller
                            .toggleSubCategoryToFavorites(item.id);
                        return result;
                      },
                          item.isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          state.search![index]),
                    ),
                  );
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1),
            );
          }

          // If no search results or initial state
          return Center(
            child: Text(LocaleKeys.noResultsFound.localize),
          );
        },
      ),
    );
  }

  Widget buildItem(SubCategoryEntity model, Function() fav, IconData icon,
          MainCategoryEntity item) =>
      InkWell(
        onTap: () => context.push(Routes.ADS,
            extra: AdsViewParams(mainCategory: item, subCategory: model)),
        child: Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(5.r),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    offset: Offset(-1, 1),
                    blurRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SquareImage(
                        fit: BoxFit.cover,
                        radius: 5,
                        url: model.image,
                      ),
                    ),
                    Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: IconAppButton(
                          icon: icon,
                          onPressed: () async {
                            final result = await fav();
                            print("resutlt=$result");
                            if (result == true) {
                              model.isFavorite = !model.isFavorite!;
                              setState(() {});
                            }
                            // var result = await widget.onFav();
                            // if (result == true) {
                            //   widget.item.isFavorite = !widget.item.isFavorite!;
                            //   setState(() {});
                            // }
                          },
                          color: AppColors.SECONDARY_COLOR,
                        ))
                  ],
                ),
              ),
              const Sizer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: context.locale == Locales.english
                                ? model.nameEn
                                : model.nameAr,
                            style:
                                Styles.mediumText(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconAppButton(
                        icon: Icons.add_box_rounded,
                        size: 40.h,
                        onPressed: () {
                          if (AuthHelper().isLoggedIn()) {
                            context.push(Routes.CREATEAD,
                                extra: CategorizationEntity(
                                    mainCategory: item, subCategory: model));
                            print('item.id: ${item.id}');
                          } else {
                            context.push(Routes.LOGIN);
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
