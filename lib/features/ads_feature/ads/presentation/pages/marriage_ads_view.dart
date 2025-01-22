import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
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
  late ScrollController _scrollController;

  @override
  void initState() {
    context
        .read<SubcategoriesCubit>()
        .loadInitialData(subCategoryId:widget.mainCategory.id);
    _scrollController = ScrollController()..addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent ) {
      context.read<SubcategoriesCubit>().filterAds(model: context.read<SubcategoriesCubit>().state.filterModel!, filter: '');
    }
  }


  bool _isFilterApplied = false;

  Future<void> _applyFilter(BuildContext context, SubcategoriesCubit controller) async {
    if (_isFilterApplied) return; // Prevent duplicate execution
    _isFilterApplied = true;

    dynamic data = await context.push(
      Routes.GOVERNORATEFILTERADS,
      extra: CategorizationEntity(
        mainCategory: controller.state.mainCategory!,
        subCategory: controller.state.subCategories![
        controller.state.subCategories!.indexWhere((element) => element.isSelected == true) ?? 0],
      ),
    );

    if (data != null) {
      controller.state.city = data.cityId;
      controller.state.governorate = data.governorateId;
      controller.changeFilterModel(data);
      await controller.loadFilterData(model: data, filter: 'user');
    }

    _isFilterApplied = false; // Reset the flag
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
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
                        subCategory: state.subCategories![state.subCategories?.indexWhere((element) => element.isSelected==true)??0],fromMarriage: true));
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
                context.isArabic?"${context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected==true)??0].nameAr}":"${context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected==true)??0].nameEn}"
                }",),
              )),
          body: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
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
                Container(
                    margin: EdgeInsetsDirectional.all(10.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: BadgedLabel(
                              label: LocaleKeys.filter.localize,
                              width: 170.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 5.w),
                              icon: Icons.filter_alt_rounded,
                              iconLeading: Icons.arrow_drop_down,
                              onTap: () async {
                                dynamic data = await context.push(Routes.FILTERADS,
                                    extra: CategorizationEntity(
                                        mainCategory: state.mainCategory!,
                                        fromMarriage: true,
                                        subCategory: state.subCategories![state.subCategories?.indexWhere((element) => element.isSelected==true)??0],));
                                if (data != null) {
                                  print("objectsdaa");
                                  // Future.delayed(const Duration(seconds: 1), () =>
                                  //     controller.changeState(data, data != null));
                                  // context.read<AdvertisementCubit>().loadFilterData(
                                  //     model: data,
                                  //     filter: userType);
                                  controller.changeFilterModel(data);

                                  controller.loadFilterData(
                                      model: data, filter: 'user');
                                }
                              }),
                        ),
                        const Sizer(
                          width: 5,
                        ),
                        Expanded(
                          child: BadgedLabel(
                              label: LocaleKeys.city.localize,
                              width: 170.h,
                              icon: Icons.filter_alt_rounded,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 5.w),
                              iconLeading: Icons.arrow_drop_down,
                              onTap: () async {
                                dynamic data = await context.push(
                                    Routes.GOVERNORATEFILTERADS,
                                    extra: CategorizationEntity(
                                        mainCategory: state.mainCategory!,
                                        fromMarriage: true,
                                        subCategory: state.subCategories![state.subCategories?.indexWhere((element) => element.isSelected==true)??0]));
                                if (data != null) {
                                  print("data.cityId${data.cityId}");
                                  print("data.governorateId${data.governorateId}");
                                  print("objectsdaa");
                                  controller.state.city = data.cityId;
                                  controller.state.governorate = data.governorateId;
                                  controller.changeFilterModel(data);
                                  FilterModel model = FilterModel(cityId: "state.city", governorateId: "state.governorate");
                                  // Future.delayed(const Duration(seconds: 1), () =>
                                  //     controller.changeState(data, data != null));
                                  // context.read<AdvertisementCubit>().loadFilterData(
                                  //     model: data,
                                  //     filter: userType);
                                  await controller.loadFilterData(
                                      model: data, filter: 'user');
                                }
                              }),
                        ),
                      ],
                    )),
                const Sizer(height: 40,),
                SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    itemCount: state.subCategories?.length??0,
                    // controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3, childAspectRatio: 1),
                    itemBuilder: (context, index) => ClickableWidget(
                      onTap: ()async{
                        await controller.changeSubCatIndex(index);

                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsets.all(6.w),
                        margin: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:state.subCategories?[index].isSelected==true?AppColors.PRIMARY_COLOR: Theme.of(context).scaffoldBackgroundColor,
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
                        child: Label(text: context.isArabic?(state.subCategories?[index].nameAr??''):(state.subCategories?[index].nameEn??''),color: state.subCategories?[index].isSelected==true?Colors.white:null,),
                      ),
                    ), separatorBuilder: (BuildContext context, int index) =>const Sizer(width: 30,),
                  ),
                ),
                const Sizer(height: 40,),
                Expanded(
                  child: state.status == SubcategoriesStates.loadingAds?const Center(child: CircularProgressIndicator(),):ListView.builder(
                    controller: _scrollController,
                      itemCount: controller.marriageAds.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => ClickableWidget(
                        onTap: (){
                          context.push(Routes.ADdetails,
                              extra:  controller.marriageAds[index].id);

                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20.r),
                            // border: Border.all(color: AppColors.PRIMARY_COLOR),
                          ),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ImageFromInternet(image: controller.marriageAds[index].images.first
                                  ,height: 80.h,width: 80.w,isCircle: true,

                                  ),
                                  const Sizer(width: 15,),
                                  Label(text: controller.marriageAds[index].title)
                                ],
                              ),
                              const Sizer(),
                              Label(text: controller.marriageAds[index].description),
                              const Sizer(),
                              CallMessageButtons(otherUserId: controller.marriageAds[index].userId??'', subcategoryId: state.subCategories?[state.subCategories?.indexWhere((element) => element.isSelected==true)??0].id??'', phone: controller.marriageAds[index].phone??'', id: controller.marriageAds[index].id,hasReport: true,)
                            ]
                          ),
                        ),
                      )),
          )
              ],
            ),
          ),
        );
      }
    );
  }
}
