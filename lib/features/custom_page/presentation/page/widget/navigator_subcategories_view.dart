import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_floating_action_button.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../../domain/entity/custom_page_categories_entity.dart';
import '../../cubit/custom_page_cubit.dart';

class NavigatorSubCategoriesView extends StatefulWidget {
  final CustomPageCategoriesEntity mainCategory;

  const NavigatorSubCategoriesView({
    super.key,
    required this.mainCategory,
  });

  @override
  State<NavigatorSubCategoriesView> createState() =>
      _NavigatorSubCategoriesViewState();
}

class _NavigatorSubCategoriesViewState
    extends State<NavigatorSubCategoriesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomPageCubit, CustomPageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CustomScaffold(
          enableCustomAppBar: true,

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: BackAppBar(
              label: context.isArabic
                  ? widget.mainCategory.nameAr
                  : widget.mainCategory.nameEn,
              textColor: Colors.white,
              iconColor: Colors.white,
              enableCustomAppBar: true,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: BlocBuilder<CustomPageCubit, CustomPageState>(
              builder: (context, state) {
                if (state.status == CustomPageStates.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.status == CustomPageStates.error) {
                  return Center(
                    child: Text(state.failure.toString()),
                  );
                }
                return ListView.separated(
                    itemBuilder: (context, index) {
                      var currentSubCategory = state.favouriteSubCat![index];
                      return ListTile(
                        leading: Checkbox(
                          shape: const CircleBorder(),
                          value: currentSubCategory.selected,
                          checkColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (bool? value) {
                            setState(() {
                              currentSubCategory.selected =
                                  !currentSubCategory.selected;
                              print(currentSubCategory.selected);
                              print(
                                  "===================${currentSubCategory.selected}");
                            });
                            context
                                .read<CustomPageCubit>()
                                .updateCategoryModel(
                                  subCategoryId:
                                      state.favouriteSubCat![index].id,
                                  categoryId: widget.mainCategory.id,
                                );
                          },
                        ),
                        title: Text(
                          context.isArabic
                              ? state.favouriteSubCat![index].nameAr
                              : state.favouriteSubCat![index].nameEn,
                          style: Styles.mediumText(
                              fontSize: 65.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor),
                        ),
                        selected: state.favouriteSubCat![index].selected,
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.favouriteSubCat!.length);
              },
            ),
          ),
          floatingActionButton: CustomFloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: LocaleKeys.save.localize,
          ),
        );
      },
    );
  }
}
