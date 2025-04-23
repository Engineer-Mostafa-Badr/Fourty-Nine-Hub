import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'build_Item_search_main_category.dart';

class MainCategorySearchView extends StatefulWidget {
  const MainCategorySearchView({super.key, required this.params});
  final SearchParams params;

  @override
  State<MainCategorySearchView> createState() => _MainCategorySearchViewState();
}

class _MainCategorySearchViewState extends State<MainCategorySearchView> {

  late ScrollController _scrollController;
  late SearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().getPaginatedSearch(
          params:widget.params);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

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
            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.paginatedSearch.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.push(Routes.SUBCATEGORIES,
                        extra: controller.paginatedSearch[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: BuildItemSearchMainCategory(
                      category: controller.paginatedSearch[index],
                      onFavorite: () async {
                        var result = await controller
                            .toggleFavoriteMedicalService(controller.paginatedSearch[index].id);
                        print("result$result");
                        return result;
                      },
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              LocaleKeys.noData.localize,
              style: Styles.mediumText(),
            ),
          );
        },
      ),
    );
  }
}
