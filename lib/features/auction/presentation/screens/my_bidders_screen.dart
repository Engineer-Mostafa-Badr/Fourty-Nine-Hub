// AVAILABLE TAB
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';

class MyBiddersScreen extends StatelessWidget {
  const MyBiddersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🏗️ MyBiddersScreen: Building widget");

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.myBiddersData;

        print("📋 Current auctions list:");
        print("   - Length: ${auctions.length}");
        print("   - Is Empty: ${auctions.isEmpty}");
        print("   - State Status: ${state.status}");

        if (state.status == StateStatus.error) {
          return  Center(
            child: Text(
                "${LocaleKeys.somethingWentWrong.localize}",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.status == StateStatus.loading) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          return Center(
            child: Text(
              context.isArabic ? 'لا يوجد مزايدون متاحون' : 'No Bidders available',
            ),
          );

        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          // padding: const EdgeInsets.all(16),
          itemCount: auctions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final auction = auctions[index];
            print("🎯 Rendering auction at index $index: ${auction.toString()}");
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w,vertical: 10),
              decoration: BoxDecoration(
                // color: AppColors.getFillColor(context),
                border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.LIGHT_COLOR
                      : const Color(0xB20B1035),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xfff2f1f7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: _buildHeader(
                      context: context,
                      status: auction.subscriptionType,
                      views: auction.views ?? 0,
                    ),
                  ),
                  Divider(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : const Color(0xB20B1035),
                    thickness: 1,
                    height: 0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                auction.gender == 'male'
                                    ? Assets.maleImagePlaceholder
                                    : Assets.femaleImagePlacehlder,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Label(
                              text: auction.username ?? (context.isArabic ? 'غير معروف' : 'Unknown'),
                              style: Styles.headerText(
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.black,
                                fontSize: 36,
                                height: 1.60,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Label(
                          text: "${LocaleKeys.wonTheAuction.localize}"
                              " ${auction.auctionTitle ?? "${context.isArabic ? 'لا يوجد عنوان' : 'No title'}"} ${LocaleKeys.forAuction.localize} ${auction.price} ${LocaleKeys.EGP.localize}",
                          style: Styles.mediumText(
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black,
                            fontSize: 24,
                            height: 1.40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : AppColors.black.withValues(alpha: 0.7),
                    thickness: 1,
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24),
                    child: MarriageCallMessageButtons(
                      otherUserId: auction.winnerId ?? "",
                      subcategoryId: auction.auctionId ?? "",
                      phone: auction.phone ?? "",
                      id: UserCubit.to.state.data?.id ?? '',
                      hasReport: true,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader({
    required num views,
    required String? status,
    required BuildContext context,
  }) {
    String label;
    Color color;

    switch (status) {
      case "Premium":
        label = LocaleKeys.premium2.localize;
        color = AppColors.SECONDARY_COLOR;
        break;
      case "Regular":
        label = LocaleKeys.regular.localize;
        color = AppColors.PRIMARY_COLOR;
        break;
      case "Not subscribe":
      default:
        label = LocaleKeys.notSubscribed.localize;
        color = Colors.grey;
        break;
    }

    // ✅ Use helper here
    final formattedViews = _formatNumber(context, views);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.adsEyeIcon),
          const SizedBox(width: 6),

          Label(
            text: "$formattedViews ${LocaleKeys.views.localize}",
            style: Styles.mediumText(
              color: const Color(0xFF6C6C6C),
              fontSize: 24,
              height: 1.60,
            ),
          ),

          const Spacer(),

          Label(
            text: label,
            style: Styles.mediumText(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }


  String _formatNumber(BuildContext context, num? number) {
    if (number == null) return "0";

    final locale = context.isArabic ? 'ar' : 'en';
    final formatter = NumberFormat.decimalPattern(locale);
    String formatted = formatter.format(number);

    // Ensure Arabic-Indic digits when app is Arabic
    if (context.isArabic) {
      const english = ['0','1','2','3','4','5','6','7','8','9'];
      const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

      for (int i = 0; i < english.length; i++) {
        formatted = formatted.replaceAll(english[i], arabic[i]);
      }
    }

    return formatted;
  }


}

