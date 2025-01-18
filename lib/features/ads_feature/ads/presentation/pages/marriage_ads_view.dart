import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';


class MarriageSubCategoriesView extends StatefulWidget {
  final MainCategoryEntity mainCategory;

  const MarriageSubCategoriesView({super.key, required this.mainCategory});

  @override
  State<MarriageSubCategoriesView> createState() => _MarriageSubCategoriesViewState();
}

class _MarriageSubCategoriesViewState extends State<MarriageSubCategoriesView> {
  @override
  void initState() {
    context
        .read<SubcategoriesCubit>()
        .loadData(widget.mainCategory.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        buildWhen: (previous, current) => previous != current && current.isInitState,
        builder: (context, state) {
          print("state.status${state.status}");
          var controller = context.read<SubcategoriesCubit>();
        return state.isLoading?Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: CircularProgressIndicator(),)):Scaffold(
          appBar: BackAppBar(
            label: context.isArabic?widget.mainCategory.name:widget.mainCategory.nameEn,
            centerTitle: false,
          ),
          floatingActionButton: ClickableWidget(
            onTap: (){
              if (AuthHelper().isLoggedIn()) {
                context.push(Routes.CREATEAD,
                    extra: CategorizationEntity(
                        mainCategory: widget.mainCategory,
                        subCategory: state.subCategories![state.subCatIndex??0],fromMarriage: true));
              } else {
                context.push(Routes.LOGIN);
              }
            },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.PRIMARY_COLOR),
                ),
                padding: EdgeInsets.all(10.w),
                child: Label(text: "${LocaleKeys.add.localize} ${LocaleKeys.ad.localize} ${
                context.isArabic?"${context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCatIndex??0].nameAr}":"${context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCatIndex??0].nameEn}"
                }",),
              )),
          body: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                // Container(
                //   padding: EdgeInsets.all(10.w),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //     borderRadius: BorderRadius.circular(15.r),
                //     border: Border.all()
                //   ),
                //   child: Row(
                //     children: [
                //       Icon()
                //     ],
                //   ),
                // ),
                state.mainCategory==null?Container():MainCategoryBanner(
                  category: context.read<SubcategoriesCubit>().state.mainCategory!,
                  onFavorite: () async {
                    // var result =
                    // await controller.toggleFavoriteMedicalService(
                    //     state.data![index].id);
                    // print("result$result");
                    // return result;
                  },
                ),
                const Sizer(),
                BadgedLabel(
                    label: LocaleKeys.filter.localize,
                    width: double.infinity,
                    color: Colors.white,
                    textColor: AppColors.PRIMARY_COLOR,
                    isBordered: true,
                    margin: 1.w,
                    borderColor: AppColors.PRIMARY_COLOR,
                    padding: EdgeInsets.symmetric(
                        vertical: 15.h, horizontal: 5.w),
                    icon: Icons.filter_alt_rounded,
                    iconLeading: Icons.arrow_drop_down,
                    onTap: () async {

                    }),
                const Sizer(height: 40,),
                SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    itemCount: state.subCategories?.length??0,
                    // controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3, childAspectRatio: 1),
                    itemBuilder: (context, index) => ClickableWidget(
                      onTap: (){
                        controller.changeSubCatIndex(index);
                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsets.all(6.w),
                        margin: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:(state.subCatIndex??0)==index?AppColors.PRIMARY_COLOR: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 249, 159, 162),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                        child: Label(text: context.isArabic?(state.subCategories?[index].nameAr??''):(state.subCategories?[index].nameEn??''),color: (state.subCatIndex??0)==index?Colors.white:null,),
                      ),
                    ), separatorBuilder: (BuildContext context, int index) =>const Sizer(width: 30,),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
