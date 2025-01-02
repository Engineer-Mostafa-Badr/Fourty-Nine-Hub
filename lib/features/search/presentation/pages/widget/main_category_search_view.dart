import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'build_Item_search_main_category.dart';

class MainCategorySearchView extends StatelessWidget {
  const MainCategorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // if(state.status ==SearchStates.loading){
          //   return const Center(child: CircularProgressIndicator());
          // }
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return PagedListView<int, MainCategoryEntity>(
              pagingController: controller.searchPagingController,
              builderDelegate: PagedChildBuilderDelegate<MainCategoryEntity>(
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
                      child: BuildItemSearchMainCategory(
                        category: item,
                        onFavorite: () async {
                          var result = await controller
                              .toggleFavoriteMedicalService(item.id);
                          print("result$result");
                          return result;
                        },
                      ),
                    ),
                  );
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
              ),
            );
          }
          return Center(
            child: Text(LocaleKeys.noResultsFound.localize),
          );
        },
      ),
    );
  }
}
