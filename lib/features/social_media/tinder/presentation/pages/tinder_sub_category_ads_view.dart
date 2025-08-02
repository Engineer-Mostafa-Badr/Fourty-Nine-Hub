import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class TinderSubCategoryAdsView extends StatefulWidget {
  // final TinderSubAdsViewParams params;

  const TinderSubCategoryAdsView({
    super.key,
    // required this.params,
  });

  @override
  State<TinderSubCategoryAdsView> createState() =>
      _TinderSubCategoryAdsViewState();
}

class _TinderSubCategoryAdsViewState extends State<TinderSubCategoryAdsView>
    with SingleTickerProviderStateMixin {
  late final MainCategoryEntity mainCategory;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // context.read<TinderViewCubit>().fetchMainCategoryById(
    //       context,
    //       '6718f27eacb309f8b1f94d0c',
    //     );

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final tinderCubit = context.watch<TinderViewCubit>();

    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final padding = isSmallScreen ? 10.0 : 20.0;
          final textSize = isSmallScreen ? 14.0 : 18.0;
          final iconSize = isSmallScreen ? 24.0 : 30.0;

          return
            // tinderCubit.state.mainCategoryResponse != null
            //   ?
            Column(
                  children: [
                    const Sizer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: padding, horizontal: padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.yellow,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://i.pinimg.com/736x/c8/59/72/c8597269752fd834d4f71ceaac6642fb.jpg'
                            // tinderCubit.state.mainCategoryResponse?.banner ??
                            //     '',
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.favorite,
                                    size: iconSize,
                                    color:
                                        // widget.params.subCategory.isFavorite ==
                                        //         true
                                        //     ? AppColors.SECONDARY_COLOR
                                        //     :
                                        AppColors.GREY_DARK_COLOR,
                                  ),
                                ),
                                const Sizer(),
                                Text('kldsfuslfkds',
                                  //'${tinderCubit.state.mainCategoryResponse!.numberOfAdsCount} ${Labels.ads}',
                                  textScaler: TextScaler.noScaling,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30.sp),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: FittedBox(
                              child: Text(
                                // tinderCubit.state.mainCategoryResponse!.name ??
                                //     "",
                                'sdklfdsfds',
                                textScaler: TextScaler.noScaling,
                                style: TextStyle(
                                    // color: AppColors.PRIMARY_COLOR,
                                    color: Colors.white,
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Sizer(),
                    Text(
                      context.isArabic
                          ? 'jdjfsjj'
                          //widget.params.subCategory.nameAr
                          : 'fjfjfj',
                      //widget.params.subCategory.nameEn,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                          fontSize: 40.sp,
                          color: AppColors.SECONDARY_COLOR,
                          fontWeight: FontWeight.bold),
                    ),
                    const Sizer(),
                    Builder(builder: (context) {
                      String provider = getServiceName(context.isArabic
                              ? 'fjfjjf'
                              //widget.params.subCategory.nameAr
                              : 'fkfjfj'
                          //widget.params.subCategory.nameEn
                          );
                      String user = getUserName(context.isArabic
                              ? 'dkkfjfj'
                              // widget.params.subCategory.nameAr
                              : 'fkfjfjf'
                          // widget.params.subCategory.nameEn
                          );
                      return TabBar(
                        controller: _tabController,
                        labelColor: AppColors.SECONDARY_COLOR,
                        unselectedLabelColor: AppColors.PRIMARY_COLOR,
                        indicatorColor: AppColors.SECONDARY_COLOR,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            text: provider,
                          ),
                          Tab(text: user),
                        ],
                      );
                    }),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Center(
                              child: Text(
                            'Provider: ${getServiceName(
                                context.isArabic ?'okjoij'
                                //widget.params.subCategory.nameAr
                                    :'knknnk'
                                //widget.params.subCategory.nameEn
                            )}',
                            textScaler: TextScaler.noScaling,
                          )),
                          Center(
                              child: Text(
                            'User: ${getUserName(context.isArabic ?'dsjns'
                            //widget.params.subCategory.nameAr
                                : 'kmslkakjd'
                            //widget.params.subCategory.nameEn
                            )}',
                            textScaler: TextScaler.noScaling,
                          )),
                        ],
                      ),
                    ),
                  ],
                );
              //: const Center(child: CustomCircularProgressIndicator());
        },
      ),
    );
  }

  String getServiceName(String serviceType) {
    switch (serviceType) {
      case 'Friendship':
        return 'Connector';
      case 'You Know Me':
        return 'Man';
      case 'Chatting':
        return 'Host';
      case 'Khatba':
        return 'Matcher';
      case 'Marriage':
        return 'Planner';
      case 'Maazoun':
        return 'Registrar';
      case 'Cafe':
        return 'Barista';
      case 'Picnic':
        return 'Organizer';
      case 'Forums':
        return 'Moderator';
      case 'Missing':
        return 'Rescuer';
      default:
        return 'provider';
    }
  }

  String getUserName(String serviceType) {
    switch (serviceType) {
      case 'Friendship':
      case 'Khatba':
        return 'Seeker';
      case 'Chatting':
        return 'Talker';
      case 'You Know Me':
        return 'Woman';
      case 'Marriage':
      case 'Maazoun':
        return 'Partner';
      case 'Cafe':
        return 'Drinker';
      case 'Picnic':
        return 'Picnicker';
      case 'Forums':
        return 'Member';
      case 'Missing':
        return 'Missing';
      default:
        return 'user';
    }
  }
}

class TinderSubAdsViewParams {
  final SubCategoryEntity subCategory;

  TinderSubAdsViewParams({required this.subCategory});
}
