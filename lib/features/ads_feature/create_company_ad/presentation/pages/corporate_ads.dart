import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/create_posts_company.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CorporateAds extends StatefulWidget {
  const CorporateAds({super.key});

  @override
  State<CorporateAds> createState() => _CorporateAdsState();
}

class _CorporateAdsState extends State<CorporateAds> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
        builder: (context, state) => GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColors.SECONDARY_COLOR,
              child: ListView(
                padding: EdgeInsets.only(top: 30.h),
                children: [
                  // Title with shimmer
                  state.status == StateStatus.loading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200,
                            height: 24,
                            margin: EdgeInsets.only(bottom: 30),
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          context.isArabic
                              ? 'اختر نوع الاعلان'
                              : 'Choose Ad Type',
                          style: TextStyle(
                              fontSize: FontSize.s18,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),

                  SizedBox(height: 8),

                  // Text & Photo Ad Option with container border
                  _buildAdOption(context,
                      isLoading: state.status == StateStatus.loading,
                      icon: Icons.text_fields,
                      image: Icons.image,
                      title: context.isArabic
                          ? 'اعلان صورة ونص'
                          : 'Text & Photo Ad',
                      description: context.isArabic
                          ? 'أنشئ اعلان صورة ونص'
                          : 'Create ads with text and static images',
                      buttonText: context.isArabic
                          ? 'أنشئ اعلان صورة ونص'
                          : 'Create Photo and Text Ad', onPressed: () {
                    ManageVibration.vibrate();
                    if (!context.isUserLoggedIn) {
                      print('not logged in');
                      context.push(Routes.FirstLoginScreen);
                    } else {
                      if (state.price?.isSubscribed == true) {
                        context.push(
                          Routes.CREATECOMPANYPOSTAD,
                          extra: CreatePostCompanyParams(
                              title: LocaleKeys.createPost.localize,
                              type: 'photo_written',
                              totalPrice: state.price?.postAndPhotoPrice ?? 0,
                              text: true,
                              picture: true),
                        );
                      } else if (state.price?.isSubscribed == false) {
                        SubscriptionMethod().subscribe(
                            subscribeId: Constants.companyAdsSubCategory,
                            showRegular: true,
                            title: LocaleKeys.companyAdvertise.localize);
                        context.read<CreateCompanyAdCubit>().loadData();
                      }
                    }
                  }),

                  SizedBox(height: 30),

                  // Reel Ad Option with container border
                  _buildAdOption(context,
                      isLoading: state.status == StateStatus.loading,
                      icon: Icons.video_library,
                      image: Icons.movie_creation,
                      title: context.isArabic ? 'اعلان فيديو' : 'Reel Ad',
                      description: context.isArabic
                          ? 'أنشئ اعلان فيديو'
                          : 'Create short video ads',
                      buttonText: context.isArabic
                          ? 'أنشئ اعلان فيديو'
                          : 'Create Reel Ad', onPressed: () {
                    ManageVibration.vibrate();
                    if (!context.isUserLoggedIn) {
                      print('not logged in');
                      context.push(Routes.FirstLoginScreen);
                    } else {
                      print('logged in');
                      if (state.price?.isSubscribed == true) {
                        context.push(
                          Routes.CREATECOMPANYPOSTREALAD,
                          extra: state.price?.reelPrice ?? 0,
                        );
                      } else if (state.price?.isSubscribed == false) {
                        SubscriptionMethod().subscribe(
                            subscribeId: Constants.companyAdsSubCategory,
                            showRegular: true,
                            title: LocaleKeys.companyAdvertise.localize);
                        context.read<CreateCompanyAdCubit>().loadData();
                      }
                    }
                  }),
                ],
              ),
            ));
  }

  @override
  void initState() {
    context.read<CreateCompanyAdCubit>().loadData();
    super.initState();
  }

  Widget _buildAdOption(
    BuildContext context, {
    required bool isLoading,
    required IconData icon,
    required IconData image,
    required String title,
    required String description,
    required String buttonText,
    required Function()? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Visual representation with shimmer
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : Container(
                    height: 96,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(image, size: 60, color: Colors.grey[600]),
                        PositionedDirectional(
                          top: 10,
                          start: 10,
                          child: Icon(icon,
                              size: 30, color: AppColors.SECONDARY_COLOR),
                        ),
                      ],
                    ),
                  ),

            SizedBox(height: 16),

            // Title with shimmer
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 24,
                      width: 150,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

            SizedBox(height: 0),

            // Description with shimmer
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 16,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.white,
                    ),
                  )
                : Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),

            SizedBox(height: 8),

            // Button with shimmer
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                          color: context.isDarkMode
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.whiteColor,
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
