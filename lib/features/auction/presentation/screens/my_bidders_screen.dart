// AVAILABLE TAB
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/last_viewers_widget.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../cubit/auction_cubit.dart';

class MyBiddersScreen extends StatefulWidget {
  const MyBiddersScreen({super.key});

  @override
  State<MyBiddersScreen> createState() => _MyBiddersScreenState();
}

class _MyBiddersScreenState extends State<MyBiddersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuctionCubit>().loadInitialMyBidders();
  }

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
          return Center(
            child: Text(
              LocaleKeys.somethingWentWrong.localize,
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.status == StateStatus.loading) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message");
          return Center(
              child: CustomEmptyWidget(
            label: context.isArabic
                ? 'لا يوجد مزايدون متاحون'
                : 'No Bidders available',
          ));
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          // padding: const EdgeInsets.all(16),
          itemCount: auctions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final auction = auctions[index];
            print(
                "🎯 Rendering auction at index $index: ${auction.toString()}");
            return Container(
              margin: EdgeInsets.all(8),
              child: GlobalCard(
                subcategoryId: '',
                phone: auctions[index].phone ?? '',
                reportId: '',
                otherUserId: '',
                onTap: () {},
                hasTopSide: true,
                hasBottomSide: true,
                subscriptionType: auction.subscriptionType ==
                        SubscriptionStatus.premium.status
                    ? LocaleKeys.premium2.localize
                    : auction.subscriptionType ==
                            SubscriptionStatus.regular.status
                        ? LocaleKeys.regular.localize
                        : LocaleKeys.notSubscribed.localize,

                views: auction.views,
                onShowViewers: () async {
                  final cubit = context.read<AuctionCubit>();

                  // Fetch viewers first
                  if ((auction.views ?? 0) > 0) {
                    await cubit.fetchViewerEntity(id: auction.auctionId!);

                    final viewers = cubit.state.auctionViewerData;

                    if (viewers != null && viewers.isNotEmpty) {
                      showModalBottomSheet(
                        backgroundColor: context.isDarkMode
                            ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
                            : AppColors.LIGHT_COLOR,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.32,
                        ),
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0),
                          ),
                        ),
                        isDismissible: true,
                        // isScrollControlled: true,
                        builder: (BuildContext context) {
                          return LastViewersWidget(
                            lastViewers: viewers,
                          );
                        },
                      );
                    } else {
                      // Handle empty viewers or error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.isArabic
                                ? 'لا يوجد مشاهدون متاحون'
                                : 'No viewers available',
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.isArabic
                              ? 'لا يوجد مشاهدون متاحون'
                              : 'No viewers available',
                        ),
                      ),
                    );
                  }
                },
                // onSubscribe: (){
                //   context.pop();
                // },
                body: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ProfilePictureWidget(
                            isMale: auction.gender == 'male' ? true : false,
                          ),
                          // Container(
                          //   height: 40,
                          //   width: 40,
                          //   decoration: const BoxDecoration(
                          //     shape: BoxShape.circle,
                          //   ),
                          //   clipBehavior: Clip.antiAlias,
                          //   child: Image.asset(
                          //     auction.gender == 'male'
                          //         ? Assets.maleImagePlaceholder
                          //         : Assets.femaleImagePlacehlder,
                          //   ),
                          // ),
                          SizedBox(width: 16.w),
                          Flexible(
                            child: Label(
                              text: auction.username ??
                                  (context.isArabic ? 'غير معروف' : 'Unknown'),
                              style: Styles.headerText(
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.black,
                                fontSize: 36,
                                height: 1.60,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Label(
                        text: "${LocaleKeys.wonTheAuction.localize}"
                            " ${auction.auctionTitle ?? (context.isArabic ? 'لا يوجد عنوان' : 'No title')} ${LocaleKeys.forAuction.localize} ${auction.price} ${LocaleKeys.EGP.localize}",
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
              ),
            );
          },
        );
      },
    );
  }

  String _formatNumber(BuildContext context, num? number) {
    if (number == null) return "0";

    final locale = context.isArabic ? 'ar' : 'en';
    final formatter = NumberFormat.decimalPattern(locale);
    String formatted = formatter.format(number);

    // Ensure Arabic-Indic digits when app is Arabic
    if (context.isArabic) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

      for (int i = 0; i < english.length; i++) {
        formatted = formatted.replaceAll(english[i], arabic[i]);
      }
    }

    return formatted;
  }
}
