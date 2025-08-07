import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/corporate_ads.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/retail_ads.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../res/style/app_colors.dart';

class CreateCompanyAdView extends StatefulWidget {
  const CreateCompanyAdView({super.key});

  @override
  State<CreateCompanyAdView> createState() => _CreateCompanyAdViewState();
}

class _CreateCompanyAdViewState extends State<CreateCompanyAdView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isShowExplainCompanyAd = false;
  bool isShowExplainPersonalAd = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.isArabic? "إنشاء إعلانات" : "Create Ads",
            style: TextStyle(
                color: context.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: FontSize.s20),
          ),
          leadingWidth: 60.w,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                padding: EdgeInsets.zero,
                labelStyle: const TextStyle(fontSize: 17),
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
                indicatorColor:
                    context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                labelColor:
                    context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                tabs: [
                  Tab(
                    height: 78,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                Assets.microphone,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : null,
                                height: 35,
                                width: 35,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
      ManageVibration.vibrate();
                                  setState(() {
                                    isShowExplainCompanyAd = !isShowExplainCompanyAd;
                                  });
                                  if (isShowExplainCompanyAd) {
                                    isShowExplainPersonalAd = false;
                                  }
                                },
                                child: SvgPicture.asset(
                                  Assets.idea,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Label(
                          text: context.isArabic ? 'شركة' : 'Corporate',
                          style: Styles.headerText(
                            fontSize: FontSize.s25,
                            fontWeight: FontWeight.w700,
                            height: 1.83,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    height: 78,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                Assets.menuSvg,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : null,
                                height: 35,
                                width: 35,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
      ManageVibration.vibrate();
                                  setState(() {
                                    isShowExplainPersonalAd = !isShowExplainPersonalAd;
                                    if (isShowExplainPersonalAd) {
                                      isShowExplainCompanyAd = false;
                                    }
                                  });
                                },
                                child: SvgPicture.asset(
                                  Assets.idea,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Label(
                          text: context.isArabic ? 'افراد' : 'Retail',
                          style: Styles.headerText(
                            fontSize: FontSize.s25,
                            fontWeight: FontWeight.w700,
                            height: 1.83,
                          ),
                        ),
                      ],
                    ),
                    // text: LocaleKeys.Insta.localize,
                  ),
                ],
              ),
              if (isShowExplainCompanyAd)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                  context.isArabic ? 'إنشاء إعلان شركة' :  'Create Your Company Ad',
                    style: Styles.headerText(
                      fontSize: FontSize.s25,
                      fontWeight: FontWeight.w700,
                      height: 1.83,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                ),
              if (isShowExplainPersonalAd)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                   context.isArabic ? 'إنشاء إعلان شخصي' : 'Create Your Personal Ad',
                    style: Styles.headerText(
                      fontSize: FontSize.s25,
                      fontWeight: FontWeight.w700,
                      height: 1.83,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                ),
              Expanded(
                child: SizedBox(
                  child: TabBarView(controller: tabController, children: [
                    BlocProvider<CreateCompanyAdCubit>(
                        create: (_) => serviceLocator(), child: CorporateAds()),
                    BlocProvider<CreateCompanyAdCubit>(
                        create: (_) => serviceLocator(), child: RetailAds())
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
